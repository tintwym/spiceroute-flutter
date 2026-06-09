import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/firebase_options.dart';
import 'auth.dart';

/// Per-user data we mirror to `users/{uid}` in Firestore so saves and
/// AI-authored recipes follow the user across devices.
///
/// This is intentionally a **mirror**, not the source of truth — the local
/// `flutter_secure_storage` bookmark set keeps the UI instant offline, and
/// Firestore is the eventually-consistent shadow that lets the next device
/// pick up where you left off. On sign-in we union-merge cloud ⇄ local so
/// neither side wins; on toggle we write-through to both.
@immutable
class UserProfile {
  const UserProfile({
    this.savedRecipeIds = const <String>{},
    this.customRecipes = const <Map<String, dynamic>>[],
    this.displayName,
  });

  final Set<String> savedRecipeIds;

  /// Denormalised AI-authored recipes — stored as raw maps so a new client
  /// can render them without round-tripping to the backend. Each map carries
  /// the same shape as a [SpiceRouteDetail] JSON payload.
  final List<Map<String, dynamic>> customRecipes;

  final String? displayName;

  factory UserProfile.fromDoc(Map<String, dynamic> data) {
    final ids = (data['savedRecipeIds'] as List?)
            ?.whereType<String>()
            .toSet() ??
        const <String>{};
    final customs = (data['customRecipes'] as List?)
            ?.whereType<Map>()
            .map((m) => m.cast<String, dynamic>())
            .toList(growable: false) ??
        const <Map<String, dynamic>>[];
    return UserProfile(
      savedRecipeIds: ids,
      customRecipes: customs,
      displayName: data['displayName'] as String?,
    );
  }

  Map<String, dynamic> toDoc() => {
        'savedRecipeIds': savedRecipeIds.toList(),
        'customRecipes': customRecipes,
        if (displayName != null) 'displayName': displayName,
      };
}

/// Singleton handle to Firestore. Returns `null` when Firebase isn't
/// configured (dev-mode auth stub) so the rest of the app can guard cleanly
/// instead of crashing.
///
/// Uses `instanceFor(databaseId: …)` rather than the bare `instance` getter
/// because the AI-Studio-provisioned project ships with a **named** Firestore
/// database, not the conventional `(default)`. Hitting `(default)` would
/// silently land docs in a database the React companion app can't read.
final firestoreProvider = Provider<FirebaseFirestore?>((_) {
  if (!firebaseConfigured) return null;
  try {
    if (firestoreDatabaseId.isEmpty) return FirebaseFirestore.instance;
    return FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: firestoreDatabaseId,
    );
  } catch (_) {
    return null;
  }
});

/// Reactive view of `users/{uid}` for the signed-in user.
///
/// Emits `null` whenever:
///   * the user is signed out,
///   * Firebase isn't configured (dev mode), or
///   * the doc doesn't exist yet (we'll create it on first write).
final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final user = ref.watch(authControllerProvider);
  final fs = ref.watch(firestoreProvider);
  if (user == null || fs == null) {
    return Stream<UserProfile?>.value(null);
  }
  return fs
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((snap) => snap.exists ? UserProfile.fromDoc(snap.data() ?? {}) : null);
});
