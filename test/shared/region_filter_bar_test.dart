import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/l10n/generated/app_localizations.dart';
import 'package:spiceroute/models/spice_route.dart';
import 'package:spiceroute/shared/filter_bar.dart';
import 'package:spiceroute/shared/region_filter_bar.dart';

/// Pumps the [RegionFilterBar] inside the minimum Material + l10n
/// scaffolding required to look up theme + AppL10n.
Future<void> _pumpBar(
  WidgetTester tester, {
  Cuisine? cuisine,
  ValueChanged<Cuisine?>? onChanged,
  Locale locale = const Locale('en'),
  Size viewSize = const Size(800, 1200),
}) async {
  // Force the test view to the requested logical size — without this
  // the harness defaults to ~800x600 which masks phone-only overflow
  // bugs (e.g. the Burmese eyebrow text running off the right edge of
  // a 360px phone).
  tester.view.physicalSize = viewSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          // Phone-style page padding (16px each side, matches
          // breakpoints.dart). Constrains the bar to a realistic
          // content width so the test reproduces what real users see.
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: RegionFilterBar(
            cuisine: cuisine,
            onCuisineChanged: onChanged ?? (_) {},
          ),
        ),
      ),
    ),
  );
  // Two pumps: one for the build, one for AppL10n's async load on first
  // frame. Without the second pump, l10n strings come up as keys.
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('pill button exposes selected state to screen readers', (
    tester,
  ) async {
    // ensureSemantics turns on the semantics tree for this test;
    // by default Flutter test harness leaves it off (it's expensive
    // per frame). Without it, semantic finders/lookups return empty.
    final handle = tester.ensureSemantics();
    // Korean is in East Asia (the default initial region) so the
    // Korean cuisine pill should render with selected=true in
    // semantics.
    await _pumpBar(tester, cuisine: Cuisine.korean);

    // Use find.text to locate the pill's visible label, then walk
    // up to its semantics — the Semantics ancestor on _PillButton
    // merges its flags into this subtree. The label comes from the
    // Text widget; the parent Semantics adds button + selected.
    expect(
      tester.getSemantics(find.text('Korean')),
      matchesSemantics(
        isButton: true,
        isSelected: true,
        isFocusable: true,
        // hasSelectedState is auto-set whenever `selected:` is
        // passed to the Semantics widget (so the AT knows the
        // node IS a toggleable). Must be declared explicitly in
        // the matcher.
        hasSelectedState: true,
        hasTapAction: true,
        hasFocusAction: true,
        label: 'Korean',
      ),
    );

    handle.dispose();
  });

  testWidgets('tapping the active cuisine pill clears it', (tester) async {
    Cuisine? captured = Cuisine.korean;
    await _pumpBar(
      tester,
      cuisine: Cuisine.korean,
      onChanged: (c) => captured = c,
    );

    // Re-tap the already-active pill — region bar should fire
    // `onChanged(null)` to clear the filter. Use find.text instead
    // of bySemanticsLabel here so the test doesn't need the
    // semantics tree turned on just to find the pill.
    await tester.tap(find.text('Korean'));
    await tester.pumpAndSettle();

    expect(captured, isNull);
  });

  testWidgets('renders at iPhone SE width without RenderFlex overflow', (
    tester,
  ) async {
    // 320 dp is the narrowest iPhone screen still in use today
    // (SE 1st gen). If the eyebrow / pill row overflows here, it
    // overflows on every phone narrower than ~360.
    await _pumpBar(tester, viewSize: const Size(320, 800));
    // Flutter records overflow as exceptions; pumpAndSettle would
    // surface them. Extra paranoia: explicitly look for the
    // takeException sink.
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'renders verbose-locale eyebrow at narrow width without overflow',
    (tester) async {
      // Vietnamese region / eyebrow strings are the longest in the
      // remaining catalog (the previous worst-case Burmese locale was
      // removed). This combo (narrow viewport + verbose locale)
      // covers horizontal overflow at the worst-case width still in
      // production.
      await _pumpBar(
        tester,
        locale: const Locale('vi'),
        viewSize: const Size(360, 900),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('pill meets 44pt touch-target minimum', (tester) async {
    // Apple HIG / Material both call for ≥44pt tappable height.
    // Pre-fix the pill landed around 36-38 px which fails the
    // spec; this regression test fails if anyone trims the
    // ConstrainedBox(minHeight: 44) we added to _PillButton.
    //
    // Pass `cuisine: Cuisine.korean` so the cuisine drawer is open
    // (East Asia auto-selected) and the Korean pill is on screen
    // for us to measure. Without it, the bar is in blank-slate
    // mode and there's no Korean pill to find.
    await _pumpBar(
      tester,
      cuisine: Cuisine.korean,
      viewSize: const Size(800, 1200),
    );
    final pill = find.ancestor(
      of: find.text('Korean'),
      matching: find.byType(InkWell),
    );
    expect(pill, findsOneWidget);
    final size = tester.getSize(pill);
    expect(
      size.height,
      greaterThanOrEqualTo(44),
      reason: 'pill touch target must be >= 44pt',
    );
  });

  // -------------------------------------------------------------------
  // Blank-slate behavior: the cuisine drawer should be hidden until a
  // region is explicitly tapped, then close again on re-tap. These
  // tests pin the contract introduced when we removed the auto-pick of
  // "first populated region".
  // -------------------------------------------------------------------

  testWidgets('no cuisine filter → cuisine drawer is hidden on first build', (
    tester,
  ) async {
    await _pumpBar(tester); // no cuisine, tablet width

    expect(find.text('SELECT CUISINE TRADITION'), findsNothing);
    expect(find.text('Korean'), findsNothing);

    // Region pills are visible on tablet+ — only the drawer collapses.
    expect(find.text('East Asia'), findsOneWidget);
  });

  testWidgets('phone collapses region pills until expanded', (tester) async {
    await _pumpBar(tester, viewSize: const Size(360, 900));

    expect(find.text('Choose a region'), findsOneWidget);
    expect(find.text('East Asia'), findsNothing);

    await tester.tap(find.text('Choose a region'));
    await tester.pumpAndSettle();

    expect(find.text('East Asia'), findsOneWidget);
    expect(find.text('Mainland Southeast Asia'), findsOneWidget);
  });

  testWidgets('phone selects region then collapses picker again', (
    tester,
  ) async {
    await _pumpBar(tester, viewSize: const Size(360, 900));

    await tester.tap(find.text('Choose a region'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('East Asia'));
    await tester.pumpAndSettle();

    expect(find.text('Korean'), findsOneWidget);
    expect(find.text('East Asia'), findsOneWidget);
    expect(find.text('Mainland Southeast Asia'), findsNothing);
  });

  testWidgets('tapping a region pill opens that region\'s drawer', (
    tester,
  ) async {
    await _pumpBar(tester); // start in blank slate

    // Pre-condition: drawer hidden.
    expect(find.text('Korean'), findsNothing);

    await tester.tap(find.text('East Asia'));
    await tester.pumpAndSettle();

    // Korean is in East Asia, so it should now be visible.
    expect(find.text('Korean'), findsOneWidget);
    expect(find.text('SELECT CUISINE TRADITION'), findsOneWidget);
  });

  testWidgets('tapping the active region pill again closes the drawer', (
    tester,
  ) async {
    await _pumpBar(tester);

    // Open East Asia.
    await tester.tap(find.text('East Asia'));
    await tester.pumpAndSettle();
    expect(find.text('Korean'), findsOneWidget);

    // Re-tap to close.
    await tester.tap(find.text('East Asia'));
    await tester.pumpAndSettle();
    expect(find.text('Korean'), findsNothing);
    expect(find.text('SELECT CUISINE TRADITION'), findsNothing);
  });

  testWidgets('closing the drawer with an active cuisine clears the filter', (
    tester,
  ) async {
    // The user has Korean filtered (drawer auto-opens to East Asia
    // because that's Korean's region), then taps the East Asia pill
    // to close — the cuisine pill it contained no longer has a
    // visible affordance, so the filter must clear too.
    Cuisine? captured = Cuisine.korean;
    await _pumpBar(
      tester,
      cuisine: Cuisine.korean,
      onChanged: (c) => captured = c,
    );

    expect(find.text('Korean'), findsOneWidget);

    await tester.tap(find.text('East Asia'));
    await tester.pumpAndSettle();

    expect(captured, isNull, reason: 'closing drawer should clear filter');
    expect(find.text('Korean'), findsNothing);
  });

  testWidgets(
    'cuisine pre-set on mount → drawer opens to that cuisine\'s region',
    (tester) async {
      // Reopening the sheet with `cuisine = Cuisine.korean` already
      // active should NOT show the blank-slate state — that would
      // hide the only handle the user has to clear their filter.
      // East Asia must be auto-selected and Korean visible.
      await _pumpBar(tester, cuisine: Cuisine.korean);

      expect(find.text('Korean'), findsOneWidget);
      expect(find.text('SELECT CUISINE TRADITION'), findsOneWidget);
    },
  );

  testWidgets(
    'phone collapsed chooser survives verbose locale without overflow',
    (tester) async {
      await _pumpBar(
        tester,
        locale: const Locale('vi'),
        viewSize: const Size(320, 800),
      );
      expect(find.text('Chọn khu vực'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'scrollable cuisine pills stay inside tradition card on phone',
    (tester) async {
      await _pumpBar(
        tester,
        cuisine: Cuisine.thai,
        viewSize: const Size(390, 844),
      );

      expect(find.text('SELECT CUISINE TRADITION'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'phone layout uses horizontal scroll for cuisine pills when open',
    (tester) async {
      await _pumpBar(
        tester,
        cuisine: Cuisine.korean,
        viewSize: const Size(360, 900),
      );

      final horizontalLists = tester.widgetList<ListView>(
        find.byWidgetPredicate(
          (w) => w is ListView && w.scrollDirection == Axis.horizontal,
        ),
      );
      // Cuisine drawer uses a horizontal ListView on phone.
      expect(horizontalLists.length, greaterThanOrEqualTo(1));
    },
  );

  testWidgets(
    'phone collapsed trigger shows cuisine name when cuisine is active',
    (tester) async {
      await _pumpBar(
        tester,
        cuisine: Cuisine.korean,
        viewSize: const Size(360, 900),
      );

      // Collapsed chooser must show the active cuisine, not only the region.
      expect(find.text('Korean'), findsWidgets);
      expect(find.text('East Asian Countries'), findsNothing);
    },
  );

  testWidgets('phone combined refine row shows region + preferences halves', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppL10n.localizationsDelegates,
        supportedLocales: AppL10n.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: RegionFilterBar(
              cuisine: null,
              onCuisineChanged: (_) {},
              phonePreferencesTrigger: MobileCourseDietaryFilterTrigger(
                course: null,
                dietary: null,
                onCourseChanged: (_) {},
                onDietaryChanged: (_) {},
              ),
            ),
          ),
        ),
      ),
    );
    tester.view.physicalSize = const Size(360, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpAndSettle();

    expect(find.text('REFINE'), findsOneWidget);
    expect(find.text('Choose a region'), findsOneWidget);
    expect(find.text('Preferences'), findsNothing);
    expect(find.text('Course & diet'), findsOneWidget);
    expect(find.text('EXPLORE BY GEOGRAPHIC REGION'), findsNothing);
    expect(find.text('Filter recipes'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
