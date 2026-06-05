// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TokenPair _$TokenPairFromJson(Map<String, dynamic> json) {
  return _TokenPair.fromJson(json);
}

/// @nodoc
mixin _$TokenPair {
  @JsonKey(name: 'access_token')
  String get accessToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'refresh_token')
  String get refreshToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'token_type')
  String get tokenType => throw _privateConstructorUsedError;

  /// Serializes this TokenPair to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TokenPair
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TokenPairCopyWith<TokenPair> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TokenPairCopyWith<$Res> {
  factory $TokenPairCopyWith(TokenPair value, $Res Function(TokenPair) then) =
      _$TokenPairCopyWithImpl<$Res, TokenPair>;
  @useResult
  $Res call({
    @JsonKey(name: 'access_token') String accessToken,
    @JsonKey(name: 'refresh_token') String refreshToken,
    @JsonKey(name: 'token_type') String tokenType,
  });
}

/// @nodoc
class _$TokenPairCopyWithImpl<$Res, $Val extends TokenPair>
    implements $TokenPairCopyWith<$Res> {
  _$TokenPairCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TokenPair
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenType = null,
  }) {
    return _then(
      _value.copyWith(
            accessToken: null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String,
            refreshToken: null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String,
            tokenType: null == tokenType
                ? _value.tokenType
                : tokenType // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TokenPairImplCopyWith<$Res>
    implements $TokenPairCopyWith<$Res> {
  factory _$$TokenPairImplCopyWith(
    _$TokenPairImpl value,
    $Res Function(_$TokenPairImpl) then,
  ) = __$$TokenPairImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'access_token') String accessToken,
    @JsonKey(name: 'refresh_token') String refreshToken,
    @JsonKey(name: 'token_type') String tokenType,
  });
}

