import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/models/spice_route.dart';
import 'package:spiceroute/state/recipe_reviews.dart';

void main() {
  group('decodeReviewPhoto', () {
    test('returns null on empty input', () {
      expect(decodeReviewPhoto(''), isNull);
    });

    test('decodes a raw base64 string', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7]);
      final raw = base64Encode(bytes);
      expect(decodeReviewPhoto(raw), bytes);
    });

    test('strips the data:image/...;base64, prefix written by React', () {
      // The React companion stores `photoUrl` as a `data:` URL so it can
      // drop straight into an <img src>. We need to peel the prefix off
      // before handing the bytes to Image.memory — otherwise a Flutter
      // viewer of a React-authored review sees an empty placeholder.
      final bytes = Uint8List.fromList([10, 20, 30, 40]);
      final dataUrl = 'data:image/jpeg;base64,${base64Encode(bytes)}';
      expect(decodeReviewPhoto(dataUrl), bytes);
    });

    test('returns null on malformed base64', () {
      expect(decodeReviewPhoto('not!valid!base64!@@@'), isNull);
    });
  });

  group('RecipeReview.fromDoc', () {
    late FakeFirebaseFirestore fake;

    setUp(() {
      fake = FakeFirebaseFirestore();
    });

    test('maps every Firestore field into the model', () async {
      final ts = Timestamp.fromDate(DateTime.utc(2026, 6, 1, 12, 30));
      final ref = await fake.collection('reviews').add({
        'recipeId': 'recipe-1',
        'userId': 'uid-abc',
        'userName': 'Chef Alex',
        'rating': 4,
        'comment': 'Loved the broth, would simmer longer next time.',
        'photoUrl': 'data:image/jpeg;base64,SGVsbG8=',
        'cuisine': 'korean',
        'createdAt': ts,
      });
      final snap = await fake.collection('reviews').get();
      final doc = snap.docs.firstWhere((d) => d.id == ref.id);

      final review = RecipeReview.fromDoc(doc);

      expect(review.id, ref.id);
      expect(review.recipeId, 'recipe-1');
      expect(review.userId, 'uid-abc');
      expect(review.userName, 'Chef Alex');
      expect(review.rating, 4);
      expect(review.comment, contains('broth'));
      expect(review.photoBase64, startsWith('data:image/jpeg'));
      expect(review.hasPhoto, isTrue);
      expect(review.cuisine, Cuisine.korean);
      expect(review.createdAt, ts.toDate());
      expect(review.isPreset, isFalse);
    });

    test('falls back gracefully when optional fields are missing', () async {
      await fake.collection('reviews').add({
        'recipeId': 'recipe-2',
        'rating': 5,
        // intentionally no userName, no comment, no photoUrl, no cuisine,
        // no createdAt — make sure the model fills in safe defaults
        // instead of throwing.
      });
      final snap = await fake.collection('reviews').get();
      final review = RecipeReview.fromDoc(snap.docs.single);

      expect(review.userName, 'Home Chef');
      expect(review.comment, isEmpty);
      expect(review.photoBase64, isEmpty);
      expect(review.hasPhoto, isFalse);
      expect(review.cuisine, isNull);
      expect(review.createdAt, isNull);
    });

    test('clamps rating into the 1..5 band', () async {
      // The Firestore rules already cap rating at 1..5, but the model is
      // the second line of defence: a doc seeded outside the rules (e.g.
      // by an admin migration) shouldn't blow up the UI star row.
      await fake.collection('reviews').add({'recipeId': 'r', 'rating': 99});
      await fake.collection('reviews').add({'recipeId': 'r', 'rating': -3});
      final snap = await fake.collection('reviews').get();
      final ratings = snap.docs.map(RecipeReview.fromDoc).map((r) => r.rating);
      expect(ratings, everyElement(inInclusiveRange(1, 5)));
    });

    test('treats unknown cuisine strings as null', () async {
      // Defaults to americanWestern internally on lookup-miss, but we
      // explicitly want unknown cuisines to *not* be treated as
      // legitimate filters. Empty string is the canonical "no cuisine"
      // marker (matches what community_photos writes for the "All"
      // selection).
      await fake.collection('reviews').add({
        'recipeId': 'r',
        'rating': 5,
        'cuisine': '',
      });
      final snap = await fake.collection('reviews').get();
      final review = RecipeReview.fromDoc(snap.docs.single);
      expect(review.cuisine, isNull);
    });
  });
}
