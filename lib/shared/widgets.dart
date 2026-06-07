import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/spice_route.dart';
import '../state/saved.dart';

class CenterMessage extends StatelessWidget {
  const CenterMessage({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56, color: theme.colorScheme.outline),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
              if (action != null) ...[
                const SizedBox(height: 20),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key, this.height = 120});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

void showAppSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// Single recipe card used by Explore + Saved.
class RecipeCard extends ConsumerWidget {
  const RecipeCard({super.key, required this.recipe});
  final SpiceRouteSummary recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final saved = ref.watch(savedRecipesProvider);
    final isSaved = saved.isSaved(recipe.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/recipes/${recipe.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (recipe.imageUrl != null)
                    CachedNetworkImage(
                      imageUrl: recipe.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                      errorWidget: (_, _, _) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.restaurant_menu, size: 36),
                      ),
                    )
                  else
                    Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.restaurant_menu, size: 36),
                    ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Wrap(
                      spacing: 6,
                      children: [
                        if (recipe.isPremium)
                          _Chip.filled(
                            text: l.recipePremiumBadge,
                            color: theme.colorScheme.primary,
                            onColor: theme.colorScheme.onPrimary,
                          ),
                        if (recipe.isAiAuthored)
                          _Chip.filled(
                            text: l.recipeAiBadge,
                            color: theme.colorScheme.secondary,
                            onColor: theme.colorScheme.onPrimary,
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: theme.colorScheme.surface.withValues(alpha: 0.9),
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: isSaved ? l.detailUnsave : l.detailSave,
                        onPressed: () => ref
                            .read(savedRecipesProvider.notifier)
                            .toggle(recipe),
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  if (recipe.description != null)
                    Text(
                      recipe.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.schedule,
                          size: 14, color: theme.colorScheme.outline),
                      const SizedBox(width: 4),
                      Text(
                        l.recipeMinutesShort(recipe.totalMinutes),
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 14),
                      Icon(Icons.restaurant,
                          size: 14, color: theme.colorScheme.outline),
                      const SizedBox(width: 4),
                      Text(
                        l.recipeServings(recipe.servings),
                        style: theme.textTheme.bodySmall,
                      ),
                      if (recipe.caloriesPerServing != null) ...[
                        const SizedBox(width: 14),
                        Icon(Icons.local_fire_department_outlined,
                            size: 14, color: theme.colorScheme.outline),
                        const SizedBox(width: 4),
                        Text(
                          l.recipeKcal(recipe.caloriesPerServing!),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip.filled({
    required this.text,
    required this.color,
    required this.onColor,
  });

  final String text;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: onColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
