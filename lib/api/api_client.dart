import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/auth.dart';
import '../models/spice_route.dart';
import '../shared/config.dart';
import 'token_store.dart';

class ApiException implements Exception {
  ApiException(this.statusCode, this.message);
  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient(this.tokens) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors.add(_AuthInterceptor(this));
  }

  final TokenStore tokens;
  late final Dio _dio;
  Dio get dio => _dio;

  /// Called when the refresh flow fails (i.e. user must re-authenticate).
  /// The auth controller listens to this so the UI can react and the router
  /// can bounce the user back to the login screen.
  VoidCallback? onUnauthorized;

  Future<TokenPair> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final res = await _dio.post(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'display_name': displayName,
      },
    );
    final pair = TokenPair.fromJson(res.data as Map<String, dynamic>);
    await tokens.write(access: pair.accessToken, refresh: pair.refreshToken);
    return pair;
  }

  Future<TokenPair> login({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    final pair = TokenPair.fromJson(res.data as Map<String, dynamic>);
    await tokens.write(access: pair.accessToken, refresh: pair.refreshToken);
    return pair;
  }

  Future<void> logout() => tokens.clear();

  Future<UserPublic> me() async {
    final res = await _dio.get('/auth/me');
    return UserPublic.fromJson(res.data as Map<String, dynamic>);
  }

  Future<AccessToken> refresh(String refreshToken) async {
    final res = await _dio.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
      options: Options(headers: {'Authorization': null}),
    );
    return AccessToken.fromJson(res.data as Map<String, dynamic>);
  }

  Future<SpiceRouteListResponse> listSpiceRoutes({
    String? q,
    String? tag,
    int? maxMinutes,
    bool mineOnly = false,
    bool favoritesOnly = false,
    int limit = 20,
    int offset = 0,
  }) async {
    final res = await _dio.get(
      '/spice_routes',
      queryParameters: {
        if (q != null && q.isNotEmpty) 'q': q,
        if (tag != null && tag.isNotEmpty) 'tag': tag,
        // ignore: use_null_aware_elements
        if (maxMinutes != null) 'max_minutes': maxMinutes,
        if (mineOnly) 'mine_only': true,
        if (favoritesOnly) 'favorites_only': true,
        'limit': limit,
        'offset': offset,
      },
    );
    return SpiceRouteListResponse.fromJson(res.data as Map<String, dynamic>);
  }

  Future<SpiceRouteDetail> getSpiceRoute(String id) async {
    final res = await _dio.get('/spice_routes/$id');
    return SpiceRouteDetail.fromJson(res.data as Map<String, dynamic>);
  }

  Future<SpiceRouteDetail> createSpiceRoute(Map<String, dynamic> body) async {
    final res = await _dio.post('/spice_routes', data: body);
    return SpiceRouteDetail.fromJson(res.data as Map<String, dynamic>);
  }

  Future<SpiceRouteDetail> updateSpiceRoute(
      String id, Map<String, dynamic> body) async {
    final res = await _dio.patch('/spice_routes/$id', data: body);
    return SpiceRouteDetail.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> deleteSpiceRoute(String id) async {
    await _dio.delete('/spice_routes/$id');
  }

  Future<String> uploadImage(
    String spiceRouteId, {
    required Uint8List bytes,
    required String filename,
    required String mimeType,
  }) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: filename,
        contentType: DioMediaType.parse(mimeType),
      ),
    });
    final res =
        await _dio.post('/spice_routes/$spiceRouteId/image', data: form);
    return (res.data as Map<String, dynamic>)['image_url'] as String;
  }

  Future<bool> toggleFavorite(String spiceRouteId) async {
    final res = await _dio.post('/spice_routes/$spiceRouteId/favorite');
    return (res.data as Map<String, dynamic>)['favorited'] as bool;
  }

  Future<List<SpiceRouteSummary>> listMyFavorites() async {
    final res = await _dio.get('/me/favorites');
    return (res.data as List)
        .map((j) => SpiceRouteSummary.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<List<Tag>> listTags({String? q}) async {
    final res = await _dio.get(
      '/tags',
      queryParameters: {if (q != null && q.isNotEmpty) 'q': q},
    );
    return (res.data as List)
        .map((j) => Tag.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this.api);
  final ApiClient api;

  bool _refreshing = false;
  final List<Completer<void>> _waiters = [];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.headers['Authorization'] == null) {
      final access = await api.tokens.readAccess();
      if (access != null && access.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $access';
      } else {
        options.headers.remove('Authorization');
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    final isAuthEndpoint = (err.requestOptions.path).startsWith('/auth/');
    if (response?.statusCode == 401 &&
        !isAuthEndpoint &&
        err.requestOptions.extra['retried'] != true) {
      try {
        await _ensureRefreshed();
        final access = await api.tokens.readAccess();
        if (access == null || access.isEmpty) {
          handler.next(err);
          return;
        }
        final retryOptions = err.requestOptions;
        retryOptions.headers['Authorization'] = 'Bearer $access';
        retryOptions.extra['retried'] = true;
        final retried = await api.dio.fetch(retryOptions);
        handler.resolve(retried);
        return;
      } catch (_) {
        await api.tokens.clear();
        api.onUnauthorized?.call();
      }
    }
    handler.next(err);
  }

  Future<void> _ensureRefreshed() async {
    if (_refreshing) {
      final c = Completer<void>();
      _waiters.add(c);
      return c.future;
    }
    _refreshing = true;
    try {
      final refresh = await api.tokens.readRefresh();
      if (refresh == null || refresh.isEmpty) {
        throw Exception('no refresh token');
      }
      final fresh = await api.refresh(refresh);
      await api.tokens.write(
        access: fresh.accessToken,
        refresh: refresh,
      );
      for (final c in _waiters) {
        c.complete();
      }
      _waiters.clear();
    } catch (e) {
      for (final c in _waiters) {
        c.completeError(e);
      }
      _waiters.clear();
      rethrow;
    } finally {
      _refreshing = false;
    }
  }
}

String apiErrorMessage(Object e) {
  if (e is DioException) {
    final data = e.response?.data;
    if (data is Map && data['detail'] is String) return data['detail'] as String;
    if (e.message != null) return e.message!;
  }
  return e.toString();
}
