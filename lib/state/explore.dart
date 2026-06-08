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
    this.course,
    this.dietary,
    this.q = '',
    this.items = const [],
    this.loading = true,
    this.error,
  });

  /// `null` means "All".
  final Cuisine? cuisine;

  /// `null` means "All Courses". Filtered client-side via tag matching.
  final Course? course;

  /// `null` means "All Requests". Filtered client-side via tag matching.
  final Dietary? dietary;

  final String q;

  /// Raw items returned by the API (filtered by cuisine + search server-side).
  /// Use [visibleItems] for the post-client-filter list to render.
  final List<SpiceRouteSummary> items;
  final bool loading;
  final String? error;

  /// Items after applying client-side course + dietary filters.
  ///
  /// The backend only knows about cuisine + free-text search. Course and
  /// dietary live in the `tags` list (e.g. a recipe tagged "vegetarian"
  /// passes `Dietary.vegetarian`), so we narrow further in-memory rather
  /// than round-tripping. Keeps the network the same while making the
  /// UI dropdowns actually work.
  List<SpiceRouteSummary> get visibleItems {
    if (course == null && dietary == null) return items;
    return items
        .where((r) => _matchesCourse(r) && _matchesDietary(r))
        .toList(growable: false);
  }

  bool _matchesCourse(SpiceRouteSummary r) {
    if (course == null) return true;
    final needle = course!.tagName.toLowerCase();
    return r.tags.any((t) => t.name.toLowerCase() == needle);
  }

  bool _matchesDietary(SpiceRouteSummary r) {
    if (dietary == null) return true;
    final needle = dietary!.tagName.toLowerCase();
    return r.tags.any((t) => t.name.toLowerCase() == needle);
  }

  ExploreState copyWith({
    Cuisine? cuisine,
    bool clearCuisine = false,
    Course? course,
    bool clearCourse = false,
    Dietary? dietary,
    bool clearDietary = false,
    String? q,
    List<SpiceRouteSummary>? items,
    bool? loading,
    String? error,
    bool clearError = false,
  }) =>
      ExploreState(
        cuisine: clearCuisine ? null : (cuisine ?? this.cuisine),
        course: clearCourse ? null : (course ?? this.course),
        dietary: clearDietary ? null : (dietary ?? this.dietary),
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

  /// Course is a client-side filter — no need to re-hit the API.
  void setCourse(Course? course) {
    if (course == state.course) return;
    state = course == null
        ? state.copyWith(clearCourse: true)
        : state.copyWith(course: course);
  }

  /// Dietary is a client-side filter — no need to re-hit the API.
  void setDietary(Dietary? dietary) {
    if (dietary == state.dietary) return;
    state = dietary == null
        ? state.copyWith(clearDietary: true)
        : state.copyWith(dietary: dietary);
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
      state = state.copyWith(loading: false, error: _humanError(e));
    }
  }

  static String _humanError(Object e) =>
      e is ApiException ? e.message : 'Something went wrong.';

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
