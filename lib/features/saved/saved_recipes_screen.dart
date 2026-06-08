import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../shared/breakpoints.dart';
import '../../shared/widgets.dart';
import '../../state/saved.dart';
import '../explore/explore_screen.dart' show SliverCrossAxisConstrained;

class SavedRecipesScreen extends ConsumerWidget {
  const SavedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final state = ref.watch(savedRecipesProvider);
    final controller = ref.read(savedRecipesProvider.notifier);
    final pagePad = pagePadding(context);
    final maxW = contentMaxWidth(context);

    if (state.loading && state.recipes.isEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        physics: const ClampingScrollPhysics(),
        itemCount: 4,
        itemBuilder: (_, _) => const LoadingShimmer(height: 240),
      );
    }

    if (state.recipes.isEmpty) {
      return CenterMessage(
        icon: Icons.bookmark_border,
        title: l.savedEmptyTitle,
        subtitle: l.savedEmptySubtitle,
      );
    }

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: pagePad.copyWith(top: 16, bottom: 16),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.savedTitle,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.delete_sweep_outlined),
                      label: Text(l.savedClearAll),
                      onPressed: () => _confirmClear(context, controller, l),
                    ),
                  ],
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
              itemCount: state.recipes.length,
              itemBuilder: (_, i) =>
                  RecipeCard(recipe: state.recipes[i]),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  Future<void> _confirmClear(
    BuildContext context,
    SavedRecipesController controller,
    AppL10n l,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.savedClearConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.savedClearConfirmNo),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.savedClearConfirmYes),
          ),
        ],
      ),
    );
    if (ok == true) controller.clearAll();
  }
}
