import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../models/spice_route.dart';
import 'auth.dart';
import 'explore.dart' show kUnknownErrorSentinel;
import 'locale.dart';
import 'providers.dart';

/// External invalidation token for the /my-recipes listing. Writers
/// (recipe delete confirmation, AI Creator save, recipe PATCH) bump
/// this so the next read sees a fresh fetch instead of cached items.
///
/// Two write paths can mutate the user's owned-recipe set without
/// otherwise triggering a refresh:
///
///   1. Deleting a recipe from the detail modal then popping back to
///      /my-recipes (the modal sits over /my-recipes so the underlying
///      route's State is preserved — without a revision bump, the
///      deleted recipe stays as a tombstone tile until the user pulls
///      to refresh).
///   2. Saving an AI-generated recipe from /ai/creator. The new id
///      lands server-side, but /my-recipes won't pick it up until
///      the next manual refresh.
///
/// Lives in this state file (not in the screen file) so the
/// controller can subscribe to it without a cyclic import.
final myRecipesRevisionProvider = StateProvider<int>((_) => 0);

/// Convenience: bump the revision from any writer without dealing
/// with the notifier directly. Idempotent and cheap (single state
/// notifier write), safe to call when /my-recipes isn't mounted.
void invalidateMyRecipes(WidgetRef ref) {
  ref.read(myRecipesRevisionProvider.notifier).state++;
}

/// Paginated state for the /my-recipes grid. Mirrors the shape of
/// `ExploreState` so the two surfaces share a mental model for
/// loading / loadingMore / error / hasMore.
///
/// We DON'T need cuisine / course / dietary / q here — /my-recipes
/// is a simple "show me everything I own" view; filtering is left
/// for a future iteration if user libraries grow large enough to
/// warrant it.
@immutable
class MyRecipesState {
  const MyRecipesState({
    this.items = const [],
    this.loading = true,
    this.loadingMore = false,
    this.total = 0,
    this.error,
    this.errorFromRefresh = false,
  });

  final List<SpiceRouteSummary> items;
  final bool loading;
  final bool loadingMore;
  final int total;
  final String? error;

  /// True when [error] came from [MyRecipesController.refresh].
  final bool errorFromRefresh;

  /// True iff the server has more rows beyond what we've already
  /// loaded. Drives the infinite-scroll trigger AND gates retry
  /// attempts after a `loadMore` failure.
  bool get hasMore => items.length < total;

