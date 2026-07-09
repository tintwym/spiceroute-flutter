import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/sign_out_confirm.dart';
import '../l10n/generated/app_localizations.dart';
import '../state/auth.dart';

/// Unified top-right action: a single avatar button that opens a Material 3
/// cascading menu containing every "personal" action that used to live in
/// the app bar — My Recipes, Settings, and Sign out.
///
/// Why one menu instead of three buttons:
///   - Top-bar real estate is precious once the search pill, brand mark
///     and 5 nav items are in there.
///   - Settings, Language and Sign out are all "about you / your
///     account", so they belong under the avatar (matches Gmail /
///     GitHub / Vercel patterns).
///
/// "My Recipes" lives in the account menu (above Settings), not in the
/// bottom tab bar — keeps four primary destinations on phone and avoids
/// duplicating the same screen in two places.
///
/// The trigger always renders the avatar:
///   - signed in  -> photo or initial on the theme's primary container
///   - signed out -> neutral person silhouette on a soft fill
///
/// Pressing the avatar opens a single popup, and language sits inside a
/// nested [SubmenuButton] so we don't dump 6+ locale rows into the
/// account-level menu.
class AccountMenuButton extends ConsumerStatefulWidget {
  const AccountMenuButton({super.key});

  @override
  ConsumerState<AccountMenuButton> createState() => _AccountMenuButtonState();
}

class _AccountMenuButtonState extends ConsumerState<AccountMenuButton> {
  // One MenuController for the lifetime of the widget — used by the
  // locale submenu items to dismiss the outer menu after a pick.
  // Hoisting into state (instead of creating per-build) keeps the
  // open/close state stable across `ref.watch` rebuilds.
  final _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final user = ref.watch(authControllerProvider);

    // Signed-out users get a dedicated "SIGN IN" pill button instead of
    // an empty avatar — clearer call-to-action that matches the editorial
    // reference design. (The Settings / Language menu is still reachable
    // from the in-page Settings tab.)
    if (user == null) {
      return _SignInButton(
        label: l.authSignIn,
        onTap: () => context.push('/sign-in'),
      );
    }

    return MenuAnchor(
      controller: _menuController,
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
        // We already returned early if `user == null`, so the menu only
        // ever shows the signed-in flow.
        _AccountHeader(user: user),
        const Divider(height: 8),
        MenuItemButton(
          leadingIcon: const Icon(Icons.restaurant_outlined),
          onPressed: () {
            _menuController.close();
            context.go('/my-recipes');
          },
          child: Text(l.navMyRecipes),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.settings_outlined),
          onPressed: () => context.go('/me'),
          child: Text(l.settingsTitle),
        ),
        // Language was previously a submenu here. It was removed once
        // the [LanguageFlagPills] row was promoted to labelled mode
        // in the top nav (desktop) and the [LanguageMenuButton] pill
        // anchors the picker in the AppBar (phone). Keeping it in
        // the account menu duplicated the surface — every
        // language-related affordance now lives in those two pill
        // entry points instead of a dropdown submenu users had to
        // discover.
        const Divider(height: 8),
        MenuItemButton(
          leadingIcon: const Icon(Icons.logout),
          onPressed: () async {
            _menuController.close();
            await confirmAndSignOut(context, ref, navigateHome: true);
          },
          child: Text(l.authSignOut),
        ),
      ],
    );
  }
}

/// The avatar pill that opens the menu. Rendered as a plain [InkWell] so
/// it can absorb the tap before [MenuAnchor]'s default focus dance kicks
/// in (which on web sometimes swallows the first click).
///
/// Stateful because we need to track network-image load failures and
/// flip the avatar back to the initial/icon fallback when the photo
/// 404s. Google/Facebook avatar URLs DO 404 in the wild (deleted
/// accounts, transient CDN hiccups, signed-URL expiry), and
/// `CircleAvatar.child` is only consulted when `backgroundImage` is
/// null — a failed image leaves the avatar as an empty colored disc
/// with no glyph until we manually drop the image and rebuild.
class _AvatarTrigger extends StatefulWidget {
  const _AvatarTrigger({
    required this.user,
    required this.tooltip,
    required this.onTap,
  });

  final AppUser? user;
  final String tooltip;
  final VoidCallback onTap;

  @override
  State<_AvatarTrigger> createState() => _AvatarTriggerState();
}

class _AvatarTriggerState extends State<_AvatarTrigger> {
  // Per-URL failure flag. Sticky for the session so we don't re-attempt
  // a URL that already 404'd on every rebuild (avoids the network
  // spinner-then-disappear flicker).
  String? _failedUrl;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final signedIn = widget.user != null;
    final photoUrl = widget.user?.photoUrl;
    final showImage = photoUrl != null && photoUrl != _failedUrl;
    return Tooltip(
      message: widget.tooltip,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(3),
            // Soft ring around the avatar so it reads as a clickable target
            // and visually balances the flag-pill row next to it.
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: cs.outlineVariant, width: 1),
              ),
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: signedIn
                    ? cs.primaryContainer
                    : cs.surfaceContainerHighest,
                foregroundColor: signedIn
                    ? cs.onPrimaryContainer
                    : cs.onSurfaceVariant,
                backgroundImage: showImage ? NetworkImage(photoUrl) : null,
                // On load failure, drop the image and force a rebuild so
                // the initial/icon child takes over. setState during a
                // build phase is illegal — schedule on the next frame.
                onBackgroundImageError: showImage
                    ? (_, _) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;
                          setState(() => _failedUrl = photoUrl);
                        });
                      }
                    : null,
                child: showImage
                    ? null
                    : signedIn
                    ? Text(
                        widget.user!.initial,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      )
                    : const Icon(Icons.person_outline, size: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Dark olive pill that doubles as the "signed-out" affordance in the
/// top nav — opens the sign-in modal in one tap. Trailing arrow signals
/// "this goes somewhere"; uppercase tracked label matches the rest of
/// the editorial typography.
class _SignInButton extends StatelessWidget {
  const _SignInButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Material(
      color: cs.primary,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_forward, size: 16, color: cs.onPrimary),
              const SizedBox(width: 8),
              Text(
                label.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: cs.onPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ],
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
