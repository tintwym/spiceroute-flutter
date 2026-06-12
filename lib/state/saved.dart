import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../api/api_client.dart';
import '../models/spice_route.dart';
import 'auth.dart';
import 'explore.dart' show kUnknownErrorSentinel;
import 'locale.dart';
import 'providers.dart';
import 'user_profile.dart';

// LEGACY storage-key names. The `savor_*` prefixes are from when the
// app was named SavorGlobal; renaming them now would silently wipe
// every existing user's saved-recipe list AND IndexedDB store on the
// next deploy. Keep as-is until we ship a migration shim. See
// `lib/state/auth.dart::_kDevUserKey` for the full justification.
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
    // Re-hydrate when the user switches UI locale so the saved-recipe
    // grid's titles + descriptions arrive in the new language. We only
    // need to refetch the recipe payloads — the bookmark id set is
    // language-independent.
    _ref.listen<Locale>(localeProvider, (prev, next) {
      if (prev?.languageCode != next.languageCode && state.ids.isNotEmpty) {
        unawaited(_hydrate());
      }
    });
  }

  final Ref _ref;
  ApiClient get _api => _ref.read(apiClientProvider);
  FirebaseFirestore? get _fs => _ref.read(firestoreProvider);

  /// Monotonic counter incremented on every `_hydrate()` entry. Same
  /// write-fence pattern `ExploreController.refresh` uses — only the
  /// most recent hydrate is allowed to write `state.recipes` back so
  /// concurrent triggers (boot + sign-in merge + locale change +
  /// optimistic toggle re-fetch) don't interleave and leave the
  /// visible recipe list out of sync with `state.ids` (e.g. ids says
  /// "3 saved" but recipes shows only 2 cards).
  int _hydrateToken = 0;

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
        error: e is ApiException ? e.message : kUnknownErrorSentinel,
      );
    }
  }

  Future<void> _hydrate() async {
    final token = ++_hydrateToken;
    if (state.ids.isEmpty) {
      // Guard the early-out too — a stale hydrate that was kicked
      // off when ids were non-empty might race a `clearAll()` that
      // emptied them, and the OUTGOING (stale) hydrate could
      // overwrite the now-empty state with its earlier results
      // unless we bail here as well.
      if (token != _hydrateToken) return;
      state = state.copyWith(recipes: const [], loading: false);
      return;
    }
    // Chunk the fetches into batches of 8 so a 200-bookmark user
    // doesn't open up 200 parallel HTTP requests at once — that used
    // to saturate the Dio pool and starve every other view in the
    // app until they all completed.
    const batchSize = 8;
    final ids = state.ids.toList();
    final hydrated = <SpiceRouteDetail>[];
    // Snapshot the active locale once for the entire batch — if the
    // user switches mid-hydrate we'll just refetch on the next
    // localeProvider listener tick rather than mixing two languages.
    final locale = _ref.read(localeProvider).languageCode;
    for (var i = 0; i < ids.length; i += batchSize) {
      final batch = ids.sublist(
        i,
        i + batchSize > ids.length ? ids.length : i + batchSize,
      );
      final batchResults = await Future.wait(
        batch.map((id) async {
          try {
            return await _api.getRecipe(id, translateTo: locale);
          } catch (_) {
            return null;
          }
        }),
      );
      // Bail mid-loop if a newer hydrate has started. Keeps us from
      // burning the rest of the API budget on results that will be
      // discarded anyway, and from holding the loading flag true
      // longer than necessary.
      if (token != _hydrateToken) return;
      hydrated.addAll(batchResults.whereType<SpiceRouteDetail>());
    }
    // Final write-fence check before the only state mutation that
    // actually publishes the recipe payload. Without this, a stale
    // hydrate that started before a `toggle()` (which added a new
    // id and triggered no new hydrate of its own) could clobber the
    // optimistic update and leave `state.ids` and `state.recipes`
    // out of sync — ids says "3 saved" but only 2 cards render.
    if (token != _hydrateToken) return;
    // Drop ids that no longer resolve (e.g. deleted server-side).
    final stillValid = hydrated.map((r) => r.id).toSet();
    final pruned = state.ids.intersection(stillValid);
    if (pruned.length != state.ids.length) {
      final removedIds = state.ids.difference(stillValid);
      await _persistLocal(pruned);
      // Use targeted arrayRemove for each cleanup so concurrent
      // toggles on another device aren't clobbered by a whole-array
      // overwrite. See `_persistCloudDelta` for the full rationale.
      await _persistCloudDelta(remove: removedIds);
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
      await _persistLocal(merged);
      // Push the IDs that exist locally but not in the cloud as
      // targeted arrayUnion entries. We deliberately don't write the
      // full merged list back as a whole-array replace — that would
      // squash any in-flight toggles from a second device.
      final toAdd = state.ids.difference(cloudIds);
      if (toAdd.isNotEmpty) {
        await _persistCloudDelta(add: toAdd);
      }
      if (hydrateAfter) await _hydrate();
    } catch (e, st) {
      // Best-effort: a Firestore outage shouldn't break local
      // bookmarks. We DO want the failure surfaced in dev console
      // though — previously this was a `// ignore` that silently
      // hid permission-denied / rules-misconfig errors during
      // development, so a broken rule looked like "sync works"
      // until QA noticed bookmarks weren't reaching the cloud. The
      // print is no-op in release builds (kDebugMode gate).
      if (kDebugMode) {
        debugPrint('SavedRecipes: cloud merge on sign-in failed: $e\n$st');
      }
    }
  }

  void toggle(SpiceRouteSummary recipe) {
    // Optimistic update: flip state synchronously so the bookmark icon
    // animates immediately, then persist to secure storage in the background.
    // Awaiting `_persist*` first added a perceptible 50–200 ms lag on web
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

    unawaited(_persistLocal(current));
    // Single-id cloud delta. arrayUnion / arrayRemove commute, so
    // two devices toggling DIFFERENT recipes at the same time both
    // succeed — the old whole-array overwrite would silently drop
    // whichever write landed first.
    unawaited(_persistCloudDelta(
      add: wasSaved ? const {} : {recipe.id},
      remove: wasSaved ? {recipe.id} : const {},
    ));
  }

  void clearAll() {
    final removed = state.ids;
    state = state.copyWith(ids: const {}, recipes: const []);
    unawaited(_persistLocal(const {}));
    if (removed.isNotEmpty) {
      unawaited(_persistCloudDelta(remove: removed));
    }
  }

  /// Local-only persistence. Always operates on the full current set
  /// (it's the source of truth on-device).
  Future<void> _persistLocal(Set<String> ids) async {
    try {
      if (ids.isEmpty) {
        await _storage.delete(key: _savedKey);
      } else {
        await _storage.write(key: _savedKey, value: jsonEncode(ids.toList()));
      }
    } catch (_) {
      // best-effort
    }
  }

  /// Cloud persistence as TARGETED additions / removals using
  /// [FieldValue.arrayUnion] and [FieldValue.arrayRemove].
  ///
  /// Why not just write the whole array (`set({savedRecipeIds: [...]},
  /// merge: true)`)? Because `merge: true` only merges at the
  /// *field* level — the array itself is overwritten. So if device
  /// A is saving recipe X right when device B is saving recipe Y,
  /// whichever write lands second replaces the other's addition.
  /// Real "I saved it on my phone, opened the laptop, it's gone"
  /// report waiting to happen.
  ///
  /// arrayUnion / arrayRemove are server-side mutators — they
  /// commute, so concurrent writes from N devices all succeed
  /// without clobbering each other.
  Future<void> _persistCloudDelta({
    Set<String> add = const {},
    Set<String> remove = const {},
  }) async {
    if (add.isEmpty && remove.isEmpty) return;
    final user = _ref.read(authControllerProvider);
    final fs = _fs;
    if (user == null || fs == null) return;
    try {
      final doc = <String, Object>{
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (add.isNotEmpty) {
        doc['savedRecipeIds'] = FieldValue.arrayUnion(add.toList());
      } else if (remove.isNotEmpty) {
        doc['savedRecipeIds'] = FieldValue.arrayRemove(remove.toList());
      }
      // arrayUnion + arrayRemove on the same field in one write is
      // not allowed by Firestore — split into two writes when both
      // sides are non-empty.
      await fs.collection('users').doc(user.uid).set(
            doc,
            SetOptions(merge: true),
          );
      if (add.isNotEmpty && remove.isNotEmpty) {
        await fs.collection('users').doc(user.uid).set({
          'savedRecipeIds': FieldValue.arrayRemove(remove.toList()),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      // Local storage is the source of truth; Firestore is the
      // cross-device shadow. A retry loop here would just queue
      // duplicate writes on flaky connections — but we DO log so
      // a misconfigured ruleset or auth-domain mismatch surfaces
      // in dev console rather than failing silently for weeks.
      if (kDebugMode) {
        debugPrint('SavedRecipes: cloud delta write failed: $e');
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
