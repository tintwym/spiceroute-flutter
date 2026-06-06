import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/chat.dart';
import '../models/spice_route.dart';
import '../shared/config.dart';

class ApiException implements Exception {
  ApiException(this.statusCode, this.message);
  final int statusCode;
  final String message;

  bool get isRateLimited => statusCode == 429;
  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Pluggable token provider. Returns a Firebase ID token (or null) for the
/// currently signed-in user. The default no-op is used in places where we
/// haven't wired in auth yet (e.g. tests).
typedef TokenProvider = Future<String?> Function({bool forceRefresh});

class ApiClient {
  ApiClient({TokenProvider? tokenProvider}) : _tokenProvider = tokenProvider {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors.add(_authInterceptor());
  }

  final TokenProvider? _tokenProvider;
  late final Dio _dio;
  Dio get dio => _dio;

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final getter = _tokenProvider;
        if (getter != null) {
          final token = await getter(forceRefresh: false);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        handler.next(options);
      },
      onError: (e, handler) async {
        // One free retry on 401 with a force-refreshed token. Avoids most
        // "token just expired between mint and use" failures.
        final getter = _tokenProvider;
        final isRetryable = e.response?.statusCode == 401 &&
            getter != null &&
            e.requestOptions.extra['__retried__'] != true;
        if (!isRetryable) {
          handler.next(e);
          return;
        }
        try {
          final fresh = await getter(forceRefresh: true);
          if (fresh == null) {
            handler.next(e);
            return;
          }
          final retryReq = e.requestOptions
            ..headers['Authorization'] = 'Bearer $fresh'
            ..extra['__retried__'] = true;
          final retryRes = await _dio.fetch<dynamic>(retryReq);
          handler.resolve(retryRes);
        } catch (_) {
          handler.next(e);
        }
      },
    );
  }

  // ---------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------

  /// Verifies the current Firebase token with the backend and lazily
  /// provisions the local user row. Returns the user profile.
  Future<Map<String, dynamic>> me() async {
    try {
      final res = await _dio.get('/auth/me');
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  // ---------------------------------------------------------------------
  // Recipes
  // ---------------------------------------------------------------------

  Future<SpiceRouteListResponse> listRecipes({
    String? q,
    Cuisine? cuisine,
    String? language,
    String? tag,
    int? maxMinutes,
    bool premiumOnly = false,
    bool mine = false,
    int limit = 24,
    int offset = 0,
  }) async {
    try {
      final res = await _dio.get(
        '/spice_routes',
        queryParameters: {
          if (q != null && q.isNotEmpty) 'q': q,
          if (cuisine != null) 'cuisine': cuisine.wire,
          if (language != null && language.isNotEmpty) 'language': language,
          if (tag != null && tag.isNotEmpty) 'tag': tag,
          // ignore: use_null_aware_elements
          if (maxMinutes != null) 'max_minutes': maxMinutes,
          if (premiumOnly) 'premium_only': true,
          if (mine) 'mine': true,
          'limit': limit,
          'offset': offset,
        },
      );
      return SpiceRouteListResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  Future<SpiceRouteDetail> getRecipe(String id) async {
    try {
      final res = await _dio.get('/spice_routes/$id');
      return SpiceRouteDetail.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  Future<SpiceRouteDetail> createRecipe(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/spice_routes', data: payload);
      return SpiceRouteDetail.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  Future<SpiceRouteDetail> updateRecipe(
    String id,
    Map<String, dynamic> payload,
  ) async {
    try {
      final res = await _dio.patch('/spice_routes/$id', data: payload);
      return SpiceRouteDetail.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      await _dio.delete('/spice_routes/$id');
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  // ---------------------------------------------------------------------
  // AI Creator
  // ---------------------------------------------------------------------

  /// Generates a recipe and (when `save: true`) persists it to the public
  /// catalog as the caller's recipe. `save: true` requires authentication.
  Future<AiRecipeResult> generateRecipe({
    required String idea,
    Cuisine? cuisine,
    required String language,
    bool save = false,
  }) async {
    try {
      final res = await _dio.post(
        '/ai/recipe/generate',
        data: {
          'idea': idea,
          if (cuisine != null) 'cuisine': cuisine.wire,
          'language': language,
          'save': save,
        },
      );
      final data = res.data as Map<String, dynamic>;
      return AiRecipeResult.fromJson(data);
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  // ---------------------------------------------------------------------
  // AI Companion (SSE)
  // ---------------------------------------------------------------------

  /// Streams SSE deltas back as plain strings. The stream completes once the
  /// server emits its `done` event (or on socket close).
  ///
  /// Cancel by calling `.cancel()` on the returned `CancelToken` (or simply
  /// stop listening — the underlying response will be closed).
  Stream<String> chatStream({
    required List<ChatMessage> messages,
    required String language,
    CancelToken? cancelToken,
  }) async* {
    final token = cancelToken ?? CancelToken();
    Response<ResponseBody>? response;
    try {
      response = await _dio.post<ResponseBody>(
        '/ai/chat/stream',
        data: {
          'messages': messages.map((m) => m.toJson()).toList(),
          'language': language,
        },
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: const Duration(minutes: 2),
          headers: {'Accept': 'text/event-stream'},
        ),
        cancelToken: token,
      );
    } on DioException catch (e) {
      throw _toApiException(e);
    }

    final body = response.data;
    if (body == null) return;

    final raw = body.stream.cast<List<int>>().transform(utf8.decoder);
    var buffer = '';
    await for (final chunk in raw) {
      buffer += chunk;
      while (true) {
        final newlineIdx = buffer.indexOf('\n\n');
        if (newlineIdx < 0) break;
        final frame = buffer.substring(0, newlineIdx);
        buffer = buffer.substring(newlineIdx + 2);
        for (final line in const LineSplitter().convert(frame)) {
          if (!line.startsWith('data:')) continue;
          final payload = line.substring(5).trim();
          if (payload.isEmpty) continue;
          try {
            final event = jsonDecode(payload) as Map<String, dynamic>;
            switch (event['type']) {
              case 'delta':
                final text = event['text'] as String?;
                if (text != null && text.isNotEmpty) yield text;
                break;
              case 'error':
                throw ApiException(
                  502,
                  event['message']?.toString() ?? 'stream error',
                );
              case 'done':
                return;
            }
          } on FormatException {
            // ignore malformed frames
          }
        }
      }
    }
  }

  ApiException _toApiException(DioException e) {
    final statusCode = e.response?.statusCode ?? 0;
    final data = e.response?.data;
    String detail = e.message ?? 'Network error';
    if (data is Map && data['detail'] is String) {
      detail = data['detail'] as String;
    }
    return ApiException(statusCode, detail);
  }
}

class AiRecipeResult {
  const AiRecipeResult({required this.recipe, this.saved});

  /// Recipe payload exactly as Gemini produced it (or stub equivalent).
  final Map<String, dynamic> recipe;

  /// Persisted detail when `save=true` was requested. Null otherwise.
  final SpiceRouteDetail? saved;

  factory AiRecipeResult.fromJson(Map<String, dynamic> json) {
    return AiRecipeResult(
      recipe: (json['recipe'] as Map<String, dynamic>),
      saved: json['saved'] == null
          ? null
          : SpiceRouteDetail.fromJson(json['saved'] as Map<String, dynamic>),
    );
  }
}
