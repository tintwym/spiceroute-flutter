import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../shared/breakpoints.dart';
import '../../shared/filter_bar.dart';
import '../../shared/widgets.dart';
import '../../state/explore.dart';

/// Explore tab — the recipe grid. The search field that used to live at
/// the top of this scroll view has been promoted to the nav bar (top
/// nav on tablet+, phone AppBar on phone), so it's reachable from every
/// screen. This page is now just filters + results.
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final state = ref.watch(exploreProvider);
    final controller = ref.read(exploreProvider.notifier);

    final maxW = contentMaxWidth(context);
    final pagePad = pagePadding(context);

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
          padding: pagePad.copyWith(top: 20),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: FilterBar(
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
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
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
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: recipeCardMaxExtent(context),
              childAspectRatio: 0.78,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 6,
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
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: recipeCardMaxExtent(context),
              childAspectRatio: 0.78,
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
