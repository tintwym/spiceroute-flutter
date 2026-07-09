import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/cuisine_catalog.dart';
import '../../shared/breakpoints.dart';
import '../../shared/cuisine_pill_bar.dart';
import '../../shared/nav_search_field.dart';
import '../../state/explore.dart';

/// Search field paired with a live "Showing N recipes in `<scope>`"
/// counter. Rendered by `ExploreScreen` inside a
/// `SliverPinnedFilterBar` so the row pins to the top of the
/// viewport once the hero scrolls past it — refining a query
/// mid-scroll no longer requires scrolling back up to find the
/// input. (This widget used to live inside `PageHero.below` on
/// `ExploreScreen` and scrolled away with the rest of the hero.)
///
/// Three responsive shapes (mirrors the original logic verbatim so
/// the move is a pure refactor):
///   * Phone — result counter with search directly below (search was
///     removed from the AppBar so it sits under "Showing N recipes…").
///   * Tablet narrow (`< 640 px`) — search above, counter below.
///   * Tablet wide / desktop (`>= 640 px`) — search left, counter
///     right, on the same row.
///
/// Heights are exposed via [estimatedHeight] so the persistent-header
/// sliver can hand a fixed extent to the framework without having to
/// measure dynamically (which `SliverPersistentHeaderDelegate` can't
/// do).
class ExploreFilterRow extends ConsumerWidget {
  const ExploreFilterRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final count = ref.watch(
      exploreProvider.select((s) => s.visibleItems.length),
    );
    final cuisine = ref.watch(exploreProvider.select((s) => s.cuisine));
    final scope = cuisine == null
        ? l.filterAllCuisines
        : CuisinePillBar.labelFor(l, cuisineForDisplay(cuisine));

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final counter = Text(
      l.exploreResultCount(count, scope),
      // Single-line + ellipsis so verbose locales ("Showing 12 recipes
      // in <long cuisine name>" in Korean / Vietnamese / Chinese) can't
      // wrap onto a second line and overflow the fixed `estimatedHeight`
      // (56 dp on phone). Overflow there is silent — the `ClipRect` in
      // `SliverPinnedFilterBar` swallows the bottom row of pixels, so
      // you'd never spot the regression at code review time.
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
    );

    if (deviceClassOf(context).isPhone) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          counter,
          const SizedBox(height: 10),
          NavSearchField(maxWidth: double.infinity, dense: true),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 640;
        final search = NavSearchField(maxWidth: wide ? 460 : double.infinity);
        if (!wide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [search, const SizedBox(height: 10), counter],
          );
        }
        return Row(
          children: [
            search,
            const Spacer(),
            Flexible(
              child: Align(
                alignment: Alignment.centerRight,
                child: counter,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Fixed extent the persistent-header sliver should reserve, in
  /// logical pixels, INCLUDING the standard 16 px top + 16 px bottom
  /// vertical padding the sliver wraps around the row. Computed
  /// per device class to match the three responsive shapes returned
  /// from `build`.
  ///
  /// The numbers are conservative — they slightly overshoot the
  /// actual rendered height so the row never gets clipped at the
  /// bottom when the OS font scale is bumped one notch. Undershooting
  /// would clip; overshooting just leaves a few px of breathing room
  /// at rest (invisible because the sliver background blends into
  /// the page surface until the user scrolls).
  static double estimatedHeight(BuildContext context) {
    final dc = deviceClassOf(context);
    // Scale line heights when the user bumps OS text size so the pinned
    // bar never clips the counter or search field.
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final counterLine = (24.0 * textScale).clamp(24.0, 40.0);
    const verticalPad = 32.0;

    if (dc.isPhone) {
      const searchHeight = 44.0;
      const rowGap = 10.0;
      return searchHeight + rowGap + counterLine + verticalPad;
    }
    final contentW = framedContentWidth(context);
    const searchHeight = 48.0;
    const rowGap = 10.0;
    if (contentW < 640) {
      return searchHeight + rowGap + counterLine + verticalPad;
    }
    final rowLine = (48.0 * textScale).clamp(48.0, 56.0);
    return rowLine + verticalPad;
  }
}
