import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/api/api_client.dart';
import 'package:spiceroute/data/explore_cache.dart';
import 'package:spiceroute/models/spice_route.dart';
import 'package:spiceroute/state/explore.dart';

import '../helpers/saved_test_support.dart' show mockSecureStorage;

/// Fake [ApiClient] for the Explore controller that records every
/// `listRecipes` call and returns a queue of pre-built responses.
///
/// We expose a per-call [Completer] so individual tests can interleave
/// `refresh()` and `loadMore()` and pin the exact order in which their
/// futures resolve — that's how we exercise the write-fence (the
/// in-flight loadMore must NOT clobber state after a refresh has been
/// issued mid-flight).
class _FakeApi implements ApiClient {
  final List<({int limit, int offset, String? q, Cuisine? cuisine})> calls = [];
  final List<Completer<SpiceRouteListResponse>> _queue = [];

  /// Queue a response to be returned by the *next* call. Returns the
  /// Completer so the test can resolve it on demand. The order of
  /// queueing must match the order of calls.
  Completer<SpiceRouteListResponse> queue() {
    final c = Completer<SpiceRouteListResponse>();
    _queue.add(c);
    return c;
  }

  /// Convenience: queue a response that resolves immediately with the
  /// given items + total.
  void queueImmediate(List<SpiceRouteSummary> items, int total) {
    final c = queue();
    c.complete(SpiceRouteListResponse(items: items, total: total));
  }

  @override
  Future<SpiceRouteListResponse> listRecipes({
    String? q,
    Cuisine? cuisine,
    String? language,
    String? translateTo,
    String? tag,
    int? maxMinutes,
    bool premiumOnly = false,
    bool mine = false,
    int limit = 24,
    int offset = 0,
  }) {
    calls.add((limit: limit, offset: offset, q: q, cuisine: cuisine));
    if (_queue.isEmpty) {
      throw StateError(
        'No response queued. Call queue() or queueImmediate() before each '
        'controller call you intend to make.',
      );
    }
    return _queue.removeAt(0).future;
  }

  @override
  noSuchMethod(Invocation invocation) {
    throw StateError(
      '_FakeApi.${invocation.memberName.toString()} was called — pagination '
      "tests shouldn't reach the rest of the API surface.",
    );
  }
}

/// Builds a fresh `ExploreController` wired against `_FakeApi`.
///
/// We can't pass a bare [ProviderContainer] to the controller because
/// its constructor expects a [Ref] (which is what overrides receive),
/// so the indirection is: register an override that constructs the
/// controller from the override's `ref`, then `read` it back out.
({ExploreController controller, _FakeApi api, ProviderContainer container})
_makeController() {
  final api = _FakeApi();
  // ExploreController calls refresh() in its constructor, so queue a
  // response for that opening call. Tests can override this baseline
  // by replacing the queue between construction and their first
  // assertion.
  api.queueImmediate(const <SpiceRouteSummary>[], 0);
  final container = ProviderContainer(
    overrides: [
      exploreProvider.overrideWith((ref) => ExploreController(api, ref)),
    ],
  );
  final controller = container.read(exploreProvider.notifier);
  addTearDown(container.dispose);
  return (controller: controller, api: api, container: container);
}

SpiceRouteSummary _summary(String id) => SpiceRouteSummary(id: id, title: id);

