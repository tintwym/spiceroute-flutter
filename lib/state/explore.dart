import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../models/spice_route.dart';
import 'locale.dart';
import 'providers.dart';

/// Sentinel stored in [ExploreState.error] (and other state-notifier
/// error fields) when the failure was *not* an [ApiException] — i.e.
/// there's no server-supplied message we can surface verbatim.
///
/// The state notifier lives outside the widget tree and can't reach
/// [AppL10n]; the render site checks for this sentinel and substitutes
/// the localized `commonError` string ("Đã xảy ra lỗi" / "出错了" /
/// "တစ်စုံတစ်ရာ မှားယွင်းသွားသည်", …). Without the sentinel the
/// fallback string was a hardcoded English literal — visible to every
/// non-English user on a network blip.
const String kUnknownErrorSentinel = '__app_unknown_error__';

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
    return course!.matches(r.tags);
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
  ExploreController(this._api, this._ref) : super(const ExploreState()) {
    // Re-fetch when the user switches UI locale so card titles /
    // descriptions arrive in the new language (the backend swaps them
    // server-side based on the `translate_to` query param). Without
    // this watcher, switching from English → Burmese leaves the
    // visible grid stuck on whatever titles the previous request
    // returned, defeating the whole point of seeded translations.
    _localeSub = _ref.listen<Locale>(localeProvider, (prev, next) {
      if (prev?.languageCode != next.languageCode) {
        refresh();
      }
    });
    refresh();
  }

  final ApiClient _api;
  final Ref _ref;
  Timer? _searchDebounce;
  ProviderSubscription<Locale>? _localeSub;

  /// Monotonic counter incremented on every `refresh()` entry. Used as
  /// a write-fence: only the most recent in-flight request is allowed
  /// to apply its result. Without this, rapidly cycling cuisine pills
  /// (or typing fast in the search box) starts multiple parallel API
  /// calls and the SLOWEST one's results win — so the visible recipes
  /// stop matching the active filter pills (a common "the filter looks
  /// broken" bug).
  int _refreshToken = 0;

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
    final token = ++_refreshToken;
    state = state.copyWith(loading: true, clearError: true);
    try {
      final res = await _api.listRecipes(
        q: state.q.isEmpty ? null : state.q,
        cuisine: state.cuisine,
        // Tell the backend which locale to substitute into the title
        // and description columns. Recipes without a matching entry in
        // their `translations` JSONB fall back to the source values, so
        // an English-only seeded recipe still shows English on a
        // Burmese UI rather than going blank.
        translateTo: _ref.read(localeProvider).languageCode,
        limit: 60,
      );
      if (token != _refreshToken) return;
      state = state.copyWith(loading: false, items: res.items);
    } catch (e) {
      if (token != _refreshToken) return;
      state = state.copyWith(loading: false, error: _humanError(e));
    }
  }

  static String _humanError(Object e) =>
      e is ApiException ? e.message : kUnknownErrorSentinel;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _localeSub?.close();
    super.dispose();
  }
}

final exploreProvider =
    StateNotifierProvider<ExploreController, ExploreState>((ref) {
  return ExploreController(ref.watch(apiClientProvider), ref);
});
