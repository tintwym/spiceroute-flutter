import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/spice_route.dart';

/// Horizontal pill bar listing the 16 cuisines + an "All" pill.
class CuisinePillBar extends StatelessWidget {
  const CuisinePillBar({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final Cuisine? value;
  final ValueChanged<Cuisine?> onChanged;

  /// Flag emoji per cuisine — used by the filter dropdown so each option
  /// has a country flag (and also exposed for any "what country" surface
  /// that still wants the flag affordance).
  static String emojiFor(Cuisine c) {
    switch (c) {
      case Cuisine.korean:
        return '🇰🇷';
      case Cuisine.japanese:
        return '🇯🇵';
      case Cuisine.chinese:
        return '🇨🇳';
      case Cuisine.burmese:
        return '🇲🇲';
      case Cuisine.thai:
        return '🇹🇭';
      case Cuisine.vietnamese:
        return '🇻🇳';
      case Cuisine.indian:
        return '🇮🇳';
      case Cuisine.italian:
        return '🇮🇹';
      case Cuisine.americanWestern:
        return '🇺🇸';
      case Cuisine.mexican:
        return '🇲🇽';
      case Cuisine.french:
        return '🇫🇷';
      case Cuisine.greek:
        return '🇬🇷';
      case Cuisine.spanish:
        return '🇪🇸';
      case Cuisine.malaysian:
        return '🇲🇾';
      case Cuisine.german:
        return '🇩🇪';
      case Cuisine.indonesian:
        return '🇮🇩';
    }
  }

  /// Food-themed emoji per cuisine — picks the most iconic dish so a
  /// glance at the top-left card badge tells you "this is sushi" or
  /// "this is a taco" without reading the title. Used for the small
  /// circular badge on recipe cards.
  static String foodEmojiFor(Cuisine c) {
    switch (c) {
      case Cuisine.korean:
        return '🍜';
      case Cuisine.japanese:
        return '🍣';
      case Cuisine.chinese:
        return '🥟';
      case Cuisine.burmese:
        return '🍛';
      case Cuisine.thai:
        return '🌶️';
      case Cuisine.vietnamese:
        return '🍲';
      case Cuisine.indian:
        return '🍛';
      case Cuisine.italian:
        return '🍝';
      case Cuisine.americanWestern:
        return '🍔';
      case Cuisine.mexican:
        return '🌮';
      case Cuisine.french:
        return '🥐';
      case Cuisine.greek:
        return '🥙';
      case Cuisine.spanish:
        return '🥘';
      case Cuisine.malaysian:
        return '🍢';
      case Cuisine.german:
        return '🥨';
      case Cuisine.indonesian:
        return '🍚';
    }
  }

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
      case Cuisine.french:
        return l.cuisineFrench;
      case Cuisine.greek:
        return l.cuisineGreek;
      case Cuisine.spanish:
        return l.cuisineSpanish;
      case Cuisine.malaysian:
        return l.cuisineMalaysian;
      case Cuisine.german:
        return l.cuisineGerman;
      case Cuisine.indonesian:
        return l.cuisineIndonesian;
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
