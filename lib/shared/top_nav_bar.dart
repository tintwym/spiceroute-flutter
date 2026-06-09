import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/spice_route.dart';
import '../state/locale.dart';
import 'breakpoints.dart';
import 'language_flag_pills.dart';

/// Sticky top navigation used on tablet+ in place of the side rail.
///
/// Single row matching the editorial reference design:
///   brand mark + wordmark + tagline (left), language flag pills +
///   account avatar (right).
///
/// The page-level tab row (Explore / AI Creator / AI Companion / Saved)
/// no longer lives here — it has moved into the body, just below each
/// page's hero. See [PageTabs] in `page_tabs.dart`.
///
/// Implements [PreferredSizeWidget] so it slots into `Scaffold.appBar`,
/// which is what makes it sticky for free.
class TopNavBar extends ConsumerWidget implements PreferredSizeWidget {
  const TopNavBar({super.key, required this.actions});

  /// Trailing actions (the account avatar dropdown).
  final List<Widget> actions;

  static const double _row1 = 60;

  /// Width of the 1-px bottom hairline on the header container. The
  /// preferred-size advertised to the [Scaffold] / [SliverPersistentHeader]
  /// has to include this — otherwise the inner row (`_row1 = 60`) gets
  /// squeezed into 59 px and Flutter logs a "RenderFlex overflowed by
  /// 1.00 pixels on the bottom" exception.
  static const double _borderH = 1;

  @override
  Size get preferredSize => const Size.fromHeight(_row1 + _borderH);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Match the body's content frame so the header lines up with the grid.
    //
    // IMPORTANT: ordering matters. The body wraps content in
    //   SliverPadding(pagePad) -> Center -> ConstrainedBox(maxW)
    // i.e. *outer* pagePadding first, *then* the centered max-width cap.
    // We do the same here. A previous version applied the padding INSIDE
    // the ConstrainedBox, which doubled the indent on wide viewports
    // (vw > maxW) and pushed the wordmark ~64 px further right than the
    // hero badge below it.
    final pagePad = pagePadding(context);
    final maxW = contentMaxWidth(context);

    return Material(
      color: cs.surface,
      elevation: 0,
      child: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: cs.outlineVariant, width: 1),
            ),
          ),
          child: Padding(
            padding: pagePad,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: LayoutBuilder(builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  // Reference design always shows endonyms on desktop, so
                  // we set a generous threshold here. The pills are also
                  // small enough (~70 px each labelled) that 6 of them
                  // fit alongside brand + SIGN IN well below 900 px.
                  //   >= 760 -> flag + endonym
                  //   >= 540 -> flag-only
                  //   < 540  -> hidden (settings page handles language)
                  final showFlagLabels = w >= 760;
                  final showFlags = w >= 540;
                  return SizedBox(
                    height: _row1,
                    width: double.infinity,
                    child: Row(
                      children: [
                        // Brand block: logo + serif wordmark + tagline.
                        Flexible(
                          child: _Brand(onTap: () => context.go('/')),
                        ),
                        const SizedBox(width: 16),
                        const Spacer(),
                        // Pills sized to their natural width — no scroll
                        // view, no Flexible, so what you see is always
                        // the full row starting at the active language
                        // on the left.
                        if (showFlags) ...[
                          LanguageFlagPills(showLabels: showFlagLabels),
                          const SizedBox(width: 12),
                        ],
                        ...actions,
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Brand block: logo mark + serif wordmark + dynamic tagline counting
/// supported cuisines and locales (e.g. "11 CUISINES · 6 LANGUAGES").
class _Brand extends StatelessWidget {
  const _Brand({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l = AppL10n.of(context);
    // Wordmark uses `heroTitle` (the displayed brand name). Right now
    // `heroTitle == appTitle == "SpiceRoute"`, but keeping the indirection
    // means we can swap the marketing headline without touching the
    // technical product id used elsewhere.
    final title = l.heroTitle;
    final tagline =
        l.brandTagline(Cuisine.values.length, supportedLocales.length);

    return Tooltip(
      message: title,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BrandLogo(size: 36),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        // Bumped from 19 -> 22 with a heavier weight so
                        // the serif wordmark anchors the header the way
                        // the reference design's "Savor Global Recipes"
                        // does. Tight line-height keeps it stacked with
                        // the tagline at _row1 = 60 px.
                        fontSize: 22,
                        height: 1.0,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      tagline.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Square brand mark (the steaming-bowl icon). Canonical so any surface
/// (header, footer, recipe detail, empty states) drops in the same logo.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 32});
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.22),
      child: Image.asset(
        'assets/icon/icon.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}

