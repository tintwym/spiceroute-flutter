import '../l10n/generated/app_localizations.dart';
import '../models/spice_route.dart';

/// Picks the right "duration" l10n string for a recipe's total time.
///
/// - `< 60 min`   -> "20 min"           (compact, single unit)
/// - `=  60n`     -> "3 h"              (whole hours, drop the trailing 0 min)
/// - `> 60`       -> "3 h 20 min"       (hours + remainder)
///
/// We have to do this in code (rather than ICU `plural` in the .arb) because
/// the rule isn't strict pluralization — it switches *units*, not just the
/// noun. Trying to express "switch to hours after 60" in ICU MessageFormat
/// is gymnastics that's worse to read than a `if minutes >= 60`.
String formatRecipeDuration(AppL10n l, int minutes) {
  if (minutes < 60) return l.recipeMinutesShort(minutes);
  final hours = minutes ~/ 60;
  final remainder = minutes % 60;
  if (remainder == 0) return l.recipeHoursShort(hours);
  return l.recipeHoursMinutesShort(hours, remainder);
}

/// Localize a server-issued [Difficulty] enum to the user-facing
/// pill label. The label strings are exhaustive over the enum — every
/// case returns a non-null string — so call sites can use this without
/// any null-fallback gymnastics.
///
/// The model now carries `difficulty` as a first-class column (see
/// `app/models/difficulty.py` on the backend); the old client-side
/// `totalMinutes + steps*5` heuristic was deleted because (a) it
/// undersold long unattended cooks like Taiwanese Beef Noodle Soup
/// as EASY and (b) the chip was hidden on narrow viewports, leaving
/// many cards looking like they were missing the field entirely.
String recipeDifficultyLabel(AppL10n l, Difficulty difficulty) {
  switch (difficulty) {
    case Difficulty.easy:
      return l.detailDifficultyEasy;
    case Difficulty.medium:
      return l.detailDifficultyMedium;
    case Difficulty.hard:
      return l.detailDifficultyHard;
  }
}
