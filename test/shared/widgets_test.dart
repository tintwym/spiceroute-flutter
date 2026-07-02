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

  testWidgets('AI badge appears for owner-less, non-premium recipes', (
    tester,
  ) async {
    // `SpiceRouteSummary.isAiAuthored` is true when `owner == null &&
    // !isPremium` — those are the recipes generated through the AI
    // Creator flow rather than curated/published by a human.
    await pumpCard(tester, _sample(owner: null, isPremium: false));

    expect(
      find.text('AI'),
      findsOneWidget,
      reason: 'AI badge should be visible on AI-authored recipes',
    );
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

  testWidgets('image-missing recipe falls back to gradient + cuisine label', (
    tester,
  ) async {
    // imageUrl == null hits the _ImageFallback widget. We can't reach
    // the private class by name, so we assert on the cuisine label that
    // the fallback renders ("KOREAN") and the absence of any Image
    // widget in the card.
    await pumpCard(tester, _sample(imageUrl: null));

    // KOREAN appears at least once (cuisine eyebrow under the title).
    expect(find.text('KOREAN'), findsWidgets);
    expect(
      find.byType(Image),
      findsNothing,
      reason: 'no <Image> should render when imageUrl is null',
    );
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

  testWidgets('card footer survives narrow 4-up grid cards without overflow', (
    tester,
  ) async {
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
  });

  testWidgets(
    'card footer shows servings and kcal for long hour+minute on 4-up widths',
    (tester) async {
      // Regression: "1 h 5 min" / "3 h 20 min" footers showed ONLY the
      // time on desktop 4-up cards because longTime cutoffs were 300+.
      final stew = SpiceRouteSummary(
        id: 'r-stew',
        title: 'Slow braise',
        description: 'Long cook.',
        prepMinutes: 5,
        cookMinutes: 60,
        servings: 4,
        imageUrl: 'https://example.com/stew.jpg',
        cuisine: Cuisine.french,
        caloriesPerServing: 520,
        difficulty: Difficulty.medium,
      );
      await pumpCard(tester, stew, width: 310);

      expect(find.textContaining('5'), findsWidgets);
      expect(find.textContaining('servings'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'card footer avoids overlap for long hour+minute durations on narrow cards',
    (tester) async {
      // UAT: "3 h 25 min" collided with the servings icon when the
      // footer used a centered Stack overlay. Linear layout + tighter
      // cutoffs should keep the row in bounds on a 4-up desktop card.
      final beefNoodle = SpiceRouteSummary(
        id: 'r-taiwanese-beef',
        title: 'Taiwanese Beef Noodle Soup',
        description: 'Long simmer.',
        prepMinutes: 25,
        cookMinutes: 180,
        servings: 4,
        imageUrl: 'https://example.com/noodle.jpg',
        cuisine: Cuisine.taiwanese,
        caloriesPerServing: 560,
        difficulty: Difficulty.medium,
      );
      await pumpCard(tester, beefNoodle, width: 260);

      expect(
        find.textContaining('25'),
        findsWidgets,
        reason: 'hour+minute duration must render without truncation',
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'card footer renders full time + pill on typical desktop 4-up widths',
    (tester) async {
      // Regression for "we don't see fully time" (v2 bug, fixed in
      // v3) AND "what's missing?" (v3 over-correction, the
      // difficulty pill silently vanished in tight mode; fixed in
      // v4). Together these guard the tight-mode invariant: every
      // metadata item — time, servings, kcal, AND the difficulty
      // pill — renders without ellipsis on a 280-dp card.
      //
      // Card width 280 dp → footer 252 dp (the app's
      // `cardTheme.margin` is `EdgeInsets.zero`, so the column's
      // 28-dp horizontal padding is what gets subtracted). For
      // recipes with hours that's below the 260-dp tight/roomy
      // split (lowered from 290 → 260 in the mobile pass so a
      // 320-dp viewport still shows the difficulty pill).
      //
      // Recipe is 30 minutes total ("30 min" in en, ~84 dp Ahem)
      // and EASY difficulty (~52 dp Ahem). Ahem (the test font,
      // 1 em per glyph) is meaningfully wider than production
      // Inter, so we keep the time string short here so all four
      // items fit at intrinsic in tests as well as production.
      // Long-time cases like "1 h 15 min" are covered separately
      // by the phone-width test above (footer ~392 dp, roomy mode
      // where the pill rides on the Spacer-pushed right rail).
      final r = SpiceRouteSummary(
        id: 'r-time',
        title: 'Quick fry',
        description: 'Fast.',
        prepMinutes: 10,
        cookMinutes: 20,
        servings: 6,
        imageUrl: 'https://example.com/fry.jpg',
        cuisine: Cuisine.italian,
        caloriesPerServing: 620,
        // The difficulty pill now reads a first-class column instead
        // of deriving from time+steps, so the test has to pin the
        // value it wants to assert against. Pinning EASY keeps this
        // test focused on layout (pill renders inline, no overflow)
        // without coupling it to the auto-rule's thresholds.
        difficulty: Difficulty.easy,
      );
      await pumpCard(tester, r, width: 310);

      // Time text must contain the minutes portion verbatim — no
      // ellipsis. We match on the substring "30" because the exact
      // formatter output depends on locale.
      expect(
        find.textContaining('30'),
        findsWidgets,
        reason: 'time minutes must render verbatim, not ellipsized',
      );
      expect(
        find.textContaining('…'),
        findsNothing,
        reason: 'no ellipsis should appear in the metadata row',
      );
      // Kcal must be visible (compact "620" form in tight mode).
      expect(find.textContaining('620'), findsOneWidget);
      // Difficulty pill renders once the footer is wide enough to
      // show kcal AND the pill (kcal-present band uses a 280-dp
      // cutoff; 310-dp card → ~282-dp footer).
      expect(
        find.text('EASY'),
        findsOneWidget,
        reason: 'difficulty pill must be visible when footer is wide enough',
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('card footer keeps kcal visible at typical desktop 4-up widths', (
    tester,
  ) async {
    // Regression for "cannot see kcal on web layout". On wide-tier
    // viewports (≥1440 px), the 4-up grid produces card widths
    // ~300 dp → footer width ~272 dp. The earlier code split
    // tight/roomy at 230 dp and then hid kcal in roomy mode for
    // any width <290 dp, which silently dropped the kcal block on
    // every wide-tier laptop layout. The fix lifts the boundary
    // so that footer width band lands in tight mode and shows
    // compact kcal ("620") instead.
    //
    // Card widths tested span the desktop / wide tier bands —
    // 220 dp (1024-px viewport, narrowest 4-up), 270 dp (~1300-px
    // viewport), and 310 dp (~1920-px viewport on the wide tier).
    // The compact kcal value MUST appear at all three.
    for (final cardWidth in [220.0, 270.0, 310.0]) {
      final r = SpiceRouteSummary(
        id: 'r-$cardWidth',
        title: 'A test',
        description: 'A test description.',
        prepMinutes: 10,
        cookMinutes: 20,
        servings: 2,
        imageUrl: 'https://example.com/test.jpg',
        cuisine: Cuisine.italian,
        caloriesPerServing: 620,
      );
      await pumpCard(tester, r, width: cardWidth);
      expect(
        find.textContaining('620'),
        findsOneWidget,
        reason:
            'compact kcal "620" must be visible at card width $cardWidth dp',
      );
      expect(
        tester.takeException(),
        isNull,
        reason: 'no overflow at card width $cardWidth dp',
      );
    }
  });

  testWidgets('card shows region and cuisine labels', (tester) async {
    final r = SpiceRouteSummary(
      id: 'r-shandong',
      title: 'Jianbing',
      description: 'Crispy crepe.',
      cuisine: Cuisine.shandong,
      cuisineWire: 'shandong',
      caloriesPerServing: 520,
    );
    await pumpCard(tester, r);
    expect(find.text('EAST ASIA'), findsOneWidget);
    expect(find.textContaining('SHANDONG'), findsWidgets);
  });

  testWidgets('web grid cell uses two-line footer with pill for long cooks', (
    tester,
  ) async {
    // Web-only Option A: time/servings on row 1, kcal/pill on row 2.
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final stew = SpiceRouteSummary(
      id: 'r-web-grid',
      title: 'Slow braise',
      description: 'Long cook.',
      prepMinutes: 5,
      cookMinutes: 60,
      servings: 4,
      imageUrl: 'https://example.com/stew.jpg',
      cuisine: Cuisine.french,
      caloriesPerServing: 520,
      difficulty: Difficulty.medium,
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        wrapWithApp(
          child: SizedBox(
            width: 258,
            height: 420,
            child: RecipeCard(
              recipe: stew,
              fillGridCell: true,
              twoLineGridFooter: true,
            ),
          ),
        ),
      );
      await tester.pump();
    });

    expect(find.textContaining('5'), findsWidgets);
    expect(find.textContaining('4'), findsOneWidget);
    expect(find.textContaining('520'), findsOneWidget);
    expect(find.text('MEDIUM'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('grid cell footer avoids overlap for long cook times', (
    tester,
  ) async {
    // Regression: the old `uniform: true` Stack footer painted servings
    // on top of the time row on narrow 4-up desktop cards.
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final r = SpiceRouteSummary(
      id: 'r-beef-noodle',
      title: 'Taiwanese Beef Noodle Soup',
      description: 'Slow-braised beef in a rich spiced broth.',
      prepMinutes: 30,
      cookMinutes: 175,
      servings: 4,
      imageUrl: 'https://example.com/noodle.jpg',
      cuisine: Cuisine.taiwanese,
      caloriesPerServing: 480,
      difficulty: Difficulty.medium,
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        wrapWithApp(
          child: SizedBox(
            width: 258,
            height: 420,
            child: Builder(
              builder: (context) => RecipeCard.gridCell(context, r),
            ),
          ),
        ),
      );
      await tester.pump();
    });

    expect(find.textContaining('3'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('phone list card shows full footer for long hour+minute cook', (
    tester,
  ) async {
    // iPhone-class viewport: single-column list, ~330 dp footer after
    // page + card padding. Regression for metadata vanishing on mobile.
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final stew = SpiceRouteSummary(
      id: 'r-phone-stew',
      title: 'Slow braise',
      description: 'Long cook.',
      prepMinutes: 5,
      cookMinutes: 60,
      servings: 4,
      imageUrl: 'https://example.com/stew.jpg',
      cuisine: Cuisine.french,
      caloriesPerServing: 520,
      difficulty: Difficulty.medium,
    );
    await pumpCard(tester, stew, width: 358);

    expect(find.textContaining('5'), findsWidgets);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    expect(find.byIcon(Icons.local_fire_department_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('narrow phone list card keeps time and servings for 3 h cooks', (
    tester,
  ) async {
    // iPhone SE-class width — footer ~260 dp after padding.
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final beefNoodle = SpiceRouteSummary(
      id: 'r-phone-narrow',
      title: 'Taiwanese Beef Noodle Soup',
      description: 'Slow simmer.',
      prepMinutes: 25,
      cookMinutes: 175,
      servings: 4,
      imageUrl: 'https://example.com/noodle.jpg',
      cuisine: Cuisine.taiwanese,
      caloriesPerServing: 560,
      difficulty: Difficulty.medium,
    );
    await pumpCard(tester, beefNoodle, width: 310);

    expect(find.textContaining('20'), findsWidgets);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('phone list card shows kcal and pill for short cook times', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final quick = SpiceRouteSummary(
      id: 'r-phone-quick',
      title: 'Quick fry',
      description: 'Fast.',
      prepMinutes: 10,
      cookMinutes: 35,
      servings: 4,
      imageUrl: 'https://example.com/fry.jpg',
      cuisine: Cuisine.italian,
      caloriesPerServing: 510,
      difficulty: Difficulty.medium,
    );
    await pumpCard(tester, quick, width: 358);

    expect(find.textContaining('45'), findsWidgets);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    expect(find.textContaining('510'), findsOneWidget);
    expect(find.text('MEDIUM'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('phone grid cell keeps footer tight below description', (
    tester,
  ) async {
    // Regression: uniform grid slots + Spacer left a large gap between
    // the description divider and the metadata row on phone.
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final r = SpiceRouteSummary(
      id: 'r-risotto',
      title: 'Risotto alla Milanese',
      description: 'Saffron risotto finished with butter and parmesan.',
      prepMinutes: 10,
      cookMinutes: 35,
      servings: 4,
      imageUrl: 'https://example.com/risotto.jpg',
      cuisine: Cuisine.italian,
      caloriesPerServing: 620,
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        wrapWithApp(
          child: SizedBox(
            width: 390,
            height: 600,
            child: Builder(
              builder: (context) => RecipeCard.gridCell(context, r),
            ),
          ),
        ),
      );
      await tester.pump();
    });

    final dividerBottom = tester.getBottomLeft(find.byType(Divider)).dy;
    final footerTop = tester.getTopLeft(find.textContaining('620')).dy;
    expect(
      footerTop - dividerBottom,
      lessThan(40),
      reason: 'footer should sit just below the divider on phone',
    );
  });
}
