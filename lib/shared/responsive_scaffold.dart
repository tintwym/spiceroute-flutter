import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import 'account_menu.dart';
import 'breakpoints.dart';
import 'ios_liquid_glass.dart';
import 'phone_shell_brand_bar.dart';
import 'shell_create_sheet.dart';
import 'shell_nav.dart';
import 'top_nav_bar.dart';

/// Last primary-tab path used to keep the bottom nav highlight when
/// viewing AI Creator (opened from the + sheet, not a tab destination).
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
class AppShell extends ConsumerStatefulWidget {
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

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  @override
  void initState() {
    super.initState();
    _syncHighlight(widget.location);
  }

  @override
  void didUpdateWidget(AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location) {
      _syncHighlight(widget.location);
    }
  }

  void _syncHighlight(String location) {
    if (shouldUpdateShellHighlightPath(location)) {
      ref.read(shellHighlightPathProvider.notifier).state = location;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final dests = AppShell.destinationsOf(l);
    final dc = deviceClassOf(context);

    if (dc.isPhone) {
      final storedHighlight = ref.watch(shellHighlightPathProvider);
      final barHighlight = phoneBarHighlightPath(widget.location, storedHighlight);
      final barIndex = phoneBarIndexForPath(dests, barHighlight);

      return Scaffold(
        appBar: const PhoneShellBrandBar(),
        body: SafeArea(
          top: false,
          child: widget.child,
        ),
        bottomNavigationBar: PhoneShellTabBar(
          destinations: dests,
          selectedBarIndex: barIndex,
          onBarIndexSelected: (barIdx) {
            final destIdx = phoneDestIndexForBarIndex(barIdx);
            if (destIdx >= 0) context.go(dests[destIdx].path);
          },
          onPlusPressed: () => showShellCreateSheet(context),
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
      body: SafeArea(child: widget.child),
    );
  }
}
