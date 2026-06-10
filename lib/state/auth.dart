import 'dart:async';
import 'dart:convert';

import 'package:characters/characters.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../shared/firebase_options.dart';

/// Lightweight user view that the rest of the app reads from.
@immutable
class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoUrl,
  });

  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  String get initial {
    final base = (displayName ?? email ?? '?').trim();
    return base.isEmpty ? '?' : base.characters.first.toUpperCase();
  }
}

/// Result type for auth operations — UI maps `error` to a localized snackbar.
@immutable
class AuthResult {
  const AuthResult.ok() : error = null;
  const AuthResult.err(this.error);
  final String? error;
  bool get ok => error == null;
}

// Storage key for the dev-auth stub session. The `savor_` prefix is
// LEGACY (from when the app was named SavorGlobal); DO NOT rename it
// without a migration shim or every existing dev user gets logged out
// on next deploy. Same story for the `savor_saved_recipe_ids`,
// `savor_locale`, `savor_theme_mode`, and `savor_settings` keys
// elsewhere in `state/`.
const _kDevUserKey = 'savor_dev_user';
const _kStorageOpts = AndroidOptions(encryptedSharedPreferences: true);

/// Public surface the UI calls.
///
/// Three modes:
///   1. Firebase configured (production-grade): real FirebaseAuth.
///   2. Firebase NOT configured + debug build: a local "dev auth" stub backed
///      by secure storage. Useful so you can exercise the auth-gated flows
///      without wiring up a Firebase project. The stub mints `dev:<uid>...`
///      tokens which the backend's dev-mode Firebase verifier accepts.
///   3. Firebase NOT configured + release build: every method returns
///      `firebase-not-configured` so the app fails loudly instead of
///      silently letting strangers in.
class AuthController extends StateNotifier<AppUser?> {
  AuthController(this._auth) : super(_toAppUser(_auth?.currentUser)) {
    final auth = _auth;
    if (auth != null) {
      _sub = auth.authStateChanges().listen((u) {
        state = _toAppUser(u);
        _initialized = true;
      });
      // Complete any in-flight redirect-based sign-in (Safari/Firefox
      // popup fallback in [signInWithGoogle]). On the way back from
      // accounts.google.com, the redirect result lands here and flips
      // the authStateChanges stream — without this call the redirect
      // appears to have done nothing.
      if (kIsWeb) {
        _consumeRedirectResult();
      }
    } else {
      // No Firebase wired up — there's nothing to restore asynchronously.
      _initialized = true;
      if (devMode) {
        // Restore the stored dev user (if any) so refreshes don't sign you out.
        _restoreDevUser();
      }
    }
  }

  Future<void> _consumeRedirectResult() async {
    final auth = _auth;
    if (auth == null) return;
    try {
      await auth.getRedirectResult();
    } catch (e) {
      debugPrint('getRedirectResult failed: $e');
    }
  }

  final fb.FirebaseAuth? _auth;
  StreamSubscription<fb.User?>? _sub;
  static const _storage = FlutterSecureStorage(aOptions: _kStorageOpts);

  bool _initialized = false;

  /// True once we've heard at least one auth-state event from Firebase (or
  /// determined that Firebase isn't configured). Until this flips, callers
  /// such as the router redirect should *not* treat `state == null` as
  /// "definitely signed out" — Firebase's persistence layer is still
  /// rehydrating from IndexedDB / disk.
  bool get isInitialized => _initialized;

  /// True when we're running the in-app dev auth stub.
  ///
  /// Activates in debug builds when Firebase isn't configured. Lets the
  /// auth-gated flows be exercised end-to-end without setting up a Firebase
  /// project; release builds intentionally lock everything out instead.
  bool get devMode => _auth == null && kDebugMode;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _restoreDevUser() async {
    try {
      final raw = await _storage.read(key: _kDevUserKey);
      if (raw == null) return;
      final m = jsonDecode(raw) as Map<String, dynamic>;
      state = AppUser(
        uid: m['uid'] as String,
        email: m['email'] as String?,
        displayName: m['name'] as String?,
        photoUrl: null,
      );
    } catch (_) {
      // Corrupt or unreadable — ignore.
    }
  }

