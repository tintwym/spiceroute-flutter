import '../../models/spice_route.dart';

/// Cooking-time toggle: which unit system to *display* ingredient
/// quantities in. The original recipe data is never mutated — we just
/// re-render quantities through [convertQuantity] at paint time.
///
/// - [original]: leave units exactly as the recipe author wrote them.
///   Use case: the cook is comfortable with whatever the recipe uses
///   and doesn't want any conversion noise.
/// - [metric]: cups / oz / tbsp / lb -> ml / g, °F -> °C in step text.
/// - [imperial]: ml / g / l / kg -> cup / oz / fl oz / lb, °C -> °F.
enum UnitSystem { original, metric, imperial }

/// Result of converting a single quantity+unit pair. The display string
/// is pre-formatted (with pretty vulgar fractions where possible);
/// callers should not re-format the numeric value themselves.
class ConvertedQuantity {
  const ConvertedQuantity({required this.text});

  /// "1½ cup", "240 ml", "—" if quantity was null.
  final String text;
}

/// Scales an ingredient list to a new serving count and converts each
/// quantity into the requested unit system.
///
/// Pure function — easy to test, no Flutter dependency.
///
/// `originalServings` of `0` is defensively treated as `1` to avoid a
/// divide-by-zero from a malformed recipe payload (it should never
/// happen because the model defaults to 1, but a bad backend write or
/// a stale LLM response shouldn't crash the cook page).
List<ScaledIngredient> scaleIngredients(
  List<Ingredient> ings, {
  required int originalServings,
  required int targetServings,
  required UnitSystem units,
}) {
  final from = originalServings <= 0 ? 1 : originalServings;
  final ratio = targetServings / from;
  return [
    for (final i in ings)
      ScaledIngredient(
        name: i.name,
        // Don't pre-multiply by `ratio` here — `convertQuantity` does the
        // scaling AND the unit conversion in one pass so the rounding
        // happens AFTER the conversion (otherwise "1 cup × 0.5 = 0.5
        // cup -> 118.29 ml" prints garbage; we want "1 cup × 0.5 = 120
        // ml" via the scale-then-convert pipeline).
        display: convertQuantity(
          quantity: i.quantity,
          unit: i.unit,
          scale: ratio,
          target: units,
        ),
        raw: i,
      ),
  ];
}

class ScaledIngredient {
  const ScaledIngredient({
    required this.name,
    required this.display,
    required this.raw,
  });

  /// Original ingredient name, untouched ("garlic, minced").
  final String name;

  /// Pre-formatted quantity + unit, ready to paint. "1½ cup", "240 ml",
  /// or "" when the recipe didn't specify either.
  final ConvertedQuantity display;

  /// The source ingredient. Held onto so callers (e.g. the ingredient
  /// checklist) can still reference the original id / sort order.
  final Ingredient raw;
}

/// Heart of the scale-and-convert pipeline. Returns a [ConvertedQuantity]
/// already formatted for display.
///
/// Algorithm:
///   1. Multiply the quantity by `scale` (serving ratio).
///   2. Normalize the unit string to a canonical form ("Tbsp" -> "tbsp").
///   3. If `target` is [UnitSystem.original] or the unit isn't on the
///      conversion map, format-and-return.
///   4. Otherwise pick the best target unit (e.g. small g amounts stay
///      g; >= 1000 g converts to kg) and convert.
///   5. Format with pretty fractions where the value lands on a 1/8,
///      1/4, 1/3, 1/2, 2/3, 3/4 boundary.
ConvertedQuantity convertQuantity({
  required double? quantity,
  required String? unit,
  required double scale,
  required UnitSystem target,
}) {
  if (quantity == null) {
    // Some recipes are like "salt to taste" with no quantity. Just show
    // whatever unit/word the author wrote, scaled or not (it's text).
    return ConvertedQuantity(text: (unit ?? '').trim());
  }
  final scaled = quantity * scale;
  final normalUnit = _normalizeUnit(unit);

  if (target == UnitSystem.original ||
      normalUnit == null ||
      !_supportedForConversion(normalUnit, target)) {
    return ConvertedQuantity(text: _formatQty(scaled, unit?.trim() ?? ''));
  }

  final converted = _convert(scaled, normalUnit, target);
  return ConvertedQuantity(text: _formatQty(converted.value, converted.unit));
}

// ---------------------------------------------------------------------------
// Unit normalization. The recipe corpus is a mix of "tbsp" / "Tbsp" /
// "tablespoon" / "Tablespoons" coming from both LLM-generated payloads
// and the curated seeds. We map them all to a canonical key for the
// conversion table.
// ---------------------------------------------------------------------------

