import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/spice_route.dart';
import '../state/saved.dart';
import 'cuisine_pill_bar.dart';
import 'dish_emoji.dart';
import 'format.dart';
import 'theme.dart';

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

    final content = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Padding(
        padding: const EdgeInsets.all(32),
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
    );

    // "Fits when it can, scrolls when it can't." Under
    // SliverFillRemaining(hasScrollBody: false) the child gets a
    // fixed viewport-height box, so on tight viewports a pure Column
    // overflows (the 5 px BOTTOM OVERFLOW warning). Wrapping in a
    // SingleChildScrollView whose child has minHeight = viewport
    // height preserves vertical centering for the common case
    // (content < viewport) and falls back to scrolling when it
    // doesn't fit.
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.maxHeight.isFinite) {
          return Center(child: content);
        }
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: content),
          ),
        );
      },
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
                    // derived per-recipe (pie slice for Quiche, eggplant
                    // for Ratatouille, poultry leg for Coq au Vin, …)
                    // by [dishEmojiFor] instead of one icon per cuisine.
                    // Falls back to the per-cuisine emoji and finally a
                    // generic plate, so the badge is always present and
                    // visually differentiates rows of same-cuisine
                    // dishes that previously all wore the same icon.
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
                              dishEmojiFor(recipe),
                              // Use the emoji-safe TextStyle helper so
                              // CanvasKit can locate a color emoji
                              // glyph for the badge — a plain
                              // `TextStyle(fontSize: 17)` rendered as
                              // a blank box on Flutter web.
                              style: emojiTextStyle(fontSize: 17),
                            ),
                          ),
                          if (recipe.isAiAuthored) ...[
                            const SizedBox(width: 6),
                            const _AiBadge(),
                          ],
                        ],
                      ),
                    ),
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
/// Two render modes, picked by [LayoutBuilder] from the footer width:
///
/// **Roomy mode** (footer ≥ 230 dp — phone single-column, tablet
/// 2-up, recipe-detail modal). CSS analogue:
///   - `display: flex; align-items: center;`
///   - uniform `gap: 24px` between metric blocks (`16px` on the
///     tighter end of the band so things still fit)
///   - metrics are `flex-shrink: 0` so "1 h 15 min" is never
///     ellipsized — previously the time was wrapped in [Flexible]
///     and lost the fight for space against the [Spacer] + kcal
///     block, truncating to "1 h 15 ...".
///   - difficulty pill uses `margin-left: auto` (= [Spacer]) to
///     pin to the far right.
///
/// **Narrow mode** (footer < 230 dp — desktop 4-up grid cells run
/// 190-220 dp). flex-shrink:0 mathematically cannot fit time + pill
/// + difficulty here in worst-case locales, so we fall back to the
/// legacy layout: tight 8-dp gaps and a [Flexible]-wrapped time
/// that ellipsizes gracefully rather than overflowing the cell.
class _CardFooter extends StatelessWidget {
  const _CardFooter({required this.recipe});
  final SpiceRouteSummary recipe;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final difficulty =
        recipeDifficultyLabel(l, totalMinutes: recipe.totalMinutes);
    final timeText = formatRecipeDuration(l, recipe.totalMinutes);

    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final kcal = recipe.caloriesPerServing;

      // -----------------------------------------------------------
      // Narrow mode (4-up desktop grid). Keep the original layout
      // here — flex-shrink:0 is genuinely impossible at <190 dp
      // when "1 h 15 min" alone wants ~90 dp.
      // -----------------------------------------------------------
      if (w < 230) {
        final compactKcal = w < 190;
        final hideKcal = w < 150;
        final kcalText = kcal == null
            ? null
            : (compactKcal ? '$kcal' : l.recipeKcal(kcal));
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child: _MetaItem(icon: Icons.schedule, text: timeText)),
            const SizedBox(width: 8),
            _MetaItem(
                icon: Icons.person_outline, text: '${recipe.servings}'),
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
      }

      // -----------------------------------------------------------
      // Roomy mode — the user-requested layout. Thresholds chosen
      // for the worst-case glyph budget:
      //   - "1 h 15 min" + icon ≈ 90 dp in English at fontSize 11,
      //     up to ~125 dp under wide-glyph fonts (verbose locales,
      //     Ahem test font).
      //   - "MEDIUM" pill ≈ 70 dp (label + pill padding).
      //   - "620 kcal" + icon ≈ 80 dp; "620" alone ≈ 35 dp.
      // -----------------------------------------------------------
      final gap = w < 300 ? 16.0 : 24.0;
      final compactKcal = w < 380;
      final hideKcal = w < 290;
      final kcalText = kcal == null
          ? null
          : (compactKcal ? '$kcal' : l.recipeKcal(kcal));

      return Row(
        // align-items: center. Default for Row is already center, but
        // make it explicit — the icons (12 dp) and text (~14 dp)
        // have different intrinsic heights, and the difficulty pill
        // is taller still (~24 dp). Without an explicit alignment
        // the pill would baseline-drift on locales with tall scripts.
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // No outer Flexible: each _MetaItem keeps its intrinsic
          // width (flex-shrink: 0). This is the core of the fix.
          _MetaItem(icon: Icons.schedule, text: timeText),
          SizedBox(width: gap),
          _MetaItem(icon: Icons.person_outline, text: '${recipe.servings}'),
          if (kcalText != null && !hideKcal) ...[
            SizedBox(width: gap),
            _MetaItem(
              icon: Icons.local_fire_department_outlined,
              text: kcalText,
            ),
          ],
          // margin-left: auto — pushes the difficulty pill to the
          // far right and absorbs whatever slack remains.
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
    final emoji = dishEmojiFor(recipe);
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
            Text(emoji, style: emojiTextStyle(fontSize: 44)),
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