  MyRecipesState copyWith({
    List<SpiceRouteSummary>? items,
    bool? loading,
    bool? loadingMore,
    int? total,
    String? error,
    bool clearError = false,
    bool? errorFromRefresh,
  }) => MyRecipesState(
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

class MyRecipesController extends StateNotifier<MyRecipesState> {
  MyRecipesController(this._api, this._ref) : super(const MyRecipesState()) {
    // Re-fetch when the active UI locale changes so card titles +
    // descriptions arrive in the new language. Mirrors `ExploreController`.
    _localeSub = _ref.listen<Locale>(localeProvider, (prev, next) {
      if (prev?.languageCode != next.languageCode) {
        refresh(localeChanged: true);
      }
    });
    // Refresh on sign-in / sign-out / account switch. Without this
    // fence, user B signing in after user A would see A's cached
    // owned-recipes until they pull-to-refreshed — a cross-account
    // data leak in the visible UI (the same bug the previous
    // `_futureForUid` fence on the screen state guarded against).
    _authSub = _ref.listen<AppUser?>(authControllerProvider, (prev, next) {
      if (prev?.uid != next?.uid) {
        refresh();
      }
    });
    // External-invalidation token: writers (recipe delete confirmation,
    // AI Creator save, recipe edit) bump `myRecipesRevisionProvider`
    // to force the next visit to /my-recipes to re-fetch. Without
    // this fence, the user has to pull-to-refresh after every
    // mutation to see their just-saved or just-deleted recipe.
    _revisionSub = _ref.listen<int>(
      myRecipesRevisionProvider,
      (_, _) => refresh(),
    );
    refresh();
  }

  final ApiClient _api;
  final Ref _ref;
  ProviderSubscription<Locale>? _localeSub;
  ProviderSubscription<AppUser?>? _authSub;
  ProviderSubscription<int>? _revisionSub;

  /// Monotonic write-fence. Same pattern as `ExploreController`: only
  /// the most recent in-flight request is allowed to apply its
  /// result. Protects against a concurrent `refresh()` (e.g. locale
  /// flip) landing AFTER a `loadMore()` and appending stale items
  /// onto the wrong language's list.
  int _refreshToken = 0;

  /// Page size. Same 30 we use on Explore — fills ~5 desktop rows on
  /// first paint without making the first roundtrip block behind a
  /// long image-decode tail.
  static const int pageSize = 30;

  Future<SpiceRouteListResponse> _listMine({required int offset}) {
    return _api.listRecipes(
      mine: true,
      limit: pageSize,
      offset: offset,
      translateTo: _ref.read(localeProvider).languageCode,
    );
  }

  /// `mine=true` 401s right after sign-in when Firebase has flipped
  /// `currentUser` but `getIdToken()` still returns null on the first
  /// attempt. Dio's interceptor already force-refreshes once; this adds
  /// one delayed re-fetch for the post-login race.
  Future<SpiceRouteListResponse> _listMineWithAuthRetry({
    required int offset,
  }) async {
    try {
      return await _listMine(offset: offset);
    } on ApiException catch (e) {
      if (!e.isUnauthorized) rethrow;
      if (_ref.read(authControllerProvider) == null) rethrow;
      await Future<void>.delayed(const Duration(milliseconds: 600));
      if (_ref.read(authControllerProvider) == null) rethrow;
      return await _listMine(offset: offset);
    }
  }

  Future<void> refresh({bool localeChanged = false}) async {
    final token = ++_refreshToken;
    final auth = _ref.read(authControllerProvider.notifier);
    if (!auth.isInitialized) {
      // Firebase may still be rehydrating the session from disk. Hitting
      // `mine=true` before a token is mintable returns 401 and used to
      // trigger a full sign-out — felt like "Mine tab logs me out".
      state = state.copyWith(loading: true, clearError: true);
      for (var i = 0; i < 60; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        if (auth.isInitialized) break;
      }
      if (!auth.isInitialized) {
        if (token != _refreshToken) return;
        state = state.copyWith(loading: false);
        return;
      }
      if (token != _refreshToken) return;
    }
    final user = _ref.read(authControllerProvider);
    if (user == null) {
      // Signed out (or never signed in). Clear the state so the
      // screen-level "Please sign in" CenterMessage takes over, and
      // skip the doomed API call (would 401 and pollute server logs
      // + rate-limit counters).
      state = const MyRecipesState(items: [], loading: false, total: 0);
      return;
    }
    final previousItems = state.items;
    final previousTotal = state.total;
    final hadItems = previousItems.isNotEmpty;
    if (localeChanged) {
      state = state.copyWith(
        loading: true,
        loadingMore: false,
        clearError: true,
        items: const [],
        total: 0,
      );
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
      final res = await _listMineWithAuthRetry(offset: 0);
      if (token != _refreshToken) return;
      state = state.copyWith(
        loading: false,
        items: res.items,
        total: res.total,
      );
    } catch (e) {
      if (token != _refreshToken) return;
      if (e is ApiException && e.isUnauthorized) {
        // Session exists but the backend still rejected us — surface a
        // retryable error instead of the sign-in gate (user is signed in).
        state = state.copyWith(loading: false, error: kAuthRequiredSentinel);
        return;
      }
      state = state.copyWith(
        loading: false,
        error: _humanError(e),
        errorFromRefresh: true,
        items: state.items.isEmpty && hadItems ? previousItems : state.items,
        total: state.items.isEmpty && hadItems ? previousTotal : state.total,
      );
    }
  }

  /// Append the next page of results. No-op when:
  ///   * a first-page fetch is in flight (`loading`),
  ///   * a page-fetch is already in flight (`loadingMore`),
  ///   * we've already loaded everything the server has (`!hasMore`).
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
      final res = await _listMineWithAuthRetry(offset: state.items.length);
      if (token != _refreshToken) return;
      state = state.copyWith(
        loadingMore: false,
        items: [...state.items, ...res.items],
        total: res.total,
      );
    } catch (e) {
      if (token != _refreshToken) return;
      if (e is ApiException && e.isUnauthorized) {
        state = state.copyWith(
          loadingMore: false,
          error: kAuthRequiredSentinel,
        );
        return;
      }
      // Don't wipe items — the user keeps everything they've already
      // loaded; the screen renders a small "load more failed" footer
      // off the error field.
      state = state.copyWith(
        loadingMore: false,
        error: _humanError(e),
        errorFromRefresh: false,
      );
    }
  }

  static String _humanError(Object e) {
    if (e is ApiException && e.isUnauthorized) return kAuthRequiredSentinel;
    return e is ApiException ? e.message : kUnknownErrorSentinel;
  }

  @override
  void dispose() {
    _localeSub?.close();
    _authSub?.close();
    _revisionSub?.close();
    super.dispose();
  }
}

final myRecipesProvider =
    StateNotifierProvider<MyRecipesController, MyRecipesState>((ref) {
      return MyRecipesController(ref.watch(apiClientProvider), ref);
    });
