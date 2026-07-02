import 'package:flutter/foundation.dart';

/// One of the 76 cuisines surfaced by Explore. Keep these strings in sync
/// with the backend `Cuisine` StrEnum in `app/models/cuisine.py` and the
/// LLM JSON-schema enum in `app/services/ai/prompts.py`.
///
/// Order is append-only — DO NOT reorder. Vietnamese was appended after
/// the original launch catalog (page-1 muscle memory for early users),
/// French + Vietnamese pre-date the v3 catalog expansion, the next five
/// (Greek, Spanish, Malaysian, German, Indonesian) shipped with v3, and
/// the last 15 (Lebanese through british) ship with v4 — Phase 1
/// fills the empty Middle East & Africa region and balances the under-
/// weight South / Mainland-SE / Maritime-SE Asia rows; Phase 2 adds
/// Americas + East Asia + Europe gap fillers including two umbrellas
/// (Caribbean) deliberately kept at the cluster level
/// instead of country-by-country to avoid the granularity trap.
enum Cuisine {
  korean('korean'),
  japanese('japanese'),
  chinese('chinese'),
  burmese('burmese'),
  thai('thai'),
  indian('indian'),
  italian('italian'),
  americanWestern('american_western'),
  mexican('mexican'),
  french('french'),
  vietnamese('vietnamese'),
  greek('greek'),
  spanish('spanish'),
  malaysian('malaysian'),
  german('german'),
  indonesian('indonesian'),
  // v4 Phase 1 — fill empty / sparse regions.
  lebanese('lebanese'),
  turkish('turkish'),
  moroccan('moroccan'),
  ethiopian('ethiopian'),
  filipino('filipino'),
  pakistani('pakistani'),
  sriLankan('sri_lankan'),
  cambodian('cambodian'),
  // v4 Phase 2 — opportunistic expansion + umbrella cuisines.
  brazilian('brazilian'),
  peruvian('peruvian'),
  caribbean('caribbean'),
  taiwanese('taiwanese'),
  portuguese('portuguese'),
  british('british'),
  // v5 — East Asia regional expansion (26 cuisines → 30 in region).
  mongolian('mongolian'),
  tibetan('tibetan'),
  hongKong('hong_kong'),
  macanese('macanese'),
  sichuan('sichuan'),
  cantonese('cantonese'),
  shanghainese('shanghainese'),
  fujian('fujian'),
  hunan('hunan'),
  yunnan('yunnan'),
  beijing('beijing'),
  dongbei('dongbei'),
  hakka('hakka'),
  uyghur('uyghur'),
  okinawan('okinawan'),
  shandong('shandong'),
  guangxi('guangxi'),
  teochew('teochew'),
  hainanese('hainanese'),
  jiangsu('jiangsu'),
  zhejiang('zhejiang'),
  anhui('anhui'),
  jiangxi('jiangxi'),
  guizhou('guizhou'),
  manchurian('manchurian'),
  shaanxi('shaanxi'),
  shan('shan'),
  rakhine('rakhine'),
  mon('mon'),
  kachin('kachin'),
  kayin('kayin'),
  chin('chin'),
  kayah('kayah'),
  mandalay('mandalay'),
  yangon('yangon'),
  ayeyarwady('ayeyarwady'),
  tanintharyi('tanintharyi'),
  intha('intha'),
  naga('naga'),
  paO('pa_o'),
  danu('danu'),
  wa('wa'),
  magway('magway'),
  bago('bago'),
  sagaing('sagaing'),
  taunggyi('taunggyi');

  const Cuisine(this.wire);
  final String wire;

  static Cuisine? fromWire(String? raw) {
    if (raw == null) return null;
    for (final c in Cuisine.values) {
      if (c.wire == raw) return c;
    }
    return null;
  }
}

@immutable
class Tag {
  const Tag({required this.id, required this.name});
  final String id;
  final String name;

