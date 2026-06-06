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
      if (loc == '/my-recipes' && user == null) {
        return '/sign-in?next=/my-recipes';
      }
      return null;
    },
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
