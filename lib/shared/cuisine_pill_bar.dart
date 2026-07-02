import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/cuisine_catalog.dart';
import '../models/spice_route.dart';
import 'cuisine_chrome.dart';

/// Horizontal pill bar listing every [Cuisine] + an "All" pill.
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
  static String emojiFor(Cuisine c) => cuisineFlag(c);

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
      // Hummus / mezze
      case Cuisine.lebanese:
        return '🧆';
      // Kebab / döner
      case Cuisine.turkish:
        return '🥙';
      // Tagine
      case Cuisine.moroccan:
        return '🥘';
      // Stew over injera
      case Cuisine.ethiopian:
        return '🍲';
      // Adobo / lumpia
      case Cuisine.filipino:
        return '🍢';
      // Biryani
      case Cuisine.pakistani:
        return '🍛';
      // Hoppers / coconut curry
      case Cuisine.sriLankan:
        return '🍛';
      // Amok / fish curry
      case Cuisine.cambodian:
        return '🍲';
      // Churrasco / feijoada
      case Cuisine.brazilian:
        return '🥩';
      // Ceviche
      case Cuisine.peruvian:
        return '🐟';
      // Jerk chicken
      case Cuisine.caribbean:
        return '🍗';
      // Bubble tea / beef noodle
      case Cuisine.taiwanese:
        return '🧋';
      // Bacalhau / piri-piri
      case Cuisine.portuguese:
        return '🐟';
      // Roast / fish & chips
      case Cuisine.british:
        return '🥧';
      case Cuisine.mongolian:
        return '🥟';
      case Cuisine.tibetan:
        return '🍲';
      case Cuisine.hongKong:
      case Cuisine.macanese:
      case Cuisine.sichuan:
      case Cuisine.cantonese:
      case Cuisine.shanghainese:
      case Cuisine.fujian:
      case Cuisine.hunan:
      case Cuisine.yunnan:
      case Cuisine.beijing:
      case Cuisine.dongbei:
      case Cuisine.hakka:
      case Cuisine.shandong:
      case Cuisine.guangxi:
      case Cuisine.teochew:
      case Cuisine.hainanese:
      case Cuisine.jiangsu:
      case Cuisine.zhejiang:
      case Cuisine.anhui:
      case Cuisine.jiangxi:
      case Cuisine.guizhou:
      case Cuisine.manchurian:
      case Cuisine.shaanxi:
        return '🥟';
      case Cuisine.burmese:
      case Cuisine.shan:
      case Cuisine.rakhine:
      case Cuisine.mon:
      case Cuisine.kachin:
      case Cuisine.kayin:
      case Cuisine.chin:
      case Cuisine.kayah:
      case Cuisine.mandalay:
      case Cuisine.yangon:
      case Cuisine.ayeyarwady:
      case Cuisine.tanintharyi:
      case Cuisine.intha:
      case Cuisine.naga:
      case Cuisine.paO:
      case Cuisine.danu:
      case Cuisine.wa:
      case Cuisine.magway:
      case Cuisine.bago:
      case Cuisine.sagaing:
      case Cuisine.taunggyi:
        return '🍛';
      case Cuisine.uyghur:
        return '🍜';
      case Cuisine.okinawan:
        return '🍜';
    }
  }

  static String labelFor(AppL10n l, Cuisine c) => cuisineLabel(l, c);

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);

    // First pill has no leading gap so it lines up exactly with the search
    // bar and recipe cards above/below — those are flush with `pagePadding`
    // and adding any inner left padding here pushes the "All" pill in
    // further than the surrounding content (visible misalignment on phone
    // and desktop alike).
    Widget pill(
      String label,
      bool selected,
      VoidCallback onTap, {
      required bool isFirst,
    }) {
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

    final cuisines = selectableCuisines(Cuisine.values);

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
            return pill(
              l.cuisineAll,
              value == null,
              () => onChanged(null),
              isFirst: true,
            );
          }
          final c = cuisines[i - 1];
          return pill(
            labelFor(l, c),
            cuisinePillSelected(pill: c, active: value),
            () => onChanged(c),
            isFirst: false,
          );
        },
      ),
    );
  }
}
