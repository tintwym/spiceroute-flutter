import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../shared/cuisine_pill_bar.dart';
import '../../shared/nav_search_field.dart';
import '../../shared/page_hero.dart';
import '../../state/explore.dart';

/// Explore's hero: the shared [PageHero] plus a search field paired with a
/// live result counter. The search reuses [NavSearchField] so it shares
/// the exact same query state and debounced refresh as everywhere else.
class ExploreHero extends ConsumerWidget {
  const ExploreHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final count =
        ref.watch(exploreProvider.select((s) => s.visibleItems.length));
    final cuisine = ref.watch(exploreProvider.select((s) => s.cuisine));
    final scope = cuisine == null
        ? l.filterAllCuisines
        : CuisinePillBar.labelFor(l, cuisine);

    return PageHero(below: _SearchAndCount(count: count, scope: scope));
  }
}

/// Search field + result counter. Wraps to two lines on narrow widths.
class _SearchAndCount extends StatelessWidget {
  const _SearchAndCount({required this.count, required this.scope});
  final int count;
  final String scope;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final counter = Text(
      l.exploreResultCount(count, scope),
      style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
    );

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
}
