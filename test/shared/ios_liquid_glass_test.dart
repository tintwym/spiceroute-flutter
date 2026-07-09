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
    label: 'Chat',
    icon: Icons.chat_bubble_outline,
    selectedIcon: Icons.chat_bubble,
    path: '/ai/companion',
  ),
  ShellDestination(
    label: 'Saved',
    icon: Icons.bookmark_border,
    selectedIcon: Icons.bookmark,
    path: '/saved',
  ),
  ShellDestination(
    label: 'Me',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    path: '/me',
  ),
];

PhoneShellTabBar _tabBar({
  int selectedBarIndex = 0,
  ValueChanged<int>? onBarIndexSelected,
  VoidCallback? onPlusPressed,
}) {
  return PhoneShellTabBar(
    destinations: _destinations,
    selectedBarIndex: selectedBarIndex,
    onBarIndexSelected: onBarIndexSelected ?? (_) {},
    onPlusPressed: onPlusPressed ?? () {},
  );
}

void main() {
  testWidgets('PhoneShellTabBar renders four tabs and center plus', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapWithApp(child: _tabBar()),
    );

    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Me'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('PhoneShellTabBar highlights selected tab', (tester) async {
    await tester.pumpWidget(
      wrapWithApp(child: _tabBar(selectedBarIndex: 3)),
    );

    expect(find.text('Saved'), findsOneWidget);
  });

  testWidgets('PhoneShellTabBar invokes plus callback', (tester) async {
    var plusTapped = false;

    await tester.pumpWidget(
      wrapWithApp(
        child: _tabBar(onPlusPressed: () => plusTapped = true),
      ),
    );

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(plusTapped, isTrue);
  });

  testWidgets('PhoneShellTabBar uses elevated Material chrome on Android', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    await tester.pumpWidget(
      wrapWithApp(child: _tabBar()),
    );

    expect(preferAndroidMaterial, isTrue);
    expect(
      find.descendant(
        of: find.byWidgetPredicate(
          (w) => w is Material && w.elevation == 3,
        ),
        matching: find.text('Explore'),
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
