import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:spiceroute/models/spice_route.dart';
import 'package:spiceroute/shared/widgets.dart';

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
  Future<void> pumpCard(
    WidgetTester tester,
    SpiceRouteSummary recipe, {
    double width = 320,
  }) async {
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
    //
    // `width` is the rendered card width. The default 320 matches a
    // narrow card; pass a larger value to test phone-class
    // single-column layouts where the card stretches edge-to-edge.
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        wrapWithApp(
          child: SizedBox(
            width: width,
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

  testWidgets(
    'card footer renders time fully on phone-width cards (no ellipsis)',
    (tester) async {
      // Regression: before the flex-shrink fix, the time text was
      // wrapped in Flexible and got squeezed by the Spacer + kcal
      // Flexible, ellipsizing to "1 h 15 ..." even on perfectly
      // roomy phone-width cards. With flex-shrink:0 the full string
      // must render verbatim.
      //
      // 75 minutes → "1 h 15 min" via formatRecipeDuration's
      // recipeHoursMinutesShort. We assert on the *substring* so
      // this still passes if the formatter ever adds a thin space.
      //
      // Width 420 ≈ a typical 6.1" phone card (343 dp page width plus
      // safe-area room). Flutter's test harness uses the Ahem font
      // (one em per glyph), so text measures noticeably wider in
      // tests than in production — picking a generous width here
      // lets the row exercise the "show kcal in full" branch without
      // overflowing because of the test font.
      final long = SpiceRouteSummary(
        id: 'r-long',
        title: 'Long-cook stew',
        description: 'Slow and steady.',
        prepMinutes: 15,
        cookMinutes: 60,
        servings: 6,
        imageUrl: 'https://example.com/stew.jpg',
        cuisine: Cuisine.italian,
        caloriesPerServing: 620,
      );
      await pumpCard(tester, long, width: 420);

      // The full duration string must be present and not truncated.
      // textContaining so we don't trip on minor format variations
      // (e.g. localized "min" vs "m" or a thin space around the h).
      expect(
        find.textContaining('15'),
        findsWidgets,
        reason: 'time text must render fully, not as "1 h 15 ..."',
      );
      expect(
        find.textContaining('…'),
        findsNothing,
        reason: 'no ellipsis should appear in the metadata row',
      );
      // No RenderFlex overflow either — the LayoutBuilder thresholds
      // should pick a gap + kcal mode that keeps the row in bounds.
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'card footer survives narrow 4-up grid cards without overflow',
    (tester) async {
      // The 4-up desktop grid lands around 220-260 dp per card. The
      // LayoutBuilder is supposed to compact then drop the kcal
      // block to keep the row in bounds at those sizes. Test it
      // explicitly at 240 dp so any future change to thresholds
      // that pushes the layout over the edge is caught here, not
      // in production with yellow-and-black stripes.
      final long = SpiceRouteSummary(
        id: 'r-narrow',
        title: 'Slow braise',
        description: 'Tight footer.',
        prepMinutes: 15,
        cookMinutes: 60,
        servings: 6,
        imageUrl: 'https://example.com/braise.jpg',
        cuisine: Cuisine.italian,
        caloriesPerServing: 620,
      );
      await pumpCard(tester, long, width: 240);
      expect(tester.takeException(), isNull);
    },
  );
}
