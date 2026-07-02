import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/models/cuisine_catalog.dart';
import 'package:spiceroute/models/cuisine_region.dart';
import 'package:spiceroute/models/spice_route.dart';

void main() {
  group('country-level cuisine collapse', () {
    test('sub-national cuisines map to parent country for display', () {
      expect(cuisineForDisplay(Cuisine.sichuan), Cuisine.chinese);
      expect(cuisineForDisplay(Cuisine.hongKong), Cuisine.chinese);
      expect(cuisineForDisplay(Cuisine.yangon), Cuisine.burmese);
      expect(cuisineForDisplay(Cuisine.shan), Cuisine.burmese);
      expect(cuisineForDisplay(Cuisine.okinawan), Cuisine.japanese);
      expect(cuisineForDisplay(Cuisine.korean), Cuisine.korean);
      expect(cuisineForDisplay(Cuisine.thai), Cuisine.thai);
    });

    test('East Asia picker is country-level only', () {
      final pickers = selectableCuisinesInRegion(CuisineRegion.eastAsia);
      expect(pickers.where((c) => c == Cuisine.chinese).length, 1);
      expect(pickers.contains(Cuisine.sichuan), isFalse);
      expect(pickers.contains(Cuisine.hongKong), isFalse);
      expect(pickers.contains(Cuisine.okinawan), isFalse);
      expect(pickers.contains(Cuisine.korean), isTrue);
      expect(pickers.contains(Cuisine.japanese), isTrue);
      expect(pickers.contains(Cuisine.taiwanese), isTrue);
    });

    test('Mainland SE Asia picker is country-level only', () {
      final pickers = selectableCuisinesInRegion(
        CuisineRegion.mainlandSoutheastAsia,
      );
      expect(pickers.where((c) => c == Cuisine.burmese).length, 1);
      expect(pickers.contains(Cuisine.yangon), isFalse);
      expect(pickers.contains(Cuisine.shan), isFalse);
      expect(pickers.contains(Cuisine.thai), isTrue);
      expect(pickers.contains(Cuisine.vietnamese), isTrue);
      expect(pickers.contains(Cuisine.cambodian), isTrue);
    });

    test('pill selection treats sub-national as parent country', () {
      expect(
        cuisinePillSelected(pill: Cuisine.burmese, active: Cuisine.yangon),
        isTrue,
      );
      expect(
        cuisinePillSelected(pill: Cuisine.yangon, active: Cuisine.yangon),
        isFalse,
      );
    });
  });
}
