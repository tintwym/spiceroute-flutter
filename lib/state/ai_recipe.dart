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

  /// Append a saved AI recipe to `users/{uid}.customRecipes` (capped at 50
  /// entries so the doc stays under Firestore's 1 MB cap even with rich
  /// recipe payloads). De-duplicates by recipe id.
  Future<void> _mirrorToCloud(AiRecipeResult result) async {
    final user = _ref.read(authControllerProvider);
    final fs = _ref.read(firestoreProvider);
    if (user == null || fs == null) return;
    final saved = result.saved;
    if (saved == null) return;
    // The Gemini payload + the backend-assigned id is the most portable
    // representation — it round-trips through whatever renderer the
    // consumer uses without depending on `SpiceRouteDetail.toJson`.
    final entry = <String, dynamic>{
      'id': saved.id,
      'recipe': result.recipe,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    };
    try {
      final ref = fs.collection('users').doc(user.uid);
      final snap = await ref.get();
      final existing = (snap.data()?['customRecipes'] as List?)
              ?.whereType<Map>()
              .map((m) => m.cast<String, dynamic>())
              .toList() ??
          <Map<String, dynamic>>[];
      // Dedupe + bound the list — newest first, cap at 50 entries.
      final filtered = existing.where((m) => m['id'] != saved.id).toList();
      final merged = [entry, ...filtered].take(50).toList();
      await ref.set({
        'customRecipes': merged,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {
      // best-effort — the backend save is the source of truth
    }
  }

  void reset() => state = const AiRecipeState();
}

final aiRecipeProvider =
    StateNotifierProvider<AiRecipeController, AiRecipeState>((ref) {
  return AiRecipeController(ref);
});
