import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import 'account_menu.dart';
import 'breakpoints.dart';
import 'ios_liquid_glass.dart';
import 'nav_search_field.dart';
import 'shell_create_sheet.dart';
import 'shell_nav.dart';
import 'top_nav_bar.dart';

/// Last primary-tab path used to keep the bottom nav highlight when
/// viewing auxiliary routes (AI Creator, My Recipes) that are not tab
/// destinations.
final shellHighlightPathProvider = StateProvider<String>((ref) => '/');

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

/// Phone + tablet tab destinations: Explore / Chat / Saved / Me.
///
/// AI Creator is reached from the center [+] sheet on phone (and the
/// create button in the tablet header). My Recipes lives under Me and
/// the create sheet.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  static List<ShellDestination> destinationsOf(AppL10n l) => [
    ShellDestination(
      label: l.navExplore,
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore,
      path: '/',
    ),
    ShellDestination(
      label: l.navChat,
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
    ShellDestination(
      label: l.navMe,
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      path: '/me',
    ),
  ];

  static int indexForPath(List<ShellDestination> dests, String location) {
    for (var i = 0; i < dests.length; i++) {
      if (location == dests[i].path) return i;
      if (dests[i].path != '/' && location.startsWith(dests[i].path)) return i;
    }
    if (location.startsWith('/recipes/')) return 0;
    if (location == '/settings' ||
        location == '/my-recipes') {
      return dests.indexWhere((d) => d.path == '/me').clamp(0, dests.length - 1);
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final dests = destinationsOf(l);
    if (!isAuxiliaryShellPath(location) && location != '/settings') {
      ref.read(shellHighlightPathProvider.notifier).state = location;
    }
    final highlightPath = isAuxiliaryShellPath(location) || location == '/settings'
        ? ref.watch(shellHighlightPathProvider)
        : location;
    final dc = deviceClassOf(context);

    if (dc.isPhone) {
      final barIndex = phoneBarIndexForPath(dests, highlightPath);

      return Scaffold(
        body: SafeArea(child: child),
        bottomNavigationBar: PhoneShellTabBar(
          destinations: dests,
          selectedBarIndex: barIndex,
          onBarIndexSelected: (barIdx) {
            final destIdx = phoneDestIndexForBarIndex(barIdx);
            if (destIdx >= 0) context.go(dests[destIdx].path);
          },
          onPlusPressed: () => showShellCreateSheet(context),
        ),
        appBar: AppBar(
          titleSpacing: 8,
          title: const NavSearchField(dense: true),
        ),
      );
    }

    final tabletActions = <Widget>[
      const ShellCreateButton(),
      const SizedBox(width: 4),
      const AccountMenuButton(),
    ];

    return Scaffold(
      appBar: TopNavBar(actions: tabletActions),
      body: SafeArea(child: child),
    );
  }
}
