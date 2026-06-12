import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
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
///   * Phone — search lives in the AppBar pill, so we only render
///     the result counter here. Pinning a single line of secondary
///     text is still useful: it confirms the active scope while the
///     user scrolls a long grid.
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
    final count =
        ref.watch(exploreProvider.select((s) => s.visibleItems.length));
    final cuisine = ref.watch(exploreProvider.select((s) => s.cuisine));
    final scope = cuisine == null
        ? l.filterAllCuisines
        : CuisinePillBar.labelFor(l, cuisine);

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final counter = Text(
      l.exploreResultCount(count, scope),
      style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
    );

    if (deviceClassOf(context).isPhone) {
      return Align(
        alignment: Alignment.centerLeft,
        child: counter,
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 640;
      final search = NavSearchField(
        maxWidth: wide ? 460 : double.infinity,
      );
      if (!wide) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            search,
            const SizedBox(height: 10),
            counter,
          ],
        );
      }
      return Row(
        children: [
          Expanded(
            child: Align(alignment: Alignment.centerLeft, child: search),
          ),
          const SizedBox(width: 16),
          counter,
        ],
      );
    });
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
    if (dc.isPhone) {
      // Counter-only line + vertical padding.
      return 56;
    }
    // Use the same width gate the build method uses so the height
    // estimate matches the actual chosen layout. We treat anything
    // < 640 logical px as "narrow tablet" (column layout).
    final w = MediaQuery.sizeOf(context).width;
    if (w < 640) {
      // search (48) + gap (10) + counter (24) + pad (32) = 114
      return 114;
    }
    // search (48) + pad (32) = 80, counter folds inside row height.
    return 80;
  }
}
