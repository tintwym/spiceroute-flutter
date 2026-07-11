import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import 'breakpoints.dart';
import 'responsive_scaffold.dart';

/// Underlined-tab row that sits *below the hero* on each main page
/// (Explore / Chat / Saved / Me). Replaces the row that used to live
/// in the sticky [TopNavBar] — the reference design puts the tabs
/// inside the body, right under the editorial headline.
///
/// Primary destinations (Explore, Chat) cluster on the left; Saved and
/// Me dock to the far right. My Recipes is reached from Me / the create
/// sheet and highlights the Me tab when open.
///
/// Hidden on phone-width layouts: the bottom nav rail from [AppShell]
/// is the canonical destination switcher on phones.
class PageTabs extends StatelessWidget {
  const PageTabs({super.key});

  static const _rightPaths = {'/saved', '/me'};

  /// Same selection logic used by [AppShell] — keep the active tab in
  /// sync no matter which page mounted this widget.
  int _indexFor(List<ShellDestination> dests, String location) {
    if (location == '/my-recipes' || location == '/settings') {
      final me = dests.indexWhere((d) => d.path == '/me');
      return me >= 0 ? me : 0;
    }
    for (var i = 0; i < dests.length; i++) {
      if (location == dests[i].path) return i;
      if (dests[i].path != '/' && location.startsWith(dests[i].path)) return i;
    }
    if (location.startsWith('/recipes/')) return 0;
    if (location == '/ai/creator') return 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    // Phones get the bottom nav rail from [AppShell] — rendering the
    // tab row on top of that is redundant and the 4 uppercase labels
    // can't fit on a sub-400 px viewport without truncating
    // ("AI CREAT…"). Collapse to nothing and let the page hero butt
    // up against the body content.
    if (deviceClassOf(context).isPhone) {
      return const SizedBox.shrink();
    }

    final l = AppL10n.of(context);
    final cs = Theme.of(context).colorScheme;
    final dests = AppShell.destinationsOf(l);
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _indexFor(dests, location);

    final left = <Widget>[];
    final right = <Widget>[];
    for (var i = 0; i < dests.length; i++) {
      final d = dests[i];
      final tab = _NavItem(
        label: d.label,
        icon: d.icon,
        selected: i == selectedIndex,
        onTap: () => context.go(d.path),
      );
      (_rightPaths.contains(d.path) ? right : left).add(tab);
    }

    // Thin top + bottom rules so the tab row reads as a divider band
    // between the hero and the body content — same treatment used in the
    // reference screenshot.
    //
    // Layout: a fixed-width frame holds a left "primary" group and a
    // right "library" group. The left group lives inside a horizontal
    // scroller wrapped in `Expanded`, so it always claims the leftover
    // space after the right group takes its natural width. That means:
    //   - Right group (Saved) always docks to the right edge.
    //   - Left group never elbows the right group — when there isn't
    //     enough room, it scrolls horizontally inside its own slot.
    //   - No `Spacer` inside a `SingleChildScrollView` (which would
    //     assert because Spacer needs a bounded maxWidth and a scroll
    //     view provides unbounded).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(color: cs.outlineVariant, height: 1),
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  child: Row(children: left),
                ),
              ),
              if (right.isNotEmpty) const SizedBox(width: 16),
              ...right,
            ],
          ),
        ),
        Divider(color: cs.outlineVariant, height: 1),
      ],
    );
  }
}

/// One underlined text tab. Selected tabs gain a primary-colored 2 px
/// underline + bumped weight; idle tabs are muted with no underline.
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final fg = selected ? cs.onSurface : cs.onSurfaceVariant;
    final weight = selected ? FontWeight.w700 : FontWeight.w500;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        // Kill the post-tap focus rectangle that Flutter Web draws on
        // InkWells — the underline indicator below is the only "active"
        // affordance we want. Hover still gets a soft tint for
        // discoverability.
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        splashColor: cs.primary.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 15, color: fg),
                  const SizedBox(width: 7),
                  // Uppercase with tracked letter-spacing — matches the
                  // editorial reference design's "EXPLORE / AI CREATOR /
                  // AI COMPANION / MY SAVED RECIPES" tab voice.
                  Text(
                    label.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: fg,
                      fontWeight: weight,
                      fontSize: 12.5,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Underline indicator — animated width keeps tab switches
              // feeling responsive without a separate TabController.
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                height: 2,
                width: selected ? 32 : 0,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
