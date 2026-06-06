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

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: pagePadding(context).copyWith(top: 16, bottom: 12),
          child: Center(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: contentMaxWidth(context)),
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
        CuisinePillBar(
          value: state.cuisine,
          onChanged: controller.setCuisine,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: pagePadding(context),
          child: Center(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: contentMaxWidth(context)),
              child: _ResultsArea(state: state, l: l, onRetry: controller.refresh),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _ResultsArea extends StatelessWidget {
  const _ResultsArea({
    required this.state,
    required this.l,
    required this.onRetry,
  });

  final ExploreState state;
  final AppL10n l;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (state.loading && state.items.isEmpty) {
      return SizedBox(
        height: 320,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: recipeCardMaxExtent(context),
            childAspectRatio: 0.78,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 6,
          itemBuilder: (_, _) => const LoadingShimmer(height: 240),
        ),
      );
    }

    if (state.error != null && state.items.isEmpty) {
      return CenterMessage(
        icon: Icons.cloud_off,
        title: l.exploreErrorTitle,
        subtitle: state.error,
        action: FilledButton(
          onPressed: onRetry,
          child: Text(l.exploreErrorRetry),
        ),
      );
    }

    if (state.items.isEmpty) {
      return CenterMessage(
        icon: Icons.search_off,
        title: l.exploreEmptyTitle,
        subtitle: l.exploreEmptySubtitle,
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: recipeCardMaxExtent(context),
        childAspectRatio: 0.78,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: state.items.length,
      itemBuilder: (_, i) => RecipeCard(recipe: state.items[i]),
    );
  }
}
