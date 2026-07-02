import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/shared/ios_liquid_glass.dart';
import 'package:spiceroute/shared/responsive_scaffold.dart';

import '../helpers/test_harness.dart' show wrapWithApp;

const _destinations = [
  ShellDestination(
    label: 'Explore',
    icon: Icons.explore_outlined,
    selectedIcon: Icons.explore,
    path: '/',
  ),
  ShellDestination(
    label: 'Saved',
    icon: Icons.bookmark_border,
    selectedIcon: Icons.bookmark,
    path: '/saved',
  ),
];

void main() {
  testWidgets('PhoneShellTabBar renders Material NavigationBar off iOS', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapWithApp(
        child: PhoneShellTabBar(
          destinations: _destinations,
          selectedIndex: 0,
          onDestinationSelected: (_) {},
        ),
      ),
    );

    // CI / macOS widget tests run with defaultTargetPlatform != iOS, so
    // we exercise the generic Material fallback (not UiKit or Android M3).
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
  });

  testWidgets('PhoneShellTabBar falls back to Material on iOS without Liquid Glass', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await tester.pumpWidget(
      wrapWithApp(
        child: PhoneShellTabBar(
          destinations: _destinations,
          selectedIndex: 0,
          onDestinationSelected: (_) {},
        ),
      ),
    );

    // Widget tests are not web and iOS < 26, so the native bar is
    // unavailable — same path mobile Safari must take (kIsWeb gate).
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('PhoneShellTabBar uses Android Material chrome', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    await tester.pumpWidget(
      wrapWithApp(
        child: PhoneShellTabBar(
          destinations: _destinations,
          selectedIndex: 0,
          onDestinationSelected: (_) {},
        ),
      ),
    );

    expect(preferAndroidMaterial, isTrue);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(
      find.descendant(
        of: find.byWidgetPredicate(
          (w) => w is Material && w.elevation == 3,
        ),
        matching: find.byType(NavigationBar),
      ),
      findsOneWidget,
    );

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('AdaptiveLiquidGlassSwitch renders Material Switch off iOS', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapWithApp(
        child: AdaptiveLiquidGlassSwitch(
          value: true,
          onChanged: (_) {},
        ),
      ),
    );

    expect(find.byType(Switch), findsOneWidget);
  });

  testWidgets('AdaptiveLiquidGlassSegments renders SegmentedButton off iOS', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapWithApp(
        child: AdaptiveLiquidGlassSegments<String>(
          segments: const ['A', 'B'],
          selected: 'A',
          onSelectionChanged: (_) {},
          labelFor: (v) => v,
        ),
      ),
    );

    expect(find.byType(SegmentedButton<String>), findsOneWidget);
  });
}
