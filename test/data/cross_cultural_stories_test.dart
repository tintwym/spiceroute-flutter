import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/data/cross_cultural_stories.dart';
import 'package:spiceroute/models/cuisine_catalog.dart';
import 'package:spiceroute/models/cuisine_region.dart';
import 'package:spiceroute/models/spice_route.dart';

/// Course cards shown in the heritage panel (matches explore UI).
const _heritageCourses = [
  Course.breakfast,
  Course.lunch,
  Course.appetizer,
  Course.sideDish,
  Course.dessert,
  Course.snack,
  Course.drinks,
];

void main() {
  test('every selectable cuisine has a full heritage story panel', () {
    final cuisines = <Cuisine>{
      for (final region in populatedRegions())
        ...selectableCuisinesInRegion(region),
    };

    expect(cuisines, isNotEmpty);

    for (final cuisine in cuisines) {
      expect(
        hasStoriesFor(cuisine),
        isTrue,
        reason: '${cuisine.name} should have heritage stories',
      );
      final stories = crossCulturalStories[cuisineForDisplay(cuisine)];
      expect(stories, isNotNull, reason: '${cuisine.name} missing story map');
      expect(
        stories!.keys.toSet(),
        _heritageCourses.toSet(),
        reason: '${cuisine.name} should cover all 7 course cards',
      );
      for (final course in _heritageCourses) {
        final copy = stories[course]!;
        expect(copy['en'], isNotNull);
        expect(copy['en']!.trim(), isNotEmpty);
      }
    }
  });
}
