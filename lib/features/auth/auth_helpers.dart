import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

/// Map a Firebase error code to a localized message. Anything we don't
/// recognize falls back to the generic copy.
///
/// Social sign-in (Google) failure codes deserve specific copy: the
/// most common cause of "Google sign-in just shows an error" in the
/// wild is the operator forgetting to enable the Google provider in
/// the Firebase Console, NOT a client bug — the localized strings
/// for `operation-not-allowed` and `unauthorized-domain` point the
/// user (or the developer reading the screenshot) at the exact fix.
String localizeAuthError(AppL10n l, String? code) {
  switch (code) {
    case null:
      return l.authErrorGeneric;
    case 'firebase-not-configured':
      return l.authNotConfigured;
    case 'cancelled':
    case 'popup-closed-by-user':
    case 'cancelled-popup-request':
    case 'web-context-canceled':
      return l.commonCancel;
    case 'invalid-credential':
    case 'invalid-email':
    case 'wrong-password':
    case 'user-not-found':
    case 'INVALID_LOGIN_CREDENTIALS':
      return l.authErrorInvalid;
    case 'email-already-in-use':
      return l.authErrorEmailInUse;
    case 'weak-password':
      return l.authErrorWeakPassword;
    case 'network-request-failed':
      return l.authErrorNetwork;
    case 'operation-not-allowed':
    case 'configuration-not-found':
      return l.authErrorProviderDisabled;
    case 'unauthorized-domain':
      return l.authErrorUnauthorizedDomain;
    case 'popup-blocked':
      return l.authErrorPopupBlocked;
    case 'account-exists-with-different-credential':
      return l.authErrorAccountExists;
    default:
      return l.authErrorGeneric;
  }
}

/// Tiny shared validators so sign-in and register agree.
String? validateEmail(String? v) {
  final s = v?.trim() ?? '';
  if (s.isEmpty) return '';
  if (!s.contains('@') || !s.contains('.')) return '';
  return null;
}

String? validatePassword(String? v) {
  if (v == null || v.length < 6) return '';
  return null;
}

void showSnack(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}
