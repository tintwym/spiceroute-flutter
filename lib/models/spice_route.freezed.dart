// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spice_route.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Tag _$TagFromJson(Map<String, dynamic> json) {
  return _Tag.fromJson(json);
}

/// @nodoc
mixin _$Tag {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this Tag to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TagCopyWith<Tag> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagCopyWith<$Res> {
  factory $TagCopyWith(Tag value, $Res Function(Tag) then) =
      _$TagCopyWithImpl<$Res, Tag>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$TagCopyWithImpl<$Res, $Val extends Tag> implements $TagCopyWith<$Res> {
  _$TagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TagImplCopyWith<$Res> implements $TagCopyWith<$Res> {
  factory _$$TagImplCopyWith(_$TagImpl value, $Res Function(_$TagImpl) then) =
      __$$TagImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$TagImplCopyWithImpl<$Res> extends _$TagCopyWithImpl<$Res, _$TagImpl>
    implements _$$TagImplCopyWith<$Res> {
  __$$TagImplCopyWithImpl(_$TagImpl _value, $Res Function(_$TagImpl) _then)
    : super(_value, _then);

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$TagImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TagImpl implements _Tag {
  const _$TagImpl({required this.id, required this.name});

  factory _$TagImpl.fromJson(Map<String, dynamic> json) =>
      _$$TagImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'Tag(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TagImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TagImplCopyWith<_$TagImpl> get copyWith =>
      __$$TagImplCopyWithImpl<_$TagImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TagImplToJson(this);
  }
}

abstract class _Tag implements Tag {
  const factory _Tag({required final String id, required final String name}) =
      _$TagImpl;

  factory _Tag.fromJson(Map<String, dynamic> json) = _$TagImpl.fromJson;

  @override
  String get id;
  @override
  String get name;

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TagImplCopyWith<_$TagImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpiceRouteOwner _$SpiceRouteOwnerFromJson(Map<String, dynamic> json) {
  return _SpiceRouteOwner.fromJson(json);
}

/// @nodoc
mixin _$SpiceRouteOwner {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String get displayName => throw _privateConstructorUsedError;

  /// Serializes this SpiceRouteOwner to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpiceRouteOwner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpiceRouteOwnerCopyWith<SpiceRouteOwner> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpiceRouteOwnerCopyWith<$Res> {
  factory $SpiceRouteOwnerCopyWith(
    SpiceRouteOwner value,
    $Res Function(SpiceRouteOwner) then,
  ) = _$SpiceRouteOwnerCopyWithImpl<$Res, SpiceRouteOwner>;
  @useResult
  $Res call({String id, @JsonKey(name: 'display_name') String displayName});
}

/// @nodoc
class _$SpiceRouteOwnerCopyWithImpl<$Res, $Val extends SpiceRouteOwner>
    implements $SpiceRouteOwnerCopyWith<$Res> {
  _$SpiceRouteOwnerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpiceRouteOwner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? displayName = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SpiceRouteOwnerImplCopyWith<$Res>
    implements $SpiceRouteOwnerCopyWith<$Res> {
  factory _$$SpiceRouteOwnerImplCopyWith(
    _$SpiceRouteOwnerImpl value,
    $Res Function(_$SpiceRouteOwnerImpl) then,
  ) = __$$SpiceRouteOwnerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, @JsonKey(name: 'display_name') String displayName});
}

/// @nodoc
class __$$SpiceRouteOwnerImplCopyWithImpl<$Res>
    extends _$SpiceRouteOwnerCopyWithImpl<$Res, _$SpiceRouteOwnerImpl>
    implements _$$SpiceRouteOwnerImplCopyWith<$Res> {
  __$$SpiceRouteOwnerImplCopyWithImpl(
    _$SpiceRouteOwnerImpl _value,
    $Res Function(_$SpiceRouteOwnerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpiceRouteOwner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? displayName = null}) {
    return _then(
      _$SpiceRouteOwnerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SpiceRouteOwnerImpl implements _SpiceRouteOwner {
  const _$SpiceRouteOwnerImpl({
    required this.id,
    @JsonKey(name: 'display_name') required this.displayName,
  });

  factory _$SpiceRouteOwnerImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpiceRouteOwnerImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'display_name')
  final String displayName;

  @override
  String toString() {
    return 'SpiceRouteOwner(id: $id, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpiceRouteOwnerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, displayName);

  /// Create a copy of SpiceRouteOwner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpiceRouteOwnerImplCopyWith<_$SpiceRouteOwnerImpl> get copyWith =>
      __$$SpiceRouteOwnerImplCopyWithImpl<_$SpiceRouteOwnerImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SpiceRouteOwnerImplToJson(this);
  }
}

abstract class _SpiceRouteOwner implements SpiceRouteOwner {
  const factory _SpiceRouteOwner({
    required final String id,
    @JsonKey(name: 'display_name') required final String displayName,
  }) = _$SpiceRouteOwnerImpl;

  factory _SpiceRouteOwner.fromJson(Map<String, dynamic> json) =
      _$SpiceRouteOwnerImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'display_name')
  String get displayName;

  /// Create a copy of SpiceRouteOwner
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpiceRouteOwnerImplCopyWith<_$SpiceRouteOwnerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Ingredient _$IngredientFromJson(Map<String, dynamic> json) {
  return _Ingredient.fromJson(json);
}

/// @nodoc
mixin _$Ingredient {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNumToDouble)
  double? get quantity => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this Ingredient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Ingredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IngredientCopyWith<Ingredient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IngredientCopyWith<$Res> {
  factory $IngredientCopyWith(
    Ingredient value,
    $Res Function(Ingredient) then,
  ) = _$IngredientCopyWithImpl<$Res, Ingredient>;
  @useResult
  $Res call({
    String id,
    @JsonKey(fromJson: _stringOrNumToDouble) double? quantity,
    String? unit,
    String name,
    @JsonKey(name: 'sort_order') int sortOrder,
  });
}

/// @nodoc
class _$IngredientCopyWithImpl<$Res, $Val extends Ingredient>
    implements $IngredientCopyWith<$Res> {
  _$IngredientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Ingredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quantity = freezed,
    Object? unit = freezed,
    Object? name = null,
    Object? sortOrder = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double?,
            unit: freezed == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IngredientImplCopyWith<$Res>
    implements $IngredientCopyWith<$Res> {
  factory _$$IngredientImplCopyWith(
    _$IngredientImpl value,
    $Res Function(_$IngredientImpl) then,
  ) = __$$IngredientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(fromJson: _stringOrNumToDouble) double? quantity,
    String? unit,
    String name,
    @JsonKey(name: 'sort_order') int sortOrder,
  });
}

/// @nodoc
class __$$IngredientImplCopyWithImpl<$Res>
    extends _$IngredientCopyWithImpl<$Res, _$IngredientImpl>
    implements _$$IngredientImplCopyWith<$Res> {
  __$$IngredientImplCopyWithImpl(
    _$IngredientImpl _value,
    $Res Function(_$IngredientImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Ingredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quantity = freezed,
    Object? unit = freezed,
    Object? name = null,
    Object? sortOrder = null,
  }) {
    return _then(
      _$IngredientImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: freezed == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double?,
        unit: freezed == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IngredientImpl implements _Ingredient {
  const _$IngredientImpl({
    required this.id,
    @JsonKey(fromJson: _stringOrNumToDouble) this.quantity,
    this.unit,
    required this.name,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
  });

  factory _$IngredientImpl.fromJson(Map<String, dynamic> json) =>
      _$$IngredientImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(fromJson: _stringOrNumToDouble)
  final double? quantity;
  @override
  final String? unit;
  @override
  final String name;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;

  @override
  String toString() {
    return 'Ingredient(id: $id, quantity: $quantity, unit: $unit, name: $name, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IngredientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, quantity, unit, name, sortOrder);

  /// Create a copy of Ingredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IngredientImplCopyWith<_$IngredientImpl> get copyWith =>
      __$$IngredientImplCopyWithImpl<_$IngredientImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IngredientImplToJson(this);
  }
}

abstract class _Ingredient implements Ingredient {
  const factory _Ingredient({
    required final String id,
    @JsonKey(fromJson: _stringOrNumToDouble) final double? quantity,
    final String? unit,
    required final String name,
    @JsonKey(name: 'sort_order') final int sortOrder,
  }) = _$IngredientImpl;

  factory _Ingredient.fromJson(Map<String, dynamic> json) =
      _$IngredientImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(fromJson: _stringOrNumToDouble)
  double? get quantity;
  @override
  String? get unit;
  @override
  String get name;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;

  /// Create a copy of Ingredient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IngredientImplCopyWith<_$IngredientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Step _$StepFromJson(Map<String, dynamic> json) {
  return _Step.fromJson(json);
}

/// @nodoc
mixin _$Step {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;

  /// Serializes this Step to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Step
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StepCopyWith<Step> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StepCopyWith<$Res> {
  factory $StepCopyWith(Step value, $Res Function(Step) then) =
      _$StepCopyWithImpl<$Res, Step>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'sort_order') int sortOrder,
    String body,
  });
}

/// @nodoc
class _$StepCopyWithImpl<$Res, $Val extends Step>
    implements $StepCopyWith<$Res> {
  _$StepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Step
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sortOrder = null,
    Object? body = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StepImplCopyWith<$Res> implements $StepCopyWith<$Res> {
  factory _$$StepImplCopyWith(
    _$StepImpl value,
    $Res Function(_$StepImpl) then,
  ) = __$$StepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'sort_order') int sortOrder,
    String body,
  });
}

/// @nodoc
class __$$StepImplCopyWithImpl<$Res>
    extends _$StepCopyWithImpl<$Res, _$StepImpl>
    implements _$$StepImplCopyWith<$Res> {
  __$$StepImplCopyWithImpl(_$StepImpl _value, $Res Function(_$StepImpl) _then)
    : super(_value, _then);

  /// Create a copy of Step
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sortOrder = null,
    Object? body = null,
  }) {
    return _then(
      _$StepImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StepImpl implements _Step {
  const _$StepImpl({
    required this.id,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    required this.body,
  });

  factory _$StepImpl.fromJson(Map<String, dynamic> json) =>
      _$$StepImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  final String body;

  @override
  String toString() {
    return 'Step(id: $id, sortOrder: $sortOrder, body: $body)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StepImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, sortOrder, body);

  /// Create a copy of Step
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StepImplCopyWith<_$StepImpl> get copyWith =>
      __$$StepImplCopyWithImpl<_$StepImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StepImplToJson(this);
  }
}

abstract class _Step implements Step {
  const factory _Step({
    required final String id,
    @JsonKey(name: 'sort_order') final int sortOrder,
    required final String body,
  }) = _$StepImpl;

  factory _Step.fromJson(Map<String, dynamic> json) = _$StepImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  String get body;

  /// Create a copy of Step
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StepImplCopyWith<_$StepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpiceRouteSummary _$SpiceRouteSummaryFromJson(Map<String, dynamic> json) {
  return _SpiceRouteSummary.fromJson(json);
}

/// @nodoc
mixin _$SpiceRouteSummary {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'prep_minutes')
  int get prepMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'cook_minutes')
  int get cookMinutes => throw _privateConstructorUsedError;
  int get servings => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_public')
  bool get isPublic => throw _privateConstructorUsedError;
  SpiceRouteOwner get owner => throw _privateConstructorUsedError;
  List<Tag> get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_favorite')
  bool get isFavorite => throw _privateConstructorUsedError;

  /// Serializes this SpiceRouteSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpiceRouteSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpiceRouteSummaryCopyWith<SpiceRouteSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpiceRouteSummaryCopyWith<$Res> {
  factory $SpiceRouteSummaryCopyWith(
    SpiceRouteSummary value,
    $Res Function(SpiceRouteSummary) then,
  ) = _$SpiceRouteSummaryCopyWithImpl<$Res, SpiceRouteSummary>;
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    @JsonKey(name: 'prep_minutes') int prepMinutes,
    @JsonKey(name: 'cook_minutes') int cookMinutes,
    int servings,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_public') bool isPublic,
    SpiceRouteOwner owner,
    List<Tag> tags,
    @JsonKey(name: 'is_favorite') bool isFavorite,
  });

  $SpiceRouteOwnerCopyWith<$Res> get owner;
}

/// @nodoc
class _$SpiceRouteSummaryCopyWithImpl<$Res, $Val extends SpiceRouteSummary>
    implements $SpiceRouteSummaryCopyWith<$Res> {
  _$SpiceRouteSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpiceRouteSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? prepMinutes = null,
    Object? cookMinutes = null,
    Object? servings = null,
    Object? imageUrl = freezed,
    Object? isPublic = null,
    Object? owner = null,
    Object? tags = null,
    Object? isFavorite = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            prepMinutes: null == prepMinutes
                ? _value.prepMinutes
                : prepMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            cookMinutes: null == cookMinutes
                ? _value.cookMinutes
                : cookMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            servings: null == servings
                ? _value.servings
                : servings // ignore: cast_nullable_to_non_nullable
                      as int,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPublic: null == isPublic
                ? _value.isPublic
                : isPublic // ignore: cast_nullable_to_non_nullable
                      as bool,
            owner: null == owner
                ? _value.owner
                : owner // ignore: cast_nullable_to_non_nullable
                      as SpiceRouteOwner,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<Tag>,
            isFavorite: null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of SpiceRouteSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpiceRouteOwnerCopyWith<$Res> get owner {
    return $SpiceRouteOwnerCopyWith<$Res>(_value.owner, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SpiceRouteSummaryImplCopyWith<$Res>
    implements $SpiceRouteSummaryCopyWith<$Res> {
  factory _$$SpiceRouteSummaryImplCopyWith(
    _$SpiceRouteSummaryImpl value,
    $Res Function(_$SpiceRouteSummaryImpl) then,
  ) = __$$SpiceRouteSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    @JsonKey(name: 'prep_minutes') int prepMinutes,
    @JsonKey(name: 'cook_minutes') int cookMinutes,
    int servings,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_public') bool isPublic,
    SpiceRouteOwner owner,
    List<Tag> tags,
    @JsonKey(name: 'is_favorite') bool isFavorite,
  });

  @override
  $SpiceRouteOwnerCopyWith<$Res> get owner;
}

/// @nodoc
class __$$SpiceRouteSummaryImplCopyWithImpl<$Res>
    extends _$SpiceRouteSummaryCopyWithImpl<$Res, _$SpiceRouteSummaryImpl>
    implements _$$SpiceRouteSummaryImplCopyWith<$Res> {
  __$$SpiceRouteSummaryImplCopyWithImpl(
    _$SpiceRouteSummaryImpl _value,
    $Res Function(_$SpiceRouteSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpiceRouteSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? prepMinutes = null,
    Object? cookMinutes = null,
    Object? servings = null,
    Object? imageUrl = freezed,
    Object? isPublic = null,
    Object? owner = null,
    Object? tags = null,
    Object? isFavorite = null,
  }) {
    return _then(
      _$SpiceRouteSummaryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        prepMinutes: null == prepMinutes
            ? _value.prepMinutes
            : prepMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        cookMinutes: null == cookMinutes
            ? _value.cookMinutes
            : cookMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        servings: null == servings
            ? _value.servings
            : servings // ignore: cast_nullable_to_non_nullable
                  as int,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPublic: null == isPublic
            ? _value.isPublic
            : isPublic // ignore: cast_nullable_to_non_nullable
                  as bool,
        owner: null == owner
            ? _value.owner
            : owner // ignore: cast_nullable_to_non_nullable
                  as SpiceRouteOwner,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<Tag>,
        isFavorite: null == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SpiceRouteSummaryImpl implements _SpiceRouteSummary {
  const _$SpiceRouteSummaryImpl({
    required this.id,
    required this.title,
    this.description,
    @JsonKey(name: 'prep_minutes') this.prepMinutes = 0,
    @JsonKey(name: 'cook_minutes') this.cookMinutes = 0,
    this.servings = 1,
    @JsonKey(name: 'image_url') this.imageUrl,
    @JsonKey(name: 'is_public') this.isPublic = false,
    required this.owner,
    final List<Tag> tags = const <Tag>[],
    @JsonKey(name: 'is_favorite') this.isFavorite = false,
  }) : _tags = tags;

  factory _$SpiceRouteSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpiceRouteSummaryImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'prep_minutes')
  final int prepMinutes;
  @override
  @JsonKey(name: 'cook_minutes')
  final int cookMinutes;
  @override
  @JsonKey()
  final int servings;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'is_public')
  final bool isPublic;
  @override
  final SpiceRouteOwner owner;
  final List<Tag> _tags;
  @override
  @JsonKey()
  List<Tag> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey(name: 'is_favorite')
  final bool isFavorite;

  @override
  String toString() {
    return 'SpiceRouteSummary(id: $id, title: $title, description: $description, prepMinutes: $prepMinutes, cookMinutes: $cookMinutes, servings: $servings, imageUrl: $imageUrl, isPublic: $isPublic, owner: $owner, tags: $tags, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpiceRouteSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.prepMinutes, prepMinutes) ||
                other.prepMinutes == prepMinutes) &&
            (identical(other.cookMinutes, cookMinutes) ||
                other.cookMinutes == cookMinutes) &&
            (identical(other.servings, servings) ||
                other.servings == servings) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    prepMinutes,
    cookMinutes,
    servings,
    imageUrl,
    isPublic,
    owner,
    const DeepCollectionEquality().hash(_tags),
    isFavorite,
  );

  /// Create a copy of SpiceRouteSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpiceRouteSummaryImplCopyWith<_$SpiceRouteSummaryImpl> get copyWith =>
      __$$SpiceRouteSummaryImplCopyWithImpl<_$SpiceRouteSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SpiceRouteSummaryImplToJson(this);
  }
}

abstract class _SpiceRouteSummary implements SpiceRouteSummary {
  const factory _SpiceRouteSummary({
    required final String id,
    required final String title,
    final String? description,
    @JsonKey(name: 'prep_minutes') final int prepMinutes,
    @JsonKey(name: 'cook_minutes') final int cookMinutes,
    final int servings,
    @JsonKey(name: 'image_url') final String? imageUrl,
    @JsonKey(name: 'is_public') final bool isPublic,
    required final SpiceRouteOwner owner,
    final List<Tag> tags,
    @JsonKey(name: 'is_favorite') final bool isFavorite,
  }) = _$SpiceRouteSummaryImpl;

  factory _SpiceRouteSummary.fromJson(Map<String, dynamic> json) =
      _$SpiceRouteSummaryImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'prep_minutes')
  int get prepMinutes;
  @override
  @JsonKey(name: 'cook_minutes')
  int get cookMinutes;
  @override
  int get servings;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'is_public')
  bool get isPublic;
  @override
  SpiceRouteOwner get owner;
  @override
  List<Tag> get tags;
  @override
  @JsonKey(name: 'is_favorite')
  bool get isFavorite;

  /// Create a copy of SpiceRouteSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpiceRouteSummaryImplCopyWith<_$SpiceRouteSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpiceRouteDetail _$SpiceRouteDetailFromJson(Map<String, dynamic> json) {
  return _SpiceRouteDetail.fromJson(json);
}

