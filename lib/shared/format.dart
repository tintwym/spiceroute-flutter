import '../l10n/generated/app_localizations.dart';

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
