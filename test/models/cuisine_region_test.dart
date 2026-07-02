import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/models/cuisine_region.dart';
import 'package:spiceroute/models/spice_route.dart';

void main() {
  group('CuisineRegionLookup.region', () {
    test('every cuisine maps to exactly one region', () {
      // Switch-exhaustiveness guarantees coverage at compile time;
      // this test catches accidental future regressions if someone
      // adds a `default` branch that swallows a missing case.
      for (final c in Cuisine.values) {
        expect(
          () => c.region,
          returnsNormally,
          reason: 'Cuisine.$c must have a region',
        );
      }
    });

    test('known mappings hold', () {
      expect(Cuisine.korean.region, CuisineRegion.eastAsia);
      expect(Cuisine.japanese.region, CuisineRegion.eastAsia);
      expect(Cuisine.chinese.region, CuisineRegion.eastAsia);
      expect(Cuisine.burmese.region, CuisineRegion.mainlandSoutheastAsia);
      expect(Cuisine.shan.region, CuisineRegion.mainlandSoutheastAsia);
      expect(Cuisine.yangon.region, CuisineRegion.mainlandSoutheastAsia);
      expect(Cuisine.thai.region, CuisineRegion.mainlandSoutheastAsia);
      expect(Cuisine.vietnamese.region, CuisineRegion.mainlandSoutheastAsia);
      expect(Cuisine.indonesian.region, CuisineRegion.maritimeSoutheastAsia);
      expect(Cuisine.malaysian.region, CuisineRegion.maritimeSoutheastAsia);
      expect(Cuisine.indian.region, CuisineRegion.southAsia);
      expect(Cuisine.italian.region, CuisineRegion.europe);
      expect(Cuisine.french.region, CuisineRegion.europe);
      expect(Cuisine.greek.region, CuisineRegion.europe);
      expect(Cuisine.spanish.region, CuisineRegion.europe);
      expect(Cuisine.german.region, CuisineRegion.europe);
      expect(Cuisine.americanWestern.region, CuisineRegion.americas);
      expect(Cuisine.mexican.region, CuisineRegion.americas);
    });
  });

  group('CuisineRegion.cuisines', () {
    test('round-trips through every cuisine exactly once', () {
      final all = <Cuisine>[];
      for (final r in CuisineRegion.values) {
        all.addAll(r.cuisines);
      }
      // Sort then compare so order differences don't fail; what we
      // care about is that EVERY cuisine appears in SOME region
      // exactly once. (Set comparison would mask duplicates.)
      final sorted = [...all]..sort((a, b) => a.wire.compareTo(b.wire));
      final expected = [...Cuisine.values]
        ..sort((a, b) => a.wire.compareTo(b.wire));
      expect(sorted, expected);
    });

    test('every region has at least one cuisine after v4 expansion', () {
      // Pre-v4, Middle East & Africa was empty (no Lebanese / Turkish /
      // Moroccan / Ethiopian yet) and the test asserted that gap. The
      // v4 catalog seeded that region, so now the contract flips:
      // every region must have members or `populatedRegions()` will
      // hide it. If a future cleanup ever removes all members of a
      // region, this test will flag it before it ships as a dead
      // region pill on the Explore screen.
      for (final r in CuisineRegion.values) {
        expect(
          r.cuisines,
          isNotEmpty,
          reason: '$r has no cuisines — region pill would silently hide',
        );
      }
    });
  });

  group('populatedRegions', () {
    test('contains only regions with at least one cuisine', () {
      final populated = populatedRegions();
      for (final r in populated) {
        expect(
          r.cuisines,
          isNotEmpty,
          reason: 'populated region $r must have members',
        );
      }
    });

    test('preserves display order', () {
      // East Asia is intentionally first — see _regionDisplayOrder
      // in cuisine_region.dart.
      final populated = populatedRegions();
      expect(populated.first, CuisineRegion.eastAsia);
    });
  });
}
