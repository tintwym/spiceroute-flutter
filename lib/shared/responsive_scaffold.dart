import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../state/auth.dart';
import 'account_menu.dart';
import 'breakpoints.dart';
import 'language_flag_pills.dart';
import 'nav_search_field.dart';
import 'top_nav_bar.dart';

/// One destination of the bottom navigation / side rail.
class ShellDestination {
  const ShellDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.path,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String path;
}

/// The 4-tab shell: Explore / AI Creator / AI Companion / Saved
/// (+ "Mine" when signed in).
///
/// On a phone (<600 px) we keep the Material 3 [NavigationBar] at the
/// bottom — best for thumb reach and the established mobile pattern.
///
/// On tablet+ (≥600 px) we use a sticky [TopNavBar]. Reasons specific
/// to a content-heavy recipe app:
///   - Horizontal real-estate is more valuable than vertical (grids of
///     image cards prefer width).
///   - 5 items fit comfortably in a single row down to ~600 px.
///   - Unifies primary nav + settings + account into one bar instead of
///     splitting them across a left rail and a top app bar.
///   - Matches what most modern content apps (NYT Cooking, Linear,
///     Vercel, Stripe) do at this width.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  static List<ShellDestination> destinationsOf(
    AppL10n l, {
    required bool signedIn,
  }) =>
      [
        ShellDestination(
          label: l.navExplore,
          icon: Icons.explore_outlined,
          selectedIcon: Icons.explore,
          path: '/',
        ),
        ShellDestination(
          label: l.navAiCreator,
          icon: Icons.auto_awesome_outlined,
          selectedIcon: Icons.auto_awesome,
          path: '/ai/creator',
        ),
        ShellDestination(
          label: l.navAiCompanion,
          icon: Icons.forum_outlined,
          selectedIcon: Icons.forum,
          path: '/ai/companion',
        ),
        ShellDestination(
          label: l.navSaved,
          icon: Icons.bookmark_border,
          selectedIcon: Icons.bookmark,
          path: '/saved',
        ),
        if (signedIn)
          ShellDestination(
            label: l.navMyRecipes,
            icon: Icons.restaurant_outlined,
            selectedIcon: Icons.restaurant,
            path: '/my-recipes',
          ),
      ];

  int _indexFor(List<ShellDestination> dests) {
    for (var i = 0; i < dests.length; i++) {
      if (location == dests[i].path) return i;
      if (dests[i].path != '/' && location.startsWith(dests[i].path)) return i;
    }
    if (location.startsWith('/recipes/')) return 0;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final user = ref.watch(authControllerProvider);
    final dests = destinationsOf(l, signedIn: user != null);
    final index = _indexFor(dests);
    final dc = deviceClassOf(context);

    // Single dropdown trigger replaces what used to be three separate
    // actions (AccountChip + Settings IconButton + LanguagePickerButton).
    // Everything personal now lives behind the avatar — see
    // [AccountMenuButton].
    //
    // PHONE GETS AN EXTRA LANGUAGE BUTTON. The desktop top nav renders
    // [LanguageFlagPills] inline so language switching is always one
    // tap away. The phone app bar can't fit those pills — language
    // used to live ONLY behind the avatar menu, which is gated on
    // being signed in. That left signed-out mobile visitors with no
    // way to change language at all. [LanguageMenuButton] is the
    // mobile-only fix: a compact globe + flag pill that opens a
    // popup with all six locales, regardless of auth state.
    //
    // NOTE: no trailing SizedBox here on tablet+. The header content
    // frame already matches the body's `pagePadding` + `contentMaxWidth`
    // envelope, and the body's right-most elements (filter dropdowns,
    // recipe grid, MY SAVED RECIPES tab) sit flush with that frame's
    // right edge. Adding a SizedBox after AccountMenuButton would inset
    // SIGN IN / the avatar inward and break the right-edge alignment.
    // Phone shell still gets the 8 px gutter because AppBar trims
    // actions[] tight to the screen edge by default.
    final actions = dc.isPhone
        ? const [
            LanguageMenuButton(),
            SizedBox(width: 6),
            AccountMenuButton(),
            SizedBox(width: 8),
          ]
        : const [AccountMenuButton()];

    if (dc.isPhone) {
      // On a 360-414 px viewport, 5 nav slots get ~72-83 px each. The
      // default Material 3 label style (labelMedium @ 14 sp) means a
      // 10-12 char label like "AI Companion" wraps to two lines and
      // shoves its icon up out of alignment with the rest of the row.
      //
      // Fix has two layers:
      //   1. Copy: every locale's `navAiCreator` / `navAiCompanion`
      //      labels were shortened (no "AI" prefix — the page hero and
      //      route already establish the AI identity). That handles the
      //      common case and prevents truncation entirely.
      //   2. Theme: we still tighten the label style here as a defensive
      //      safety net. A future translator could ship a long string
      //      and we want the row to ellipsize cleanly rather than wrap.
      //      `labelMedium` -> `labelSmall`-ish: 12 sp + tight height +
      //      letterSpacing 0.1 saves enough horizontal room that even
      //      a borderline string fits without wrap.
      //
      // Note: TextStyle has no `overflow` property; the actual ellipsis
      // behaviour comes from `NavigationDestination`'s internal Text
      // widget. With a small enough font size, wrap never triggers in
      // the first place — which is the cleanest outcome.
      final navLabelStyle =
          (Theme.of(context).textTheme.labelMedium ?? const TextStyle())
              .copyWith(
        fontSize: 12,
        height: 1.15,
        letterSpacing: 0.1,
      );
      return Scaffold(
        body: SafeArea(child: child),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.all(navLabelStyle),
          ),
          child: NavigationBar(
            selectedIndex: index.clamp(0, dests.length - 1),
            onDestinationSelected: (i) => context.go(dests[i].path),
            destinations: [
              for (final d in dests)
                NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: d.label,
                ),
            ],
          ),
        ),
        appBar: AppBar(
          // On phone the brand title would crowd out search + actions in
          // a 360-414 px viewport, so the search pill IS the title.
          // Users already know they're in SpiceRoute (they're using the
          // app); the bottom nav tells them which tab they're on.
          titleSpacing: 8,
          title: const NavSearchField(dense: true),
          actions: actions,
        ),
      );
    }

    // Tablet+: sticky top nav, no side rail. The header is a single row
    // (brand + language pills + account dropdown); the page-level tab row
    // lives below each page's hero — see [PageTabs].
    return Scaffold(
      appBar: TopNavBar(actions: actions),
      body: SafeArea(child: child),
    );
  }
}
