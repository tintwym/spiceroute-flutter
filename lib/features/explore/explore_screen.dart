import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../shared/breakpoints.dart';
import '../../shared/error_localization.dart';
import '../../shared/filter_bar.dart';
import '../../shared/page_hero.dart';
import '../../shared/page_tabs.dart';
import '../../shared/region_filter_bar.dart';
import '../../shared/site_footer.dart';
import '../../shared/sliver_pinned_filter_bar.dart';
import '../../shared/widgets.dart';
import '../../state/explore.dart';
import 'community_board.dart';
import 'cross_cultural_stories.dart';
import 'explore_filter_bar.dart';

/// Explore tab — the editorial home page. Top to bottom: hero (badge +
/// serif headline + search + result count), the filter bar, the recipe
/// grid, the Community Culinary Board, and the site footer.
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  /// How many pixels from the bottom of the scroll view we should
  /// trigger the next page-fetch. Sized to ~2 screen heights so the
  /// next page is usually already loaded by the time the user scrolls
  /// near the end — no perceived "wait at the bottom" pause.
  static const double _loadMoreThreshold = 1200;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(exploreProvider.notifier);
    final cuisine = ref.watch(exploreProvider.select((s) => s.cuisine));
    final course = ref.watch(exploreProvider.select((s) => s.course));
    final dietary = ref.watch(exploreProvider.select((s) => s.dietary));

    final maxW = contentMaxWidth(context);
    final pagePad = pagePadding(context);
    final isPhone = deviceClassOf(context).isPhone;

    // Center + max-width helper so every section shares the body content
    // frame (and lines up with the header above).
    Widget framed(Widget child) => Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: child,
      ),
    );

    // Sliver-based scroll view so the recipe grid is *actually* lazy. The
    // previous ListView+shrinkWrap-GridView combo mounted every card up
    // front (60+ CachedNetworkImage widgets at once on Explore), which made
    // every interaction feel sticky while images decoded.
    //
    // Infinite scroll is wired via a NotificationListener rather than a
    // ScrollController for two reasons: (a) we don't need to read the
    // controller anywhere else, and (b) the existing CustomScrollView
    // creates its own internal PrimaryScrollController on web which we'd
    // otherwise have to wrestle off. The notification carries the same
    // pixels / maxScrollExtent fields the controller would expose.
    // Two nested listeners — different notification types:
    //   * ScrollUpdateNotification — drives normal "near the bottom →
    //     fetch next page" infinite scroll while the user scrolls.
    //   * ScrollMetricsNotification — fires when scroll metrics change
    //     without an associated scroll (e.g. items appended, viewport
    //     resized). On Explore this is mostly defensive — the page
    //     also contains CommunityBoard + footer slivers so the outer
    //     scroll view is almost always scrollable — but it prevents
    //     a wedge if those rails ever become conditional and the
    //     grid fits in the viewport on its own.
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (n) {
        if (n.depth != 0) return false;
        if (n.metrics.axis != Axis.vertical) return false;
        // Only prefetch when the viewport is genuinely short *and* the
        // user has already scrolled — avoids unsolicited page-2 fetches
        // on first paint when content fits without scrolling.
        if (n.metrics.pixels > 0 &&
            n.metrics.maxScrollExtent <= _loadMoreThreshold) {
          controller.loadMore();
        }
        return false;
      },
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: (n) {
          // Only react to notifications from the OUTER CustomScrollView
          // (`depth == 0`). Without this gate, any nested vertical
          // scrollable that we add later (a chat panel, a horizontal
          // story rail that briefly accepts vertical drag during a
          // transition, etc.) would bubble its own metrics up and
          // trigger loadMore based on the WRONG `maxScrollExtent`,
          // firing requests at the wrong moments. Today there is no
          // nested vertical scroller, so this is defensive — but a
          // future regression of this kind would be silent (extra
          // network calls, no visible error) and hard to spot.
          if (n.depth != 0) return false;
          if (n.metrics.axis != Axis.vertical) return false;
          final remaining = n.metrics.maxScrollExtent - n.metrics.pixels;
          if (remaining <= _loadMoreThreshold) {
            // Fire-and-forget; loadMore() itself guards against
            // re-entry while a fetch is already in flight, so a busy
            // scroll firing many notifications still results in at
            // most one network request per page.
            controller.loadMore();
          }
          return false;
        },
        child: CustomScrollView(
          scrollCacheExtent: const ScrollCacheExtent.pixels(900), physics: const ClampingScrollPhysics(),
          slivers: [
            // Editorial hero — badge + serif "SpiceRoute" + tagline.
            // Search and result counter USED to live in this hero's
            // `below` slot; they were extracted into a separate pinned
            // sliver (next) so refining a query mid-scroll no longer
            // requires scrolling back up. The hero stays a one-time
            // welcome that's free to leave the viewport.
            SliverPadding(
              padding: pagePad.copyWith(top: 32, bottom: 8),
              sliver: SliverToBoxAdapter(child: framed(const PageHero())),
            ),
            // Pinned search field + result counter. Sticks to the top of
            // the viewport as soon as the hero scrolls past it. Phone-
            // class viewports render the counter only (the search input
            // itself lives in the AppBar pill — see
            // `responsive_scaffold.dart`).
            SliverPinnedFilterBar(
              height: ExploreFilterRow.estimatedHeight(context),
              child: Padding(
                padding: pagePad.copyWith(top: 16, bottom: 16),
                child: framed(const ExploreFilterRow()),
              ),
            ),
            // Page-level tab row sits between the hero and the filter bar —
            // mirrors the reference design's banded sub-nav under the
            // editorial headline.
            SliverPadding(
              padding: pagePad.copyWith(top: 12, bottom: 0),
              sliver: SliverToBoxAdapter(child: framed(const PageTabs())),
            ),
            // Visual cuisine picker — two-tier (region → cuisine) pill UI.
            // On phone, course + dietary share one combined refine row
            // with the region trigger (Option A); tablet+ keeps separate
            // [FilterBar] below.
            SliverPadding(
              padding: pagePad.copyWith(top: 20),
              sliver: SliverToBoxAdapter(
                child: framed(
                  RegionFilterBar(
                    cuisine: cuisine,
                    onCuisineChanged: controller.setCuisine,
                    preferencesActive: course != null || dietary != null,
                    phonePreferencesTrigger: isPhone
                        ? MobileCourseDietaryFilterTrigger(
                            course: course,
                            dietary: dietary,
                            onCourseChanged: controller.setCourse,
                            onDietaryChanged: controller.setDietary,
                          )
                        : null,
                  ),
                ),
              ),
            ),
            if (!isPhone)
              SliverPadding(
                padding: pagePad.copyWith(top: 16),
                sliver: SliverToBoxAdapter(
                  child: framed(
                    FilterBar(
                      course: course,
                      dietary: dietary,
                      onCourseChanged: controller.setCourse,
                      onDietaryChanged: controller.setDietary,
                    ),
                  ),
                ),
              ),
            // "Cuisine Culinary Heritage & Connections" — only renders when
            // a specific cuisine is selected (else collapses to zero height).
            // Slots between the filter bar and the recipe grid so the heritage
            // copy reads as context for the dishes about to appear below.
            SliverPadding(
              padding: pagePad.copyWith(top: 16, bottom: 0),
              sliver: SliverToBoxAdapter(
                child: framed(const CrossCulturalStoriesCard()),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            const _ExploreRecipeResults(),
            SliverPadding(
              padding: pagePad.copyWith(top: 44),
              sliver: SliverToBoxAdapter(
                child: framed(const RepaintBoundary(child: CommunityBoard())),
              ),
            ),
            SliverPadding(
              padding: pagePad.copyWith(top: 48, bottom: 28),
              sliver: SliverToBoxAdapter(child: framed(const SiteFooter())),
            ),
          ],
        ),
      ),
    );
  }
}

