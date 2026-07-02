import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../state/auth.dart';

/// Asks the user to confirm before ending their session. Returns `true`
/// only when they tap Sign out.
Future<bool> showSignOutConfirm(BuildContext context) async {
  final l = AppL10n.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.authSignOutConfirmTitle),
      content: Text(l.authSignOutConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l.authSignOut),
        ),
      ],
    ),
  );
  return result == true;
}

/// Confirm → sign out → optional redirect home (avatar menu uses this so
/// protected routes don't trap signed-out users behind the auth redirect).
Future<void> confirmAndSignOut(
  BuildContext context,
  WidgetRef ref, {
  bool navigateHome = false,
}) async {
  final ok = await showSignOutConfirm(context);
  if (!ok || !context.mounted) return;

  await ref.read(authControllerProvider.notifier).signOut();
  if (!context.mounted) return;

  if (navigateHome) {
    GoRouter.of(context).go('/');
  }
}