/// @nodoc
mixin _$SpiceRouteDetail {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'prep_minutes')
  int get prepMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'cook_minutes')
  int get cookMinutes => throw _privateConstructorUsedError;
  int get servings => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_public')
  bool get isPublic => throw _privateConstructorUsedError;
  SpiceRouteOwner get owner => throw _privateConstructorUsedError;
  List<Tag> get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_favorite')
  bool get isFavorite => throw _privateConstructorUsedError;
  List<Ingredient> get ingredients => throw _privateConstructorUsedError;
  List<Step> get steps => throw _privateConstructorUsedError;

  /// Serializes this SpiceRouteDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpiceRouteDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpiceRouteDetailCopyWith<SpiceRouteDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpiceRouteDetailCopyWith<$Res> {
  factory $SpiceRouteDetailCopyWith(
    SpiceRouteDetail value,
    $Res Function(SpiceRouteDetail) then,
  ) = _$SpiceRouteDetailCopyWithImpl<$Res, SpiceRouteDetail>;
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    @JsonKey(name: 'prep_minutes') int prepMinutes,
    @JsonKey(name: 'cook_minutes') int cookMinutes,
    int servings,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_public') bool isPublic,
    SpiceRouteOwner owner,
    List<Tag> tags,
    @JsonKey(name: 'is_favorite') bool isFavorite,
    List<Ingredient> ingredients,
    List<Step> steps,
  });

  $SpiceRouteOwnerCopyWith<$Res> get owner;
}

