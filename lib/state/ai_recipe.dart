import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../models/spice_route.dart';
import 'providers.dart';

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
  AiRecipeController(this._api) : super(const AiRecipeState());

  final ApiClient _api;

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

  void reset() => state = const AiRecipeState();
}

final aiRecipeProvider =
    StateNotifierProvider<AiRecipeController, AiRecipeState>((ref) {
  return AiRecipeController(ref.watch(apiClientProvider));
});
