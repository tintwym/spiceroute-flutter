// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spice_route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TagImpl _$$TagImplFromJson(Map<String, dynamic> json) =>
    _$TagImpl(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$$TagImplToJson(_$TagImpl instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

_$SpiceRouteOwnerImpl _$$SpiceRouteOwnerImplFromJson(
  Map<String, dynamic> json,
) => _$SpiceRouteOwnerImpl(
  id: json['id'] as String,
  displayName: json['display_name'] as String,
);

Map<String, dynamic> _$$SpiceRouteOwnerImplToJson(
  _$SpiceRouteOwnerImpl instance,
) => <String, dynamic>{'id': instance.id, 'display_name': instance.displayName};

_$IngredientImpl _$$IngredientImplFromJson(Map<String, dynamic> json) =>
    _$IngredientImpl(
      id: json['id'] as String,
      quantity: _stringOrNumToDouble(json['quantity']),
      unit: json['unit'] as String?,
      name: json['name'] as String,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$IngredientImplToJson(_$IngredientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'name': instance.name,
      'sort_order': instance.sortOrder,
    };

_$StepImpl _$$StepImplFromJson(Map<String, dynamic> json) => _$StepImpl(
  id: json['id'] as String,
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
  body: json['body'] as String,
);

Map<String, dynamic> _$$StepImplToJson(_$StepImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sort_order': instance.sortOrder,
      'body': instance.body,
    };

_$SpiceRouteSummaryImpl _$$SpiceRouteSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$SpiceRouteSummaryImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  prepMinutes: (json['prep_minutes'] as num?)?.toInt() ?? 0,
  cookMinutes: (json['cook_minutes'] as num?)?.toInt() ?? 0,
  servings: (json['servings'] as num?)?.toInt() ?? 1,
  imageUrl: json['image_url'] as String?,
  isPublic: json['is_public'] as bool? ?? false,
  owner: SpiceRouteOwner.fromJson(json['owner'] as Map<String, dynamic>),
  tags:
      (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Tag>[],
  isFavorite: json['is_favorite'] as bool? ?? false,
);

Map<String, dynamic> _$$SpiceRouteSummaryImplToJson(
  _$SpiceRouteSummaryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'prep_minutes': instance.prepMinutes,
  'cook_minutes': instance.cookMinutes,
  'servings': instance.servings,
  'image_url': instance.imageUrl,
  'is_public': instance.isPublic,
  'owner': instance.owner,
  'tags': instance.tags,
  'is_favorite': instance.isFavorite,
};

_$SpiceRouteDetailImpl _$$SpiceRouteDetailImplFromJson(
  Map<String, dynamic> json,
) => _$SpiceRouteDetailImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  prepMinutes: (json['prep_minutes'] as num?)?.toInt() ?? 0,
  cookMinutes: (json['cook_minutes'] as num?)?.toInt() ?? 0,
  servings: (json['servings'] as num?)?.toInt() ?? 1,
  imageUrl: json['image_url'] as String?,
  isPublic: json['is_public'] as bool? ?? false,
  owner: SpiceRouteOwner.fromJson(json['owner'] as Map<String, dynamic>),
  tags:
      (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Tag>[],
  isFavorite: json['is_favorite'] as bool? ?? false,
  ingredients:
      (json['ingredients'] as List<dynamic>?)
          ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Ingredient>[],
  steps:
      (json['steps'] as List<dynamic>?)
          ?.map((e) => Step.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Step>[],
);

Map<String, dynamic> _$$SpiceRouteDetailImplToJson(
  _$SpiceRouteDetailImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'prep_minutes': instance.prepMinutes,
  'cook_minutes': instance.cookMinutes,
  'servings': instance.servings,
  'image_url': instance.imageUrl,
  'is_public': instance.isPublic,
  'owner': instance.owner,
  'tags': instance.tags,
  'is_favorite': instance.isFavorite,
  'ingredients': instance.ingredients,
  'steps': instance.steps,
};

_$SpiceRouteListResponseImpl _$$SpiceRouteListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$SpiceRouteListResponseImpl(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => SpiceRouteSummary.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SpiceRouteSummary>[],
  total: (json['total'] as num?)?.toInt() ?? 0,
  limit: (json['limit'] as num?)?.toInt() ?? 20,
  offset: (json['offset'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$SpiceRouteListResponseImplToJson(
  _$SpiceRouteListResponseImpl instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'limit': instance.limit,
  'offset': instance.offset,
};
