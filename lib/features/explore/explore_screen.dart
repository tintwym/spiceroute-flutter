import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../shared/breakpoints.dart';
import '../../shared/filter_bar.dart';
import '../../shared/page_tabs.dart';
import '../../shared/site_footer.dart';
import '../../shared/widgets.dart';
import '../../state/explore.dart';
import 'community_board.dart';
import 'cross_cultural_stories.dart';
import 'explore_hero.dart';

/// Explore tab — the editorial home page. Top to bottom: hero (badge +
/// serif headline + search + result count), the filter bar, the recipe
/// grid, the Community Culinary Board, and the site footer.
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final state = ref.watch(exploreProvider);
    final controller = ref.read(exploreProvider.notifier);

    final maxW = contentMaxWidth(context);
    final pagePad = pagePadding(context);

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
    return CustomScrollView(
      // ClampingScrollPhysics on web avoids the iOS-style elastic overscroll
      // that triggers extra repaint passes Chrome already gives us a smooth
      // momentum scroll for free.
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: pagePad.copyWith(top: 32, bottom: 8),
          sliver: SliverToBoxAdapter(child: framed(const ExploreHero())),
        ),
        // Page-level tab row sits between the hero and the filter bar —
        // mirrors the reference design's banded sub-nav under the
        // editorial headline.
        SliverPadding(
          padding: pagePad.copyWith(top: 12, bottom: 0),
          sliver: SliverToBoxAdapter(child: framed(const PageTabs())),
        ),
        SliverPadding(
          padding: pagePad.copyWith(top: 20),
          sliver: SliverToBoxAdapter(
            child: framed(
              FilterBar(
                cuisine: state.cuisine,
                course: state.course,
                dietary: state.dietary,
                onCuisineChanged: controller.setCuisine,
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
        ..._buildResultsSlivers(
          context: context,
          state: state,
          l: l,
          onRetry: controller.refresh,
          pagePad: pagePad,
          maxW: maxW,
        ),
        SliverPadding(
          padding: pagePad.copyWith(top: 44),
          sliver: SliverToBoxAdapter(child: framed(const CommunityBoard())),
        ),
        SliverPadding(
          padding: pagePad.copyWith(top: 48, bottom: 28),
          sliver: SliverToBoxAdapter(child: framed(const SiteFooter())),
        ),
      ],
    );
  }

  /// Shared sliver builder so the three result states (loading / error /
  /// data) all live in the same scroll view — no nested viewports.
  static List<Widget> _buildResultsSlivers({
    required BuildContext context,
    required ExploreState state,
    required AppL10n l,
    required VoidCallback onRetry,
    required EdgeInsets pagePad,
    required double maxW,
  }) {
    // `visibleItems` applies the client-side course + dietary filter on
    // top of the API-returned `items`. Cuisine and free-text search go
    // through the API and are already reflected in `items`.
    final visible = state.visibleItems;
    if (state.loading && visible.isEmpty) {
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
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: CenterMessage(
            icon: Icons.cloud_off,
            title: l.exploreErrorTitle,
            subtitle: state.error,
            action: FilledButton(
              onPressed: onRetry,
              child: Text(l.exploreErrorRetry),
            ),
          ),
        ),
      ];
    }

    if (visible.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: CenterMessage(
            icon: Icons.search_off,
            title: l.exploreEmptyTitle,
            subtitle: l.exploreEmptySubtitle,
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: pagePad,
        sliver: SliverCrossAxisConstrained(
          maxCrossAxisExtent: maxW,
          child: SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: recipeGridColumns(context),
              childAspectRatio: recipeCardAspectRatio(context),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: visible.length,
            itemBuilder: (_, i) => RecipeCard(recipe: visible[i]),
          ),
        ),
      ),
    ];
  }
}

/// Wraps a sliver with a centered, max-width constraint so the cards don't
/// stretch across a 4k viewport. Achieves what `ConstrainedBox(maxWidth)`
/// inside a box layout does, but in sliver-space.
class SliverCrossAxisConstrained extends StatelessWidget {
  const SliverCrossAxisConstrained({
    super.key,
    required this.maxCrossAxisExtent,
    required this.child,
  });

  final double maxCrossAxisExtent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final viewport = constraints.crossAxisExtent;
        if (!maxCrossAxisExtent.isFinite || viewport <= maxCrossAxisExtent) {
          return child;
        }
        final padding = (viewport - maxCrossAxisExtent) / 2;
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          sliver: child,
        );
      },
    );
  }
}
