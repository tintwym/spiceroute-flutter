import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_client.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/spice_route.dart';
import '../../shared/breakpoints.dart';
import '../../shared/error_localization.dart';
import '../../shared/widgets.dart';
import '../../state/auth.dart';
import '../../state/locale.dart';
import '../../state/providers.dart';
import '../explore/explore_screen.dart' show SliverCrossAxisConstrained;

/// External invalidation token for the /my-recipes listing.
///
/// `_MyRecipesScreenState` caches the in-flight `listRecipes(mine:true)`
/// Future on a `(uid, locale, revision)` fence so the list refetches
/// only when one of those keys changes. Auth flips and locale changes
/// are watched automatically, but two important write paths can mutate
/// the user's owned-recipe set WITHOUT changing uid or locale:
///
///   1. Deleting a recipe from the detail modal then popping back to
///      /my-recipes (the modal sits over /my-recipes so the underlying
///      route's State is preserved — without a revision bump, the
///      deleted recipe stays as a tombstone tile until the user pulls
///      to refresh).
///   2. Saving an AI-generated recipe from /ai/creator. The new id
///      lands server-side, but /my-recipes won't pick it up until
///      the next navigation-driven cache miss.
///
/// Writers call `ref.read(myRecipesRevisionProvider.notifier).state++`
/// after a successful mutation. The screen `watch`es this provider
/// and folds the value into its cache fence, forcing a refetch on
/// the next build.
final myRecipesRevisionProvider = StateProvider<int>((_) => 0);

/// Convenience: bump the revision from any writer without dealing
/// with the notifier directly. Idempotent and cheap (a single state
/// notifier write), so it's safe to call even when /my-recipes isn't
/// mounted — the next time it builds it'll see the new revision.
void invalidateMyRecipes(WidgetRef ref) {
  ref.read(myRecipesRevisionProvider.notifier).state++;
}

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
  // Mirror of the uid fence, but for the active UI locale. The
  // explore + saved screens get auto-refresh on locale change for
  // free because they're driven by Riverpod controllers that
  // subscribe to `localeProvider`. This screen owns its Future
  // directly, so it needs its own fence — without it, switching
  // language while sitting on /my-recipes leaves the previous
  // language's titles + descriptions cached until the user
  // pull-to-refreshes (inconsistent with every other listing in the
  // app and confusing if they were trying to verify the new
  // language even took effect).
  String? _futureForLocale;
  // External-invalidation fence — see `myRecipesRevisionProvider`
  // for the writer-side rationale. `int?` so the initial build
  // always misses the cache (matches the existing `_future == null`
  // first-build path).
  int? _futureForRevision;

  Future<SpiceRouteListResponse> _fetch() {
    // Pass the active locale so user-authored recipes that were
    // generated with the AI Creator in another language get their
    // translations applied — see `ApiClient.listRecipes` for the full
    // contract.
    final locale = ref.read(localeProvider).languageCode;
    return ref
        .read(apiClientProvider)
        .listRecipes(mine: true, limit: 100, translateTo: locale);
  }

  Future<void> _refresh() async {
    final next = _fetch();
    setState(() {
      _future = next;
      _futureForLocale = ref.read(localeProvider).languageCode;
    });
    await next;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final user = ref.watch(authControllerProvider);
    // Subscribe so the build re-runs when the user toggles language.
    // The cache-fence check below then sees the new value and re-
    // fetches with `translate_to=<new locale>`.
    final locale = ref.watch(localeProvider).languageCode;
    // External invalidation token. Bumped by writers (recipe delete
    // confirmation, AI Creator save) so the cached Future gets
    // discarded and a fresh fetch goes out — the user immediately
    // sees their just-saved AI recipe in this grid, or the just-
    // deleted recipe disappears, instead of having to pull-to-
    // refresh after every mutation.
    final revision = ref.watch(myRecipesRevisionProvider);

    if (user == null) {
      // Defensive — shell hides this destination when signed-out, but a
      // direct deep-link could still get here. Also clear any cached
      // future for the now-departed user so a fresh sign-in doesn't
      // briefly flash their stale results.
      _future = null;
      _futureForUid = null;
      _futureForLocale = null;
      _futureForRevision = null;
      return CenterMessage(
        icon: Icons.lock_outline,
        title: l.authProtectedTitle,
        subtitle: l.authProtectedBody,
      );
    }

    // First build with a signed-in user — or the active uid / locale
    // / revision has changed since we last fetched. Kick off a fresh
    // request and throw away the previous Future (cross-user data
    // leak if uid changes; stale-language titles if locale changes;
    // stale post-mutation list if revision changes).
    if (_future == null ||
        _futureForUid != user.uid ||
        _futureForLocale != locale ||
        _futureForRevision != revision) {
      _future = _fetch();
      _futureForUid = user.uid;
      _futureForLocale = locale;
      _futureForRevision = revision;
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
            // Localize via the sentinel-aware helper so transport
            // errors render in the active locale (timeouts /
            // connection failures used to leak English literals to
            // every non-English user). Server-supplied `detail`
            // strings pass through unchanged.
            String msg = l.commonError;
            if (err is ApiException) {
              msg = localizeApiErrorMessage(context, err.message);
            }
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
