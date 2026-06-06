import 'dart:async';

import 'package:characters/characters.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// Public surface the UI calls. Backed by FirebaseAuth when configured,
/// otherwise stays in "not signed in" with a clear error from each method.
class AuthController extends StateNotifier<AppUser?> {
  AuthController(this._auth) : super(_toAppUser(_auth?.currentUser)) {
    _sub = _auth?.authStateChanges().listen((u) {
      state = _toAppUser(u);
    });
  }

  final fb.FirebaseAuth? _auth;
  StreamSubscription<fb.User?>? _sub;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  bool get _ready => _auth != null;

  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (!_ready) return const AuthResult.err('firebase-not-configured');
    try {
      await _auth!.signInWithEmailAndPassword(
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
    if (!_ready) return const AuthResult.err('firebase-not-configured');
    try {
      final cred = await _auth!.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final name = displayName.trim();
      if (name.isNotEmpty) {
        await cred.user?.updateDisplayName(name);
        // Refresh local state with the new displayName.
        await cred.user?.reload();
        state = _toAppUser(_auth.currentUser);
      }
      return const AuthResult.ok();
    } on fb.FirebaseAuthException catch (e) {
      return AuthResult.err(e.code);
    } catch (e) {
      return AuthResult.err(e.toString());
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    if (!_ready) return const AuthResult.err('firebase-not-configured');
    try {
      if (kIsWeb) {
        // Web uses Firebase's built-in Google popup — no extra package.
        final provider = fb.GoogleAuthProvider();
        await _auth!.signInWithPopup(provider);
      } else {
        final google = GoogleSignIn();
        final account = await google.signIn();
        if (account == null) return const AuthResult.err('cancelled');
        final auth = await account.authentication;
        final cred = fb.GoogleAuthProvider.credential(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        );
        await _auth!.signInWithCredential(cred);
      }
      return const AuthResult.ok();
    } on fb.FirebaseAuthException catch (e) {
      return AuthResult.err(e.code);
    } catch (e) {
      return AuthResult.err(e.toString());
    }
  }

  Future<AuthResult> sendPasswordReset(String email) async {
    if (!_ready) return const AuthResult.err('firebase-not-configured');
    try {
      await _auth!.sendPasswordResetEmail(email: email.trim());
      return const AuthResult.ok();
    } on fb.FirebaseAuthException catch (e) {
      return AuthResult.err(e.code);
    }
  }

  Future<void> signOut() async {
    if (!_ready) return;
    await _auth!.signOut();
  }

  /// Returns a fresh Firebase ID token, refreshing if needed. The API client
  /// uses this for every request; null when signed out or unconfigured.
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    final u = _auth?.currentUser;
    if (u == null) return null;
    return u.getIdToken(forceRefresh);
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
