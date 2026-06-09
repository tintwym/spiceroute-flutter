import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/spice_route.dart';
import 'breakpoints.dart';

/// The shared editorial page header: the "CULINARY STUDIO" eyebrow badge,
/// a big serif headline, and a one-line subtitle.
///
/// Defaults to the Explore copy (`heroTitle` + `heroSubtitle`), but
/// every other main page passes its own [title] / [subtitle] so the
/// Explore-specific "Embark on a culinary journey…" pitch only shows up
/// on Explore. AI Creator / AI Companion / Saved each pass their own
/// page-scoped copy so the hero feels native to the page you're on.
class PageHero extends StatelessWidget {
  const PageHero({
    super.key,
    this.title,
    this.subtitle,
    this.below,
  });

  /// Override for the big serif headline. When null, falls back to
  /// [AppL10n.heroTitle] (i.e. "SpiceRoute") — the Explore default.
  final String? title;

  /// Override for the subtitle paragraph. When null, falls back to
  /// [AppL10n.heroSubtitle] (the Explore pitch).
  final String? subtitle;

  /// Optional widget rendered under the subtitle (Explore passes its
  /// search field + result counter here).
  final Widget? below;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final dc = deviceClassOf(context);

    final titleStyle = (dc.isAtLeastDesktop
            ? theme.textTheme.displayLarge
            : theme.textTheme.displayMedium)
        ?.copyWith(color: cs.onSurface);

    final headline = title ?? l.heroTitle;
    final body = subtitle ?? l.heroSubtitle(Cuisine.values.length);

    // SizedBox(width: double.infinity) pins the Column to its parent's
    // max cross-axis extent. Without it the Column would shrink to its
    // widest fixed child (~560 px from the body Text's ConstrainedBox)
    // and the outer Center would horizontally centre that narrow
    // column on the page — which made studio pages (no `below` widget)
    // look centred while Explore (with a width-greedy LayoutBuilder
    // inside `below`) looked left-aligned. Now every page renders the
    // hero flush against the framed content's left edge, lining up
    // with the tab row beneath it.
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroBadge(text: l.heroBadge),
          const SizedBox(height: 16),
          Text(headline, style: titleStyle),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              body,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
          if (below != null) ...[
            const SizedBox(height: 28),
            below!,
          ],
        ],
      ),
    );
  }
}

/// "CULINARY STUDIO" pill — soft surface fill, uppercase tracked label
/// with a tiny sparkle to read as a category eyebrow.
class HeroBadge extends StatelessWidget {
  const HeroBadge({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, size: 13, color: cs.secondary),
          const SizedBox(width: 7),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
              letterSpacing: 1.6,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
