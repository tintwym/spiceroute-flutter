// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TokenPairImpl _$$TokenPairImplFromJson(Map<String, dynamic> json) =>
    _$TokenPairImpl(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String? ?? 'bearer',
    );

Map<String, dynamic> _$$TokenPairImplToJson(_$TokenPairImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
    };

_$AccessTokenImpl _$$AccessTokenImplFromJson(Map<String, dynamic> json) =>
    _$AccessTokenImpl(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String? ?? 'bearer',
    );

Map<String, dynamic> _$$AccessTokenImplToJson(_$AccessTokenImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
    };

_$UserPublicImpl _$$UserPublicImplFromJson(Map<String, dynamic> json) =>
    _$UserPublicImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String,
    );

Map<String, dynamic> _$$UserPublicImplToJson(_$UserPublicImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'display_name': instance.displayName,
    };
