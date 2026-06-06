import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/api_client.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/spice_route.dart';
import '../../shared/breakpoints.dart';
import '../../shared/cuisine_pill_bar.dart';
import '../../shared/widgets.dart';
import '../../state/providers.dart';
import '../../state/saved.dart';

final _detailProvider =
    FutureProvider.family<SpiceRouteDetail, String>((ref, id) async {
  return ref.read(apiClientProvider).getRecipe(id);
});

class RecipeDetailScreen extends ConsumerWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});
  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final async = ref.watch(_detailProvider(recipeId));
    final myId = ref.watch(meProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            final navigator = Navigator.of(context);
            final router = GoRouter.of(context);
            final popped = await navigator.maybePop();
            if (!popped) router.go('/');
          },
        ),
        title: Text(l.appTitle),
        actions: async.maybeWhen(
          data: (recipe) {
            final isOwner =
                myId != null && recipe.owner?.id == myId;
            if (!isOwner) return const <Widget>[];
            return [
              IconButton(
                tooltip: l.detailDelete,
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(context, ref, recipe.id),
              ),
              const SizedBox(width: 4),
            ];
          },
          orElse: () => const <Widget>[],
        ),
      ),
      body: async.when(
        data: (recipe) => _DetailBody(recipe: recipe),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => CenterMessage(
          icon: Icons.error_outline,
          title: l.commonError,
          subtitle: (e is ApiException) ? e.message : e.toString(),
          action: FilledButton(
            onPressed: () => ref.invalidate(_detailProvider(recipeId)),
            child: Text(l.commonRetry),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final l = AppL10n.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.detailDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.detailDeleteOk),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await ref.read(apiClientProvider).deleteRecipe(id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.detailDeletedToast)),
      );
      GoRouter.of(context).go('/my-recipes');
    } on ApiException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.recipe});
  final SpiceRouteDetail recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final saved = ref.watch(savedRecipesProvider);
    final isSaved = saved.isSaved(recipe.id);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (recipe.imageUrl != null)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              imageUrl: recipe.imageUrl!,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(
                  color: theme.colorScheme.surfaceContainerHighest),
              errorWidget: (_, _, _) => Container(
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.restaurant_menu, size: 48),
              ),
            ),
          ),
        Padding(
          padding: pagePadding(context).copyWith(top: 24, bottom: 32),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMaxWidth(context)),
              child: LayoutBuilder(
                builder: (ctx, constraints) {
                  final wide = constraints.maxWidth >= 720;
                  final ingredientsBlock = _IngredientsBlock(recipe: recipe);
                  final stepsBlock = _StepsBlock(recipe: recipe);
                  final header = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (recipe.cuisine != null)
                            Chip(
                              label: Text(CuisinePillBar.labelFor(
                                  l, recipe.cuisine!)),
                              backgroundColor: theme
                                  .colorScheme.primary
                                  .withValues(alpha: 0.12),
                            ),
                          if (recipe.isPremium)
                            Chip(label: Text(l.recipePremiumBadge)),
                          if (recipe.isAiAuthored)
                            Chip(label: Text(l.recipeAiBadge)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(recipe.title,
                          style: theme.textTheme.displayMedium),
                      const SizedBox(height: 12),
                      if ((recipe.description ?? '').isNotEmpty)
                        Text(recipe.description!,
                            style: theme.textTheme.bodyLarge),
                      if ((recipe.description ?? '').isEmpty)
                        Text(l.detailNoDescription,
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.outline)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.schedule,
                              size: 16, color: theme.colorScheme.outline),
                          const SizedBox(width: 6),
                          Text(l.recipeMinutesShort(recipe.totalMinutes),
                              style: theme.textTheme.bodyMedium),
                          const SizedBox(width: 18),
                          Icon(Icons.restaurant,
                              size: 16, color: theme.colorScheme.outline),
                          const SizedBox(width: 6),
                          Text(l.recipeServings(recipe.servings),
                              style: theme.textTheme.bodyMedium),
                          const SizedBox(width: 18),
                          Icon(Icons.local_fire_department,
                              size: 16, color: theme.colorScheme.outline),
                          const SizedBox(width: 6),
                          Text(_spiceLabel(l, recipe.spiceLevel),
                              style: theme.textTheme.bodyMedium),
                        ],
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: () => ref
                            .read(savedRecipesProvider.notifier)
                            .toggle(recipe),
                        icon: Icon(isSaved
                            ? Icons.bookmark
                            : Icons.bookmark_border),
                        label: Text(isSaved ? l.detailSaved : l.detailSave),
                      ),
                      const SizedBox(height: 32),
                    ],
                  );

                  if (wide) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        header,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: ingredientsBlock),
                            const SizedBox(width: 32),
                            Expanded(flex: 3, child: stepsBlock),
                          ],
                        ),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      header,
                      ingredientsBlock,
                      const SizedBox(height: 28),
                      stepsBlock,
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _spiceLabel(AppL10n l, int level) {
    switch (level) {
      case 3:
        return l.recipeSpiceLevel3;
      case 2:
        return l.recipeSpiceLevel2;
      case 1:
        return l.recipeSpiceLevel1;
      default:
        return l.recipeSpiceLevel0;
    }
  }
}

class _IngredientsBlock extends StatelessWidget {
  const _IngredientsBlock({required this.recipe});
  final SpiceRouteDetail recipe;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.detailIngredients, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 12),
        for (final ing in recipe.ingredients)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6, right: 12),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    [
                      if (ing.quantity != null) _fmtQty(ing.quantity!),
                      if (ing.unit != null) ing.unit,
                      ing.name,
                    ].whereType<String>().join(' '),
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _fmtQty(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '').replaceFirst(
          RegExp(r'\.$'),
          '',
        );
  }
}

class _StepsBlock extends StatelessWidget {
  const _StepsBlock({required this.recipe});
  final SpiceRouteDetail recipe;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.detailSteps, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 12),
        for (var i = 0; i < recipe.steps.length; i++) ...[
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.detailStepNumber(i + 1),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(recipe.steps[i].body, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
