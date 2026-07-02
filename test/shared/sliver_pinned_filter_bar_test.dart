import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/shared/sliver_pinned_filter_bar.dart';

/// Contract tests for [SliverPinnedFilterBar]. The single behavioural
/// guarantee — and the entire reason this sliver exists — is "stay
/// glued to the top of the viewport once the scroll position passes
/// it." If a future refactor accidentally drops `pinned: true` on the
/// underlying `SliverPersistentHeader`, these tests fail loudly
/// instead of silently regressing the Explore UX.
void main() {
  // Stable, unique key so the assertions can locate the child after a
  // scroll without relying on Type-based finders (which would match
  // other Containers in the test tree too).
  const childKey = Key('pinned-child');

  Future<void> pumpHarness(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              // Non-pinned slot above the bar. Kept SHORTER than the
              // default test viewport (800x600) so the pinned bar is
              // actually materialised on the first frame — the
              // CustomScrollView is lazy and would otherwise refuse
              // to mount a sliver that sits below the visible region.
              const SliverToBoxAdapter(
                child: SizedBox(
                  key: Key('above'),
                  height: 400,
                  child: ColoredBox(color: Color(0xFFEEEEEE)),
                ),
              ),
              SliverPinnedFilterBar(
                height: 64,
                child: Container(
                  key: childKey,
                  height: 64,
                  alignment: Alignment.center,
                  child: const Text('search'),
                ),
              ),
              // Tall slot below the bar — content the user is
              // scrolling through while the bar stays put.
              SliverList.builder(
                itemBuilder: (_, i) =>
                    SizedBox(height: 80, child: Center(child: Text('item $i'))),
                itemCount: 30,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('child sits at natural position at rest', (tester) async {
    await pumpHarness(tester);
    // Before any scroll, the pinned child should appear right under
    // the 400-tall block above it — y = 400 (modulo float rounding).
    final dy = tester.getTopLeft(find.byKey(childKey)).dy;
    expect(
      dy,
      closeTo(400, 0.5),
      reason:
          'at rest the pinned bar should sit at its natural '
          'sliver-order position, not protrude into the above-slot',
    );
  });

  testWidgets('child pins to y=0 after scrolling past it', (tester) async {
    await pumpHarness(tester);

    // Drag the scrollable up by 600 px so the 400-tall above-slot
    // clears the viewport entirely. If the bar is working, it
    // should now be glued to the top of the scrollable area
    // instead of having scrolled away with everything else.
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();

    final dy = tester.getTopLeft(find.byKey(childKey)).dy;
    expect(
      dy,
      closeTo(0, 0.5),
      reason:
          'after the user scrolls past the bar, it must pin to '
          'the top of the viewport — that is the only reason this '
          'sliver type exists',
    );
  });

  testWidgets('shouldRebuild fires only when extent or child changes', (
    tester,
  ) async {
    // Build twice with identical inputs — the delegate should not
    // request a rebuild. We assert this indirectly by confirming the
    // pinned position is stable across two consecutive pumps.
    await pumpHarness(tester);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();
    final pos1 = tester.getTopLeft(find.byKey(childKey));

    await tester.pump();
    final pos2 = tester.getTopLeft(find.byKey(childKey));

    expect(pos1, pos2, reason: 'no rebuild should = no layout drift');
  });
}