  Future<AuthResult> _devSignIn({
    required String email,
    required String name,
  }) async {
    final cleanEmail = email.trim();
    final cleanName = name.trim();
    final uid = cleanEmail
            .toLowerCase()
            .replaceAll(RegExp(r'[^a-z0-9]'), '_')
            .replaceAll(RegExp(r'_+'), '_')
            .replaceAll(RegExp(r'^_|_$'), '')
        // Firebase UIDs are typically 28 chars; we mimic a sane bound.
        ;
    final finalUid = uid.isEmpty ? 'dev_user' : uid;
    final finalEmail = cleanEmail.isEmpty ? null : cleanEmail;
    final finalName = cleanName.isEmpty ? cleanEmail : cleanName;
    await _storage.write(
      key: _kDevUserKey,
      value: jsonEncode({
        'uid': finalUid,
        'email': finalEmail,
        'name': finalName,
      }),
    );
    state = AppUser(
      uid: finalUid,
      email: finalEmail,
      displayName: finalName,
      photoUrl: null,
    );
    return const AuthResult.ok();
  }

  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final auth = _auth;
    if (auth == null) {
      if (devMode) {
        // Password isn't checked in dev — any non-empty value works.
        return _devSignIn(email: email, name: email.split('@').first);
      }
      return const AuthResult.err('firebase-not-configured');
    }
    try {
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return const AuthResult.ok();
    } on fb.FirebaseAuthException catch (e) {
      return AuthResult.err(e.code);
    } catch (e) {
      return AuthResult.err(e.toString());
    }
  }

  Future<AuthResult> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final auth = _auth;
    if (auth == null) {
      if (devMode) return _devSignIn(email: email, name: displayName);
      return const AuthResult.err('firebase-not-configured');
    }
    try {
      final cred = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final name = displayName.trim();
      if (name.isNotEmpty) {
        await cred.user?.updateDisplayName(name);
        await cred.user?.reload();
        state = _toAppUser(auth.currentUser);
      }
      return const AuthResult.ok();
    } on fb.FirebaseAuthException catch (e) {
      return AuthResult.err(e.code);
    } catch (e) {
      return AuthResult.err(e.toString());
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    final auth = _auth;
    if (auth == null) {
      // Google sign-in requires Firebase. We don't fake it in dev mode.
      return const AuthResult.err('firebase-not-configured');
    }
    try {
      if (kIsWeb) {
        final provider = fb.GoogleAuthProvider();
        try {
          await auth.signInWithPopup(provider);
        } on fb.FirebaseAuthException catch (e) {
          // Browsers (especially Safari + Firefox) block third-party
          // popups by default. Fall back to a full-page redirect so
          // sign-in still completes — `getRedirectResult()` is called
          // from [AuthController.<init>] to finish the round trip on
          // the way back. Without this fallback the user sees a vague
          // "popup blocked" message and has no path forward.
          if (e.code == 'popup-blocked' ||
              e.code == 'popup-closed-by-user' ||
              e.code == 'cancelled-popup-request' ||
              e.code == 'operation-not-supported-in-this-environment') {
            debugPrint(
              'Google popup sign-in failed (${e.code}); '
              'falling back to redirect.',
            );
            await auth.signInWithRedirect(provider);
            // Redirect navigates away; this code path is only reached
            // when the redirect itself fails (rare).
            return const AuthResult.ok();
          }
          rethrow;
        }
      } else {
        final google = GoogleSignIn();
        final account = await google.signIn();
        if (account == null) return const AuthResult.err('cancelled');
        final googleAuth = await account.authentication;
        final cred = fb.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await auth.signInWithCredential(cred);
      }
      return const AuthResult.ok();
    } on fb.FirebaseAuthException catch (e) {
      // Print the raw code in dev so failures are diagnosable from
      // the browser console. `e.code` is the actionable handle the
      // UI snackbar uses to pick the localized copy.
      debugPrint('Google sign-in FirebaseAuthException: ${e.code} ${e.message}');
      return AuthResult.err(e.code);
    } catch (e) {
      debugPrint('Google sign-in failed: $e');
      return AuthResult.err(e.toString());
    }
  }

  Future<AuthResult> sendPasswordReset(String email) async {
    final auth = _auth;
    if (auth == null) {
      // Nothing to email in dev mode.
      return const AuthResult.err('firebase-not-configured');
    }
    try {
      await auth.sendPasswordResetEmail(email: email.trim());
      return const AuthResult.ok();
    } on fb.FirebaseAuthException catch (e) {
      return AuthResult.err(e.code);
    }
  }

  Future<void> signOut() async {
    final auth = _auth;
    if (auth != null) {
      await auth.signOut();
      return;
    }
    if (devMode) {
      await _storage.delete(key: _kDevUserKey);
      state = null;
    }
  }

  /// Returns a token the backend will accept. Real Firebase ID token in
  /// production; a `dev:<uid>:<email>:<name>` stub in dev mode.
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    final auth = _auth;
    if (auth != null) {
      final u = auth.currentUser;
      if (u == null) return null;
      return u.getIdToken(forceRefresh);
    }
    if (devMode) {
      final user = state;
      if (user == null) return null;
      return 'dev:${user.uid}:${user.email ?? ''}:${user.displayName ?? ''}';
    }
    return null;
  }

  static AppUser? _toAppUser(fb.User? u) {
    if (u == null) return null;
    return AppUser(
      uid: u.uid,
      email: u.email,
      displayName: u.displayName,
      photoUrl: u.photoURL,
    );
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AppUser?>((ref) {
  fb.FirebaseAuth? auth;
  if (firebaseConfigured) {
    try {
      auth = fb.FirebaseAuth.instance;
    } catch (_) {
      auth = null;
    }
  }
  return AuthController(auth);
});
