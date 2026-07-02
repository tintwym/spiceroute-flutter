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

/// Sentinel surfaced in [ApiException.message] when the underlying
/// failure is a *transport-level* error (timeout, connection refused,
/// DNS resolution failure, web XHR onError) rather than a server-
/// supplied response body. The render site swaps this for the
/// localized "Couldn't connect to the server" string via
/// [localizeApiErrorMessage] so non-English users don't see an
/// English literal on a network blip.
///
/// Why a sentinel instead of localizing here directly: [ApiClient]
/// lives in the data layer and has no [BuildContext], so it can't
/// reach [AppL10n]. The sentinel is the data layer's way of saying
/// "I have no human-readable message — render site, please supply
/// one in the active locale."
///
/// Server-supplied `detail` strings from the backend pass through
/// unchanged (those are already chosen for the caller's locale via
/// the per-locale recipe translations + the backend's own
/// localized error responses), so this sentinel ONLY appears when
/// Dio raised before any response came back.
const String kApiErrorNetworkSentinel = '__api_network_error__';

/// Sentinel stamped when an authed-only endpoint rejects the caller
/// (missing/expired token). Render sites swap this for localized
/// copy and a sign-in affordance instead of showing server `detail`.
const String kAuthRequiredSentinel = '__api_auth_required__';

/// True for [kAuthRequiredSentinel] or known backend auth `detail` strings.
bool isAuthRequiredApiMessage(String message) =>
    message == kAuthRequiredSentinel ||
    message.contains('requires authentication');

/// Pluggable token provider. Returns a Firebase ID token (or null) for the
/// currently signed-in user. The default no-op is used in places where we
/// haven't wired in auth yet (e.g. tests).
typedef TokenProvider = Future<String?> Function({bool forceRefresh});

/// Returns the active UI locale code for API calls (`translate_to`,
/// `Accept-Language`). Defaults to English when unset.
typedef UiLocaleCodeProvider = String Function();

class ApiClient {
  ApiClient({TokenProvider? tokenProvider, UiLocaleCodeProvider? uiLocaleCode})
    : _tokenProvider = tokenProvider,
      _uiLocaleCode = uiLocaleCode ?? (() => 'en') {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 45),
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(_localeInterceptor());
  }

  final TokenProvider? _tokenProvider;
  UiLocaleCodeProvider _uiLocaleCode;
  late final Dio _dio;
  Dio get dio => _dio;

  void setUiLocaleCodeProvider(UiLocaleCodeProvider provider) {
    _uiLocaleCode = provider;
  }

  Interceptor _localeInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        final code = _uiLocaleCode().trim().toLowerCase();
        if (code.isNotEmpty) {
          options.headers['Accept-Language'] = code;
          // Belt-and-suspenders: every recipe read carries the active
          // UI locale even if a caller forgets `translate_to`.
          final path = options.path;
          if (path.contains('spice_routes')) {
            final params = Map<String, dynamic>.from(options.queryParameters);
            final existing = params['translate_to'];
            if (existing == null || (existing is String && existing.isEmpty)) {
              params['translate_to'] = code;
            }
            options.queryParameters = params;
          }
        }
        handler.next(options);
      },
    );
  }

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
        final isRetryable =
            e.response?.statusCode == 401 &&
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
    String? translateTo,
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
          // translate_to is distinct from `language` — the latter filters
          // recipes by their *source* language, the former tells the
          // backend "give me the title/description in this locale if you
          // have one". Send it on every request whose state knows the
          // active UI locale; the backend silently falls back to the
          // source title/description for any row that wasn't seeded
          // with a matching override.
          if (translateTo != null && translateTo.isNotEmpty)
            'translate_to': translateTo,
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

  Future<SpiceRouteDetail> getRecipe(String id, {String? translateTo}) async {
    try {
      final res = await _dio.get(
        '/spice_routes/$id',
        queryParameters: {
          if (translateTo != null && translateTo.isNotEmpty)
            'translate_to': translateTo,
        },
      );
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
    // Hard cap on the unframed buffer. A misbehaving backend, a proxy
    // that fully buffers SSE, or a network that delivers bytes without
    // the `\n\n` delimiter (rare but real) could otherwise grow the
    // string indefinitely until the browser tab OOMs. 1 MB is far
    // above any legitimate SSE frame size for this app (the largest
    // delta is a single LLM chunk, kilobytes at most).
    const maxBufferSize = 1024 * 1024;
    await for (final chunk in raw) {
      buffer += chunk;
      if (buffer.length > maxBufferSize) {
        // Drop everything up to the last `data:` prefix so we keep
        // a chance of recovering if we just missed a delimiter; if
        // there's no prefix at all, reset entirely.
        final lastDataIdx = buffer.lastIndexOf('data:');
        buffer = lastDataIdx > 0 ? buffer.substring(lastDataIdx) : '';
        throw ApiException(0, 'Stream protocol error (oversized buffer).');
      }
      while (true) {
        final newlineIdx = buffer.indexOf('\n\n');
        if (newlineIdx < 0) break;
        final frame = buffer.substring(0, newlineIdx);
        buffer = buffer.substring(newlineIdx + 2);
        for (final line in const LineSplitter().convert(frame)) {
          if (!line.startsWith('data:')) continue;
          final payload = line.substring(5).trim();
          if (payload.isEmpty) continue;
          // Tolerant decode. `jsonDecode(...) as Map` was throwing a
          // TypeError (not a FormatException) on valid-but-non-object
          // payloads — e.g. if a proxy injects a keepalive `data:
          // "ping"` line, or if the backend ever yields a non-dict
          // in its error path. Catch broadly so one weird frame
          // doesn't kill the whole stream.
          dynamic raw;
          try {
            raw = jsonDecode(payload);
          } catch (_) {
            continue;
          }
          if (raw is! Map<String, dynamic>) continue;
          final event = raw;
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
        }
      }
    }
  }

  ApiException _toApiException(DioException e) {
    final statusCode = e.response?.statusCode ?? 0;
    final data = e.response?.data;

    // Prefer the backend-provided `detail` field — it's already a clean,
    // user-facing message (and frequently already localized).
    if (data is Map && data['detail'] is String) {
      return ApiException(statusCode, data['detail'] as String);
    }

    // Otherwise emit a sentinel — the render site translates it via
    // [localizeApiErrorMessage] using the active [AppL10n]. The raw
    // Dio text (e.g. "The XMLHttpRequest onError callback was
    // called…") is useless to end-users AND was previously a
    // hardcoded English literal that leaked into the UI for every
    // non-English speaker on a timeout / disconnect. All
    // transport-level errors collapse to ONE sentinel because the
    // user-actionable advice is identical for all of them ("check
    // your connection and try again"); distinguishing
    // "timeout vs. DNS vs. TLS handshake" inside the UI doesn't
    // help the user fix it.
    final message = switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError ||
      DioExceptionType.unknown ||
      DioExceptionType.cancel ||
      DioExceptionType.badCertificate => kApiErrorNetworkSentinel,
      // 4xx / 5xx with no `detail` body — use the HTTP status line
      // (e.g. "Bad Gateway", "Service Unavailable"). These come
      // from the upstream proxy / load balancer and ARE in English
      // by spec — localizing them would lie. Leaving them as the
      // status line gives the operator something to debug from a
      // user report.
      DioExceptionType.badResponse =>
        e.response?.statusMessage ?? kApiErrorNetworkSentinel,
    };
    return ApiException(statusCode, message);
  }
}

class AiRecipeResult {
  const AiRecipeResult({required this.recipe, this.saved});

  /// Recipe payload exactly as the LLM produced it (or stub equivalent).
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
