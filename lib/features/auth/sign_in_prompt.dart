import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';

/// Shows a soft "sign in to publish / edit" dialog. If the user accepts we
/// redirect to `/sign-in?next=...`. Returns true if the user opted into
/// signing in (router took over), false if they cancelled.
Future<bool> showSignInPrompt(
  BuildContext context, {
  required String nextPath,
}) async {
  final l = AppL10n.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.authProtectedTitle),
      content: Text(l.authProtectedBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l.authSignIn),
        ),
      ],
    ),
  );
  if (result == true && context.mounted) {
    context.go('/sign-in?next=${Uri.encodeComponent(nextPath)}');
    return true;
  }
  return false;
}
