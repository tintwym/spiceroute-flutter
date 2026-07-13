import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../shared/breakpoints.dart';
import '../../shared/error_localization.dart';
import '../../shared/page_tabs.dart';
import '../../shared/widgets.dart';
import '../../state/auth.dart';
import '../../state/my_recipes.dart';

/// Lists recipes published by the current user (authenticated server-side
/// via `?mine=true`). Shows public *and* private (draft) entries.
///
/// Pagination: same `limit + offset` infinite-scroll pattern as the
/// Explore grid. Page size lives in `MyRecipesController.pageSize`
/// (currently 30) and `loadMore()` self-guards against double-firing
/// so the scroll listener can be noisy without queuing requests.
class MyRecipesScreen extends ConsumerWidget {
  const MyRecipesScreen({super.key});

  /// Pixels from the bottom of the scroll view at which we trigger
  /// the next page-fetch. Matches Explore's 1200-dp threshold so
  /// the next page is usually pre-loaded by the time the user
  /// reaches the visual end of the grid — no perceived "wait at the
  /// bottom" pause.
  static const double _loadMoreThreshold = 1200;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final user = ref.watch(authControllerProvider);
    final state = ref.watch(myRecipesProvider);
    final controller = ref.read(myRecipesProvider.notifier);

    // Only gate on Firebase session — not on a stale 401 from a
    // pre-sign-in fetch or a transient token race right after login.
    // Signed-in users with zero owned recipes should see the empty
    // state, not another sign-in prompt.
    if (user == null) {
      return _authRequiredScroll(context, l);
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      // Two nested listeners — different notification types:
      //   * ScrollUpdateNotification — fires while the user is
      //     scrolling. Drives the normal "near the bottom → fetch
      //     next page" infinite scroll.
      //   * ScrollMetricsNotification — fires when the scroll view's
      //     metrics CHANGE (content height, viewport height) without
      //     an associated scroll. This is the only signal we get on
      //     a viewport that can fit the entire first page with no
      //     scroll possible — without it, a user with exactly
      //     `pageSize` (30) saved recipes on a tall tablet would be
      //     wedged with `hasMore: true` and no way to fetch page 2.
      child: NotificationListener<ScrollMetricsNotification>(
        onNotification: (n) {
          if (n.depth != 0) return false;
          if (n.metrics.axis != Axis.vertical) return false;
          // Content fits in viewport with room to spare → user can't
          // scroll to trigger loadMore. Pull the next page now.
          // `loadMore()` self-guards against re-entry and against
          // !hasMore, so we don't need to gate on either here.
          if (n.metrics.maxScrollExtent <= _loadMoreThreshold) {
            controller.loadMore();
          }
          return false;
        },
        child: NotificationListener<ScrollUpdateNotification>(
          onNotification: (n) {
            // Same depth + axis gate Explore uses (see
            // `explore_screen.dart`). Without `depth != 0`, any nested
            // vertical scrollable added later would bubble its own
            // metrics up and fire loadMore on the wrong viewport.
            if (n.depth != 0) return false;
            if (n.metrics.axis != Axis.vertical) return false;
            final remaining = n.metrics.maxScrollExtent - n.metrics.pixels;
            if (remaining <= _loadMoreThreshold) {
              // Fire-and-forget; `loadMore()` self-guards against
              // re-entry so a noisy scroll firing many notifications
              // still results in at most one network request per page.
              controller.loadMore();
            }
            return false;
          },
          child: _buildBody(context, l, state, controller),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppL10n l,
    MyRecipesState state,
    MyRecipesController controller,
  ) {
    if (state.loading && state.items.isEmpty) {
      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: 4,
        itemBuilder: (_, _) => const LoadingShimmer(height: 240),
      );
    }

    if (state.error != null && state.items.isEmpty) {
      // Auth errors while signed in are retried in the controller; if
      // they persist, show a generic retry affordance — not a second
      // sign-in prompt (the header already shows the avatar).
      final subtitle = localizeApiErrorMessage(context, state.error!);
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 80),
          CenterMessage(
            icon: Icons.error_outline,
            title: l.exploreErrorTitle,
            subtitle: subtitle,
            action: FilledButton(
              onPressed: controller.refresh,
              child: Text(l.exploreErrorRetry),
            ),
          ),
        ],
      );
    }

    if (state.items.isEmpty) {
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
    final isPhone = deviceClassOf(context).isPhone;
    return CustomScrollView(
      cacheExtent: 900,
      physics: const ClampingScrollPhysics(),
      slivers: [
        if (!isPhone)
          SliverPadding(
            padding: pagePad.copyWith(top: 16, bottom: 0),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxW),
                  child: const PageTabs(),
                ),
              ),
            ),
          ),
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
        if (state.loading && state.items.isNotEmpty)
          const SliverToBoxAdapter(child: LinearProgressIndicator(minHeight: 2)),
        recipeResultsSliver(
          context: context,
          padding: pagePad,
          itemCount: state.items.length,
          recipeAt: (i) => state.items[i],
          maxCrossAxisExtent: maxW,
        ),
        // Pagination footer — only appears while a follow-up page is
        // in flight. Sits below the grid so the user gets visual
        // feedback that their scroll triggered work without the grid
        // itself swapping out for shimmer (which would feel like the
        // page reloaded).
        if (state.loadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              ),
            ),
          )
        // Pagination-failure footer — appears when a follow-up page
        // fetch errors AND we have items on screen. Without this,
        // the spinner just vanishes silently and the user assumes
        // they've reached the end of the data when they haven't.
        else if (state.error != null && state.items.isNotEmpty)
          SliverToBoxAdapter(
            child: LoadMoreErrorFooter(
              message: localizeApiErrorMessage(context, state.error!),
              onRetry: state.errorFromRefresh
                  ? controller.refresh
                  : controller.loadMore,
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  Widget _authRequiredScroll(BuildContext context, AppL10n l) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 80),
        CenterMessage(
          icon: Icons.lock_outline,
          title: l.myRecipesSignInTitle,
          subtitle: l.myRecipesSignInBody,
          action: FilledButton(
            onPressed: () => context.push(
              '/sign-in?next=${Uri.encodeComponent('/my-recipes')}',
            ),
            child: Text(l.authSignIn),
          ),
        ),
      ],
    );
  }
}
