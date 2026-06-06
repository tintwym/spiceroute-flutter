import 'package:flutter/foundation.dart';

/// One of the 9 cuisines surfaced by Explore. Keep these strings in sync with
/// the backend `cuisine_type` enum.
enum Cuisine {
  korean('korean'),
  japanese('japanese'),
  chinese('chinese'),
  burmese('burmese'),
  thai('thai'),
  indian('indian'),
  italian('italian'),
  americanWestern('american_western'),
  mexican('mexican');

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
    this.language = 'en',
    this.spiceLevel = 0,
    this.isPremium = false,
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
  final String language;
  final int spiceLevel;
  final bool isPremium;
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
      language: (json['language'] as String?) ?? 'en',
      spiceLevel: (json['spice_level'] as int?) ?? 0,
      isPremium: (json['is_premium'] as bool?) ?? false,
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
    super.language,
    super.spiceLevel,
    super.isPremium,
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
      language: (json['language'] as String?) ?? 'en',
      spiceLevel: (json['spice_level'] as int?) ?? 0,
      isPremium: (json['is_premium'] as bool?) ?? false,
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
            .map((i) =>
                SpiceRouteSummary.fromJson(i as Map<String, dynamic>))
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
