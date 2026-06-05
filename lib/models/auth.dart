import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.freezed.dart';
part 'auth.g.dart';

@freezed
class TokenPair with _$TokenPair {
  const factory TokenPair({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @Default('bearer') @JsonKey(name: 'token_type') String tokenType,
  }) = _TokenPair;

  factory TokenPair.fromJson(Map<String, dynamic> json) =>
      _$TokenPairFromJson(json);
}

@freezed
class AccessToken with _$AccessToken {
  const factory AccessToken({
    @JsonKey(name: 'access_token') required String accessToken,
    @Default('bearer') @JsonKey(name: 'token_type') String tokenType,
  }) = _AccessToken;

  factory AccessToken.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenFromJson(json);
}

@freezed
class UserPublic with _$UserPublic {
  const factory UserPublic({
    required String id,
    required String email,
    @JsonKey(name: 'display_name') required String displayName,
  }) = _UserPublic;

  factory UserPublic.fromJson(Map<String, dynamic> json) =>
      _$UserPublicFromJson(json);
}
