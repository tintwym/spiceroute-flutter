import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../state/auth.dart';
import '../state/locale.dart';

/// Unified top-right action: a single avatar button that opens a Material 3
/// cascading menu containing every "personal" action that used to live in
/// the app bar — Account (Sign in / My Recipes / Sign out), Settings,
/// and a Language submenu.
///
/// Why one menu instead of three buttons:
///   - Top-bar real estate is precious once the search pill, brand mark
///     and 5 nav items are in there.
///   - Account, Settings and Language are all "about you", so they belong
///     under the avatar (matches Gmail / GitHub / Vercel patterns).
///
/// The trigger always renders the avatar:
///   - signed in  -> photo or initial on the theme's primary container
///   - signed out -> neutral person silhouette on a soft fill
///
/// Pressing the avatar opens a single popup, and language sits inside a
/// nested [SubmenuButton] so we don't dump 6+ locale rows into the
/// account-level menu.
class AccountMenuButton extends ConsumerWidget {
  const AccountMenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final user = ref.watch(authControllerProvider);
    final currentLocale = ref.watch(localeProvider);

    return MenuAnchor(
      // Pin the menu to the bottom-right of the avatar so it never gets
      // clipped against the viewport edge.
      alignmentOffset: const Offset(0, 8),
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(cs.surface),
        elevation: const WidgetStatePropertyAll(8),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: cs.outlineVariant),
          ),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 6),
        ),
      ),
      builder: (ctx, controller, _) {
        return _AvatarTrigger(
          user: user,
          tooltip: l.authAccount,
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
      menuChildren: [
        if (user != null) ...[
          _AccountHeader(user: user),
          const Divider(height: 8),
          MenuItemButton(
            leadingIcon: const Icon(Icons.restaurant_outlined),
            onPressed: () => context.go('/my-recipes'),
            child: Text(l.myRecipesTitle),
          ),
        ] else
          MenuItemButton(
            leadingIcon: const Icon(Icons.login),
            onPressed: () => context.go('/sign-in'),
            child: Text(l.authSignIn),
          ),
        const Divider(height: 8),
        MenuItemButton(
          leadingIcon: const Icon(Icons.settings_outlined),
          onPressed: () => context.go('/settings'),
          child: Text(l.settingsTitle),
        ),
        SubmenuButton(
          leadingIcon: const Icon(Icons.language),
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(cs.surface),
            elevation: const WidgetStatePropertyAll(8),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: cs.outlineVariant),
              ),
            ),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 6),
            ),
          ),
          menuChildren: [
            _localeItem(ref, currentLocale, const Locale('en'), l.languageEnglish),
            _localeItem(ref, currentLocale, const Locale('zh'), l.languageChinese),
            _localeItem(ref, currentLocale, const Locale('th'), l.languageThai),
            _localeItem(ref, currentLocale, const Locale('ja'), l.languageJapanese),
            _localeItem(ref, currentLocale, const Locale('ko'), l.languageKorean),
            _localeItem(ref, currentLocale, const Locale('vi'), l.languageVietnamese),
          ],
          child: Text(l.settingsLanguage),
        ),
        if (user != null) ...[
          const Divider(height: 8),
          MenuItemButton(
            leadingIcon: const Icon(Icons.logout),
            onPressed: () async {
              final router = GoRouter.of(context);
              await ref.read(authControllerProvider.notifier).signOut();
              // Bounce home so a user on a protected route (/my-recipes)
              // doesn't get punted to /sign-in by the router redirect.
              router.go('/');
            },
            child: Text(l.authSignOut),
          ),
        ],
      ],
    );
  }

  Widget _localeItem(
    WidgetRef ref,
    Locale current,
    Locale value,
    String label,
  ) {
    final selected = current.languageCode == value.languageCode;
    return MenuItemButton(
      leadingIcon: Icon(
        selected ? Icons.check : Icons.translate_outlined,
        // Hide the placeholder icon for unselected rows so only the
        // active language has a leading mark; keeps the column tidy.
        color: selected ? null : Colors.transparent,
      ),
      onPressed: () => ref.read(localeProvider.notifier).set(value),
      child: Text(label),
    );
  }
}

/// The avatar pill that opens the menu. Rendered as a plain [InkWell] so
/// it can absorb the tap before [MenuAnchor]'s default focus dance kicks
/// in (which on web sometimes swallows the first click).
class _AvatarTrigger extends StatelessWidget {
  const _AvatarTrigger({
    required this.user,
    required this.tooltip,
    required this.onTap,
  });

  final AppUser? user;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final signedIn = user != null;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: CircleAvatar(
            radius: 16,
            backgroundColor:
                signedIn ? cs.primaryContainer : cs.surfaceContainerHighest,
            foregroundColor:
                signedIn ? cs.onPrimaryContainer : cs.onSurfaceVariant,
            backgroundImage: user?.photoUrl != null
                ? NetworkImage(user!.photoUrl!)
                : null,
            child: user?.photoUrl != null
                ? null
                : signedIn
                    ? Text(
                        user!.initial,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      )
                    : const Icon(Icons.person_outline, size: 18),
          ),
        ),
      ),
    );
  }
}

/// Non-interactive header inside the menu that shows who is signed in.
/// Lives at the top so the user can confirm the account at a glance
/// without us needing to repeat the email next to every action.
class _AccountHeader extends StatelessWidget {
  const _AccountHeader({required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final primary = user.displayName?.trim().isNotEmpty == true
        ? user.displayName!.trim()
        : (user.email ?? '');
    final secondary = (user.displayName?.trim().isNotEmpty == true)
        ? (user.email ?? '')
        : '';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            primary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
          if (secondary.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              secondary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