String? _normalizeUnit(String? raw) {
  if (raw == null) return null;
  final s = raw.trim().toLowerCase().replaceAll('.', '');
  if (s.isEmpty) return null;
  // Strip trailing 's' for crude pluralization handling. Doesn't break
  // any of our mapped units because none of them END in a content 's'.
  final singular = s.endsWith('s') ? s.substring(0, s.length - 1) : s;
  return _unitAliases[s] ?? _unitAliases[singular];
}

const _unitAliases = <String, String>{
  // imperial volume
  'cup': 'cup',
  'tbsp': 'tbsp',
  'tablespoon': 'tbsp',
  't': 'tsp', // ambiguous in the wild; assume tsp (most cookbooks)
  'tsp': 'tsp',
  'teaspoon': 'tsp',
  'fl oz': 'floz',
  'floz': 'floz',
  'fluid ounce': 'floz',
  'pint': 'pint',
  'pt': 'pint',
  'quart': 'quart',
  'qt': 'quart',
  'gallon': 'gallon',
  'gal': 'gallon',
  // imperial weight
  'oz': 'oz',
  'ounce': 'oz',
  'lb': 'lb',
  'pound': 'lb',
  // metric volume
  'ml': 'ml',
  'milliliter': 'ml',
  'millilitre': 'ml',
  'l': 'l',
  'liter': 'l',
  'litre': 'l',
  // metric weight
  'g': 'g',
  'gram': 'g',
  'kg': 'kg',
  'kilogram': 'kg',
};

bool _supportedForConversion(String canonical, UnitSystem target) {
  if (target == UnitSystem.metric) return _imperialUnits.contains(canonical);
  if (target == UnitSystem.imperial) return _metricUnits.contains(canonical);
  return false;
}

const _imperialUnits = <String>{
  'cup',
  'tbsp',
  'tsp',
  'floz',
  'pint',
  'quart',
  'gallon',
  'oz',
  'lb',
};
const _metricUnits = <String>{'ml', 'l', 'g', 'kg'};

class _Converted {
  const _Converted(this.value, this.unit);
  final double value;
  final String unit;
}

_Converted _convert(double qty, String fromUnit, UnitSystem target) {
  if (target == UnitSystem.metric) {
    switch (fromUnit) {
      case 'cup':
        return _pickMetricVolume(qty * 240); // US cup
      case 'tbsp':
        return _pickMetricVolume(qty * 15);
      case 'tsp':
        return _pickMetricVolume(qty * 5);
      case 'floz':
        return _pickMetricVolume(qty * 29.5735);
      case 'pint':
        return _pickMetricVolume(qty * 473.176);
      case 'quart':
        return _pickMetricVolume(qty * 946.353);
      case 'gallon':
        return _pickMetricVolume(qty * 3785.41);
      case 'oz':
        return _pickMetricWeight(qty * 28.3495);
      case 'lb':
        return _pickMetricWeight(qty * 453.592);
    }
  }
  if (target == UnitSystem.imperial) {
    switch (fromUnit) {
      case 'ml':
        return _pickImperialVolume(qty);
      case 'l':
        return _pickImperialVolume(qty * 1000);
      case 'g':
        return _pickImperialWeight(qty);
      case 'kg':
        return _pickImperialWeight(qty * 1000);
    }
  }
  return _Converted(qty, fromUnit);
}

// Threshold tables pick a sensible unit so we render "1.5 l" instead of
// "1500 ml" and "1.5 lb" instead of "24 oz". The thresholds are
// deliberately loose — these are kitchen quantities, not lab work.

_Converted _pickMetricVolume(double ml) {
  if (ml >= 1000) return _Converted(ml / 1000, 'l');
  return _Converted(_roundKitchen(ml, 5), 'ml');
}

_Converted _pickMetricWeight(double g) {
  if (g >= 1000) return _Converted(g / 1000, 'kg');
  return _Converted(_roundKitchen(g, 5), 'g');
}

_Converted _pickImperialVolume(double ml) {
  // Anything >= 1 cup -> cups (fractions of cups read nicely).
  // <  1 cup but >= 1 tbsp -> tbsp.
  // <  1 tbsp -> tsp.
  //
  // Snapping: "2.083 cup" is technically accurate when converting from
  // 500 ml but useless to a human cook holding a measuring cup. We
  // snap each imperial unit to its kitchen-natural increment:
  //   - cup:  nearest ⅛   (matches a standard measuring-cup set)
  //   - tbsp: nearest ½   (½ tbsp is a real measuring spoon)
  //   - tsp:  nearest ¼   (¼ tsp is a real measuring spoon)
  if (ml >= 240) return _Converted(_snap(ml / 240, 8), 'cup');
  if (ml >= 15) return _Converted(_snap(ml / 15, 2), 'tbsp');
  return _Converted(_snap(ml / 5, 4), 'tsp');
}

