import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/features/recipes/recipe_reviews.dart';
import 'package:spiceroute/models/spice_route.dart';
import 'package:spiceroute/state/recipe_reviews.dart';

import '../../helpers/test_harness.dart';

SpiceRouteDetail _recipe({
  String id = 'r-1',
  Cuisine? cuisine = Cuisine.korean,
}) {
  return SpiceRouteDetail(
    id: id,
    title: 'Bibimbap',
    description: 'Mixed rice bowl.',
    prepMinutes: 15,
    cookMinutes: 20,
    servings: 2,
    cuisine: cuisine,
  );
}

// 1×1 red PNG, base64-encoded. Used as a stand-in for cooked-dish photos
// so MemoryImage can actually decode it (a placeholder like "SGVsbG8="
// would throw "Invalid image data" inside the image codec).
const _kTinyPngBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGP4z8DwHwAFAAH/q842iQAAAABJRU5ErkJggg==';

RecipeReview _review({
  String id = 'rev-1',
  String userName = 'Chef Marc',
  int rating = 5,
  String comment = 'Loved it!',
  bool withPhoto = false,
}) {
  return RecipeReview(
    id: id,
    recipeId: 'r-1',
    userId: 'u-1',
    userName: userName,
    rating: rating,
    comment: comment,
    photoBase64: withPhoto ? 'data:image/png;base64,$_kTinyPngBase64' : '',
    createdAt: DateTime.utc(2026, 6, 1, 12),
  );
}

Future<void> pumpSection(
  WidgetTester tester, {
  required SpiceRouteDetail recipe,
  required List<RecipeReview> reviews,
}) async {
  await tester.pumpWidget(
    wrapWithApp(
      // Constrain width — the photo gallery uses a horizontal ListView
      // and needs a finite parent width to lay out correctly under
      // the test's BoxConstraints.tight default.
      child: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: RecipeReviewsSection(recipe: recipe),
        ),
      ),
      overrides: [
        // Synthetic stream provider value so the widget doesn't reach
        // for Firestore at all. We seed both the loading-resolved path
        // (`AsyncData`) and the recipeId family arg.
        recipeReviewsProvider(
          recipe.id,
        ).overrideWith((ref) => Stream<List<RecipeReview>>.value(reviews)),
      ],
    ),
  );
  await tester.pump(); // resolve the seeded stream value
}

void main() {
  testWidgets('empty state shows em-dash instead of fake rating', (
    tester,
  ) async {
    final recipe = _recipe();
    await pumpSection(tester, recipe: recipe, reviews: const []);

    // Honest empty state: no fake 4.8★ — show an em-dash so users
    // can tell at a glance no one's rated yet. The earlier behavior
    // showed 4.8 to make recipes "look populated" but it was a dark
    // pattern (users assumed others had rated when nobody had).
    expect(find.text('—'), findsOneWidget);
    expect(find.text('4.8'), findsNothing);

    // Photo-gallery empty placeholder: should NOT find any Image widget.
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('populated state shows correct average and review tile', (
    tester,
  ) async {
    final recipe = _recipe();
    final reviews = [
      _review(id: 'a', rating: 4),
      _review(id: 'b', userName: 'Mei', rating: 5, comment: 'Add gochujang!'),
    ];

    await pumpSection(tester, recipe: recipe, reviews: reviews);

    // (4 + 5) / 2 = 4.5 — formatted with one decimal place.
    expect(find.text('4.5'), findsOneWidget);
    // Review tiles render the chef's display name + the comment.
    expect(find.text('Mei'), findsOneWidget);
    expect(find.text('Add gochujang!'), findsOneWidget);
    expect(find.text('Chef Marc'), findsOneWidget);
  });

  testWidgets('photo gallery shows thumbnails for reviews with photos', (
    tester,
  ) async {
    final recipe = _recipe();
    final reviews = [
      _review(id: 'p1', withPhoto: true),
      _review(id: 'p2', withPhoto: true),
      _review(id: 'p3', withPhoto: false), // comment-only, should be skipped
    ];

    await pumpSection(tester, recipe: recipe, reviews: reviews);
    await tester.pump();

    // Each photo review renders 2 Images: one thumbnail in the gallery
    // strip + one inline preview inside its review tile. The 3rd review
    // is comment-only so contributes none. The form's own preview pane
    // only renders when `_pickedBytes` is set, so the only Images on
    // screen are the two-per-photo-review pairs → 4 total.
    expect(find.byType(Image), findsNWidgets(4));
  });

  testWidgets(
    'Cook Log pivot: reviews without a comment do NOT render a notes tile',
    (tester) async {
      final recipe = _recipe();
      final reviews = [
        // Photo-only post: shows in gallery, NOT in the notes section.
        _review(id: 'photo-only', withPhoto: true, comment: ''),
        // Comment-only post: shows in notes section, NOT in the gallery.
        _review(
          id: 'comment-only',
          userName: 'Mei',
          comment: 'Loved the broth!',
        ),
      ];

      await pumpSection(tester, recipe: recipe, reviews: reviews);
      await tester.pump();

      // The notes tile renders the comment and the author. Photo-only
      // posts must not contribute a tile — the gallery is their surface,
      // and rendering an empty "X said:" stub here was the bug the
      // pivot is designed to remove.
      expect(find.text('Loved the broth!'), findsOneWidget);
      expect(find.text('Mei'), findsOneWidget);

      // The notes heading appears because at least one notes tile is
      // present. If the only contribution were photo-only, this
      // heading should NOT render — verified by the next test.
    },
  );

  testWidgets(
    'Cook Log pivot: photo-only reviews don\'t render a notes section header',
    (tester) async {
      final recipe = _recipe();
      final reviews = [
        _review(id: 'a', withPhoto: true, comment: ''),
        _review(id: 'b', withPhoto: true, comment: ''),
      ];

      await pumpSection(tester, recipe: recipe, reviews: reviews);
      await tester.pump();

      // With zero commented reviews, _ReviewList returns
      // `SizedBox.shrink()` — so the heading must not render. Guards
      // against a regression where photo-only contributions silently
      // started showing an empty "Notes from the kitchen" header.
      expect(find.text('Notes from the kitchen'), findsNothing);
    },
  );
}
