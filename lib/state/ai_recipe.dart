import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../models/spice_route.dart';
import 'auth.dart';
import 'providers.dart';
import 'user_profile.dart';

@immutable
class AiRecipeState {
  const AiRecipeState({
    this.idea = '',
    this.cuisine,
    this.loading = false,
    this.recipe,
    this.saved,
    this.error,
    this.rateLimited = false,
  });

  final String idea;
  final Cuisine? cuisine;
  final bool loading;
  final Map<String, dynamic>? recipe;
  final SpiceRouteDetail? saved;
  final String? error;
  final bool rateLimited;

  bool get hasRecipe => recipe != null;

  AiRecipeState copyWith({
    String? idea,
    Cuisine? cuisine,
    bool clearCuisine = false,
    bool? loading,
    Map<String, dynamic>? recipe,
    bool clearRecipe = false,
    SpiceRouteDetail? saved,
    bool clearSaved = false,
    String? error,
    bool clearError = false,
    bool? rateLimited,
  }) {
    return AiRecipeState(
      idea: idea ?? this.idea,
      cuisine: clearCuisine ? null : (cuisine ?? this.cuisine),
      loading: loading ?? this.loading,
      recipe: clearRecipe ? null : (recipe ?? this.recipe),
      saved: clearSaved ? null : (saved ?? this.saved),
      error: clearError ? null : (error ?? this.error),
      rateLimited: rateLimited ?? this.rateLimited,
    );
  }
}

class AiRecipeController extends StateNotifier<AiRecipeState> {
  AiRecipeController(this._ref) : super(const AiRecipeState());

  final Ref _ref;
  ApiClient get _api => _ref.read(apiClientProvider);

  void setIdea(String idea) => state = state.copyWith(idea: idea);
  void setCuisine(Cuisine? c) {
    state = c == null
        ? state.copyWith(clearCuisine: true)
        : state.copyWith(cuisine: c);
  }

  Future<void> generate({required String language, bool save = false}) async {
    if (state.idea.trim().isEmpty || state.loading) return;
    state = state.copyWith(
      loading: true,
      clearError: true,
      rateLimited: false,
      clearRecipe: !save,
      clearSaved: !save,
    );
    try {
      final result = await _api.generateRecipe(
        idea: state.idea.trim(),
        cuisine: state.cuisine,
        language: language,
        save: save,
      );
      state = state.copyWith(
        loading: false,
        recipe: result.recipe,
        saved: result.saved,
      );
      // Mirror saved AI recipes to Firestore so the same user sees them
      // on a fresh device without needing a backend round-trip. Fires
      // unawaited — a Firestore outage shouldn't roll back a successful
      // backend save.
      if (save && result.saved != null) {
        unawaited(_mirrorToCloud(result));
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.message,
        rateLimited: e.isRateLimited,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  /// Append a saved AI recipe REFERENCE to `users/{uid}.customRecipes`
  /// (capped at 50 entries). De-duplicates by recipe id.
  ///
  /// IMPORTANT: we store ONLY the skinny `{id, title, imageUrl,
  /// createdAt}` shape — NOT the full Gemini payload. An earlier
  /// version embedded the entire `result.recipe` (including all
  /// ingredients and step bodies) inline. With Gemini occasionally
  /// returning ~20 KB recipes, 50 entries × 20 KB plus the user's
  /// up-to-1000 `savedRecipeIds` strings would blow past Firestore's
  /// 1 MB document cap. Once that happens, EVERY subsequent
  /// `ref.set(..., merge: true)` to this doc fails — including the
  /// unrelated saved-recipes writes — and the user is effectively
  /// locked out of their own cloud profile until an operator
  /// manually trims the doc.
  ///
  /// Source of truth for the full recipe stays on the backend
  /// (`saved.id` resolves via `GET /spice_routes/{id}`); this
  /// list is just a recently-viewed index for the home screen.
  ///
  /// Wrapped in `runTransaction` so concurrent saves from two tabs
  /// (or two devices) don't read the same list snapshot, both
  /// append, then both write back — silently losing one entry.
  /// The transaction reads inside the same atomic unit it writes
  /// in, so Firestore aborts and replays one of the racers if the
  /// underlying doc moved between read and write. `customRecipes`
  /// is a dict-of-dicts array, NOT a string set, so we can't use
  /// `arrayUnion` here (it'd happily add two different
  /// `{id: 'x', createdAt: T1}` and `{id: 'x', createdAt: T2}`
  /// entries because the maps don't deep-equal).
  Future<void> _mirrorToCloud(AiRecipeResult result) async {
    final user = _ref.read(authControllerProvider);
    final fs = _ref.read(firestoreProvider);
    if (user == null || fs == null) return;
    final saved = result.saved;
    if (saved == null) return;
    final entry = <String, dynamic>{
      'id': saved.id,
      'title': saved.title,
      if (saved.imageUrl != null) 'imageUrl': saved.imageUrl,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    };
    try {
      final ref = fs.collection('users').doc(user.uid);
      await fs.runTransaction((tx) async {
        final snap = await tx.get(ref);
        final existing = (snap.data()?['customRecipes'] as List?)
                ?.whereType<Map>()
                .map((m) => m.cast<String, dynamic>())
                .toList() ??
            <Map<String, dynamic>>[];
        // Dedupe + bound the list — newest first, cap at 50 entries.
        final filtered = existing.where((m) => m['id'] != saved.id).toList();
        final merged = [entry, ...filtered].take(50).toList();
        tx.set(ref, {
          'customRecipes': merged,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      });
    } catch (e) {
      // Local backend save is the source of truth; the cloud mirror
      // is a recently-used index for the home screen. A retry loop
      // here would just queue duplicates on flaky connections — but
      // we DO log so a misconfigured ruleset, auth-domain mismatch,
      // or a quota-exceeded write surfaces in the dev console
      // instead of being silently swallowed for weeks. Matches the
      // pattern in `SavedRecipesController._persistCloudDelta`.
      if (kDebugMode) {
        debugPrint('AiRecipe: cloud mirror write failed: $e');
      }
    }
  }

  void reset() => state = const AiRecipeState();
}

final aiRecipeProvider =
    StateNotifierProvider<AiRecipeController, AiRecipeState>((ref) {
  return AiRecipeController(ref);
});
