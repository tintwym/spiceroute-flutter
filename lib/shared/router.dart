import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/spice_routes/spice_route_detail_screen.dart';
import '../features/spice_routes/spice_route_edit_screen.dart';
import '../features/spice_routes/spice_route_list_screen.dart';
import '../state/providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: _AuthListenable(ref),
    redirect: (context, state) {
      final loggedIn = auth.isAuthenticated;
      final loading = auth.loading;
      if (loading) return null;
      final path = state.matchedLocation;
      final isAuthScreen = path == '/login' || path == '/register';
      if (!loggedIn && !isAuthScreen) return '/login';
      if (loggedIn && isAuthScreen) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
      GoRoute(path: '/', builder: (_, _) => const SpiceRouteListScreen()),
      GoRoute(
        path: '/spice_routes/new',
        builder: (_, _) => const SpiceRouteEditScreen(),
      ),
      GoRoute(
        path: '/spice_routes/:id',
        builder: (_, st) =>
            SpiceRouteDetailScreen(spiceRouteId: st.pathParameters['id']!),
      ),
      GoRoute(
        path: '/spice_routes/:id/edit',
        builder: (_, st) =>
            SpiceRouteEditScreen(spiceRouteId: st.pathParameters['id']!),
      ),
      GoRoute(path: '/favorites', builder: (_, _) => const FavoritesScreen()),
    ],
  );
});

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(this._ref) {
    _ref.listen(authControllerProvider, (prev, next) => notifyListeners());
  }
  final Ref _ref;
}