  factory Tag.fromJson(Map<String, dynamic> json) =>
      Tag(id: json['id'] as String, name: json['name'] as String);
}

/// Course-group header shown above [Course] items in the filter dropdown.
///
/// Groups are presentation-only: the recipe match still happens at the
/// [Course] level. Each course knows which group it belongs to via
/// [Course.group], and the filter UI renders one non-clickable header
/// per group above its members.
enum CourseGroup {
  earlyDay,
  daytimeCasual,
  beforeMain,
  mainEvent,
  sweetEnding,
  afterHours,
  liquids,
}

/// Meal course / role on the plate. Used as a *client-side* filter on the
/// Explore screen — matched against each recipe's `tags` list by tag name
/// (e.g. a recipe tagged "dessert" matches `Course.dessert`). The backend
/// stores no first-class `course` column today; surfacing it via tags lets
/// us ship the filter UI without a migration.
///
/// v3 taxonomy: expanded from 7 → 12 items organized into 7 groups (Early
/// Day, Daytime / Casual, …). Order matches the user-facing grouping so
/// `Course.values` iteration is already in display order. Each course
/// matches against a list of lowercase tag names so a recipe tagged
/// "brunch" still resolves to `Course.breakfast`, "main" to
/// `Course.mainCourse`, "cocktail" to `Course.drinks`, etc.
///
/// The 7 original values (breakfast / lunch / appetizer / sideDish /
/// dessert / snack / drinks) are preserved on purpose so the existing
/// `crossCulturalStories` data and any persisted client state keep
/// working without a migration.
enum Course {
  // Early Day
  breakfast(CourseGroup.earlyDay, ['breakfast', 'brunch']),
  highTea(CourseGroup.earlyDay, ['high tea', 'afternoon tea']),
  // Daytime / Casual
  lunch(CourseGroup.daytimeCasual, ['lunch', 'box lunch', 'bento']),
  // `soupsSaladsBowls` is the legacy enum identifier — kept stable so
  // any persisted client state / git history still resolves. The
  // user-facing label is now "Soups, Broths & Salads"; tag aliases
  // include both the new (`broth`) and old (`healthy bowl`,
  // `grain bowl`) vocabulary so older seed data keeps matching.
  soupsSaladsBowls(CourseGroup.daytimeCasual, [
    'soup',
    'broth',
    'salad',
    'healthy bowl',
    'grain bowl',
  ]),
  // Before the Main
  appetizer(CourseGroup.beforeMain, ['appetizer', 'starter', 'finger food']),
  // Legacy enum identifier; label is "Sharing Platters, Boards &
  // Charcuterie". `sharing platter` is the new canonical, the rest are
  // backwards-compat aliases.
  sharingBoards(CourseGroup.beforeMain, [
    'sharing platter',
    'sharing board',
    'charcuterie',
    'platter',
  ]),
  // The Main Event — label is "High-Protein Main Courses". The
  // `high-protein` tag is honoured so wellness-tagged recipes show
  // up here even if they aren't separately tagged "main course".
  mainCourse(CourseGroup.mainEvent, [
    'main course',
    'main',
    'entrée',
    'high-protein',
  ]),
  sideDish(CourseGroup.mainEvent, ['side dish', 'side']),
  // Sweet Ending
  dessert(CourseGroup.sweetEnding, ['dessert', 'sweet']),
  // After Hours
  snack(CourseGroup.afterHours, ['snack', 'late-night']),
  // Liquids
  drinks(CourseGroup.liquids, ['alcoholic drinks', 'cocktail', 'drinks']),
  // Legacy enum identifier; label is "Non-Alcoholic Beverages". Both
  // the new (`non-alcoholic`) and old (`zero-proof`, `mocktail`,
  // `specialty beverage`) tag vocabularies resolve here.
  zeroProofDrinks(CourseGroup.liquids, [
    'non-alcoholic',
    'zero-proof',
    'mocktail',
    'specialty beverage',
  ]);

