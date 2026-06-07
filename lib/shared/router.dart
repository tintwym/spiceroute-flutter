import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/ai_companion/ai_companion_screen.dart';
import '../features/ai_creator/ai_creator_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/sign_in_screen.dart';
import '../features/explore/explore_screen.dart';
import '../features/my_recipes/my_recipes_screen.dart';
import '../features/recipes/recipe_detail_screen.dart';
import '../features/saved/saved_recipes_screen.dart';
import '../l10n/generated/app_localizations.dart';
import '../state/auth.dart';
import 'responsive_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // The router rebuilds when the user signs in / out so the redirect logic
  // for `/my-recipes` re-evaluates.
  ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final user = ref.read(authControllerProvider);
      final loc = state.matchedLocation;
      // Gate authed-only routes behind /sign-in.
      if (loc == '/my-recipes' && user == null) {
        return '/sign-in?next=/my-recipes';
      }
      // If you're already signed in, /sign-in and /register would be a dead
      // end — bounce to home (or to ?next=... if the original caller passed
      // one through).
      if ((loc == '/sign-in' || loc == '/register') && user != null) {
        return state.uri.queryParameters['next'] ?? '/';
      }
      return null;
    },
    errorBuilder: (context, state) => _NotFoundScreen(uri: state.uri),
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(path: '/', builder: (_, _) => const ExploreScreen()),
          GoRoute(
            path: '/ai/creator',
            builder: (_, _) => const AiCreatorScreen(),
          ),
          GoRoute(
            path: '/ai/companion',
            builder: (_, _) => const AiCompanionScreen(),
          ),
          GoRoute(path: '/saved', builder: (_, _) => const SavedRecipesScreen()),
          GoRoute(
            path: '/my-recipes',
            builder: (_, _) => const MyRecipesScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/sign-in',
        builder: (_, st) => SignInScreen(
          redirectTo: st.uri.queryParameters['next'] ?? (st.extra as String?),
        ),
      ),
      GoRoute(
        path: '/register',
        builder: (_, st) => RegisterScreen(
          redirectTo: st.uri.queryParameters['next'] ?? (st.extra as String?),
        ),
      ),
      GoRoute(
        path: '/recipes/:id',
        builder: (_, st) =>
            RecipeDetailScreen(recipeId: st.pathParameters['id']!),
      ),
    ],
  );
});

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen({required this.uri});
  final Uri uri;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.travel_explore_outlined,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l.commonNotFound,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    uri.toString(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => context.go('/'),
                    child: Text(l.commonHome),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