/// @nodoc
class __$$TokenPairImplCopyWithImpl<$Res>
    extends _$TokenPairCopyWithImpl<$Res, _$TokenPairImpl>
    implements _$$TokenPairImplCopyWith<$Res> {
  __$$TokenPairImplCopyWithImpl(
    _$TokenPairImpl _value,
    $Res Function(_$TokenPairImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TokenPair
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenType = null,
  }) {
    return _then(
      _$TokenPairImpl(
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
        tokenType: null == tokenType
            ? _value.tokenType
            : tokenType // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TokenPairImpl implements _TokenPair {
  const _$TokenPairImpl({
    @JsonKey(name: 'access_token') required this.accessToken,
    @JsonKey(name: 'refresh_token') required this.refreshToken,
    @JsonKey(name: 'token_type') this.tokenType = 'bearer',
  });

  factory _$TokenPairImpl.fromJson(Map<String, dynamic> json) =>
      _$$TokenPairImplFromJson(json);

  @override
  @JsonKey(name: 'access_token')
  final String accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @override
  @JsonKey(name: 'token_type')
  final String tokenType;

  @override
  String toString() {
    return 'TokenPair(accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TokenPairImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, accessToken, refreshToken, tokenType);

  /// Create a copy of TokenPair
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TokenPairImplCopyWith<_$TokenPairImpl> get copyWith =>
      __$$TokenPairImplCopyWithImpl<_$TokenPairImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TokenPairImplToJson(this);
  }
}

abstract class _TokenPair implements TokenPair {
  const factory _TokenPair({
    @JsonKey(name: 'access_token') required final String accessToken,
    @JsonKey(name: 'refresh_token') required final String refreshToken,
    @JsonKey(name: 'token_type') final String tokenType,
  }) = _$TokenPairImpl;

  factory _TokenPair.fromJson(Map<String, dynamic> json) =
      _$TokenPairImpl.fromJson;

  @override
  @JsonKey(name: 'access_token')
  String get accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  String get refreshToken;
  @override
  @JsonKey(name: 'token_type')
  String get tokenType;

  /// Create a copy of TokenPair
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TokenPairImplCopyWith<_$TokenPairImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AccessToken _$AccessTokenFromJson(Map<String, dynamic> json) {
  return _AccessToken.fromJson(json);
}

/// @nodoc
mixin _$AccessToken {
  @JsonKey(name: 'access_token')
  String get accessToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'token_type')
  String get tokenType => throw _privateConstructorUsedError;

  /// Serializes this AccessToken to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccessToken
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccessTokenCopyWith<AccessToken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccessTokenCopyWith<$Res> {
  factory $AccessTokenCopyWith(
    AccessToken value,
    $Res Function(AccessToken) then,
  ) = _$AccessTokenCopyWithImpl<$Res, AccessToken>;
  @useResult
  $Res call({
    @JsonKey(name: 'access_token') String accessToken,
    @JsonKey(name: 'token_type') String tokenType,
  });
}

/// @nodoc
class _$AccessTokenCopyWithImpl<$Res, $Val extends AccessToken>
    implements $AccessTokenCopyWith<$Res> {
  _$AccessTokenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccessToken
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? accessToken = null, Object? tokenType = null}) {
    return _then(
      _value.copyWith(
            accessToken: null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String,
            tokenType: null == tokenType
                ? _value.tokenType
                : tokenType // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AccessTokenImplCopyWith<$Res>
    implements $AccessTokenCopyWith<$Res> {
  factory _$$AccessTokenImplCopyWith(
    _$AccessTokenImpl value,
    $Res Function(_$AccessTokenImpl) then,
  ) = __$$AccessTokenImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'access_token') String accessToken,
    @JsonKey(name: 'token_type') String tokenType,
  });
}

/// @nodoc
class __$$AccessTokenImplCopyWithImpl<$Res>
    extends _$AccessTokenCopyWithImpl<$Res, _$AccessTokenImpl>
    implements _$$AccessTokenImplCopyWith<$Res> {
  __$$AccessTokenImplCopyWithImpl(
    _$AccessTokenImpl _value,
    $Res Function(_$AccessTokenImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AccessToken
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? accessToken = null, Object? tokenType = null}) {
    return _then(
      _$AccessTokenImpl(
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        tokenType: null == tokenType
            ? _value.tokenType
            : tokenType // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AccessTokenImpl implements _AccessToken {
  const _$AccessTokenImpl({
    @JsonKey(name: 'access_token') required this.accessToken,
    @JsonKey(name: 'token_type') this.tokenType = 'bearer',
  });

  factory _$AccessTokenImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccessTokenImplFromJson(json);

  @override
  @JsonKey(name: 'access_token')
  final String accessToken;
  @override
  @JsonKey(name: 'token_type')
  final String tokenType;

  @override
  String toString() {
    return 'AccessToken(accessToken: $accessToken, tokenType: $tokenType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccessTokenImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accessToken, tokenType);

  /// Create a copy of AccessToken
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccessTokenImplCopyWith<_$AccessTokenImpl> get copyWith =>
      __$$AccessTokenImplCopyWithImpl<_$AccessTokenImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccessTokenImplToJson(this);
  }
}

abstract class _AccessToken implements AccessToken {
  const factory _AccessToken({
    @JsonKey(name: 'access_token') required final String accessToken,
    @JsonKey(name: 'token_type') final String tokenType,
  }) = _$AccessTokenImpl;

  factory _AccessToken.fromJson(Map<String, dynamic> json) =
      _$AccessTokenImpl.fromJson;

  @override
  @JsonKey(name: 'access_token')
  String get accessToken;
  @override
  @JsonKey(name: 'token_type')
  String get tokenType;

  /// Create a copy of AccessToken
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccessTokenImplCopyWith<_$AccessTokenImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserPublic _$UserPublicFromJson(Map<String, dynamic> json) {
  return _UserPublic.fromJson(json);
}

/// @nodoc
mixin _$UserPublic {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String get displayName => throw _privateConstructorUsedError;

  /// Serializes this UserPublic to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserPublic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPublicCopyWith<UserPublic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPublicCopyWith<$Res> {
  factory $UserPublicCopyWith(
    UserPublic value,
    $Res Function(UserPublic) then,
  ) = _$UserPublicCopyWithImpl<$Res, UserPublic>;
  @useResult
  $Res call({
    String id,
    String email,
    @JsonKey(name: 'display_name') String displayName,
  });
}

/// @nodoc
class _$UserPublicCopyWithImpl<$Res, $Val extends UserPublic>
    implements $UserPublicCopyWith<$Res> {
  _$UserPublicCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPublic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
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
abstract class _$$UserPublicImplCopyWith<$Res>
    implements $UserPublicCopyWith<$Res> {
  factory _$$UserPublicImplCopyWith(
    _$UserPublicImpl value,
    $Res Function(_$UserPublicImpl) then,
  ) = __$$UserPublicImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    @JsonKey(name: 'display_name') String displayName,
  });
}

/// @nodoc
class __$$UserPublicImplCopyWithImpl<$Res>
    extends _$UserPublicCopyWithImpl<$Res, _$UserPublicImpl>
    implements _$$UserPublicImplCopyWith<$Res> {
  __$$UserPublicImplCopyWithImpl(
    _$UserPublicImpl _value,
    $Res Function(_$UserPublicImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserPublic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = null,
  }) {
    return _then(
      _$UserPublicImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
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
class _$UserPublicImpl implements _UserPublic {
  const _$UserPublicImpl({
    required this.id,
    required this.email,
    @JsonKey(name: 'display_name') required this.displayName,
  });

  factory _$UserPublicImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPublicImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  @JsonKey(name: 'display_name')
  final String displayName;

  @override
  String toString() {
    return 'UserPublic(id: $id, email: $email, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPublicImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, displayName);

  /// Create a copy of UserPublic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPublicImplCopyWith<_$UserPublicImpl> get copyWith =>
      __$$UserPublicImplCopyWithImpl<_$UserPublicImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPublicImplToJson(this);
  }
}

abstract class _UserPublic implements UserPublic {
  const factory _UserPublic({
    required final String id,
    required final String email,
    @JsonKey(name: 'display_name') required final String displayName,
  }) = _$UserPublicImpl;

  factory _UserPublic.fromJson(Map<String, dynamic> json) =
      _$UserPublicImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  @JsonKey(name: 'display_name')
  String get displayName;

  /// Create a copy of UserPublic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPublicImplCopyWith<_$UserPublicImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