/// Recipe grid + pagination footers — isolated so filter tweaks on the
/// rest of Explore don't rebuild the card slivers.
class _ExploreRecipeResults extends ConsumerWidget {
  const _ExploreRecipeResults();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exploreProvider);
    final l = AppL10n.of(context);
    final controller = ref.read(exploreProvider.notifier);
    final pagePad = pagePadding(context);
    final maxW = contentMaxWidth(context);

    return SliverMainAxisGroup(
      slivers: _buildResultsSlivers(
        context: context,
        state: state,
        l: l,
        onRetry: controller.refresh,
        onLoadMore: controller.loadMore,
        pagePad: pagePad,
        maxW: maxW,
      ),
    );
  }

  /// Shared sliver builder so the three result states (loading / error /
  /// data) all live in the same scroll view — no nested viewports.
  ///
  /// [onRetry] retries the whole first-page fetch (wired to
  /// `controller.refresh`). [onLoadMore] retries an in-flight-failed
  /// follow-up page (wired to `controller.loadMore`) — they're
  /// different so the page-level error CTA doesn't accidentally
  /// reset items the user already has.
  List<Widget> _buildResultsSlivers({
    required BuildContext context,
    required ExploreState state,
    required AppL10n l,
    required VoidCallback onRetry,
    required VoidCallback onLoadMore,
    required EdgeInsets pagePad,
    required double maxW,
  }) {
    // `visibleItems` applies the client-side course + dietary filter on
    // top of the API-returned `items`. Cuisine and free-text search go
    // through the API and are already reflected in `items`.
    final visible = state.visibleItems;
    if (state.loading && visible.isEmpty) {
      if (deviceClassOf(context).isPhone) {
        return [
          SliverPadding(
            padding: pagePad,
            sliver: SliverList.builder(
              itemCount: 8,
              itemBuilder: (_, _) => const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: LoadingShimmer(height: 220),
              ),
            ),
          ),
        ];
      }
      return [
        SliverPadding(
          padding: pagePad,
          sliver: SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: recipeGridColumns(context),
              childAspectRatio: recipeCardAspectRatio(context),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 8,
            itemBuilder: (_, _) => const LoadingShimmer(height: 240),
          ),
        ),
      ];
    }

    if (state.error != null && visible.isEmpty) {
      // Translate any sentinel string the controller may have stamped
      // (`kUnknownErrorSentinel`, `kApiErrorNetworkSentinel`, …) into
      // the active locale. Server-supplied `detail` strings flow
      // through unchanged. See `shared/error_localization.dart` for
      // the full sentinel list — every new sentinel must be added
      // there to avoid leaking the raw marker into the UI.
      final subtitle = localizeApiErrorMessage(context, state.error!);
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: CenterMessage(
            icon: Icons.cloud_off,
            title: l.exploreErrorTitle,
            subtitle: subtitle,
            action: FilledButton(
              onPressed: onRetry,
              child: Text(l.exploreErrorRetry),
            ),
          ),
        ),
      ];
    }

    if (visible.isEmpty) {
      final filteredOut = state.items.isNotEmpty;
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: CenterMessage(
            icon: Icons.search_off,
            title: filteredOut ? l.filterNoMatches : l.exploreEmptyTitle,
            subtitle: l.exploreEmptySubtitle,
          ),
        ),
      ];
    }

    return [
      if (state.loading && visible.isNotEmpty)
        const SliverToBoxAdapter(child: LinearProgressIndicator(minHeight: 2)),
      recipeResultsSliver(
        context: context,
        padding: pagePad,
        itemCount: visible.length,
        recipeAt: (i) => visible[i],
        maxCrossAxisExtent: maxW,
      ),
      // Pagination footer — only appears while a follow-up page is in
      // flight. Sits below the grid so the user gets visual feedback
      // that their scroll triggered work without the grid swapping
      // out for shimmer (which would feel like the page reloaded).
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
      // the spinner just vanishes and the user assumes they've
      // reached the end of the data when they haven't.
      else if (state.error != null && visible.isNotEmpty)
        SliverToBoxAdapter(
          child: LoadMoreErrorFooter(
            message: localizeApiErrorMessage(context, state.error!),
            onRetry: state.errorFromRefresh ? onRetry : onLoadMore,
          ),
        ),
    ];
  }
}
