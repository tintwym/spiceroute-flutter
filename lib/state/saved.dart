import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../api/api_client.dart';
import '../models/spice_route.dart';
import 'auth.dart';
import 'providers.dart';
import 'user_profile.dart';

const _savedKey = 'savor_saved_recipe_ids';
const _storage = FlutterSecureStorage(
  webOptions: WebOptions(dbName: 'savor_settings'),
);

class SavedRecipesState {
  const SavedRecipesState({
    this.ids = const {},
    this.recipes = const [],
    this.loading = false,
    this.error,
  });

  final Set<String> ids;
  final List<SpiceRouteSummary> recipes;
  final bool loading;
  final String? error;

  bool isSaved(String id) => ids.contains(id);

  SavedRecipesState copyWith({
    Set<String>? ids,
    List<SpiceRouteSummary>? recipes,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return SavedRecipesState(
      ids: ids ?? this.ids,
      recipes: recipes ?? this.recipes,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class SavedRecipesController extends StateNotifier<SavedRecipesState> {
  SavedRecipesController(this._ref) : super(const SavedRecipesState()) {
    _bootstrap();
    // Watch the auth state so a sign-in mid-session triggers the cloud
    // ⇄ local merge. Once `state` flips from null → AppUser, we union the
    // local bookmark set with whatever's in `users/{uid}` and persist the
    // combined view back to both stores.
    _ref.listen<AppUser?>(authControllerProvider, (prev, next) {
      if (prev == null && next != null) {
        unawaited(_mergeOnSignIn(next));
      }
    });
  }

  final Ref _ref;
  ApiClient get _api => _ref.read(apiClientProvider);
  FirebaseFirestore? get _fs => _ref.read(firestoreProvider);

  Future<void> _bootstrap() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final raw = await _storage.read(key: _savedKey);
      final ids = _decodeIds(raw);
      state = state.copyWith(ids: ids);
      // If the user is already signed in at boot (Firebase restored their
      // session), merge the cloud set before we hydrate so we don't fire a
      // burst of `getRecipe` calls only to redo it a tick later.
      final user = _ref.read(authControllerProvider);
      if (user != null) {
        await _mergeOnSignIn(user, hydrateAfter: false);
      }
      await _hydrate();
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: e is ApiException ? e.message : 'Something went wrong.',
      );
    }
  }

  Future<void> _hydrate() async {
    if (state.ids.isEmpty) {
      state = state.copyWith(recipes: const [], loading: false);
      return;
    }
    final futures = state.ids.map((id) async {
      try {
        return await _api.getRecipe(id);
      } catch (_) {
        return null;
      }
    });
    final results = await Future.wait(futures);
    final hydrated = results.whereType<SpiceRouteDetail>().toList();
    // Drop ids that no longer resolve (e.g. deleted server-side).
    final stillValid = hydrated.map((r) => r.id).toSet();
    final pruned = state.ids.intersection(stillValid);
    if (pruned.length != state.ids.length) {
      await _persist(pruned);
    }
    state = state.copyWith(
      ids: pruned,
      recipes: hydrated.cast<SpiceRouteSummary>(),
      loading: false,
    );
  }

  /// Union-merge cloud and local bookmark sets on sign-in. The cloud doc
  /// is created on first write — `setDoc({merge:true})` is idempotent so
  /// this is safe to call on every sign-in event.
  ///
  /// We deliberately don't *replace* local with cloud — a user who saved
  /// a recipe offline before signing in shouldn't lose it. Union also
  /// handles the common case where they signed in on a fresh device.
  Future<void> _mergeOnSignIn(AppUser user, {bool hydrateAfter = true}) async {
    final fs = _fs;
    if (fs == null) return;
    try {
      final ref = fs.collection('users').doc(user.uid);
      final snap = await ref.get();
      final cloudIds = (snap.data()?['savedRecipeIds'] as List?)
              ?.whereType<String>()
              .toSet() ??
          const <String>{};
      final merged = {...state.ids, ...cloudIds};
      // No-op if both sides already agree — avoids a needless Firestore
      // write on every cold boot.
      if (merged.length == state.ids.length && merged.length == cloudIds.length) {
        return;
      }
      state = state.copyWith(ids: merged);
      await _persist(merged);
      if (hydrateAfter) await _hydrate();
    } catch (_) {
      // Best-effort: a Firestore outage shouldn't break local bookmarks.
    }
  }

  void toggle(SpiceRouteSummary recipe) {
    // Optimistic update: flip state synchronously so the bookmark icon
    // animates immediately, then persist to secure storage in the background.
    // Awaiting `_persist` first added a perceptible 50–200 ms lag on web
    // (secure_storage uses IndexedDB) and made the button feel sluggish.
    final current = Set<String>.from(state.ids);
    final wasSaved = current.contains(recipe.id);
    if (wasSaved) {
      current.remove(recipe.id);
    } else {
      current.add(recipe.id);
    }
    final updatedRecipes = wasSaved
        ? state.recipes.where((r) => r.id != recipe.id).toList()
        : [recipe, ...state.recipes];
    state = state.copyWith(ids: current, recipes: updatedRecipes);

    unawaited(_persist(current));
  }

  void clearAll() {
    state = state.copyWith(ids: const {}, recipes: const []);
    unawaited(_persist(const {}));
  }

  Future<void> _persist(Set<String> ids) async {
    try {
      if (ids.isEmpty) {
        await _storage.delete(key: _savedKey);
      } else {
        await _storage.write(key: _savedKey, value: jsonEncode(ids.toList()));
      }
    } catch (_) {
      // best-effort
    }
    // Cloud write-through. Fires in parallel with the local write above;
    // failures are silent — local storage is the source of truth, Firestore
    // is the cross-device shadow. A retry loop here would just queue up
    // duplicate writes on flaky connections.
    final user = _ref.read(authControllerProvider);
    final fs = _fs;
    if (user != null && fs != null) {
      try {
        await fs.collection('users').doc(user.uid).set({
          'savedRecipeIds': ids.toList(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (_) {
        // ignore — see comment above
      }
    }
  }

  Set<String> _decodeIds(String? raw) {
    if (raw == null || raw.isEmpty) return const {};
    try {
      final list = jsonDecode(raw);
      if (list is List) {
        return list.whereType<String>().toSet();
      }
    } catch (_) {}
    return const {};
  }
}

final savedRecipesProvider = StateNotifierProvider<SavedRecipesController,
    SavedRecipesState>((ref) {
  return SavedRecipesController(ref);
});