/// @nodoc
class _$SpiceRouteDetailCopyWithImpl<$Res, $Val extends SpiceRouteDetail>
    implements $SpiceRouteDetailCopyWith<$Res> {
  _$SpiceRouteDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpiceRouteDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? prepMinutes = null,
    Object? cookMinutes = null,
    Object? servings = null,
    Object? imageUrl = freezed,
    Object? isPublic = null,
    Object? owner = null,
    Object? tags = null,
    Object? isFavorite = null,
    Object? ingredients = null,
    Object? steps = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            prepMinutes: null == prepMinutes
                ? _value.prepMinutes
                : prepMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            cookMinutes: null == cookMinutes
                ? _value.cookMinutes
                : cookMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            servings: null == servings
                ? _value.servings
                : servings // ignore: cast_nullable_to_non_nullable
                      as int,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPublic: null == isPublic
                ? _value.isPublic
                : isPublic // ignore: cast_nullable_to_non_nullable
                      as bool,
            owner: null == owner
                ? _value.owner
                : owner // ignore: cast_nullable_to_non_nullable
                      as SpiceRouteOwner,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<Tag>,
            isFavorite: null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
            ingredients: null == ingredients
                ? _value.ingredients
                : ingredients // ignore: cast_nullable_to_non_nullable
                      as List<Ingredient>,
            steps: null == steps
                ? _value.steps
                : steps // ignore: cast_nullable_to_non_nullable
                      as List<Step>,
          )
          as $Val,
    );
  }

  /// Create a copy of SpiceRouteDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpiceRouteOwnerCopyWith<$Res> get owner {
    return $SpiceRouteOwnerCopyWith<$Res>(_value.owner, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SpiceRouteDetailImplCopyWith<$Res>
    implements $SpiceRouteDetailCopyWith<$Res> {
  factory _$$SpiceRouteDetailImplCopyWith(
    _$SpiceRouteDetailImpl value,
    $Res Function(_$SpiceRouteDetailImpl) then,
  ) = __$$SpiceRouteDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    @JsonKey(name: 'prep_minutes') int prepMinutes,
    @JsonKey(name: 'cook_minutes') int cookMinutes,
    int servings,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_public') bool isPublic,
    SpiceRouteOwner owner,
    List<Tag> tags,
    @JsonKey(name: 'is_favorite') bool isFavorite,
    List<Ingredient> ingredients,
    List<Step> steps,
  });

  @override
  $SpiceRouteOwnerCopyWith<$Res> get owner;
}