  const Course(this.group, this.tagNames);

  /// Visual group the dropdown places this course under.
  final CourseGroup group;

  /// Lowercase tag names that should resolve to this course. Matched
  /// case-insensitively against `SpiceRouteSummary.tags` — a recipe is
  /// "in" this course if any of its tags appears in this list. The first
  /// entry is the canonical tag for new content; the others are
  /// backwards-compatibility aliases so older seed data keeps matching.
  final List<String> tagNames;

  /// True when any tag in [tags] matches one of this course's [tagNames].
  bool matches(Iterable<Tag> tags) {
    for (final t in tags) {
      final needle = t.name.toLowerCase();
      for (final name in tagNames) {
        if (name == needle) return true;
      }
    }
    return false;
  }
}

/// Dietary / lifestyle / format constraint a recipe satisfies. Same
/// client-side filter model as [Course] — matched against `tags` by name.
///
/// v2 taxonomy (mirrors the reference design): mixes traditional dietary
/// restrictions (vegan, vegetarian) with practical ("Meal Prep",
/// "Quick & Easy"), format ("Pasta & Soup"), wellness ("Blood Sugar
/// Balanced", "Anti-Inflammatory & Longevity") and flavor profile
/// ("Swicy"). Each value's `tagName` corresponds to a tag the backend
/// seed script attaches to qualifying recipes (see
/// `_EXTRA_TAGS_BY_TITLE` in `scripts/seed_curated_recipes.py`).
enum Dietary {
  vegan('vegan', DietaryGroup.dietaryRestrictions),
  vegetarian('vegetarian', DietaryGroup.dietaryRestrictions),
  // Allergen-free filters. The `tagName` values are the canonical
  // tag strings the backend seed / writer expects on a recipe row;
  // the filter is a case-insensitive EXACT tag-name match (see
  // `ExploreState._matchesDietary`), so the strings here have to
  // match what the seed actually writes — letter for letter,
  // hyphen for hyphen.
  //
  // The seed (`scripts/seed_curated_recipes.py::_EXTRA_TAGS_BY_TITLE`)
  // already attaches hyphenated tags like `gluten-free` and
  // `dairy-free` to qualifying recipes. The hyphenated form is also
  // consistent with the existing `Dietary.antiInflammatory` whose
  // tagName is `anti-inflammatory` — using `gluten free` (space)
  // here would silently filter to ZERO matches against the dozen+
  // recipes that ARE already tagged `gluten-free`.
  glutenFree('gluten-free', DietaryGroup.allergenFree),
  dairyFree('dairy-free', DietaryGroup.allergenFree),
  nutFree('nut-free', DietaryGroup.allergenFree),
  eggFree('egg-free', DietaryGroup.allergenFree),
  mealPrep('meal prep', DietaryGroup.cookingFormats),
  quickEasy('quick', DietaryGroup.cookingFormats),
  pastaSoup('pasta soup', DietaryGroup.cookingFormats),
  bloodSugarBalanced('blood sugar balanced', DietaryGroup.wellness),
  swicy('swicy', DietaryGroup.wellness),
  antiInflammatory('anti-inflammatory', DietaryGroup.wellness);

  const Dietary(this.tagName, this.group);
  final String tagName;

  /// Visual subcategory the accordion filter buckets this item under.
  /// Mirrors [CourseGroup] for [Course] so the dietary dropdown can
  /// render the same "group pill + selected label" trigger UI.
  final DietaryGroup group;
}

/// Subcategory groups shown as collapsible accordion sections inside
/// the dietary filter dropdown. Order here is the order rendered in
/// the menu (dietary restrictions first because they're the most
/// commonly-applied filters, then allergen-free which is the next
/// most-common explicit filter people reach for, then wellness,
/// then format).
enum DietaryGroup {
  dietaryRestrictions,
  allergenFree,
  wellness,
  cookingFormats,
}

