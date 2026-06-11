// Firebase web configuration.
//
// These values are NOT secrets — Firebase web API keys are designed to be
// public, with security enforced by Firebase Auth + Firestore Security Rules.
//
// Source: AI Studio-generated Firebase project. To swap to a project you
// fully own, replace the values below with the ones from your Firebase
// console -> Project settings -> Your apps -> Web app config.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Returns true once real Firebase config is in place. Auth-gated UI uses
/// this to decide whether to try Firebase or fall back to the local dev
/// stub (in debug builds only).
bool get firebaseConfigured =>
    DefaultFirebaseOptions.web.apiKey != _placeholderApiKey;

const _placeholderApiKey = 'REPLACE_ME_API_KEY';

/// Firestore database ID. The AI-Studio-provisioned project this app
/// shares with the original React build uses a **named** database rather
/// than the conventional `(default)` one — passing this to
/// `FirebaseFirestore.instanceFor(databaseId: …)` is the only way to land
/// reads/writes in the same DB as the React app, otherwise our docs go
/// somewhere only we can see. Leave as an empty string to fall back to
/// the default DB when wiring up your own Firebase project.
const String firestoreDatabaseId =
    'ai-studio-ff9edb73-3c2a-4a69-ba12-75ce74365135';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    // Native (iOS/Android) configs live in the platform-specific files
    // produced by `flutterfire configure`. For web-only deployment the web
    // config is reused; native shipping requires running flutterfire on a
    // properly registered Android/iOS app.
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA_45AB1Xo6qty-9jftDPcJaSMpRiBuAHI',
    authDomain: 'spice-route-498610.firebaseapp.com',
    projectId: 'spice-route-498610',
    storageBucket: 'spice-route-498610.firebasestorage.app',
    messagingSenderId: '125349390279',
    appId: '1:125349390279:web:c40e305f346392b94f9be2',
  );
}
