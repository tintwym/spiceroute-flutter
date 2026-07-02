// Firebase web configuration.
//
// These values are NOT secrets — Firebase web API keys are designed to be
// public, with security enforced by Firebase Auth + Firestore Security
// Rules. The actually-secret credential is the service-account JSON used
// by the backend (set on Render as FIREBASE_CREDENTIALS_JSON), NOT the
// values below.
//
// Source: hand-registered web app inside the `spice-route-498610`
// Firebase project. To swap to a different project (e.g. when promoting
// from staging to prod), copy the values from your Firebase console ->
// Project settings -> Your apps -> Web app config -> "Config" radio.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Returns true once real Firebase config is in place for the current
/// platform. Auth-gated UI uses this to decide whether to try Firebase or
/// fall back to the local dev stub (in debug builds only).
///
/// Web uses [web]. Native iOS/Android need platform app IDs from
/// `flutterfire configure` — reusing the web `appId` crashes the native
/// Firebase SDK at launch.
bool get firebaseConfigured {
  if (DefaultFirebaseOptions.web.apiKey == _placeholderApiKey) return false;
  if (kIsWeb) return true;
  return DefaultFirebaseOptions.hasNativeConfig;
}

const _placeholderApiKey = 'REPLACE_ME_API_KEY';
const _placeholderAppId = 'REPLACE_ME_APP_ID';
const _placeholderSenderId = 'REPLACE_ME_SENDER_ID';
const _placeholderProjectId = 'REPLACE_ME_PROJECT_ID';

/// Firestore database ID. The current Firebase project uses Firestore's
/// conventional `(default)` database, so this is the empty string and we
/// just use `FirebaseFirestore.instance` everywhere.
///
/// We keep this constant (instead of deleting it) because Firebase's web
/// SDK supports multiple Firestore databases per project — if you ever
/// need to point reads/writes at a non-default DB, set this to that DB's
/// ID and the data layer will switch over via
/// `FirebaseFirestore.instanceFor(databaseId: firestoreDatabaseId)`.
const String firestoreDatabaseId = '';

class DefaultFirebaseOptions {
  /// Set true after `flutterfire configure` adds iOS/Android options.
  static const bool hasNativeConfig = false;

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.android:
        return android;
      default:
        return web;
    }
  }

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: _placeholderApiKey,
    appId: _placeholderAppId,
    messagingSenderId: _placeholderSenderId,
    projectId: _placeholderProjectId,
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: _placeholderApiKey,
    appId: _placeholderAppId,
    messagingSenderId: _placeholderSenderId,
    projectId: _placeholderProjectId,
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDnDWIyXY8KPhZj1mhHdR-8OGf6EqgxuDo',
    authDomain: 'spice-route-498610.firebaseapp.com',
    projectId: 'spice-route-498610',
    storageBucket: 'spice-route-498610.firebasestorage.app',
    messagingSenderId: '18975255561',
    appId: '1:18975255561:web:58f998870436c7f8b59cd8',
    // Google Analytics tag, present because Firebase auto-enabled it on
    // the web app registration. Optional for Auth/Firestore — the web
    // SDK only initializes Analytics when this is set AND you call
    // `getAnalytics(app)`. Safe to remove if you disable Analytics.
    measurementId: 'G-K5H17WSKND',
  );
}