/// @nodoc
class __$$SpiceRouteDetailImplCopyWithImpl<$Res>
    extends _$SpiceRouteDetailCopyWithImpl<$Res, _$SpiceRouteDetailImpl>
    implements _$$SpiceRouteDetailImplCopyWith<$Res> {
  __$$SpiceRouteDetailImplCopyWithImpl(
    _$SpiceRouteDetailImpl _value,
    $Res Function(_$SpiceRouteDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpiceRouteDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? prepMinutes = null,
    Object? cookMinutes = null,
    Object? servings = null,
    Object? imageUrl = freezed,
    Object? isPublic = null,
    Object? owner = null,
    Object? tags = null,
    Object? isFavorite = null,
    Object? ingredients = null,
    Object? steps = null,
  }) {
    return _then(
      _$SpiceRouteDetailImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        prepMinutes: null == prepMinutes
            ? _value.prepMinutes
            : prepMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        cookMinutes: null == cookMinutes
            ? _value.cookMinutes
            : cookMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        servings: null == servings
            ? _value.servings
            : servings // ignore: cast_nullable_to_non_nullable
                  as int,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPublic: null == isPublic
            ? _value.isPublic
            : isPublic // ignore: cast_nullable_to_non_nullable
                  as bool,
        owner: null == owner
            ? _value.owner
            : owner // ignore: cast_nullable_to_non_nullable
                  as SpiceRouteOwner,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<Tag>,
        isFavorite: null == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
        ingredients: null == ingredients
            ? _value._ingredients
            : ingredients // ignore: cast_nullable_to_non_nullable
                  as List<Ingredient>,
        steps: null == steps
            ? _value._steps
            : steps // ignore: cast_nullable_to_non_nullable
                  as List<Step>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SpiceRouteDetailImpl implements _SpiceRouteDetail {
  const _$SpiceRouteDetailImpl({
    required this.id,
    required this.title,
    this.description,
    @JsonKey(name: 'prep_minutes') this.prepMinutes = 0,
    @JsonKey(name: 'cook_minutes') this.cookMinutes = 0,
    this.servings = 1,
    @JsonKey(name: 'image_url') this.imageUrl,
    @JsonKey(name: 'is_public') this.isPublic = false,
    required this.owner,
    final List<Tag> tags = const <Tag>[],
    @JsonKey(name: 'is_favorite') this.isFavorite = false,
    final List<Ingredient> ingredients = const <Ingredient>[],
    final List<Step> steps = const <Step>[],
  }) : _tags = tags,
       _ingredients = ingredients,
       _steps = steps;

  factory _$SpiceRouteDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpiceRouteDetailImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'prep_minutes')
  final int prepMinutes;
  @override
  @JsonKey(name: 'cook_minutes')
  final int cookMinutes;
  @override
  @JsonKey()
  final int servings;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'is_public')
  final bool isPublic;
  @override
  final SpiceRouteOwner owner;
  final List<Tag> _tags;
  @override
  @JsonKey()
  List<Tag> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey(name: 'is_favorite')
  final bool isFavorite;
  final List<Ingredient> _ingredients;
  @override
  @JsonKey()
  List<Ingredient> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  final List<Step> _steps;
  @override
  @JsonKey()
  List<Step> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  String toString() {
    return 'SpiceRouteDetail(id: $id, title: $title, description: $description, prepMinutes: $prepMinutes, cookMinutes: $cookMinutes, servings: $servings, imageUrl: $imageUrl, isPublic: $isPublic, owner: $owner, tags: $tags, isFavorite: $isFavorite, ingredients: $ingredients, steps: $steps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpiceRouteDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.prepMinutes, prepMinutes) ||
                other.prepMinutes == prepMinutes) &&
            (identical(other.cookMinutes, cookMinutes) ||
                other.cookMinutes == cookMinutes) &&
            (identical(other.servings, servings) ||
                other.servings == servings) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            const DeepCollectionEquality().equals(
              other._ingredients,
              _ingredients,
            ) &&
            const DeepCollectionEquality().equals(other._steps, _steps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    prepMinutes,
    cookMinutes,
    servings,
    imageUrl,
    isPublic,
    owner,
    const DeepCollectionEquality().hash(_tags),
    isFavorite,
    const DeepCollectionEquality().hash(_ingredients),
    const DeepCollectionEquality().hash(_steps),
  );

  /// Create a copy of SpiceRouteDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpiceRouteDetailImplCopyWith<_$SpiceRouteDetailImpl> get copyWith =>
      __$$SpiceRouteDetailImplCopyWithImpl<_$SpiceRouteDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SpiceRouteDetailImplToJson(this);
  }
}

