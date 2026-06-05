import 'package:freezed_annotation/freezed_annotation.dart';

part 'spice_route.freezed.dart';
part 'spice_route.g.dart';

@freezed
class Tag with _$Tag {
  const factory Tag({required String id, required String name}) = _Tag;
  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}

@freezed
class SpiceRouteOwner with _$SpiceRouteOwner {
  const factory SpiceRouteOwner({
    required String id,
    @JsonKey(name: 'display_name') required String displayName,
  }) = _SpiceRouteOwner;

  factory SpiceRouteOwner.fromJson(Map<String, dynamic> json) =>
      _$SpiceRouteOwnerFromJson(json);
}

@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    required String id,
    @JsonKey(fromJson: _stringOrNumToDouble) double? quantity,
    String? unit,
    required String name,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}

@freezed
class Step with _$Step {
  const factory Step({
    required String id,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    required String body,
  }) = _Step;

  factory Step.fromJson(Map<String, dynamic> json) => _$StepFromJson(json);
}

@freezed
class SpiceRouteSummary with _$SpiceRouteSummary {
  const factory SpiceRouteSummary({
    required String id,
    required String title,
    String? description,
    @JsonKey(name: 'prep_minutes') @Default(0) int prepMinutes,
    @JsonKey(name: 'cook_minutes') @Default(0) int cookMinutes,
    @Default(1) int servings,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_public') @Default(false) bool isPublic,
    required SpiceRouteOwner owner,
    @Default(<Tag>[]) List<Tag> tags,
    @JsonKey(name: 'is_favorite') @Default(false) bool isFavorite,
  }) = _SpiceRouteSummary;

  factory SpiceRouteSummary.fromJson(Map<String, dynamic> json) =>
      _$SpiceRouteSummaryFromJson(json);
}

@freezed
class SpiceRouteDetail with _$SpiceRouteDetail {
  const factory SpiceRouteDetail({
    required String id,
    required String title,
    String? description,
    @JsonKey(name: 'prep_minutes') @Default(0) int prepMinutes,
    @JsonKey(name: 'cook_minutes') @Default(0) int cookMinutes,
    @Default(1) int servings,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_public') @Default(false) bool isPublic,
    required SpiceRouteOwner owner,
    @Default(<Tag>[]) List<Tag> tags,
    @JsonKey(name: 'is_favorite') @Default(false) bool isFavorite,
    @Default(<Ingredient>[]) List<Ingredient> ingredients,
    @Default(<Step>[]) List<Step> steps,
  }) = _SpiceRouteDetail;

  factory SpiceRouteDetail.fromJson(Map<String, dynamic> json) =>
      _$SpiceRouteDetailFromJson(json);
}

@freezed
class SpiceRouteListResponse with _$SpiceRouteListResponse {
  const factory SpiceRouteListResponse({
    @Default(<SpiceRouteSummary>[]) List<SpiceRouteSummary> items,
    @Default(0) int total,
    @Default(20) int limit,
    @Default(0) int offset,
  }) = _SpiceRouteListResponse;

  factory SpiceRouteListResponse.fromJson(Map<String, dynamic> json) =>
      _$SpiceRouteListResponseFromJson(json);
}

double? _stringOrNumToDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}
