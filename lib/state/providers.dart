import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../api/token_store.dart';
import '../models/auth.dart';

final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore());

final apiClientProvider = Provider<ApiClient>((ref) {
  final tokens = ref.watch(tokenStoreProvider);
  return ApiClient(tokens);
});

class AuthState {
  const AuthState({this.user, this.loading = false});
  final UserPublic? user;
  final bool loading;

  bool get isAuthenticated => user != null;

  AuthState copyWith({UserPublic? user, bool? loading, bool clearUser = false}) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      loading: loading ?? this.loading,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._api) : super(const AuthState(loading: true)) {
    // If the API client's refresh flow ever fails (e.g. refresh token also
    // expired, account deleted server-side, etc.) clear our user state so
    // the router bounces back to /login instead of staying on a screen that
    // can only 401.
    _api.onUnauthorized = _handleUnauthorized;
    _bootstrap();
  }

  final ApiClient _api;

  void _handleUnauthorized() {
    if (mounted) state = const AuthState();
  }

  Future<void> _bootstrap() async {
    try {
      final access = await _api.tokens.readAccess();
      if (access == null || access.isEmpty) {
        state = const AuthState();
        return;
      }
      final user = await _api.me();
      state = AuthState(user: user);
    } catch (_) {
      await _api.tokens.clear();
      state = const AuthState();
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true);
    try {
      await _api.login(email: email, password: password);
      final user = await _api.me();
      state = AuthState(user: user);
    } catch (e) {
      state = state.copyWith(loading: false);
      rethrow;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = state.copyWith(loading: true);
    try {
      await _api.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      final user = await _api.me();
      state = AuthState(user: user);
    } catch (e) {
      state = state.copyWith(loading: false);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _api.logout();
    state = const AuthState();
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(apiClientProvider));
});
