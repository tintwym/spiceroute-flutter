import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/models/spice_route.dart';
import 'package:spiceroute/shared/filter_bar.dart';

import '../helpers/test_harness.dart';

/// Pumps the filter bar at a phone-class viewport so the columns stack
/// vertically and we can find each dropdown trigger by its label.
Future<void> _pumpFilterBar(
  WidgetTester tester, {
  Course? course,
  Dietary? dietary,
  ValueChanged<Course?>? onCourseChanged,
  ValueChanged<Dietary?>? onDietaryChanged,
  Size viewSize = const Size(900, 1400),
}) async {
  // Force the test view's logical size. The default test viewport is
  // ~800x600 which sits under the 560-dp stacking threshold; pick a
  // generous default so the menu route has room to render its
  // accordion underneath the trigger.
  tester.view.physicalSize = viewSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    wrapWithApp(
      child: FilterBar(
        course: course,
        dietary: dietary,
        onCourseChanged: onCourseChanged ?? (_) {},
        onDietaryChanged: onDietaryChanged ?? (_) {},
      ),
    ),
  );
  // Two pumps: one to build, one for AppL10n's async load.
  await tester.pumpAndSettle();
}

void main() {
  group('trigger pill', () {
    testWidgets(
      'dietary trigger shows no group pill when nothing is selected',
      (tester) async {
        await _pumpFilterBar(tester);
        // Hint text "All Preferences" should render alone — no group
        // chip ahead of it.
        expect(find.text('All Preferences'), findsOneWidget);
        expect(find.text('Cooking Formats'), findsNothing);
        expect(find.text('Dietary Restrictions'), findsNothing);
        expect(find.text('Wellness & Lifestyles'), findsNothing);
      },
    );

    testWidgets(
      'dietary trigger shows category chip when a dietary value is selected',
      (tester) async {
        await _pumpFilterBar(tester, dietary: Dietary.quickEasy);
        // Quick & Easy lives under Cooking Formats, so the trigger
        // should render the two-tier "Cooking Formats · Quick & Easy"
        // presentation.
        expect(find.text('Cooking Formats'), findsOneWidget);
        expect(find.text('Quick & Easy'), findsOneWidget);
      },
    );

    testWidgets('course trigger shows category chip matching the screenshot', (
      tester,
    ) async {
      await _pumpFilterBar(tester, course: Course.dessert);
      // Mirrors the screenshot exactly: "Sweet Ending" pill +
      // "Desserts & Sweets" label.
      expect(find.text('Sweet Ending'), findsOneWidget);
      expect(find.text('Desserts & Sweets'), findsOneWidget);
    });
  });

  group('course accordion', () {
    /// Course mirrors Dietary's accordion behavior — these tests
    /// focus on the things that differ (group labels, item counts,
    /// search hint) rather than re-asserting the shared chrome.
    Future<void> openCourse(WidgetTester tester) async {
      await tester.tap(find.text('All Courses'));
      await tester.pumpAndSettle();
    }

    testWidgets('opens with the seven CourseGroup sections rendered', (
      tester,
    ) async {
      await _pumpFilterBar(tester);
      await openCourse(tester);

      // All seven group headers must be present, matching the
      // screenshot's section list verbatim.
      expect(find.text('EARLY DAY'), findsOneWidget);
      expect(find.text('DAYTIME / CASUAL'), findsOneWidget);
      expect(find.text('BEFORE THE MAIN'), findsOneWidget);
      expect(find.text('THE MAIN EVENT'), findsOneWidget);
      expect(find.text('SWEET ENDING'), findsOneWidget);
      expect(find.text('AFTER HOURS'), findsOneWidget);
      expect(find.text('LIQUIDS'), findsOneWidget);
      // Search placeholder must be the course-specific copy.
      expect(find.text('Search courses…'), findsOneWidget);
    });

    testWidgets('group counts match the actual Course taxonomy', (
      tester,
    ) async {
      await _pumpFilterBar(tester);
      await openCourse(tester);

      // 5 of the 7 groups currently hold 2 courses, 2 hold 1
      // (SWEET ENDING and AFTER HOURS). Bracket the counts so the
      // assertions stay valid if the taxonomy grows by 1-2 items
      // per group later.
      expect(find.text('2 choices'), findsNWidgets(5));
      expect(find.text('1 choice'), findsNWidgets(2));
    });

    testWidgets('selecting a course from the accordion fires onChanged', (
      tester,
    ) async {
      Course? captured;
      await _pumpFilterBar(tester, onCourseChanged: (c) => captured = c);
      await openCourse(tester);

      // Expand Sweet Ending and pick Desserts & Sweets.
      await tester.tap(find.text('SWEET ENDING'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Desserts & Sweets'));
      await tester.pumpAndSettle();

      expect(captured, Course.dessert);
    });

    testWidgets('opens with the selected course\'s group pre-expanded', (
      tester,
    ) async {
      // Re-open the dropdown after the parent rebuilds with the
      // new selection; the active group (Sweet Ending) should
      // unfold automatically so the user can see/clear it.
      await _pumpFilterBar(tester, course: Course.dessert);
      await tester.tap(find.text('Desserts & Sweets'));
      await tester.pumpAndSettle();

      // Sweet Ending's lone child should be visible…
      expect(find.text('Desserts & Sweets'), findsWidgets);
      // …while another group's items stay hidden.
      expect(find.text('Breakfast & Brunch'), findsNothing);
    });
  });

  group('accordion menu', () {
    /// Opens the dietary dropdown so the accordion overlay is mounted
    /// and ready to interact with.
    Future<void> openDietary(WidgetTester tester) async {
      await tester.tap(find.text('All Preferences'));
      await tester.pumpAndSettle();
    }

    testWidgets('opens with all groups collapsed when no selection', (
      tester,
    ) async {
      await _pumpFilterBar(tester);
      await openDietary(tester);

      // The three category headers must render…
      expect(find.text('DIETARY RESTRICTIONS'), findsOneWidget);
      expect(find.text('WELLNESS & LIFESTYLES'), findsOneWidget);
      expect(find.text('COOKING FORMATS'), findsOneWidget);
      // …but no individual choice should be visible yet.
      expect(find.text('Vegan'), findsNothing);
      expect(find.text('Quick & Easy'), findsNothing);
    });

    testWidgets('opens with the selected item\'s group pre-expanded', (
      tester,
    ) async {
      await _pumpFilterBar(tester, dietary: Dietary.quickEasy);
      // Tap the trigger to open the menu. We aim at the label
      // inside the trigger (Quick & Easy) rather than All Preferences.
      await tester.tap(find.text('Quick & Easy').first);
      await tester.pumpAndSettle();

      // Cooking Formats should be open, restrictions/wellness closed.
      expect(find.text('Meal Prep'), findsOneWidget);
      expect(find.text('Pasta & Soup'), findsOneWidget);
      expect(find.text('Vegan'), findsNothing);
      expect(find.text('Blood Sugar Balanced'), findsNothing);
    });

    testWidgets('expand all opens every group and toggles its own label', (
      tester,
    ) async {
      await _pumpFilterBar(tester);
      await openDietary(tester);

      // Initial: button reads EXPAND ALL and groups are closed.
      expect(find.text('EXPAND ALL'), findsOneWidget);
      expect(find.text('COLLAPSE ALL'), findsNothing);
      expect(find.text('Vegan'), findsNothing);

      await tester.tap(find.text('EXPAND ALL'));
      await tester.pumpAndSettle();

      // Every group's items are now visible.
      expect(find.text('Vegan'), findsOneWidget);
      expect(find.text('Quick & Easy'), findsOneWidget);
      expect(find.text('Blood Sugar Balanced'), findsOneWidget);
      // Button has flipped.
      expect(find.text('EXPAND ALL'), findsNothing);
      expect(find.text('COLLAPSE ALL'), findsOneWidget);

      // Re-tap collapses everything.
      await tester.tap(find.text('COLLAPSE ALL'));
      await tester.pumpAndSettle();

      expect(find.text('Vegan'), findsNothing);
      expect(find.text('Quick & Easy'), findsNothing);
      expect(find.text('Blood Sugar Balanced'), findsNothing);
      expect(find.text('EXPAND ALL'), findsOneWidget);
    });

    testWidgets(
      'tapping a choice fires onChanged with the value and closes menu',
      (tester) async {
        Dietary? captured;
        await _pumpFilterBar(tester, onDietaryChanged: (d) => captured = d);
        await openDietary(tester);

        // Open Cooking Formats so Quick & Easy is reachable.
        await tester.tap(find.text('COOKING FORMATS'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Quick & Easy'));
        await tester.pumpAndSettle();

        expect(captured, Dietary.quickEasy);
        // Menu should have popped — no more group headers in tree.
        expect(find.text('DIETARY RESTRICTIONS'), findsNothing);
      },
    );

    testWidgets('search filters items and auto-expands groups with matches', (
      tester,
    ) async {
      await _pumpFilterBar(tester);
      await openDietary(tester);

      // Initially no items visible.
      expect(find.text('Vegan'), findsNothing);

      // Type a query that only matches the wellness group.
      await tester.enterText(find.byType(TextField), 'blood');
      await tester.pumpAndSettle();

      // Matching item should be visible — its group auto-expanded.
      expect(find.text('Blood Sugar Balanced'), findsOneWidget);
      // Non-matching items must NOT appear (they're filtered out
      // of their groups; non-matching groups stay collapsed).
      expect(find.text('Vegan'), findsNothing);
      expect(find.text('Quick & Easy'), findsNothing);
    });

    testWidgets('search showing nothing renders the no-matches message', (
      tester,
    ) async {
      await _pumpFilterBar(tester);
      await openDietary(tester);

      await tester.enterText(find.byType(TextField), 'zzzzzz nonexistent');
      await tester.pumpAndSettle();

      expect(find.text('No matches'), findsOneWidget);
    });

    testWidgets('reset row at the top clears the active selection', (
      tester,
    ) async {
      // Bug #1 (major): pre-fix users had no way to clear a
      // selection from inside the accordion menu — the old flat
      // menu had an "All Preferences" row at the top but the
      // accordion didn't. The reset row is now pinned above the
      // accordion sections and tapping it pops with null.
      Dietary? captured = Dietary.quickEasy;
      await _pumpFilterBar(
        tester,
        dietary: Dietary.quickEasy,
        onDietaryChanged: (d) => captured = d,
      );
      // Open the menu by tapping the trigger.
      await tester.tap(find.text('Quick & Easy').first);
      await tester.pumpAndSettle();

      // "All Preferences" should now be visible as a pinned reset row.
      expect(find.text('All Preferences'), findsWidgets);

      await tester.tap(find.text('All Preferences').last);
      await tester.pumpAndSettle();

      expect(
        captured,
        isNull,
        reason:
            'tapping the reset row must report value=null '
            'so the parent clears its filter back to "all"',
      );
    });

    testWidgets('search clear button wipes the query and restores all groups', (
      tester,
    ) async {
      // Bug #6 (low): when the user has typed something there
      // should be a one-tap clear affordance on the right edge of
      // the search field.
      await _pumpFilterBar(tester);
      await openDietary(tester);

      await tester.enterText(find.byType(TextField), 'blood');
      await tester.pumpAndSettle();
      expect(find.text('Blood Sugar Balanced'), findsOneWidget);

      // Clear icon should now be visible — tap it.
      final clearBtn = find.bySemanticsLabel('Clear search');
      expect(clearBtn, findsOneWidget);
      await tester.tap(clearBtn);
      await tester.pumpAndSettle();

      // Search field is empty…
      expect(
        (tester.widget<TextField>(find.byType(TextField))).controller?.text,
        '',
      );
      // …and every group's count rolled back to the unfiltered
      // total. Wellness + Cooking Formats each have 3 items, so
      // "3 choices" should appear twice. Restrictions has 2.
      expect(
        find.text('3 choices'),
        findsNWidgets(2),
        reason:
            'Wellness + Cooking Formats both report their '
            'full 3-item count again after the search is cleared',
      );
      expect(
        find.text('2 choices'),
        findsOneWidget,
        reason: 'Restrictions group reports its full count too',
      );
    });

    testWidgets('group count reflects filtered visible items during search', (
      tester,
    ) async {
      // Bug #3 (medium): before the memoization refactor the count
      // string read the unfiltered total even when only one item
      // was visible.
      await _pumpFilterBar(tester);
      await openDietary(tester);

      await tester.enterText(find.byType(TextField), 'blood');
      await tester.pumpAndSettle();

      // Wellness has 3 items total, but only "Blood Sugar
      // Balanced" matches → header must now read "1 choice", not
      // "3 choices". Two other groups are hidden so no other
      // count appears.
      expect(find.text('1 choice'), findsOneWidget);
      expect(find.text('3 choices'), findsNothing);
    });
  });

  group('mobile combined pill + tabbed sheet', () {
    /// Pump the filter bar at a phone-class viewport (< 560 dp wide)
    /// so [FilterBar] collapses both filter dimensions into a single
    /// combined trigger pill that opens the shared two-tab sheet.
    Future<void> pumpMobile(
      WidgetTester tester, {
      Course? course,
      Dietary? dietary,
      ValueChanged<Course?>? onCourseChanged,
      ValueChanged<Dietary?>? onDietaryChanged,
    }) async {
      // 420 dp wide × 1400 dp tall: under the 560-dp stacking
      // threshold so the FilterBar collapses to the combined pill,
      // and tall enough that the modal bottom sheet has room to
      // render its 85%-of-viewport body comfortably.
      await _pumpFilterBar(
        tester,
        course: course,
        dietary: dietary,
        onCourseChanged: onCourseChanged,
        onDietaryChanged: onDietaryChanged,
        viewSize: const Size(420, 1400),
      );
    }

    testWidgets(
      'mobile renders ONE combined pill (no separate Course/Dietary triggers)',
      (tester) async {
        await pumpMobile(tester);
        // The desktop two-pill labels must NOT appear on mobile.
        expect(find.text('All Courses'), findsNothing);
        expect(find.text('All Preferences'), findsNothing);
        // The combined-pill hint is the user-visible trigger.
        expect(find.text('Filter recipes'), findsOneWidget);
        // Cleared state uses the chef filter glyph, not clock + target.
        expect(find.text('🧑‍🍳'), findsOneWidget);
        expect(find.text('🕐'), findsNothing);
        expect(find.text('🎯'), findsNothing);
      },
    );

    testWidgets(
      'tapping the combined pill opens the tabbed sheet on the Course tab',
      (tester) async {
        await pumpMobile(tester);
        await tester.tap(find.text('Filter recipes'));
        await tester.pumpAndSettle();
        // Both tab labels render — confirms it's the tabbed sheet,
        // not the single-dimension accordion route.
        expect(find.text('By Course'), findsNothing);
        expect(find.text('Course'), findsOneWidget);
        expect(find.text('By Diet & Lifestyle'), findsNothing);
        expect(find.text('Diet & lifestyle'), findsOneWidget);
        // Flat mobile list — group subheaders visible without expanding.
        expect(find.text('Early Day'), findsOneWidget);
        expect(find.text('COURSE SELECTION FILTERS'), findsNothing);
        expect(find.text('EXPAND ALL'), findsNothing);
        expect(find.text('Search courses…'), findsNothing);
      },
    );

    testWidgets(
      'with only a dietary value set the sheet lands on the Diet tab',
      (tester) async {
        // No course, but dietary preselected → the user lands on the
        // tab where their existing selection lives.
        await pumpMobile(tester, dietary: Dietary.vegan);
        // The pill summary now reflects the active dietary filter
        // instead of the generic hint.
        expect(find.text('Filter recipes'), findsNothing);
        await tester.tap(find.text('Vegan'));
        await tester.pumpAndSettle();
        expect(find.text('DIETARY & LIFESTYLE RESTRICTIONS'), findsNothing);
        expect(find.text('Cooking Formats'), findsOneWidget);
        expect(find.text('Search dietary preferences…'), findsNothing);
      },
    );

    testWidgets(
      'switching tabs swaps the accordion body without dismissing the sheet',
      (tester) async {
        await pumpMobile(tester);
        await tester.tap(find.text('Filter recipes'));
        await tester.pumpAndSettle();
        expect(find.text('Early Day'), findsOneWidget);

        await tester.tap(find.text('Diet & lifestyle'));
        await tester.pumpAndSettle();
        expect(find.text('Dietary Restrictions'), findsOneWidget);
      },
    );

    testWidgets(
      'selecting a course in the tabbed sheet fires onCourseChanged + dismisses',
      (tester) async {
        Course? captured;
        await pumpMobile(tester, onCourseChanged: (v) => captured = v);
        await tester.tap(find.text('Filter recipes'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Desserts & Sweets'));
        await tester.pumpAndSettle();

        expect(captured, Course.dessert);
        expect(find.text('Course'), findsNothing);
      },
    );

    testWidgets(
      'selecting a dietary value in the tabbed sheet fires onDietaryChanged',
      (tester) async {
        Dietary? captured;
        await pumpMobile(tester, onDietaryChanged: (v) => captured = v);
        await tester.tap(find.text('Filter recipes'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Diet & lifestyle'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Quick & Easy'));
        await tester.pumpAndSettle();

        expect(captured, Dietary.quickEasy);
        expect(find.text('Course'), findsNothing);
      },
    );

    testWidgets('each tab shows a flat list without search on mobile', (
      tester,
    ) async {
      await pumpMobile(tester);
      await tester.tap(find.text('Filter recipes'));
      await tester.pumpAndSettle();

      expect(find.text('Early Day'), findsOneWidget);
      expect(find.text('Search courses…'), findsNothing);

      await tester.tap(find.text('Diet & lifestyle'));
      await tester.pumpAndSettle();
      expect(find.text('Cooking Formats'), findsOneWidget);
      expect(find.text('Search dietary preferences…'), findsNothing);

      await tester.tap(find.text('Course'));
      await tester.pumpAndSettle();
      expect(find.text('Early Day'), findsOneWidget);
    });

    testWidgets(
      'tablet and desktop render two separate pills, NOT the combined pill',
      (tester) async {
        // Minimum tablet width (600 dp) — framed column is ~536 dp but
        // device class is tablet, so the phone bottom sheet must not
        // appear. Each dimension keeps its own accordion dropdown.
        await _pumpFilterBar(tester, viewSize: const Size(600, 1400));
        expect(find.text('Filter recipes'), findsNothing);
        expect(find.text('All Courses'), findsOneWidget);
        expect(find.text('All Preferences'), findsOneWidget);
      },
    );

    testWidgets('desktop renders two separate pills, NOT the combined pill', (
      tester,
    ) async {
      // 900 dp viewport → side-by-side columns → each dimension
      // gets its own labeled pill + its own single-dimension
      // accordion route. The combined-pill hint must not appear.
      await _pumpFilterBar(tester);
      expect(find.text('Filter recipes'), findsNothing);
      // Both desktop pills are present.
      expect(find.text('All Courses'), findsOneWidget);
      expect(find.text('All Preferences'), findsOneWidget);

      await tester.tap(find.text('All Courses'));
      await tester.pumpAndSettle();
      // No tab toggle on desktop.
      expect(find.text('By Course'), findsNothing);
      expect(find.text('By Diet & Lifestyle'), findsNothing);
      expect(find.text('Course'), findsNothing);
      expect(find.text('Diet & lifestyle'), findsNothing);
      // The Course accordion still opens normally.
      expect(find.text('SWEET ENDING'), findsOneWidget);
    });
  });

  group('trigger overflow', () {
    testWidgets('narrow phone-width trigger never RenderFlex-overflows '
        'with a verbose-locale group label + long selection', (tester) async {
      // Bug #2 (medium): pre-fix the trigger group chip was a
      // rigid-width child of the inner Row. On a 360-dp phone in
      // a verbose locale the chip + selection text could exceed
      // the Expanded slot and trigger yellow-and-black overflow.
      // The fix caps the chip at 160 dp and gives the selection
      // a higher flex factor.
      //
      // Originally pinned to `Locale('my')` because Burmese strings
      // were the longest in the catalog. Burmese was removed; we
      // pin to Vietnamese now since it has the longest remaining
      // labels and stresses the same overflow path.
      tester.view.physicalSize = const Size(360, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        wrapWithApp(
          locale: const Locale('vi'),
          child: FilterBar(
            course: null,
            dietary: Dietary.bloodSugarBalanced,
            onCourseChanged: (_) {},
            onDietaryChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Flutter records overflow as a test exception — if the
      // trigger overflowed even by a single pixel we'd see it
      // here.
      expect(tester.takeException(), isNull);
    });
  });
}
