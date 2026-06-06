import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../shared/breakpoints.dart';
import '../../shared/widgets.dart';
import '../../state/saved.dart';

class SavedRecipesScreen extends ConsumerWidget {
  const SavedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final state = ref.watch(savedRecipesProvider);
    final controller = ref.read(savedRecipesProvider.notifier);

    Widget body;
    if (state.loading && state.recipes.isEmpty) {
      body = ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: 4,
        itemBuilder: (_, _) => const LoadingShimmer(height: 240),
      );
    } else if (state.recipes.isEmpty) {
      body = CenterMessage(
        icon: Icons.bookmark_border,
        title: l.savedEmptyTitle,
        subtitle: l.savedEmptySubtitle,
      );
    } else {
      body = ListView(
        padding: pagePadding(context).copyWith(top: 16, bottom: 32),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMaxWidth(context)),
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
          const SizedBox(height: 16),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMaxWidth(context)),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
        ],
      );
    }

    return body;
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
