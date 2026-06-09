import '../l10n/generated/app_localizations.dart';
import '../models/spice_route.dart';

/// Shared display helpers for the `Cuisine` enum.
///
/// Previously inlined as private helpers inside `community_board.dart` and
/// `cross_cultural_stories.dart`. Extracting keeps the two switch statements
/// from drifting out of sync as we add cuisines — every place that needs to
/// label or flag a cuisine now reads from this single file.
String cuisineLabel(AppL10n l, Cuisine c) {
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
  }
}

/// Flag glyph for a cuisine. Used in pills, badges, and the community
/// feed's per-post chip.
String cuisineFlag(Cuisine c) {
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
  }
}
