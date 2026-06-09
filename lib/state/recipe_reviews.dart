import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/spice_route.dart';
import '../shared/image_processing.dart';
import 'auth.dart';
import 'user_profile.dart';

/// Translate a thrown exception into a STABLE error code string that
/// the UI can switch on for localized copy. Critically, never returns
/// `e.toString()` — that surfaces raw FirebaseException internals
/// (project ids, internal call paths) directly into the user-facing
/// banner.
String _classifyFirestoreError(Object e) {
  if (e is FirebaseException) {
    switch (e.code) {
      case 'permission-denied':
        return 'permission-denied';
      case 'unavailable':
      case 'deadline-exceeded':
        return 'network-error';
      case 'resource-exhausted':
        return 'rate-limited';
      case 'unauthenticated':
        return 'not-signed-in';
    }
  }
  return 'generic';
}

/// A single review on a recipe (UGC). Mirrors the schema the React
/// companion app writes into the `reviews` Firestore collection so both
/// clients can read each other's posts without translation:
///
///   recipeId  : recipe doc id this review belongs to
///   userId    : Firebase auth uid of the author
///   userName  : the chef's display name (denormalised so we don't have to
///               read users/{uid} for every review row)
///   rating    : 1..5, integer
///   comment   : free-text kitchen notes
///   photoUrl  : *base64 data URL* of the cooked-dish photo (React stores
///               it inline rather than uploading to Cloud Storage; we keep
///               the same name + shape so writes from either client line up)
///   cuisine   : enum name, used by analytics + future filtering
///   createdAt : server timestamp
@immutable
class RecipeReview {
  const RecipeReview({
    required this.id,
    required this.recipeId,
    this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    this.photoBase64 = '',
    this.cuisine,
    this.createdAt,
    this.isPreset = false,
  });

  final String id;
  final String recipeId;
  final String? userId;
  final String userName;
  final int rating;
  final String comment;

  /// May be a raw base64 string OR a `data:image/...` URL (React writes the
  /// latter, the Flutter client normalises to raw bytes on read).
  final String photoBase64;

  final Cuisine? cuisine;
  final DateTime? createdAt;

  /// True for the seeded "Chef Marc"-style demo reviews — UI uses this to
  /// hide the delete affordance even for the signed-in author.
  final bool isPreset;

  bool get hasPhoto => photoBase64.isNotEmpty;

  factory RecipeReview.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> d) {
    final data = d.data();
    final ts = data['createdAt'];
    final cuisineRaw = (data['cuisine'] as String?) ?? '';
    return RecipeReview(
      id: d.id,
      recipeId: (data['recipeId'] as String?) ?? '',
      userId: data['userId'] as String?,
      // Coerce missing OR empty/whitespace to the fallback. The new
      // Firestore rule rejects empty userNames on create, but older
      // docs (from before the rule landed) or the React companion
      // may have written blanks — render those as "Home Chef"
      // rather than an empty author byline with a trailing separator.
      userName: () {
        final raw = (data['userName'] as String?)?.trim();
        return (raw == null || raw.isEmpty) ? 'Home Chef' : raw;
      }(),
      rating: ((data['rating'] as num?) ?? 5).toInt().clamp(1, 5),
      comment: (data['comment'] as String?) ?? '',
      photoBase64: (data['photoUrl'] as String?) ?? '',
      cuisine: cuisineRaw.isEmpty
          ? null
          : Cuisine.values.firstWhere(
              (c) => c.name == cuisineRaw,
              orElse: () => Cuisine.americanWestern,
            ),
      createdAt: ts is Timestamp ? ts.toDate() : null,
    );
  }
}

/// Reactive feed of reviews for a single recipe (newest first). Returns an
/// empty list when Firebase isn't configured so the rest of the UI still
/// renders cleanly in dev mode.
final recipeReviewsProvider =
    StreamProvider.family<List<RecipeReview>, String>((ref, recipeId) async* {
  final fs = ref.watch(firestoreProvider);
  if (fs == null) {
    yield const <RecipeReview>[];
    return;
  }
  // We avoid the composite (recipeId, createdAt desc) index by ordering
  // client-side after the where clause — these review counts are small
  // (< 100) so the sort is negligible and skipping the index keeps the
  // ops checklist for the rules deploy short.
  final stream = fs
      .collection('reviews')
      .where('recipeId', isEqualTo: recipeId)
      .limit(100)
      .snapshots();
  await for (final snap in stream) {
    final rows = snap.docs.map(RecipeReview.fromDoc).toList()
      ..sort((a, b) {
        final ad = a.createdAt;
        final bd = b.createdAt;
        if (ad == null && bd == null) return 0;
        if (ad == null) return 1;
        if (bd == null) return -1;
        return bd.compareTo(ad);
      });
    yield rows;
  }
});

