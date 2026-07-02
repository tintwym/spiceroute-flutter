import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../data/explore_cache.dart';
import '../models/cuisine_catalog.dart';
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
    this.loadingMore = false,
    this.total = 0,
    this.error,
    this.errorFromRefresh = false,
  });

  /// `null` means "All".
  final Cuisine? cuisine;

  /// `null` means "All Courses". Filtered client-side via tag matching.
  final Course? course;

  /// `null` means "All Preferences". Filtered client-side via tag matching.
  final Dietary? dietary;

  final String q;

  /// Raw items returned by the API (filtered by cuisine + search server-side).
  /// Use [visibleItems] for the post-client-filter list to render.
  final List<SpiceRouteSummary> items;

  /// True for the first-page fetch (no items yet). Use to show the
  /// shimmer placeholder grid in place of the recipes.
  final bool loading;

  /// True while a follow-up page is being fetched. Renders as a small
  /// spinner footer below the existing grid so the user knows their
  /// scroll triggered work without the whole list disappearing.
  final bool loadingMore;

  /// Total public-recipe count reported by the API. Drives [hasMore]
  /// and the result-counter label. The backend re-reports this on
  /// every request so it always tracks the latest filter state.
  final int total;

  final String? error;

  /// True when [error] came from a first-page [ExploreController.refresh]
  /// (locale / filter / search). False when it came from [loadMore].
  final bool errorFromRefresh;

  /// Whether the server has more items beyond what we've already
  /// loaded. Pulls from the API's `total` (not from `visibleItems`)
  /// because course/dietary filters are applied client-side and would
  /// otherwise falsely signal "no more" any time a filter hid all
  /// remaining items on the current page.
  bool get hasMore => items.length < total;

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
    bool? loadingMore,
    int? total,
    String? error,
    bool clearError = false,
    bool? errorFromRefresh,
  }) => ExploreState(
    cuisine: clearCuisine ? null : (cuisine ?? this.cuisine),
    course: clearCourse ? null : (course ?? this.course),
    dietary: clearDietary ? null : (dietary ?? this.dietary),
    q: q ?? this.q,
    items: items ?? this.items,
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    total: total ?? this.total,
    error: clearError ? null : (error ?? this.error),
    errorFromRefresh: clearError
        ? false
        : (errorFromRefresh ?? this.errorFromRefresh),
  );
}

class ExploreController extends StateNotifier<ExploreState> {
  ExploreController(this._api, this._ref) : super(const ExploreState()) {
    _localeSub = _ref.listen<Locale>(localeProvider, (prev, next) {
      if (prev?.languageCode != next.languageCode) {
        // Drop any cached grid for the old locale so we never paint
        // English titles under Chinese chrome (or vice versa) from a
        // prior fetch that fell back to source copy.
        unawaited(ExploreCache.clear());
        refresh(localeChanged: true);
      }
    });
    unawaited(_initialRefresh());
  }

  final ApiClient _api;
  final Ref _ref;
  Timer? _searchDebounce;
  ProviderSubscription<Locale>? _localeSub;
  bool _disposed = false;

  Future<void> _initialRefresh() async {
    // Read cache in parallel with locale bootstrap so a hard refresh
    // can paint stale cards as soon as the locale latch completes.
    final cacheFuture = ExploreCache.read();
    await _ref.read(localeProvider.notifier).ready;
    if (_disposed) return;
    await _hydrateFromCache(await cacheFuture);
    if (_disposed) return;
    await refresh();
  }

  Future<void> _hydrateFromCache(ExploreCacheSnapshot? snapshot) async {
    if (snapshot == null) return;
    final locale = _ref.read(localeProvider).languageCode;
    if (!snapshot.matches(
      locale: locale,
      q: state.q,
      cuisine: state.cuisine,
    )) {
      return;
    }
    state = state.copyWith(
      items: snapshot.items,
      total: snapshot.total,
      loading: true,
      clearError: true,
    );
  }

  void _persistCache() {
    final items = state.items;
    if (items.isEmpty) return;
    unawaited(
      ExploreCache.write(
        locale: _ref.read(localeProvider).languageCode,
        q: state.q,
        cuisine: state.cuisine,
        items: items,
        total: state.total,
      ),
    );
  }

  /// Monotonic counter incremented on every `refresh()` entry. Used as
  /// a write-fence: only the most recent in-flight request is allowed
  /// to apply its result. Without this, rapidly cycling cuisine pills
  /// (or typing fast in the search box) starts multiple parallel API
  /// calls and the SLOWEST one's results win — so the visible recipes
  /// stop matching the active filter pills (a common "the filter looks
  /// broken" bug).
  int _refreshToken = 0;

