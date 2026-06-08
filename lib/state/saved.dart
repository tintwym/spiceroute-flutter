import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../api/api_client.dart';
import '../models/spice_route.dart';
import 'providers.dart';

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
  SavedRecipesController(this._api) : super(const SavedRecipesState()) {
    _bootstrap();
  }

  final ApiClient _api;

  Future<void> _bootstrap() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final raw = await _storage.read(key: _savedKey);
      final ids = _decodeIds(raw);
      state = state.copyWith(ids: ids);
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
  return SavedRecipesController(ref.watch(apiClientProvider));
});
