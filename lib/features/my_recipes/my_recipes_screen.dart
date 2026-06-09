import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_client.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/spice_route.dart';
import '../../shared/breakpoints.dart';
import '../../shared/widgets.dart';
import '../../state/auth.dart';
import '../../state/providers.dart';
import '../explore/explore_screen.dart' show SliverCrossAxisConstrained;

/// Lists recipes published by the current user (authenticated server-side
/// via `?mine=true`). Shows public *and* private (draft) entries.
class MyRecipesScreen extends ConsumerStatefulWidget {
  const MyRecipesScreen({super.key});

  @override
  ConsumerState<MyRecipesScreen> createState() => _MyRecipesScreenState();
}

class _MyRecipesScreenState extends ConsumerState<MyRecipesScreen> {
  // Lazily set on first build with a signed-in user. We DON'T fire
  // the request in `initState` because that path runs before any
  // build-time auth check, so on a direct deep-link to /my-recipes
  // from a signed-out user (or during the brief Firebase auth-
  // rehydration window) we'd send a guaranteed-401 request to the
  // backend and silently discard the result. The 401 itself was
  // harmless but it polluted server logs and rate-limit counters.
  Future<SpiceRouteListResponse>? _future;
  // Track WHICH user the cached `_future` belongs to. The /sign-in
  // route is a modal pushed over /my-recipes, so this State is
  // preserved across sign-out → sign-in-as-different-user. Without
  // this fence, user B would re-enter and see user A's already-
  // resolved recipe list (titles + descriptions) until they hit
  // pull-to-refresh — a real cross-account data leak in the UI.
  String? _futureForUid;

  Future<SpiceRouteListResponse> _fetch() {
    return ref.read(apiClientProvider).listRecipes(mine: true, limit: 100);
  }

  Future<void> _refresh() async {
    final next = _fetch();
    setState(() => _future = next);
    await next;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final user = ref.watch(authControllerProvider);

    if (user == null) {
      // Defensive — shell hides this destination when signed-out, but a
      // direct deep-link could still get here. Also clear any cached
      // future for the now-departed user so a fresh sign-in doesn't
      // briefly flash their stale results.
      _future = null;
      _futureForUid = null;
      return CenterMessage(
        icon: Icons.lock_outline,
        title: l.authProtectedTitle,
        subtitle: l.authProtectedBody,
      );
    }

    // First build with a signed-in user — or the active uid has
    // changed since we last fetched. Kick off a fresh request and
    // throw away the previous user's cached Future.
    if (_future == null || _futureForUid != user.uid) {
      _future = _fetch();
      _futureForUid = user.uid;
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<SpiceRouteListResponse>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: 4,
              itemBuilder: (_, _) => const LoadingShimmer(height: 240),
            );
          }
          if (snap.hasError) {
            final err = snap.error;
            String msg = l.commonError;
            if (err is ApiException) msg = err.message;
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 80),
                CenterMessage(
                  icon: Icons.error_outline,
                  title: l.exploreErrorTitle,
                  subtitle: msg,
                ),
              ],
            );
          }
          final items = snap.data?.items ?? const <SpiceRouteSummary>[];
          if (items.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 80),
                CenterMessage(
                  icon: Icons.restaurant_outlined,
                  title: l.myRecipesEmptyTitle,
                  subtitle: l.myRecipesEmptySubtitle,
                ),
              ],
            );
          }
          final pagePad = pagePadding(context);
          final maxW = contentMaxWidth(context);
          return CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: pagePad.copyWith(top: 16, bottom: 16),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxW),
                      child: Text(
                        l.myRecipesTitle,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: pagePad,
                sliver: SliverCrossAxisConstrained(
                  maxCrossAxisExtent: maxW,
                  child: SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: recipeCardMaxExtent(context),
                      childAspectRatio: 0.78,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: items.length,
                    itemBuilder: (_, i) => RecipeCard(recipe: items[i]),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }
}
