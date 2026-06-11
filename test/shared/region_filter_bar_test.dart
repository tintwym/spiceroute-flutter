import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/l10n/generated/app_localizations.dart';
import 'package:spiceroute/models/spice_route.dart';
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
  testWidgets(
    'pill button exposes selected state to screen readers',
    (tester) async {
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
    },
  );

  testWidgets(
    'tapping the active cuisine pill clears it',
    (tester) async {
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
    },
  );

  testWidgets(
    'renders at iPhone SE width without RenderFlex overflow',
    (tester) async {
      // 320 dp is the narrowest iPhone screen still in use today
      // (SE 1st gen). If the eyebrow / pill row overflows here, it
      // overflows on every phone narrower than ~360.
      await _pumpBar(tester, viewSize: const Size(320, 800));
      // Flutter records overflow as exceptions; pumpAndSettle would
      // surface them. Extra paranoia: explicitly look for the
      // takeException sink.
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'renders Burmese eyebrow at narrow width without overflow',
    (tester) async {
      // Burmese region/eyebrow strings are the longest in the
      // catalog. This combo (narrow viewport + verbose locale) is
      // the worst case for horizontal overflow.
      await _pumpBar(
        tester,
        locale: const Locale('my'),
        viewSize: const Size(360, 900),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'pill meets 44pt touch-target minimum',
    (tester) async {
      // Apple HIG / Material both call for ≥44pt tappable height.
      // Pre-fix the pill landed around 36-38 px which fails the
      // spec; this regression test fails if anyone trims the
      // ConstrainedBox(minHeight: 44) we added to _PillButton.
      await _pumpBar(tester, viewSize: const Size(360, 900));
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
    },
  );
}