abstract class _SpiceRouteDetail implements SpiceRouteDetail {
  const factory _SpiceRouteDetail({
    required final String id,
    required final String title,
    final String? description,
    @JsonKey(name: 'prep_minutes') final int prepMinutes,
    @JsonKey(name: 'cook_minutes') final int cookMinutes,
    final int servings,
    @JsonKey(name: 'image_url') final String? imageUrl,
    @JsonKey(name: 'is_public') final bool isPublic,
    required final SpiceRouteOwner owner,
    final List<Tag> tags,
    @JsonKey(name: 'is_favorite') final bool isFavorite,
    final List<Ingredient> ingredients,
    final List<Step> steps,
  }) = _$SpiceRouteDetailImpl;

  factory _SpiceRouteDetail.fromJson(Map<String, dynamic> json) =
      _$SpiceRouteDetailImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'prep_minutes')
  int get prepMinutes;
  @override
  @JsonKey(name: 'cook_minutes')
  int get cookMinutes;
  @override
  int get servings;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'is_public')
  bool get isPublic;
  @override
  SpiceRouteOwner get owner;
  @override
  List<Tag> get tags;
  @override
  @JsonKey(name: 'is_favorite')
  bool get isFavorite;
  @override
  List<Ingredient> get ingredients;
  @override
  List<Step> get steps;

  /// Create a copy of SpiceRouteDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpiceRouteDetailImplCopyWith<_$SpiceRouteDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpiceRouteListResponse _$SpiceRouteListResponseFromJson(
  Map<String, dynamic> json,
) {
  return _SpiceRouteListResponse.fromJson(json);
}

