import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/api/api_client.dart';
import 'package:spiceroute/models/spice_route.dart';
import 'package:spiceroute/state/auth.dart';
import 'package:spiceroute/state/my_recipes.dart';

import '../helpers/saved_test_support.dart' show mockSecureStorage;

/// Fake [ApiClient] for the MyRecipes controller that records every
/// `listRecipes(mine: true)` call and returns a queue of responses.
/// Same shape as the Explore pagination test's `_FakeApi` — we keep
/// them separate rather than sharing because the assertion targets
/// diverge enough (mine-flag, single-cuisine semantics, no client-
/// side filters) that a shared base class would just hide intent.
class _FakeApi implements ApiClient {
  final List<({int limit, int offset, bool mine})> calls = [];
  final List<Completer<SpiceRouteListResponse>> _queue = [];

  Completer<SpiceRouteListResponse> queue() {
    final c = Completer<SpiceRouteListResponse>();
    _queue.add(c);
    return c;
  }

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
    calls.add((limit: limit, offset: offset, mine: mine));
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

/// Riverpod harness: signed-in user, fake API, controller-under-test.
///
/// We override `authControllerProvider` with a `StateProvider<AppUser?>`
/// so the controller's constructor sees a user and goes through the
/// happy refresh() path. The real authControllerProvider is a
/// StateNotifierProvider that would otherwise try to talk to Firebase.
({MyRecipesController controller, _FakeApi api, ProviderContainer container})
_makeController({AppUser? user = _kTestUser}) {
  final api = _FakeApi();
  // MyRecipesController calls refresh() in its constructor (matching
  // ExploreController's pattern). With a signed-in user that means
  // one immediate API call — queue an empty baseline response so
  // the construct-then-test flow doesn't blow up.
  if (user != null) {
    api.queueImmediate(const <SpiceRouteSummary>[], 0);
  }
  final container = ProviderContainer(
    overrides: [
      authControllerProvider.overrideWith((ref) => _FixedAuth(user)),
      myRecipesProvider.overrideWith((ref) => MyRecipesController(api, ref)),
    ],
  );
  final controller = container.read(myRecipesProvider.notifier);
  addTearDown(container.dispose);
  return (controller: controller, api: api, container: container);
}

/// Fixed-state subclass of `AuthController`. We pass `null` to the
/// super constructor so it skips the FirebaseAuth wiring path; then
/// we directly set `state` to the desired user. This is enough for
/// controllers that only `ref.read(authControllerProvider)` and
/// `ref.listen` on it — neither path cares whether the controller is
/// the "real" AuthController or a tame subclass.
class _FixedAuth extends AuthController {
  _FixedAuth(AppUser? user) : super(null) {
    state = user;
  }
}

const _kTestUser = AppUser(
  uid: 'u-test',
  email: null,
  displayName: 'Test',
  photoUrl: null,
);

SpiceRouteSummary _summary(String id) => SpiceRouteSummary(id: id, title: id);

void main() {
  // localeProvider's constructor reads from FlutterSecureStorage; without
  // the mock it raises MissingPluginException. The mock setter touches
  // TestDefaultBinaryMessengerBinding.instance, which requires the test
  // binding to be initialized first.
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(mockSecureStorage);

  group('MyRecipesController pagination', () {
    test(
      'constructor refresh passes mine=true with the configured page size',
      () async {
        final ctx = _makeController();
        await Future<void>.delayed(Duration.zero);

        expect(ctx.api.calls, isNotEmpty);
        expect(
          ctx.api.calls.first.mine,
          isTrue,
          reason: 'My Recipes must always set mine:true.',
        );
        expect(ctx.api.calls.first.limit, MyRecipesController.pageSize);
        expect(ctx.api.calls.first.offset, 0);
      },
    );

    test('refresh resets pagination state and requests page 0', () async {
      final ctx = _makeController();
      await Future<void>.delayed(Duration.zero);

      ctx.api.queueImmediate([_summary('a'), _summary('b'), _summary('c')], 90);
      await ctx.controller.refresh();

      expect(ctx.controller.state.loading, isFalse);
      expect(ctx.controller.state.items.length, 3);
      expect(ctx.controller.state.total, 90);
      expect(ctx.controller.state.hasMore, isTrue);
      expect(ctx.api.calls.last.offset, 0);
      expect(ctx.api.calls.last.limit, MyRecipesController.pageSize);
    });

    test('loadMore appends results and advances offset', () async {
      final ctx = _makeController();
      await Future<void>.delayed(Duration.zero);

      ctx.api.queueImmediate([_summary('a'), _summary('b'), _summary('c')], 5);
      await ctx.controller.refresh();
      expect(ctx.controller.state.hasMore, isTrue);

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
      expect(ctx.api.calls.last.offset, 3);
    });

    test('loadMore is a no-op when there are no more results', () async {
      final ctx = _makeController();
      await Future<void>.delayed(Duration.zero);

      ctx.api.queueImmediate([_summary('a'), _summary('b')], 2);
      await ctx.controller.refresh();
      expect(ctx.controller.state.hasMore, isFalse);

      final before = ctx.api.calls.length;
      await ctx.controller.loadMore();
      await ctx.controller.loadMore();
      expect(ctx.api.calls.length, before);
    });

    test(
      'loadMore guards against re-entry while a fetch is in flight',
      () async {
        final ctx = _makeController();
        await Future<void>.delayed(Duration.zero);

        ctx.api.queueImmediate([_summary('a')], 10);
        await ctx.controller.refresh();
        final before = ctx.api.calls.length;

        final pending = ctx.api.queue();
        final first = ctx.controller.loadMore();
        expect(ctx.controller.state.loadingMore, isTrue);

        await ctx.controller.loadMore();
        await ctx.controller.loadMore();
        expect(ctx.api.calls.length, before + 1);

        pending.complete(
          SpiceRouteListResponse(items: [_summary('b')], total: 10),
        );
        await first;
        expect(ctx.controller.state.loadingMore, isFalse);
      },
    );

    test(
      'refresh while loadMore is in flight discards the stale page',
      () async {
        // Regression analogue: a manual refresh (pull-to-refresh, or
        // the controller's auth/locale listener firing) must invalidate
        // any in-flight loadMore so its stale results don't get
        // appended onto the fresh first-page items.
        final ctx = _makeController();
        await Future<void>.delayed(Duration.zero);

        ctx.api.queueImmediate([_summary('a1'), _summary('a2')], 10);
        await ctx.controller.refresh();

        final stale = ctx.api.queue();
        final staleCall = ctx.controller.loadMore();

        ctx.api.queueImmediate([
          _summary('b1'),
          _summary('b2'),
          _summary('b3'),
        ], 3);
        await ctx.controller.refresh();

        stale.complete(
          SpiceRouteListResponse(items: [_summary('a3')], total: 10),
        );
        await staleCall;

        expect(
          ctx.controller.state.items.map((r) => r.id).toList(),
          ['b1', 'b2', 'b3'],
          reason:
              'Stale loadMore should not have appended a3 onto the '
              'post-refresh items.',
        );
      },
    );

    test(
      '401 on refresh retries then succeeds when token becomes ready',
      () async {
        final ctx = _makeController();
        await Future<void>.delayed(Duration.zero);

        final fail1 = ctx.api.queue();
        final ok = ctx.api.queue();
        final refreshFuture = ctx.controller.refresh();
        fail1.completeError(
          ApiException(401, '`mine=true` requires authentication'),
        );
        await Future<void>.delayed(const Duration(milliseconds: 650));
        ok.complete(const SpiceRouteListResponse(items: [], total: 0));
        await refreshFuture;
        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(ctx.container.read(authControllerProvider), isNotNull);
        expect(ctx.controller.state.error, isNull);
        expect(ctx.controller.state.items, isEmpty);
        expect(ctx.controller.state.loading, isFalse);
      },
    );

    test('401 on refresh keeps session and surfaces auth gate state', () async {
      final ctx = _makeController();
      await Future<void>.delayed(Duration.zero);

      final fail1 = ctx.api.queue();
      final fail2 = ctx.api.queue();
      final refreshFuture = ctx.controller.refresh();
      fail1.completeError(
        ApiException(401, '`mine=true` requires authentication'),
      );
      await Future<void>.delayed(const Duration(milliseconds: 650));
      fail2.completeError(
        ApiException(401, '`mine=true` requires authentication'),
      );
      await refreshFuture;
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(ctx.container.read(authControllerProvider), isNotNull);
      expect(ctx.controller.state.error, kAuthRequiredSentinel);
      expect(ctx.controller.state.loading, isFalse);
      expect(ctx.controller.state.items, isEmpty);
    });

    test('signed-out user clears state and skips the API call', () async {
      final ctx = _makeController(user: null);
      // No queued response — _FakeApi.listRecipes would throw if
      // called. We verify the controller didn't reach for it.
      await Future<void>.delayed(Duration.zero);

      expect(
        ctx.api.calls,
        isEmpty,
        reason:
            'No API call should be made when the user is signed out '
            '(would 401 and pollute server logs + rate-limit counters).',
      );
      expect(ctx.controller.state.items, isEmpty);
      expect(ctx.controller.state.loading, isFalse);
      expect(ctx.controller.state.total, 0);
    });
  });
}
