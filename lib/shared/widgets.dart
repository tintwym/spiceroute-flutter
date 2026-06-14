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

/// Clean footer row: time · servings · calories on the left. On
/// roomy widths a soft difficulty pill is also pinned to the far
/// right; on tight widths the pill is suppressed so the data fits.
///
/// Two render modes, picked by [LayoutBuilder] from the footer width.
///
/// Worst-case glyph budget (English, fontSize 11):
///   * time "1 h 15 min" + icon  ≈  90 dp
///   * servings "4" + icon        ≈  35 dp
///   * compact kcal "620" + icon  ≈  35 dp
///   * full kcal "620 kcal" + ic. ≈  80 dp
///   * "MEDIUM" difficulty pill   ≈  70 dp
///
/// **Tight mode** (footer < 290 dp — desktop 4-up grid cells run
/// ~184–280 dp on most laptops, small-tablet 2-up runs ~232–303 dp,
/// some narrow phone columns dip below 290 too):
///   - 8-dp gaps
///   - difficulty pill is **dropped** at this width band. Worst-case
///     English ("1 h 15 min") needs ~90 dp at intrinsic; with the
///     pill (~70 dp) + servings (~35 dp) + compact kcal (~35 dp) +
///     three 8-dp gaps the row totals 254 dp before any Spacer
///     slack. Anything narrower forced the time to ellipsize to
///     "1 h 15 …", which is what users actually saw on every
///     1280-px-class laptop. Dropping the pill (stylistic chrome
///     that's already redundant with cooking time — longer cook =
///     harder) frees that 70 dp so the *data* (time/servings/kcal)
///     all renders verbatim.
///   - items pack left (no [Spacer]); the freed slack sits as empty
///     space on the right of the row
///   - [Flexible] wrapper on time stays as a safety net for sub-130-dp
///     viewports; at every realistic width it's a no-op and time
///     takes its intrinsic size
///   - kcal stays in compact form ("620"), and is dropped entirely
///     only below 180 dp (where time + servings is the floor)
///
/// **Roomy mode** (footer ≥ 290 dp — phone single-column, tablet 2-up
/// at full width, recipe-detail modal). CSS analogue:
///   - `display: flex; align-items: center; gap: 16px` (or 24 px
///     above 360 dp where every metric fits with breathing room)
///   - metrics are `flex-shrink: 0` so "1 h 15 min" is never
///     ellipsized — previously the time was wrapped in [Flexible]
///     and lost the fight for space against the [Spacer] + kcal
///     block, truncating to "1 h 15 ...".
///   - kcal is full "620 kcal" above 380 dp, compact "620" below;
///     it's no longer hidden anywhere in this band.
///
/// History:
///   * v1: tight at <230, roomy at ≥230, `hideKcal = w < 290`
///     inside roomy. → dead band 230–289 dp where kcal silently
///     vanished on every wide-tier 4-up laptop layout.
///   * v2: lifted boundary to 290 dp so wide-tier 4-up landed in
///     tight mode and showed compact kcal. But the tight-mode row
///     still kept the difficulty pill + Spacer, leaving Flexible
///     time fighting Flexible kcal and Spacer for residual space —
///     time ellipsized to "1 h 15 …" on those same layouts.
///   * v3: tight mode dropped the difficulty pill entirely so
///     time, servings, and kcal could pack left at intrinsic. Time
///     was preserved, but the pill silently vanished on every
///     mobile / 4-up card — visible empty space on the right
///     where the pill would have fit. Reported as "what's
///     missing?" with a screenshot.
///   * v4 (current): tight mode keeps everything packed left at
///     intrinsic, AND brings the pill back inline (right after
///     kcal, no Spacer). Time + pill are wrapped in [Flexible]
///     with weights 4 : 1 so if a verbose locale ever pushes the
///     row past the viewport, the pill ellipsizes ("INTRICA…")
///     well before time does. In every realistic production
///     layout (Inter / Noto fonts) all four items render at
///     intrinsic with slack to spare; the flex weights are pure
///     defense-in-depth.
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
      // Tight mode (4-up desktop / wide grids, small-tablet 2-up,
      // and any other layout below the 290-dp threshold).
      //
      // Items pack LEFT at intrinsic widths (no Spacer); the
      // difficulty pill rides at the end of the row.
      //
      // Time and pill are wrapped in [Flexible] with weights 4 : 1.
      // At every realistic production-font width all four items
      // fit at intrinsic and the Flexibles are no-ops. The weights
      // only kick in when total intrinsic exceeds the viewport
      // (verbose locale + degenerate width); when they do, the
      // pill is allowed to shrink to ~1/5 of the residual budget
      // and ellipsizes first ("INTRICA…"). Time stays readable
      // because its 4/5 share is enough for any locale's time
      // formatter output we ship.
      //
      // Sub-band at < 180 dp drops kcal too — only time + servings
      // + pill can fit at this floor (~140 dp Inter).
      // -----------------------------------------------------------
      if (w < 290) {
        final hideKcal = w < 180;
        final kcalText = kcal == null ? null : '$kcal';
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 4,
              child: _MetaItem(icon: Icons.schedule, text: timeText),
            ),
            const SizedBox(width: 8),
            _MetaItem(
                icon: Icons.person_outline, text: '${recipe.servings}'),
            if (kcalText != null && !hideKcal) ...[
              const SizedBox(width: 8),
              _MetaItem(
                icon: Icons.local_fire_department_outlined,
                text: kcalText,
              ),
            ],
            const SizedBox(width: 8),
            Flexible(
              flex: 1,
              child: _DifficultyPill(label: difficulty),
            ),
          ],
        );
      }

      // -----------------------------------------------------------
      // Roomy mode. flex-shrink: 0 on every metric.
      //
      // Gap: 16 dp until we reach 360 dp footer width, where the
      // worst-case English "1 h 15 min" fits at intrinsic + a
      // 24 dp-gap layout still leaves comfortable Spacer slack.
      //
      // Compact kcal up to 380 dp; above that the full "$kcal kcal"
      // localized form fits without crowding the difficulty pill.
      // -----------------------------------------------------------
      final gap = w < 360 ? 16.0 : 24.0;
      final compactKcal = w < 380;
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
          _MetaItem(icon: Icons.schedule, text: timeText),
          SizedBox(width: gap),
          _MetaItem(icon: Icons.person_outline, text: '${recipe.servings}'),
          if (kcalText != null) ...[
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