  void setCuisine(Cuisine? cuisine) {
    final normalized = normalizeCuisineFilter(cuisine);
    if (normalized == state.cuisine) return;
    state = normalized == null
        ? state.copyWith(clearCuisine: true)
        : state.copyWith(cuisine: normalized);
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
    _searchDebounce = Timer(const Duration(milliseconds: 200), refresh);
  }

  /// Page size for the Explore grid. Sized to fill ~5 desktop rows of
  /// 4 cards at first paint (more than that and the first roundtrip
  /// blocks behind 30 image decodes) while keeping follow-up pages
  /// snappy. The backend caps `limit` at 100.
  static const int pageSize = 30;

  Future<void> refresh({bool localeChanged = false}) async {
    final token = ++_refreshToken;
    final previousItems = state.items;
    final previousTotal = state.total;
    final hadItems = previousItems.isNotEmpty;

    if (localeChanged) {
      // Prefer a cached grid for the target locale, then fall back to
      // the visible grid while revalidating. Clearing to empty on a
      // network blip left non-English users staring at a full-screen
      // error even though English cards were fine a moment ago.
      final locale = _ref.read(localeProvider).languageCode;
      final cached = await ExploreCache.read();
      if (cached != null &&
          cached.matches(
            locale: locale,
            q: state.q,
            cuisine: state.cuisine,
          ) &&
          cached.items.isNotEmpty) {
        state = state.copyWith(
          items: cached.items,
          total: cached.total,
          loading: true,
          loadingMore: false,
          clearError: true,
        );
      } else {
        // Never keep the previous locale's titles on screen — Chinese
        // footers + English recipe names is exactly what users report
        // as "language failed". Brief shimmer beats mixed-language cards.
        state = state.copyWith(
          loading: true,
          loadingMore: false,
          clearError: true,
          items: const [],
          total: 0,
        );
      }
    } else {
      state = state.copyWith(
        loading: true,
        loadingMore: false,
        clearError: true,
        items: hadItems ? previousItems : const [],
        total: hadItems ? previousTotal : 0,
      );
    }
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
        limit: pageSize,
        offset: 0,
      );
      if (token != _refreshToken) return;
      state = state.copyWith(
        loading: false,
        items: res.items,
        total: res.total,
      );
      _persistCache();
    } catch (e) {
      if (token != _refreshToken) return;
      final stillEmpty = state.items.isEmpty;
      state = state.copyWith(
        loading: false,
        error: _humanError(e),
        errorFromRefresh: true,
        items: stillEmpty && hadItems ? previousItems : state.items,
        total: stillEmpty && hadItems ? previousTotal : state.total,
      );
    }
  }

  /// Append the next page of results. No-op when:
  ///   * a first-page fetch is in flight (`loading`), so we don't
  ///     double up while shimmer is showing,
  ///   * a page-fetch is already in flight (`loadingMore`), so the
  ///     scroll-listener can fire rapidly without queueing requests,
  ///   * we've hit the end of the result set (`!hasMore`).
  ///
  /// Uses the same `_refreshToken` write-fence as [refresh] so a
  /// concurrent refresh (e.g. user changed cuisine mid-scroll) wins
  /// over an in-flight loadMore — the older request's results are
  /// discarded instead of appended onto the wrong filter set.
  Future<void> loadMore() async {
    if (state.loading || state.loadingMore || !state.hasMore) return;
    final token = _refreshToken;
    // Clear any previous error on entry so the retry path produces
    // a clean state on success. Without this, the screen's "load
    // more failed — tap to retry" footer (driven by `state.error`)
    // stays stuck on screen even AFTER the retry succeeds and
    // appends the next page.
    state = state.copyWith(loadingMore: true, clearError: true);
    try {
      final res = await _api.listRecipes(
        q: state.q.isEmpty ? null : state.q,
        cuisine: state.cuisine,
        translateTo: _ref.read(localeProvider).languageCode,
        limit: pageSize,
        offset: state.items.length,
      );
      if (token != _refreshToken) return;
      state = state.copyWith(
        loadingMore: false,
        items: [...state.items, ...res.items],
        total: res.total,
      );
      _persistCache();
    } catch (e) {
      if (token != _refreshToken) return;
      // Surface the error on the state so the screen can show a small
      // "load more failed — tap to retry" footer. We deliberately
      // don't wipe `items` here: the user keeps everything they've
      // already loaded.
      state = state.copyWith(
        loadingMore: false,
        error: _humanError(e),
        errorFromRefresh: false,
      );
    }
  }

  static String _humanError(Object e) =>
      e is ApiException ? e.message : kUnknownErrorSentinel;

  @override
  void dispose() {
    _disposed = true;
    _searchDebounce?.cancel();
    _localeSub?.close();
    super.dispose();
  }
}

final exploreProvider = StateNotifierProvider<ExploreController, ExploreState>((
  ref,
) {
  return ExploreController(ref.watch(apiClientProvider), ref);
});
