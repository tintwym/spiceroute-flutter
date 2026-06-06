import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../state/auth.dart';
import 'account_chip.dart';
import 'breakpoints.dart';
import 'language_picker.dart';

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

/// The 4-tab shell: Explore / AI Creator / AI Companion / Saved.
///
/// On a phone (<600 px) it renders a Material 3 NavigationBar at the bottom.
/// On tablets+ (≥600 px) it renders a NavigationRail on the leading edge.
/// On desktops/wide screens we additionally pin a top app bar with the
/// language picker.
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

    final actions = const [
      AccountChip(),
      SizedBox(width: 4),
      LanguagePickerButton(),
      SizedBox(width: 8),
    ];

    if (dc.isPhone) {
      return Scaffold(
        body: SafeArea(child: child),
        bottomNavigationBar: NavigationBar(
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
        appBar: AppBar(
          title: Text(l.appTitle, style: Theme.of(context).textTheme.titleLarge),
          actions: actions,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.appTitle, style: Theme.of(context).textTheme.titleLarge),
        actions: actions,
      ),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: index.clamp(0, dests.length - 1),
              onDestinationSelected: (i) => context.go(dests[i].path),
              extended: dc.isAtLeastDesktop,
              minExtendedWidth: 200,
              destinations: [
                for (final d in dests)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
