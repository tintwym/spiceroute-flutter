import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/features/explore/explore_filter_bar.dart';

import '../helpers/test_harness.dart';

void main() {
  testWidgets('tablet narrow framed width reserves column layout height', (
    tester,
  ) async {
    // iPad portrait-ish: 700 dp viewport → framed column ~636 dp
    // (< 640) → search stacked above counter → 114 dp sliver.
    tester.view.physicalSize = const Size(700, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late double height;
    await tester.pumpWidget(
      wrapWithApp(
        child: Builder(
          builder: (context) {
            height = ExploreFilterRow.estimatedHeight(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pump();

    expect(height, 114);
  });

  testWidgets('tablet wide framed width reserves single-row layout height', (
    tester,
  ) async {
    // 900 dp viewport → framed column hits 720 cap → wide row → 80 dp.
    tester.view.physicalSize = const Size(900, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late double height;
    await tester.pumpWidget(
      wrapWithApp(
        child: Builder(
          builder: (context) {
            height = ExploreFilterRow.estimatedHeight(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pump();

    expect(height, 80);
  });

  testWidgets('wide row pins counter to the right of the search field', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      wrapWithApp(
        child: const Scaffold(
          body: Center(
            child: SizedBox(
              width: 900,
              child: ExploreFilterRow(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final search = tester.getTopLeft(find.byType(TextField));
    final counter = tester.getTopLeft(find.textContaining('All Cuisines'));
    final rowRight = tester.getTopRight(find.byType(Row)).dx;

    expect(counter.dx, greaterThan(search.dx + 200));
    expect(counter.dx, greaterThan(rowRight - 320));
  });
}
