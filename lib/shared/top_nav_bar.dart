import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'nav_search_field.dart';
import 'responsive_scaffold.dart';

/// Sticky top navigation bar used on tablet+ in place of the side rail.
///
/// Layout (left → right):
///   [ Brand "SpiceRoute" ]   [ Explore  AI Creator  AI Companion  Saved  Mine ]   [ Actions ]
///
/// Selection style mirrors the rest of the app's "pill" language: the
/// active destination wears a filled primary-tinted pill, bumps to a
/// 600-weight, and shifts to the on-primary text color.
///
/// Implements [PreferredSizeWidget] so it can be slotted directly into
/// `Scaffold.appBar`, which is what makes it sticky for free — the body
/// scrolls while the AppBar surface stays pinned to the viewport top.
class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  const TopNavBar({
    super.key,
    required this.title,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.actions,
  });

  final String title;
  final List<ShellDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<Widget> actions;

  static const double _height = 64;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      // Solid surface so content scrolling underneath doesn't ghost
      // through. Same color as the rest of the chrome.
      color: cs.surface,
      elevation: 0,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: _height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: cs.outlineVariant, width: 1),
            ),
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            // Adaptive layout based on viewport width:
            //   - <760 px: hide the search pill (it would crowd the
            //     nav items). The phone AppBar carries the search
            //     instead.
            //   - 760-1080 px: logo + nav + compact search.
            //   - >=1080 px: logo + nav + roomy search.
            final w = constraints.maxWidth;
            final showSearch = w >= 760;
            // Cap the search width tighter on medium widths so nav
            // items don't get pushed off-screen.
            final searchMaxWidth = w >= 1080 ? 420.0 : 280.0;
            return Row(
              children: [
                _Brand(
                  title: title,
                  onTap: () => context.go('/'),
                ),
                const SizedBox(width: 20),
                // Nav items get a flex factor so they expand to fill
                // available space *up to* their intrinsic width. The
                // inner horizontal scroller is the safety net for the
                // pathological case (super-long localized labels).
                Flexible(
                  flex: 3,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    child: Row(
                      children: [
                        for (var i = 0; i < destinations.length; i++) ...[
                          if (i > 0) const SizedBox(width: 4),
                          _NavItem(
                            label: destinations[i].label,
                            selected: i == selectedIndex,
                            onTap: () => onDestinationSelected(i),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (showSearch) ...[
                  const SizedBox(width: 16),
                  Flexible(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: NavSearchField(maxWidth: searchMaxWidth),
                    ),
                  ),
                ],
                const SizedBox(width: 12),
                ...actions,
              ],
            );
          }),
        ),
      ),
    );
  }
}

/// Brand block on the leading edge.
///
/// Renders the [BrandLogo] mark only — the wordmark has been retired in
/// favour of the icon. Tapping the mark routes home, matching the
/// universal web convention.
class _Brand extends StatelessWidget {
  const _Brand({required this.title, required this.onTap});

  /// Kept around for `Semantics` / tooltip purposes so screen readers
  /// and hover-tips still announce the app name.
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: title,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Semantics(
            label: title,
            button: true,
            child: const BrandLogo(size: 34),
          ),
        ),
      ),
    );
  }
}

/// Square brand mark (the steaming-bowl icon). Lives here so any other
/// surface that wants to show the logo (recipe detail header, splash,
/// empty states, etc.) has one canonical widget to drop in.
///
/// Rendered with `filterQuality: FilterQuality.medium` because we're
/// downsampling from a 1024 px source to a ~32 px slot — the default
/// `low` filter produces visible aliasing on the bowl's curves.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 32});
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Slightly-rounded square reads "app icon" without going full
      // circle — the bowl-on-red mark loses its identity if cropped to
      // a circle and the corners get clipped.
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

/// One destination in the top nav. Text-only — keeps the bar light and
/// readable, which is the whole reason for moving off the icon-heavy
/// rail.
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Selected: filled secondary-container pill with primary-tinted text
    //           and a bumped weight. Reads as "you're here".
    // Idle    : transparent, onSurfaceVariant text.
    // Hover/  : InkWell handles the subtle highlight automatically.
    final bg = selected ? cs.secondaryContainer : Colors.transparent;
    final fg = selected ? cs.onSecondaryContainer : cs.onSurfaceVariant;
    final weight = selected ? FontWeight.w700 : FontWeight.w500;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: fg,
              fontWeight: weight,
              letterSpacing: 0.1,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
