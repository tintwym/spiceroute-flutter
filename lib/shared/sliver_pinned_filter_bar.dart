import 'package:flutter/material.dart';

/// Sliver that pins its [child] to the top of the viewport while the
/// rest of the scroll view moves underneath. Use for the
/// search-row-plus-result-counter band on long content lists (see
/// `ExploreScreen`) so refining a query never requires scrolling all
/// the way back up to find the input.
///
/// Why a custom sliver instead of `SliverAppBar`:
///   * `SliverAppBar` is hard-wired to AppBar-shaped content — its
///     `flexibleSpace` slot fights our centred max-width framing
///     and the implicit leading/title rendering would have to be
///     turned off piece by piece.
///   * `SliverPersistentHeader` is the primitive `SliverAppBar`
///     itself is built on, and gives us full control over the
///     painted background, the scroll-under elevation cue, and the
///     extent (which must be fixed — see the [height] contract on
///     the constructor for why we use a per-device-class number
///     instead of trying to measure dynamically).
///
/// Visual contract:
///   * **At rest** (caller is at the top of the scroll view) the
///     sliver paints `cs.surface` with no border or shadow, so it
///     reads as a flush continuation of whatever sits above it
///     (typically a [PageHero]). The user shouldn't perceive a
///     distinct "filter bar band" until they scroll.
///   * **When pinned** (`shrinkOffset > 0`) a hairline bottom border
///     and a soft 2 px down-shadow fade in over 140 ms. The shift
///     is visible enough to telegraph "this is now floating above
///     the content" without flickering during natural scroll
///     wobble.
class SliverPinnedFilterBar extends StatelessWidget {
  const SliverPinnedFilterBar({
    super.key,
    required this.child,
    required this.height,
  });

  /// Widget rendered inside the pinned strip. Constrain its own
  /// internal padding to match the rest of the page's content
  /// framing — the sliver itself paints background chrome only.
  final Widget child;

  /// Fixed vertical extent the sliver claims, in logical pixels.
  /// `SliverPersistentHeaderDelegate` requires `minExtent == maxExtent`
  /// at construction time; we pass a per-device-class estimate from
  /// the call site so the bar doesn't clip its content on narrow
  /// viewports where the search field stacks above the counter.
  final double height;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _PinnedFilterBarDelegate(child: child, height: height),
    );
  }
}

class _PinnedFilterBarDelegate extends SliverPersistentHeaderDelegate {
  _PinnedFilterBarDelegate({required this.child, required this.height});

  final Widget child;
  final double height;

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Treat any non-zero shrinkOffset OR an `overlapsContent` flag
    // as "we are now pinning over scrolling content beneath us." We
    // intentionally do NOT use a > 0.5 threshold — the scroll
    // physics can briefly settle the offset at fractional values
    // after a fling, and a hysteresis band makes the elevation cue
    // flicker on/off. A simple `> 0` check matches what
    // `SliverAppBar` does internally.
    final pinned = shrinkOffset > 0 || overlapsContent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: cs.surface,
        border: pinned
            ? Border(bottom: BorderSide(color: cs.outlineVariant, width: 1))
            : null,
        boxShadow: pinned
            ? [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      // ClipRect keeps the box-shadow from bleeding upward into the
      // hero (where it'd paint a phantom line at rest), and prevents
      // the child's own InkWell ripples from leaking outside the
      // pinned band when the user taps the search field while it's
      // stuck at the top.
      child: ClipRect(child: child),
    );
  }

  @override
  bool shouldRebuild(_PinnedFilterBarDelegate old) =>
      // Deliberately ignore `child`: the call site (ExploreScreen) wraps
      // its content in fresh `Padding` widgets every build, so a naive
      // `old.child != child` would flag the delegate dirty on every
      // `exploreProvider` mutation (search debounce ticks, loading
      // flips, filter changes) and force the AnimatedContainer to
      // re-tick its 140ms color/border interpolation — visible as a
      // flicker on the pinned band while typing in the search field.
      // The child manages its own state through its own `ref.watch`
      // dependencies; we only need to rebuild when our extent changes.
      old.height != height;
}
