import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/spice_route.dart';

/// Horizontal pill bar listing the 9 cuisines + an "All" pill.
class CuisinePillBar extends StatelessWidget {
  const CuisinePillBar({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final Cuisine? value;
  final ValueChanged<Cuisine?> onChanged;

  static String labelFor(AppL10n l, Cuisine c) {
    switch (c) {
      case Cuisine.korean:
        return l.cuisineKorean;
      case Cuisine.japanese:
        return l.cuisineJapanese;
      case Cuisine.chinese:
        return l.cuisineChinese;
      case Cuisine.burmese:
        return l.cuisineBurmese;
      case Cuisine.thai:
        return l.cuisineThai;
      case Cuisine.indian:
        return l.cuisineIndian;
      case Cuisine.italian:
        return l.cuisineItalian;
      case Cuisine.americanWestern:
        return l.cuisineAmericanWestern;
      case Cuisine.mexican:
        return l.cuisineMexican;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);

    Widget pill(String label, bool selected, VoidCallback onTap) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => onTap(),
          showCheckmark: false,
          labelStyle: theme.textTheme.labelMedium?.copyWith(
            color: selected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      );
    }

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          pill(l.cuisineAll, value == null, () => onChanged(null)),
          for (final c in Cuisine.values)
            pill(labelFor(l, c), value == c, () => onChanged(c)),
        ],
      ),
    );
  }
}
