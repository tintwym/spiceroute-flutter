import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../state/auth.dart';

/// Compact app-bar chip:
/// * signed in  -> avatar + popup menu (My Recipes / Sign out)
/// * signed out -> "Sign in" text button
class AccountChip extends ConsumerWidget {
  const AccountChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final user = ref.watch(authControllerProvider);

    if (user == null) {
      return TextButton(
        onPressed: () => context.go('/sign-in'),
        child: Text(l.authSignIn),
      );
    }

    return PopupMenuButton<String>(
      tooltip: l.authAccount,
      offset: const Offset(0, 40),
      onSelected: (v) async {
        switch (v) {
          case 'mine':
            context.go('/my-recipes');
            break;
          case 'sign-out':
            await ref.read(authControllerProvider.notifier).signOut();
            break;
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(value: 'mine', child: Text(l.myRecipesTitle)),
        PopupMenuItem(value: 'sign-out', child: Text(l.authSignOut)),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundImage:
                  user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
              child: user.photoUrl == null ? Text(user.initial) : null,
            ),
          ],
        ),
      ),
    );
  }
}
