import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/features/cook/cook_scaling.dart';
import 'package:spiceroute/models/spice_route.dart';

/// Unit tests for the pure scaling + unit conversion helper. The
/// quantities + unit strings flow from real recipe payloads (Gemini and
/// curated seeds), so this is the safety net that protects against
/// silly regressions like "2 cup × 2 servings = 4 cup" turning into
/// "0.5 cup" because of a bad ratio direction.
void main() {
  group('convertQuantity', () {
    test('no quantity returns the unit/word as-is', () {
      final r = convertQuantity(
        quantity: null,
        unit: 'to taste',
        scale: 1,
        target: UnitSystem.original,
      );
      expect(r.text, 'to taste');
    });

    test('original mode keeps the unit and just scales the number', () {
      final r = convertQuantity(
        quantity: 2,
        unit: 'cup',
        scale: 0.5,
        target: UnitSystem.original,
      );
      expect(r.text, '1 cup');
    });

    test('vulgar fractions appear for natural cook quantities', () {
      final r = convertQuantity(
        quantity: 1,
        unit: 'cup',
        scale: 0.5,
        target: UnitSystem.original,
      );
      expect(r.text, '½ cup');
    });

    test('whole + fraction renders compactly ("1¾ tsp")', () {
      final r = convertQuantity(
        quantity: 7,
        unit: 'tsp',
        scale: 0.25,
        target: UnitSystem.original,
      );
      expect(r.text, '1¾ tsp');
    });

    test('cup -> ml when target is metric (with kitchen rounding)', () {
      final r = convertQuantity(
        quantity: 1,
        unit: 'cup',
        scale: 1,
        target: UnitSystem.metric,
      );
      expect(r.text, '240 ml');
    });

    test('large metric weights snap to kg', () {
      final r = convertQuantity(
        quantity: 3,
        unit: 'lb',
        scale: 1,
        target: UnitSystem.metric,
      );
      // 3 * 453.592 = 1360.776 g -> 1.36 kg. The fraction 0.36 is
      // close enough to ⅓ (within tolerance 0.04) that the pretty-
      // print formatter snaps to the vulgar fraction. Reads more
      // naturally than "1.36 kg" or "1.4 kg".
      expect(r.text, '1⅓ kg');
    });

    test('imperial conversion picks cup for >= 240 ml and snaps to ⅛', () {
      final r = convertQuantity(
        quantity: 500,
        unit: 'ml',
        scale: 1,
        target: UnitSystem.imperial,
      );
      // 500 / 240 ≈ 2.083 cup -> snaps to nearest ⅛ -> 2.125 -> "2⅛ cup".
      // ⅛ is a real measuring-cup increment so this is what we want a
      // cook to see, not "2.08 cup".
      expect(r.text, '2⅛ cup');
    });

    test('imperial conversion picks tbsp for < 1 cup', () {
      final r = convertQuantity(
        quantity: 30,
        unit: 'ml',
        scale: 1,
        target: UnitSystem.imperial,
      );
      // 30 / 15 = 2 tbsp
      expect(r.text, '2 tbsp');
    });

    test('unknown units pass through untouched', () {
      // "pinch" isn't on the conversion table; should just scale the
      // number and keep the unit.
      final r = convertQuantity(
        quantity: 1,
        unit: 'pinch',
        scale: 2,
        target: UnitSystem.metric,
      );
      expect(r.text, '2 pinch');
    });

    // Regression: values within the vulgar-fraction tolerance of 0
    // or 1 used to render an empty number (" cup") because the
    // (0.0, '') and (1.0, '') entries returned an empty glyph and
    // _formatNumber didn't bump `whole` on rollover.
    test('values just under 1 render as 1 (rollover snap)', () {
      final r = convertQuantity(
        quantity: 0.99,
        unit: 'cup',
        scale: 1,
        target: UnitSystem.original,
      );
      expect(r.text, '1 cup');
    });

    test('values just over 1 render as 1 (rollover snap)', () {
      final r = convertQuantity(
        quantity: 1.02,
        unit: 'cup',
        scale: 1,
        target: UnitSystem.original,
      );
      expect(r.text, '1 cup');
    });

    test('values just above 0 still render a numeric leading digit', () {
      final r = convertQuantity(
        quantity: 0.03,
        unit: 'cup',
        scale: 1,
        target: UnitSystem.original,
      );
      // Tiny fraction — fine to round to 0. The key invariant is
      // that the string ISN'T empty (regression was ' cup').
      expect(r.text, isNot(startsWith(' ')));
      expect(r.text, contains('cup'));
    });

    test('whole-number outputs never include a vulgar fraction', () {
      final r = convertQuantity(
        quantity: 2,
        unit: 'cup',
        scale: 1,
        target: UnitSystem.original,
      );
      expect(r.text, '2 cup');
    });

    test('unit aliases normalize (Tablespoons -> tbsp)', () {
      final r = convertQuantity(
        quantity: 2,
        unit: 'Tablespoons',
        scale: 1,
        target: UnitSystem.metric,
      );
      expect(r.text, '30 ml');
    });
  });

  group('scaleIngredients', () {
    test('serving ratio applies before unit conversion', () {
      final ings = [
        const Ingredient(id: '1', quantity: 2, unit: 'cup', name: 'rice'),
      ];
      final out = scaleIngredients(
        ings,
        originalServings: 4,
        targetServings: 2,
        units: UnitSystem.original,
      );
      expect(out, hasLength(1));
      expect(out.first.display.text, '1 cup');
      expect(out.first.name, 'rice');
    });

    test('originalServings of 0 is defensively treated as 1', () {
      // A malformed recipe payload (servings missing / zero) shouldn't
      // divide-by-zero — we just scale 1:1.
      final ings = [
        const Ingredient(id: '1', quantity: 1, unit: 'cup', name: 'flour'),
      ];
      final out = scaleIngredients(
        ings,
        originalServings: 0,
        targetServings: 2,
        units: UnitSystem.original,
      );
      expect(out.first.display.text, '2 cup');
    });

    test('upsizing 4 servings -> 8 doubles the ml output', () {
      final ings = [
        const Ingredient(id: '1', quantity: 1, unit: 'cup', name: 'milk'),
      ];
      final out = scaleIngredients(
        ings,
        originalServings: 4,
        targetServings: 8,
        units: UnitSystem.metric,
      );
      // 1 cup * 2 = 2 cup -> 480 ml.
      expect(out.first.display.text, '480 ml');
    });
  });
}
