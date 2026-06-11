import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/spice_route.dart';
import 'cuisine_pill_bar.dart';

/// Shared "brand language" widgets — the small recurring visual atoms
/// that make every SpiceRoute surface feel like SpiceRoute (and not a
/// generic Material 3 sample).
///
/// Promotion policy:
///   - A widget belongs here when at least two surfaces (recipe
///     detail, cook mode, explore hero, etc.) want the exact same
///     visual treatment.
///   - If a surface needs a *variant*, add a parameter — don't
///     duplicate the class.
///
/// Anti-pattern: a widget that only one surface uses lives in that
/// surface's own file. Premature shared abstractions are how
/// design-systems calcify.
///
/// Things explicitly NOT here:
///   - The settings-screen `_SectionHeader` (simpler list-group
///     header, no primary rule). Different visual job, kept local.
///   - Anything still moving (auth screens, AI Creator chrome).
///     Pull those in once the design has settled.

/// Editorial section header: a 4-px primary-color rule on the left,
/// followed by uppercase tracked text. Used wherever the page needs
/// to mark a "real" section break (Ingredients, Cooking Instructions,
/// Reviews, ...).
///
/// Renders at `titleMedium` weight 700 with 1.0 letterSpacing — the
/// same treatment the recipe-detail modal has been using since the
/// editorial redesign.
class BrandSectionHeader extends StatelessWidget {
  const BrandSectionHeader({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text.toUpperCase(),
          style: theme.textTheme.titleMedium?.copyWith(
            letterSpacing: 1.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// The floating cuisine pill that overlays the recipe hero image and
/// other cuisine-scoped surfaces. Cream surface, uppercase label, slim
/// padding.
///
/// Defaults to the "labelMedium / weight 700 / 0.6 tracking" treatment
/// used on recipe detail. Pass [dense] for a smaller variant used on
/// chrome bars (e.g. the cook mode top bar) where the pill shouldn't
/// dominate.
class BrandCuisinePill extends StatelessWidget {
  const BrandCuisinePill({
    super.key,
    required this.cuisine,
    this.dense = false,
  });

  final Cuisine cuisine;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 10 : 12,
        vertical: dense ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(40),
        // Thin border for dense use over light backgrounds; the
        // recipe-hero variant sits over imagery and reads fine
        // without the border, so skip it in the non-dense case.
        border: dense ? Border.all(color: cs.outlineVariant) : null,
      ),
      child: Text(
        CuisinePillBar.labelFor(l, cuisine).toUpperCase(),
        style: (dense
                ? theme.textTheme.labelSmall
                : theme.textTheme.labelMedium)
            ?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: cs.onSurface,
        ),
      ),
    );
  }
}

/// Numbered round badge used as the "Step N" eyebrow on cooking
/// surfaces. The number renders in PlayfairDisplay so the badge reads
/// editorial — same serif as the brand wordmark + recipe headlines.
///
/// Three states:
///   - [active] (default): subtle primary-tinted fill, primary-colored
///     numeral. The default visual.
///   - [done]: solid primary fill with a check icon — the numeral
///     swaps out so the cook can see at a glance which steps are
///     behind them.
///
/// Size scales the badge proportionally; the numeral font sizes to
/// ~55% of the badge diameter, which keeps the proportion right at
/// 28 px (recipe detail row badge), 40 px (medium), and 56 px (cook
/// mode phone hero badge).
class BrandStepBadge extends StatelessWidget {
  const BrandStepBadge({
    super.key,
    required this.number,
    this.done = false,
    this.size = 28,
  });

  final int number;
  final bool done;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final fontSize = size * 0.55;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 140),
      child: done
          ? Container(
              key: const ValueKey('done'),
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: cs.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: cs.onPrimary,
                size: size * 0.55,
              ),
            )
          : Container(
              key: const ValueKey('num'),
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$number',
                style: TextStyle(
                  // Serif for the editorial cooking voice — the
                  // brand wordmark uses the same family.
                  fontFamily: 'PlayfairDisplay',
                  fontSize: fontSize,
                  height: 1.0,
                  fontWeight: FontWeight.w800,
                  color: cs.primary,
                ),
              ),
            ),
    );
  }
}
