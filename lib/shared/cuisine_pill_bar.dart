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
      case Cuisine.vietnamese:
        return l.cuisineVietnamese;
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

    // First pill has no leading gap so it lines up exactly with the search
    // bar and recipe cards above/below — those are flush with `pagePadding`
    // and adding any inner left padding here pushes the "All" pill in
    // further than the surrounding content (visible misalignment on phone
    // and desktop alike).
    Widget pill(String label, bool selected, VoidCallback onTap,
        {required bool isFirst}) {
      return Padding(
        padding: EdgeInsets.only(left: isFirst ? 0 : 8),
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

    final cuisines = Cuisine.values;

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        // Zero padding — the parent wraps us in `pagePadding`, so the first
        // pill starts at exactly the same x as the cards and search bar,
        // and the last pill can scroll right up to the trailing edge.
        padding: EdgeInsets.zero,
        itemCount: cuisines.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return pill(l.cuisineAll, value == null, () => onChanged(null),
                isFirst: true);
          }
          final c = cuisines[i - 1];
          return pill(labelFor(l, c), value == c, () => onChanged(c),
              isFirst: false);
        },
      ),
    );
  }
}