@immutable
class SpiceRouteOwner {
  const SpiceRouteOwner({required this.id, required this.displayName});
  final String id;
  final String displayName;

  factory SpiceRouteOwner.fromJson(Map<String, dynamic> json) =>
      SpiceRouteOwner(
        id: json['id'] as String,
        displayName: json['display_name'] as String,
      );
}

@immutable
class Ingredient {
  const Ingredient({
    required this.id,
    this.quantity,
    this.unit,
    required this.name,
    this.sortOrder = 0,
  });
  final String id;
  final double? quantity;
  final String? unit;
  final String name;
  final int sortOrder;

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
    id: (json['id'] ?? '') as String,
    quantity: _toDouble(json['quantity']),
    unit: json['unit'] as String?,
    name: json['name'] as String,
    sortOrder: (json['sort_order'] as int?) ?? 0,
  );
}

@immutable
class RecipeStep {
  const RecipeStep({required this.id, this.sortOrder = 0, required this.body});
  final String id;
  final int sortOrder;
  final String body;

  factory RecipeStep.fromJson(Map<String, dynamic> json) => RecipeStep(
    id: (json['id'] ?? '') as String,
    sortOrder: (json['sort_order'] as int?) ?? 0,
    body: json['body'] as String,
  );
}

/// How challenging a recipe is to execute. Mirrors the backend
/// `Difficulty` enum (`app/models/difficulty.py`) — the wire strings
/// are load-bearing and must match exactly. The Explore card and the
/// recipe detail header both render one of these three values; the
/// l10n keys live in `app_en.arb`'s `detailDifficulty{Easy,Medium,Hard}`.
enum Difficulty {
  easy('easy'),
  medium('medium'),
  hard('hard');

  const Difficulty(this.wire);
  final String wire;

  /// Parse a server-issued string. Unknown / null falls back to
  /// MEDIUM — chosen as the neutral default so that a missing field
  /// can't push the UI toward either extreme. The backend now always
  /// sends a value (NOT NULL column), so this branch is only hit by
  /// (a) very old cached responses or (b) a future enum rename
  /// without a coordinated FE deploy.
  static Difficulty fromWire(String? value) {
    if (value == null) return Difficulty.medium;
    final v = value.toLowerCase();
    for (final d in Difficulty.values) {
      if (d.wire == v) return d;
    }
    return Difficulty.medium;
  }
}

@immutable
class SpiceRouteSummary {
  const SpiceRouteSummary({
    required this.id,
    required this.title,
    this.description,
    this.prepMinutes = 0,
    this.cookMinutes = 0,
    this.servings = 1,
    this.imageUrl,
    this.isPublic = true,
    this.cuisine,
    this.cuisineWire,
    this.language = 'en',
    this.spiceLevel = 0,
    this.isPremium = false,
    this.caloriesPerServing,
    this.difficulty = Difficulty.medium,
    this.owner,
    this.tags = const [],
  });

  final String id;
  final String title;
  final String? description;
  final int prepMinutes;
  final int cookMinutes;
  final int servings;
  final String? imageUrl;
  final bool isPublic;
  final Cuisine? cuisine;

  /// Raw `cuisine` string from the API. Kept even when [cuisine] is null
  /// (unknown enum value on an older client) so cards can still label
  /// the dish.
  final String? cuisineWire;
  final String language;
  final int spiceLevel;
  final bool isPremium;
  final int? caloriesPerServing;
  final Difficulty difficulty;
  final SpiceRouteOwner? owner;
  final List<Tag> tags;

  int get totalMinutes => prepMinutes + cookMinutes;
  bool get isAiAuthored => owner == null && !isPremium;

