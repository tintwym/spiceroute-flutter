import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import 'breakpoints.dart';
import 'language_flag_pills.dart';

/// Sticky top navigation used on tablet+ in place of the side rail.
///
/// Single row matching the editorial reference design:
///   brand mark + wordmark (left), language flag pills +
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
                  // We render flag-only pills at every width — the
                  // labelled variant pushed the whole language row ~480 px
                  // wide and broke the right-edge alignment with the body
                  // ("Showing N recipes", "MY SAVED RECIPES", filter
                  // dropdowns). Below 540 px we hide the row entirely;
                  // the in-page Settings + account menu still expose the
                  // full language list with names.
                  final showFlags = w >= 540;
                  return SizedBox(
                    height: _row1,
                    width: double.infinity,
                    child: Row(
                      children: [
                        // Brand block: logo + serif wordmark.
                        Flexible(
                          child: _Brand(onTap: () => context.go('/')),
                        ),
                        const SizedBox(width: 16),
                        const Spacer(),
                        // Flag-only pills tucked tight against the
                        // trailing SIGN IN / avatar so the language UI's
                        // right edge lines up with the body's right
                        // edge (Showing N recipes, MY SAVED RECIPES,
                        // filter dropdowns). We used to render endonyms
                        // here too (English / 中文 / မြန်မာ / …) but
                        // that made the row ~480 px wide and pushed
                        // the language UI well left of the body's
                        // right-side content. Endonyms still live in
                        // the account-menu language submenu and on the
                        // Settings page; the tooltips on each pill
                        // cover hover-discovery on web.
                        if (showFlags) ...[
                          const LanguageFlagPills(showLabels: false),
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

/// Brand block: logo mark + serif wordmark.
///
/// We previously rendered a "{11 CUISINES · 6 LANGUAGES}" tagline under
/// the wordmark via [AppL10n.brandTagline], but it just restated info
/// already visible on screen — the hero subtitle counts the same
/// cuisines, the cuisine pill bar enumerates them as chips, and the
/// flag-pills row in this same header lists the supported locales. The
/// header earned more room than the brag earned visual interest, so
/// the tagline is gone. The ARB string is intentionally kept so future
/// marketing surfaces (e.g. a landing page outside the app shell) can
/// reuse it without re-translating into the 6 locales.
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
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    // Bumped from 22 -> 26 now that the tagline is gone
                    // — the wordmark has the vertical room to be the
                    // sole anchor of the header, and a slightly larger
                    // serif reads more confidently as a brand mark.
                    fontSize: 26,
                    height: 1.0,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
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

