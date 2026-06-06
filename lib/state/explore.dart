import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../models/spice_route.dart';
import 'providers.dart';

@immutable
class ExploreState {
  const ExploreState({
    this.cuisine,
    this.q = '',
    this.items = const [],
    this.loading = true,
    this.error,
  });

  /// `null` means "All".
  final Cuisine? cuisine;
  final String q;
  final List<SpiceRouteSummary> items;
  final bool loading;
  final String? error;

  ExploreState copyWith({
    Cuisine? cuisine,
    bool clearCuisine = false,
    String? q,
    List<SpiceRouteSummary>? items,
    bool? loading,
    String? error,
    bool clearError = false,
  }) =>
      ExploreState(
        cuisine: clearCuisine ? null : (cuisine ?? this.cuisine),
        q: q ?? this.q,
        items: items ?? this.items,
        loading: loading ?? this.loading,
        error: clearError ? null : (error ?? this.error),
      );
}

class ExploreController extends StateNotifier<ExploreState> {
  ExploreController(this._api) : super(const ExploreState()) {
    refresh();
  }

  final ApiClient _api;
  Timer? _searchDebounce;

  void setCuisine(Cuisine? cuisine) {
    if (cuisine == state.cuisine) return;
    state = cuisine == null
        ? state.copyWith(clearCuisine: true)
        : state.copyWith(cuisine: cuisine);
    refresh();
  }

  void setQuery(String q) {
    state = state.copyWith(q: q);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 280), refresh);
  }

  Future<void> refresh() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final res = await _api.listRecipes(
        q: state.q.isEmpty ? null : state.q,
        cuisine: state.cuisine,
        limit: 60,
      );
      state = state.copyWith(loading: false, items: res.items);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}

final exploreProvider =
    StateNotifierProvider<ExploreController, ExploreState>((ref) {
  return ExploreController(ref.watch(apiClientProvider));
});
