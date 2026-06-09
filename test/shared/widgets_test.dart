import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:savor_global/models/spice_route.dart';
import 'package:savor_global/shared/widgets.dart';

import '../helpers/test_harness.dart';

/// Builds the smallest viable [SpiceRouteSummary] for these tests with
/// every kwarg defaulted to "uninteresting", so each test can override
/// only the field it cares about.
SpiceRouteSummary _sample({
  String id = 'r-1',
  String title = 'Spicy Garlic Noodles',
  String? imageUrl = 'https://example.com/noodles.jpg',
  Cuisine? cuisine = Cuisine.korean,
  SpiceRouteOwner? owner,
  bool isPremium = false,
}) {
  return SpiceRouteSummary(
    id: id,
    title: title,
    description: 'A bowl of comfort.',
    prepMinutes: 10,
    cookMinutes: 15,
    servings: 2,
    imageUrl: imageUrl,
    cuisine: cuisine,
    isPremium: isPremium,
    caloriesPerServing: 420,
    owner: owner,
  );
}

void main() {
  Future<void> pumpCard(WidgetTester tester, SpiceRouteSummary recipe) async {
    // `network_image_mock` intercepts CachedNetworkImage so we don't
    // hit example.com (which would 404 in CI). For the null-imageUrl
    // case the card never builds an Image at all, so the mock is a
    // no-op there.
    //
    // We deliberately don't override the saved-recipes provider: the
    // real controller starts with an empty id set and its bootstrap
    // failure (secure storage isn't wired up in unit tests) is caught
    // silently, leaving the card in the "unsaved" state — which is
    // exactly what these tests want.
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        wrapWithApp(
          child: SizedBox(
            width: 320,
            child: RecipeCard(recipe: recipe),
          ),
        ),
      );
      // pump (not pumpAndSettle) — RecipeCard hosts a long-lived bookmark
      // animation controller; pumpAndSettle would block forever waiting
      // for it to come to rest.
      await tester.pump();
    });
  }

  testWidgets('AI badge appears for owner-less, non-premium recipes',
      (tester) async {
    // `SpiceRouteSummary.isAiAuthored` is true when `owner == null &&
    // !isPremium` — those are the recipes generated through the AI
    // Creator flow rather than curated/published by a human.
    await pumpCard(tester, _sample(owner: null, isPremium: false));

    expect(find.text('AI'), findsOneWidget,
        reason: 'AI badge should be visible on AI-authored recipes');
  });

  testWidgets('no AI badge when an owner is attributed', (tester) async {
    final owned = _sample(
      owner: const SpiceRouteOwner(id: 'u-1', displayName: 'Chef'),
    );
    await pumpCard(tester, owned);
    expect(find.text('AI'), findsNothing);
  });

  testWidgets('no AI badge on curated premium recipes', (tester) async {
    await pumpCard(tester, _sample(isPremium: true));
    expect(find.text('AI'), findsNothing);
  });

  testWidgets('image-missing recipe falls back to gradient + cuisine label',
      (tester) async {
    // imageUrl == null hits the _ImageFallback widget. We can't reach
    // the private class by name, so we assert on the cuisine label that
    // the fallback renders ("KOREAN") and the absence of any Image
    // widget in the card.
    await pumpCard(tester, _sample(imageUrl: null));

    // KOREAN appears at least once (cuisine eyebrow under the title).
    expect(find.text('KOREAN'), findsWidgets);
    expect(find.byType(Image), findsNothing,
        reason: 'no <Image> should render when imageUrl is null');
  });
}