/// State for the inline "post a review" form on the recipe detail screen.
@immutable
class ReviewSubmitState {
  const ReviewSubmitState({
    this.submitting = false,
    this.lastSuccess = false,
    this.error,
  });
  final bool submitting;
  final bool lastSuccess;
  final String? error;

  ReviewSubmitState copy({
    bool? submitting,
    bool? lastSuccess,
    String? error,
    bool clearError = false,
  }) =>
      ReviewSubmitState(
        submitting: submitting ?? this.submitting,
        lastSuccess: lastSuccess ?? this.lastSuccess,
        error: clearError ? null : (error ?? this.error),
      );
}

class ReviewSubmitController extends StateNotifier<ReviewSubmitState> {
  ReviewSubmitController(this._ref) : super(const ReviewSubmitState());
  final Ref _ref;

  Future<void> submit({
    required String recipeId,
    required String userName,
    required int rating,
    required String comment,
    Uint8List? photoBytes,
    Cuisine? cuisine,
  }) async {
    final fs = _ref.read(firestoreProvider);
    final user = _ref.read(authControllerProvider);
    if (fs == null || user == null) {
      state = state.copy(error: 'not-signed-in');
      return;
    }
    state = state.copy(submitting: true, lastSuccess: false, clearError: true);
    try {
      String photoField = '';
      if (photoBytes != null && photoBytes.isNotEmpty) {
        final compressed = await _maybeCompress(photoBytes);
        // React stores `photoUrl` as a `data:` URL so it can drop straight
        // into an <img src>. We do the same here for full interop — the
        // client decoder strips the prefix at render time.
        photoField = 'data:image/jpeg;base64,${base64Encode(compressed)}';
        // Firestore docs cap at ~1 MB; bail loudly before we waste the round
        // trip if compression couldn't bring us under the limit.
        if (photoField.length > 800 * 1024) {
          state = state.copy(submitting: false, error: 'photo-too-large');
          return;
        }
      }
      await fs.collection('reviews').add({
        'recipeId': recipeId,
        'userId': user.uid,
        'userName': userName.trim().isEmpty ? 'Home Chef' : userName.trim(),
        'rating': rating.clamp(1, 5),
        'comment': comment.trim(),
        'photoUrl': photoField,
        if (cuisine != null) 'cuisine': cuisine.name,
        'createdAt': FieldValue.serverTimestamp(),
      });
      state = state.copy(submitting: false, lastSuccess: true);
    } catch (e) {
      state = state.copy(
        submitting: false,
        error: _classifyFirestoreError(e),
      );
    }
  }

  Future<void> delete(String reviewId) async {
    final fs = _ref.read(firestoreProvider);
    if (fs == null) return;
    try {
      await fs.collection('reviews').doc(reviewId).delete();
    } catch (e) {
      state = state.copy(error: _classifyFirestoreError(e));
    }
  }

  void dismissSuccess() => state = state.copy(lastSuccess: false);

  /// Hands the photo to the shared [compressForUpload] helper, which
  /// does the same compression budget the community board uses AND
  /// strips EXIF metadata across web + mobile. Critical for privacy —
  /// before this, web-uploaded review photos still carried the
  /// camera's GPS coordinates in their EXIF tags.
  Future<Uint8List> _maybeCompress(Uint8List src) => compressForUpload(src);
}

final reviewSubmitProvider =
    StateNotifierProvider<ReviewSubmitController, ReviewSubmitState>(
  (ref) => ReviewSubmitController(ref),
);

/// Decodes the inline base64 photo from a [RecipeReview]. Handles both the
/// raw-base64 shape we write from Flutter and the `data:image/...;base64,…`
/// shape the React client writes, so reviews from either codebase render
/// without any per-source branching at the call site.
Uint8List? decodeReviewPhoto(String src) {
  if (src.isEmpty) return null;
  final raw = src.startsWith('data:')
      ? src.substring(src.indexOf(',') + 1)
      : src;
  try {
    return base64Decode(raw);
  } catch (_) {
    return null;
  }
}
