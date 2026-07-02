import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/models/spice_route.dart';
import 'package:spiceroute/state/providers.dart';
import 'package:spiceroute/state/saved.dart';

import '../helpers/saved_test_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(mockSecureStorage);

  group('SavedRecipesController.forgetDeleted', () {
    test('removes the id and matching summary from state', () async {
      final container = ProviderContainer(
        overrides: [apiClientProvider.overrideWithValue(NoNetworkApi())],
      );
      addTearDown(container.dispose);

      final ctl = container.read(savedRecipesProvider.notifier);
      // Bootstrap kicks off in the constructor; let it settle (it
      // no-ops in tests because secure storage is mocked empty and
      // there's no signed-in user, so no API hydrate happens).
      await Future<void>.delayed(Duration.zero);

      const a = SpiceRouteSummary(id: 'a', title: 'Recipe A');
      const b = SpiceRouteSummary(id: 'b', title: 'Recipe B');
      const c = SpiceRouteSummary(id: 'c', title: 'Recipe C');
      ctl.state = SavedRecipesState(
        ids: const {'a', 'b', 'c'},
        recipes: const [a, b, c],
      );

      ctl.forgetDeleted('b');

      expect(ctl.state.ids, equals({'a', 'c'}));
      expect(ctl.state.recipes.map((r) => r.id).toList(), equals(['a', 'c']));
    });

    test('is a no-op when the id is not in the saved set', () async {
      final container = ProviderContainer(
        overrides: [apiClientProvider.overrideWithValue(NoNetworkApi())],
      );
      addTearDown(container.dispose);

      final ctl = container.read(savedRecipesProvider.notifier);
      await Future<void>.delayed(Duration.zero);

      const a = SpiceRouteSummary(id: 'a', title: 'Recipe A');
      ctl.state = SavedRecipesState(ids: const {'a'}, recipes: const [a]);

      final stateBefore = ctl.state;
      ctl.forgetDeleted('not-a-saved-id');

      // Idempotency contract: the test exists because the recipe-
      // detail flow calls forgetDeleted unconditionally after the
      // backend DELETE returns 200, EVEN IF the user never saved
      // the recipe they just deleted. We must not allocate a new
      // state object (and therefore not trigger a listener rebuild)
      // when nothing changed.
      expect(identical(ctl.state, stateBefore), isTrue);
    });

    test(
      'removes id even when recipes list is missing a matching summary',
      () async {
        // Regression: an earlier shape of forgetDeleted only fired
        // when the id was in BOTH `ids` and `recipes`. After a
        // partial hydrate failure (id is saved but the API never
        // returned the payload, so it's in `ids` but not yet in
        // `recipes`), the early-out would prevent the bookmark from
        // being cleaned up at all — and the user's next hydrate would
        // re-discover the same 404 in a loop.
        final container = ProviderContainer(
          overrides: [apiClientProvider.overrideWithValue(NoNetworkApi())],
        );
        addTearDown(container.dispose);

        final ctl = container.read(savedRecipesProvider.notifier);
        await Future<void>.delayed(Duration.zero);

        ctl.state = const SavedRecipesState(ids: {'orphan-id'}, recipes: []);

        ctl.forgetDeleted('orphan-id');

        expect(ctl.state.ids, isEmpty);
        expect(ctl.state.recipes, isEmpty);
      },
    );
  });
}
