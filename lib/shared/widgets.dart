import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/spice_route.dart';
import '../state/saved.dart';
import 'format.dart';

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
    // Scope the listen to *just this card's saved bit*. The previous
    // `ref.watch(savedRecipesProvider)` rebuilt every visible card whenever
    // any bookmark toggled — with 24+ cards on Explore that meant 24+
    // CachedNetworkImage / Material rebuilds per tap and a perceptible
    // input lag.
    final isSaved = ref.watch(
      savedRecipesProvider.select((s) => s.ids.contains(recipe.id)),
    );

    // RepaintBoundary makes each card its own layer — without it, scrolling
    // a grid of 24 cards forces the whole viewport to repaint per frame,
    // which is what makes Flutter web feel "syrupy". With it, only newly
    // visible / animating cards repaint.
    return RepaintBoundary(
      child: Card(
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
                      // 500 ms fade-in (CachedNetworkImage default) is jarring
                      // on a fast cache hit. 150 ms feels instant when cached
                      // and still smooth on cold loads.
                      fadeInDuration: const Duration(milliseconds: 150),
                      fadeOutDuration: const Duration(milliseconds: 100),
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
                      // Solid surface (no alpha) so the icon sits on a stable
                      // background regardless of how dark/light the photo is —
                      // a translucent surface in dark mode was washing the
                      // bookmark icon out almost completely.
                      color: theme.colorScheme.surface,
                      shape: const CircleBorder(),
                      elevation: 1,
                      child: IconButton(
                        tooltip: isSaved ? l.detailUnsave : l.detailSave,
                        onPressed: () => ref
                            .read(savedRecipesProvider.notifier)
                            .toggle(recipe),
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          // High-contrast foreground vs. surface in both
                          // brightnesses — primary on cream looks OK but
                          // dropped into invisibility on the dark olive
                          // surface.
                          color: theme.colorScheme.onSurface,
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
                  // Use onSurfaceVariant for the meta row — same hue as the
                  // small text but at full opacity, so the schedule / fork /
                  // flame glyphs are actually visible on dark cards instead
                  // of fading into the background.
                  Builder(builder: (context) {
                    final metaColor = theme.colorScheme.onSurfaceVariant;
                    return Row(
                      children: [
                        Icon(Icons.schedule, size: 14, color: metaColor),
                        const SizedBox(width: 4),
                        Text(
                          formatRecipeDuration(l, recipe.totalMinutes),
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(width: 14),
                        Icon(Icons.restaurant, size: 14, color: metaColor),
                        const SizedBox(width: 4),
                        Text(
                          l.recipeServings(recipe.servings),
                          style: theme.textTheme.bodySmall,
                        ),
                        if (recipe.caloriesPerServing != null) ...[
                          const SizedBox(width: 14),
                          Icon(
                            Icons.local_fire_department_outlined,
                            size: 14,
                            color: metaColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l.recipeKcal(recipe.caloriesPerServing!),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
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