/// @nodoc
mixin _$SpiceRouteListResponse {
  List<SpiceRouteSummary> get items => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get offset => throw _privateConstructorUsedError;

  /// Serializes this SpiceRouteListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpiceRouteListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpiceRouteListResponseCopyWith<SpiceRouteListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpiceRouteListResponseCopyWith<$Res> {
  factory $SpiceRouteListResponseCopyWith(
    SpiceRouteListResponse value,
    $Res Function(SpiceRouteListResponse) then,
  ) = _$SpiceRouteListResponseCopyWithImpl<$Res, SpiceRouteListResponse>;
  @useResult
  $Res call({List<SpiceRouteSummary> items, int total, int limit, int offset});
}

/// @nodoc
class _$SpiceRouteListResponseCopyWithImpl<
  $Res,
  $Val extends SpiceRouteListResponse
>
    implements $SpiceRouteListResponseCopyWith<$Res> {
  _$SpiceRouteListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpiceRouteListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<SpiceRouteSummary>,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            offset: null == offset
                ? _value.offset
                : offset // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SpiceRouteListResponseImplCopyWith<$Res>
    implements $SpiceRouteListResponseCopyWith<$Res> {
  factory _$$SpiceRouteListResponseImplCopyWith(
    _$SpiceRouteListResponseImpl value,
    $Res Function(_$SpiceRouteListResponseImpl) then,
  ) = __$$SpiceRouteListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SpiceRouteSummary> items, int total, int limit, int offset});
}