  factory SpiceRouteSummary.fromJson(Map<String, dynamic> json) {
    return SpiceRouteSummary(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      prepMinutes: (json['prep_minutes'] as int?) ?? 0,
      cookMinutes: (json['cook_minutes'] as int?) ?? 0,
      servings: (json['servings'] as int?) ?? 1,
      imageUrl: json['image_url'] as String?,
      isPublic: (json['is_public'] as bool?) ?? true,
      cuisine: Cuisine.fromWire(json['cuisine'] as String?),
      cuisineWire: json['cuisine'] as String?,
      language: (json['language'] as String?) ?? 'en',
      spiceLevel: (json['spice_level'] as int?) ?? 0,
      isPremium: (json['is_premium'] as bool?) ?? false,
      caloriesPerServing: json['calories_per_serving'] as int?,
      difficulty: Difficulty.fromWire(json['difficulty'] as String?),
      owner: json['owner'] == null
          ? null
          : SpiceRouteOwner.fromJson(json['owner'] as Map<String, dynamic>),
      tags: ((json['tags'] as List?) ?? const [])
          .map((t) => Tag.fromJson(t as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}

@immutable
class SpiceRouteDetail extends SpiceRouteSummary {
  const SpiceRouteDetail({
    required super.id,
    required super.title,
    super.description,
    super.prepMinutes,
    super.cookMinutes,
    super.servings,
    super.imageUrl,
    super.isPublic,
    super.cuisine,
    super.cuisineWire,
    super.language,
    super.spiceLevel,
    super.isPremium,
    super.caloriesPerServing,
    super.difficulty,
    super.owner,
    super.tags,
    this.ingredients = const [],
    this.steps = const [],
  });

  final List<Ingredient> ingredients;
  final List<RecipeStep> steps;

  factory SpiceRouteDetail.fromJson(Map<String, dynamic> json) {
    return SpiceRouteDetail(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      prepMinutes: (json['prep_minutes'] as int?) ?? 0,
      cookMinutes: (json['cook_minutes'] as int?) ?? 0,
      servings: (json['servings'] as int?) ?? 1,
      imageUrl: json['image_url'] as String?,
      isPublic: (json['is_public'] as bool?) ?? true,
      cuisine: Cuisine.fromWire(json['cuisine'] as String?),
      cuisineWire: json['cuisine'] as String?,
      language: (json['language'] as String?) ?? 'en',
      spiceLevel: (json['spice_level'] as int?) ?? 0,
      isPremium: (json['is_premium'] as bool?) ?? false,
      caloriesPerServing: json['calories_per_serving'] as int?,
      difficulty: Difficulty.fromWire(json['difficulty'] as String?),
      owner: json['owner'] == null
          ? null
          : SpiceRouteOwner.fromJson(json['owner'] as Map<String, dynamic>),
      tags: ((json['tags'] as List?) ?? const [])
          .map((t) => Tag.fromJson(t as Map<String, dynamic>))
          .toList(growable: false),
      ingredients: ((json['ingredients'] as List?) ?? const [])
          .map((i) => Ingredient.fromJson(i as Map<String, dynamic>))
          .toList(growable: false),
      steps: ((json['steps'] as List?) ?? const [])
          .map((s) => RecipeStep.fromJson(s as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}

@immutable
class SpiceRouteListResponse {
  const SpiceRouteListResponse({
    this.items = const [],
    this.total = 0,
    this.limit = 20,
    this.offset = 0,
  });

  final List<SpiceRouteSummary> items;
  final int total;
  final int limit;
  final int offset;

  factory SpiceRouteListResponse.fromJson(Map<String, dynamic> json) =>
      SpiceRouteListResponse(
        items: ((json['items'] as List?) ?? const [])
            .map((i) => SpiceRouteSummary.fromJson(i as Map<String, dynamic>))
            .toList(growable: false),
        total: (json['total'] as int?) ?? 0,
        limit: (json['limit'] as int?) ?? 20,
        offset: (json['offset'] as int?) ?? 0,
      );
}

double? _toDouble(Object? v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}
