import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../shared/breakpoints.dart';
import '../../shared/cuisine_pill_bar.dart';
import '../../shared/widgets.dart';
import '../../state/explore.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  late final TextEditingController _searchCtl;

  @override
  void initState() {
    super.initState();
    _searchCtl = TextEditingController(text: ref.read(exploreProvider).q);
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          padding: pagePad.copyWith(top: 16, bottom: 12),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: TextField(
                  controller: _searchCtl,
                  onChanged: controller.setQuery,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => controller.refresh(),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: l.exploreSearchHint,
                    suffixIcon: state.q.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _searchCtl.clear();
                              controller.setQuery('');
                            },
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: pagePad,
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: CuisinePillBar(
                  value: state.cuisine,
                  onChanged: controller.setCuisine,
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
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
  List<Widget> _buildResultsSlivers({
    required BuildContext context,
    required ExploreState state,
    required AppL10n l,
    required VoidCallback onRetry,
    required EdgeInsets pagePad,
    required double maxW,
  }) {
    if (state.loading && state.items.isEmpty) {
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

    if (state.error != null && state.items.isEmpty) {
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

    if (state.items.isEmpty) {
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
            itemCount: state.items.length,
            itemBuilder: (_, i) => RecipeCard(recipe: state.items[i]),
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
