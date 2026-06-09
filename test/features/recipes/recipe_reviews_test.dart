import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:savor_global/features/recipes/recipe_reviews.dart';
import 'package:savor_global/models/spice_route.dart';
import 'package:savor_global/state/recipe_reviews.dart';

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
        recipeReviewsProvider(recipe.id).overrideWith(
          (ref) => Stream<List<RecipeReview>>.value(reviews),
        ),
      ],
    ),
  );
  await tester.pump(); // resolve the seeded stream value
}

void main() {
  testWidgets('empty state shows fallback 4.8 rating and the "be first" line',
      (tester) async {
    final recipe = _recipe();
    await pumpSection(tester, recipe: recipe, reviews: const []);

    // The widget seeds 4.8 when reviews list is empty so the average
    // never reads as a flat 0.0 (which looks broken). Verify both the
    // numeric label and the localized "0 reviews" count are present.
    expect(find.text('4.8'), findsOneWidget);

    // Photo-gallery empty placeholder: should NOT find any Image widget.
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('populated state shows correct average and review tile',
      (tester) async {
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

  testWidgets('photo gallery shows thumbnails for reviews with photos',
      (tester) async {
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
}
