import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/spice_route.dart';
import '../state/saved.dart';
import 'cuisine_pill_bar.dart';
import 'format.dart';

/// Muted orange/brown used for the cuisine eyebrow on cards and the
/// difficulty pill text — reads on both the cream and dark-olive surfaces.
const Color _cuisineTagColor = Color(0xFFB5703C);

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
    final cs = theme.colorScheme;

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
                        fadeInDuration: const Duration(milliseconds: 150),
                        fadeOutDuration: const Duration(milliseconds: 100),
                        placeholder: (_, _) =>
                            Container(color: cs.surfaceContainerHighest),
                        errorWidget: (_, _, _) =>
                            _ImageFallback(recipe: recipe),
                      )
                    else
                      _ImageFallback(recipe: recipe),
                    // Top-left "what kind of dish" badge — a food emoji
                    // (sushi for Japanese, taco for Mexican, etc.) on a
                    // creamy circular chip. Keeps the photo content the
                    // hero and gives a glanceable dish-type cue without
                    // duplicating the country flag (the flag stays inside
                    // the filter dropdown).
                    if (recipe.cuisine != null)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: cs.surface,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.18),
                                    blurRadius: 6,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Text(
                                CuisinePillBar.foodEmojiFor(recipe.cuisine!),
                                style: const TextStyle(fontSize: 17, height: 1),
                              ),
                            ),
                            if (recipe.isAiAuthored) ...[
                              const SizedBox(width: 6),
                              const _AiBadge(),
                            ],
                          ],
                        ),
                      )
                    else if (recipe.isAiAuthored)
                      const Positioned(top: 10, left: 10, child: _AiBadge()),
                    // Top-right bookmark (solid bg for contrast on any photo).
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: cs.surface,
                        shape: const CircleBorder(),
                        elevation: 1,
                        child: IconButton(
                          tooltip: isSaved ? l.detailUnsave : l.detailSave,
                          visualDensity: VisualDensity.compact,
                          onPressed: () => ref
                              .read(savedRecipesProvider.notifier)
                              .toggle(recipe),
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (recipe.cuisine != null) ...[
                      Text(
                        CuisinePillBar.labelFor(l, recipe.cuisine!)
                            .toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _cuisineTagColor,
                          fontSize: 11,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      recipe.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 16.5,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (recipe.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        recipe.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: 10),
                    Divider(height: 1, color: cs.outlineVariant),
                    const SizedBox(height: 10),
                    _CardFooter(recipe: recipe),
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

/// Clean footer row: time · servings · calories on the left, a soft
/// difficulty pill pinned to the far right.
///
/// Cards are very narrow at 4-up (~190-210 px usable width), so this
/// uses a [LayoutBuilder] to drop the kcal unit (and, if needed, the
/// kcal item entirely) before any [Row] children overflow.
class _CardFooter extends StatelessWidget {
  const _CardFooter({required this.recipe});
  final SpiceRouteSummary recipe;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final difficulty =
        recipeDifficultyLabel(l, totalMinutes: recipe.totalMinutes);

    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final compactKcal = w < 240; // strip the " kcal" suffix
      final hideKcal = w < 175; // not enough room at all

      final kcal = recipe.caloriesPerServing;
      final kcalText = kcal == null
          ? null
          : (compactKcal ? '$kcal' : l.recipeKcal(kcal));

      return Row(
        children: [
          Flexible(
            child: _MetaItem(
              icon: Icons.schedule,
              text: formatRecipeDuration(l, recipe.totalMinutes),
            ),
          ),
          const SizedBox(width: 8),
          _MetaItem(icon: Icons.person_outline, text: '${recipe.servings}'),
          if (kcalText != null && !hideKcal) ...[
            const SizedBox(width: 8),
            Flexible(
              child: _MetaItem(
                icon: Icons.local_fire_department_outlined,
                text: kcalText,
              ),
            ),
          ],
          const Spacer(),
          _DifficultyPill(label: difficulty),
        ],
      );
    });
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontSize: 11,
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}

/// Cream→stone gradient with a centered cuisine emoji, shown when the
/// image either failed to load or the recipe has no `imageUrl`. Matches
/// the React placeholder treatment so the card never collapses into a
/// flat grey square.
class _ImageFallback extends StatelessWidget {
  const _ImageFallback({required this.recipe});
  final SpiceRouteSummary recipe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final emoji = recipe.cuisine == null
        ? '🥘'
        : CuisinePillBar.foodEmojiFor(recipe.cuisine!);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.surface,
            cs.surfaceContainerHighest,
            cs.surfaceContainerHigh,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 44, height: 1)),
            if (recipe.cuisine != null) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Text(
                  CuisinePillBar.labelFor(AppL10n.of(context), recipe.cuisine!)
                      .toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// "AI" pill matching the React card — dark olive chip with a chef-hat
/// icon, shown on AI-authored recipes (owner-less, non-premium).
class _AiBadge extends StatelessWidget {
  const _AiBadge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cs.onSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.soup_kitchen_outlined,
              size: 11, color: cs.onInverseSurface),
          const SizedBox(width: 4),
          Text(
            'AI',
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.onInverseSurface,
              fontWeight: FontWeight.w800,
              fontSize: 9.5,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Soft light-orange pill on the far right of the card footer.
class _DifficultyPill extends StatelessWidget {
  const _DifficultyPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        label.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: theme.textTheme.labelSmall?.copyWith(
          color: _cuisineTagColor,
          fontSize: 9.5,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