void main() {
  // localeProvider's constructor reads from FlutterSecureStorage; without
  // a mock it raises MissingPluginException. The mock setter touches
  // TestDefaultBinaryMessengerBinding.instance, which requires the test
  // binding to be initialized first.
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(mockSecureStorage);

  group('ExploreController pagination', () {
    test('hydrates cached grid before the opening refresh resolves', () async {
      exploreCacheMemoryStore = {};
      addTearDown(() => exploreCacheMemoryStore = null);

      await ExploreCache.write(
        locale: 'en',
        q: '',
        items: [_summary('cached-a'), _summary('cached-b')],
        total: 12,
      );

      final api = _FakeApi();
      final pending = api.queue();
      final container = ProviderContainer(
        overrides: [
          exploreProvider.overrideWith((ref) => ExploreController(api, ref)),
        ],
      );
      addTearDown(container.dispose);

      while (container.read(exploreProvider).items.isEmpty) {
        await Future<void>.delayed(Duration.zero);
      }

      final mid = container.read(exploreProvider);
      expect(mid.loading, isTrue);
      expect(mid.items.map((r) => r.id).toList(), ['cached-a', 'cached-b']);
      expect(mid.total, 12);

      pending.complete(
        SpiceRouteListResponse(
          items: [_summary('fresh')],
          total: 1,
        ),
      );
      while (container.read(exploreProvider).loading) {
        await Future<void>.delayed(Duration.zero);
      }

      final done = container.read(exploreProvider);
      expect(done.loading, isFalse);
      expect(done.items.single.id, 'fresh');
    });

    test('refresh resets pagination state and requests page 0', () async {
      final ctx = _makeController();
      // Wait for the constructor's initial refresh() to settle.
      await Future<void>.delayed(Duration.zero);

      // Queue a meaningful first-page response so we can assert state
      // after the refresh.
      ctx.api.queueImmediate([_summary('a'), _summary('b'), _summary('c')], 90);
      await ctx.controller.refresh();

      expect(ctx.controller.state.loading, isFalse);
      expect(ctx.controller.state.items.length, 3);
      expect(ctx.controller.state.total, 90);
      expect(ctx.controller.state.hasMore, isTrue);
      // The second call should be the manual refresh (the first was
      // from the constructor); both ask for offset=0 with pageSize.
      expect(ctx.api.calls.last.offset, 0);
      expect(ctx.api.calls.last.limit, ExploreController.pageSize);
    });

    test('loadMore appends results and advances offset', () async {
      final ctx = _makeController();
      await Future<void>.delayed(Duration.zero);

      // Page 1: 3 items out of 5 total → hasMore should be true.
      ctx.api.queueImmediate([_summary('a'), _summary('b'), _summary('c')], 5);
      await ctx.controller.refresh();
      expect(ctx.controller.state.hasMore, isTrue);

      // Page 2: the remaining 2 items.
      ctx.api.queueImmediate([_summary('d'), _summary('e')], 5);
      await ctx.controller.loadMore();

      expect(ctx.controller.state.items.map((r) => r.id).toList(), [
        'a',
        'b',
        'c',
        'd',
        'e',
      ]);
      expect(ctx.controller.state.hasMore, isFalse);
      // Page-2 call used the post-refresh items.length as offset.
      expect(ctx.api.calls.last.offset, 3);
    });

    test('loadMore is a no-op when there are no more results', () async {
      final ctx = _makeController();
      await Future<void>.delayed(Duration.zero);

      // total == items.length → hasMore is false.
      ctx.api.queueImmediate([_summary('a'), _summary('b')], 2);
      await ctx.controller.refresh();
      expect(ctx.controller.state.hasMore, isFalse);

      final callCountBefore = ctx.api.calls.length;
      await ctx.controller.loadMore();
      await ctx.controller.loadMore();
      // No new API calls because the controller short-circuited.
      expect(ctx.api.calls.length, callCountBefore);
    });

    test(
      'loadMore guards against re-entry while a fetch is in flight',
      () async {
        final ctx = _makeController();
        await Future<void>.delayed(Duration.zero);

        ctx.api.queueImmediate([_summary('a')], 10);
        await ctx.controller.refresh();
        final callsBefore = ctx.api.calls.length;

        // Don't resolve the loadMore response — leave it pending so we
        // can verify that a second loadMore() call returns immediately
        // without hitting the API.
        final pending = ctx.api.queue();
        final firstCall = ctx.controller.loadMore();
        // The state should report loadingMore=true so the UI knows a
        // fetch is in flight.
        expect(ctx.controller.state.loadingMore, isTrue);

        // A re-entry attempt fires zero new API calls.
        await ctx.controller.loadMore();
        await ctx.controller.loadMore();
        expect(ctx.api.calls.length, callsBefore + 1);

        // Let the first loadMore finish so addTearDown can dispose cleanly.
        pending.complete(
          SpiceRouteListResponse(items: [_summary('b')], total: 10),
        );
        await firstCall;
        expect(ctx.controller.state.loadingMore, isFalse);
      },
    );

    test(
      'concurrent refresh wins the write-fence over an in-flight loadMore',
      () async {
        // Regression: if the user changes cuisine mid-scroll, the
        // in-flight loadMore must NOT append its (stale) results onto
        // the new filter's items. The token check in loadMore() drops
        // the result silently.
        final ctx = _makeController();
        await Future<void>.delayed(Duration.zero);

        // Page 1 of cuisine "A".
        ctx.api.queueImmediate([_summary('a1'), _summary('a2')], 10);
        await ctx.controller.refresh();

        // Start a loadMore but don't resolve it yet.
        final stalePage = ctx.api.queue();
        final stale = ctx.controller.loadMore();

        // Meanwhile, the user changes cuisine which fires a fresh
        // refresh(). Refresh wipes items and increments the token, so
        // the stale loadMore's result should be discarded when it
        // finally resolves.
        ctx.api.queueImmediate([
          _summary('b1'),
          _summary('b2'),
          _summary('b3'),
        ], 3);
        ctx.controller.setCuisine(Cuisine.korean);
        // setCuisine triggers a refresh internally; wait for it.
        await Future<void>.delayed(Duration.zero);

        // Now resolve the stale loadMore — its result must be ignored.
        stalePage.complete(
          SpiceRouteListResponse(items: [_summary('a3')], total: 10),
        );
        await stale;

        expect(
          ctx.controller.state.items.map((r) => r.id).toList(),
          ['b1', 'b2', 'b3'],
          reason:
              'Stale loadMore should not have appended a3 onto the '
              'post-refresh items.',
        );
      },
    );

    test('refresh keeps stale items when the network fails', () async {
      final ctx = _makeController();
      await Future<void>.delayed(Duration.zero);

      ctx.api.queueImmediate([_summary('a'), _summary('b')], 2);
      await ctx.controller.refresh();
      expect(ctx.controller.state.items.map((r) => r.id), ['a', 'b']);

      final failing = ctx.api.queue();
      failing.completeError(
        ApiException(0, kApiErrorNetworkSentinel),
      );
      await ctx.controller.refresh();

      expect(ctx.controller.state.items.map((r) => r.id), ['a', 'b']);
      expect(ctx.controller.state.error, kApiErrorNetworkSentinel);
      expect(ctx.controller.state.errorFromRefresh, isTrue);
    });
  });
}