_Converted _pickImperialWeight(double g) {
  // lb snaps to nearest ⅛ lb (≈ 2 oz), oz to nearest ¼ oz. Same
  // motivation as volume: kitchen scales aren't lab balances.
  if (g >= 454) return _Converted(_snap(g / 453.592, 8), 'lb');
  return _Converted(_snap(g / 28.3495, 4), 'oz');
}

/// Snap [v] to the nearest 1/[denom]. e.g. `_snap(2.083, 8)` → 2.125
/// (i.e. 2⅛), `_snap(2.0833, 4)` → 2.0 (i.e. 2).
double _snap(double v, int denom) => (v * denom).round() / denom;

/// Snap to the nearest multiple of `step`. "300.7 ml" -> "300 ml",
/// "12.4 g" -> "10 g". Avoids the false-precision look that pure
/// floating-point conversion gives.
double _roundKitchen(double v, int step) {
  if (v <= step) return v.roundToDouble();
  return (v / step).round() * step.toDouble();
}

// ---------------------------------------------------------------------------
// Pretty quantity formatter. Tries vulgar fractions for "natural" cook
// quantities (½ cup, 1¾ tsp). Falls back to one-decimal for awkward
// numbers, and integer when the value is already whole.
// ---------------------------------------------------------------------------

String _formatQty(double v, String unitText) {
  final qty = _formatNumber(v);
  if (unitText.isEmpty) return qty;
  // ml / g / kg / l usually read tightly ("240 ml"). cup / tbsp / tsp
  // also read fine with a space ("½ cup"). Single space everywhere.
  return '$qty $unitText';
}

String _formatNumber(double v) {
  if (v.isNaN || v.isInfinite) return '';
  // Cap: anything over 99 is plain integer (no fractions).
  if (v >= 100) return v.round().toString();

  // Integer snap FIRST. If the value lands within tolerance of any
  // integer (incl. rollover-to-1 from 0.97, or rollover-to-0 from
  // 0.03), render that integer plain — never a vulgar fraction.
  //
  // Regression context: the previous version had `(0.0, '')` and
  // `(1.0, '')` as entries in the fraction table, so `_formatNumber
  // (0.99)` matched the 1.0 entry, got an empty glyph back, and with
  // `whole == 0` returned `''`. That bubbled up as a quantity column
  // reading " cup" with no number — clearly broken from the cook's
  // point of view, and especially likely to bite when servings are
  // scaled down (1 cup / 4 servings × 1 ≈ 0.25, but 0.99 cup / 1 × 1
  // = 0.99 → rolls to 1).
  final rounded = v.roundToDouble();
  if ((v - rounded).abs() < 0.04) {
    return rounded.toInt().toString();
  }

  final whole = v.truncate();
  final frac = v - whole;
  final glyph = _vulgarFraction(frac);
  if (glyph != null) {
    if (whole == 0) return glyph;
    return '$whole$glyph';
  }
  // No nice fraction — fall back to a one-decimal representation,
  // stripping trailing zero ("1.5" but "2" not "2.0").
  final s = v.toStringAsFixed(2);
  return s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
}

/// Returns the unicode vulgar-fraction glyph for the given fractional
/// part if it's "close enough" to a kitchen-natural fraction. Tolerance
/// of 0.04 means "1.24 cup" renders as "1¼ cup" but "1.18 cup" stays
/// numeric.
///
/// Stored as a flat `(double, String)` list rather than a `Map<double,
/// String>` because Dart forbids `double` keys in a `const` map (==
/// behaviour for IEEE-754 isn't reliable enough to be a primary key).
/// A linear scan over 7 entries is trivially fast.
///
/// IMPORTANT: this table contains NO entries for 0.0 or 1.0 — the
/// integer-snap branch in [_formatNumber] handles rollover before we
/// get here, so a "(0.0, '')" sentinel that returned an empty glyph
/// would just reintroduce the bug it was trying to mask.
String? _vulgarFraction(double frac) {
  const tol = 0.04;
  for (final (value, glyph) in _fractions) {
    if ((frac - value).abs() < tol) return glyph;
  }
  return null;
}

const _fractions = <(double, String)>[
  (0.125, '⅛'),
  (0.25, '¼'),
  (0.333, '⅓'),
  (0.5, '½'),
  (0.666, '⅔'),
  (0.667, '⅔'),
  (0.75, '¾'),
  (0.875, '⅞'),
];