/// @nodoc
class __$$SpiceRouteListResponseImplCopyWithImpl<$Res>
    extends
        _$SpiceRouteListResponseCopyWithImpl<$Res, _$SpiceRouteListResponseImpl>
    implements _$$SpiceRouteListResponseImplCopyWith<$Res> {
  __$$SpiceRouteListResponseImplCopyWithImpl(
    _$SpiceRouteListResponseImpl _value,
    $Res Function(_$SpiceRouteListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpiceRouteListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(
      _$SpiceRouteListResponseImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<SpiceRouteSummary>,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        offset: null == offset
            ? _value.offset
            : offset // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SpiceRouteListResponseImpl implements _SpiceRouteListResponse {
  const _$SpiceRouteListResponseImpl({
    final List<SpiceRouteSummary> items = const <SpiceRouteSummary>[],
    this.total = 0,
    this.limit = 20,
    this.offset = 0,
  }) : _items = items;

  factory _$SpiceRouteListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpiceRouteListResponseImplFromJson(json);

  final List<SpiceRouteSummary> _items;
  @override
  @JsonKey()
  List<SpiceRouteSummary> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final int limit;
  @override
  @JsonKey()
  final int offset;

  @override
  String toString() {
    return 'SpiceRouteListResponse(items: $items, total: $total, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpiceRouteListResponseImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    total,
    limit,
    offset,
  );

  /// Create a copy of SpiceRouteListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpiceRouteListResponseImplCopyWith<_$SpiceRouteListResponseImpl>
  get copyWith =>
      __$$SpiceRouteListResponseImplCopyWithImpl<_$SpiceRouteListResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SpiceRouteListResponseImplToJson(this);
  }
}

abstract class _SpiceRouteListResponse implements SpiceRouteListResponse {
  const factory _SpiceRouteListResponse({
    final List<SpiceRouteSummary> items,
    final int total,
    final int limit,
    final int offset,
  }) = _$SpiceRouteListResponseImpl;

  factory _SpiceRouteListResponse.fromJson(Map<String, dynamic> json) =
      _$SpiceRouteListResponseImpl.fromJson;

  @override
  List<SpiceRouteSummary> get items;
  @override
  int get total;
  @override
  int get limit;
  @override
  int get offset;

  /// Create a copy of SpiceRouteListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpiceRouteListResponseImplCopyWith<_$SpiceRouteListResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
