import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/cuisine_catalog.dart';
import '../models/cuisine_region.dart';
import '../models/spice_route.dart';
import '../state/saved.dart';
import 'breakpoints.dart';
import 'cuisine_chrome.dart';
import 'cuisine_pill_bar.dart';
import 'dish_emoji.dart';
import 'format.dart';
import 'recipe_image.dart';
import 'theme.dart';

/// Muted orange/brown used for the cuisine eyebrow on cards and the
/// difficulty pill text — reads on both the cream and dark-olive surfaces.
const Color _cuisineTagColor = Color(0xFFB5703C);

/// Fixed text-band heights for [RecipeCard.fillGridCell] so every tile
/// in a grid row lines up on web.
const double _kCardCuisineSlotHeight = 32;
const double _kCardFooterSlotHeight = 28;

/// Two-line web grid footer (time/servings, then kcal/pill) — taller than
/// the single-line slot used on phone list cards and native grid tiles.
const double _kWebGridCardFooterSlotHeight = 44;

/// Tighter slots for grid cells — the aspect-ratio band reserves a fixed
/// text height; these numbers must sum (with padding + divider) to less
/// than that band or the Column overflows (~9 px at ~228 dp card width).
const double _kGridCuisineSlotHeight = 30;
const double _kGridTitleSlotHeight = 36;
const double _kGridDescSlotHeight = 32;

/// Decode width for recipe card thumbnails — caps memory + decode work on
/// web without visibly softening 4:3 card images.
int recipeThumbnailCachePx(BuildContext context) {
  final dpr = MediaQuery.devicePixelRatioOf(context);
  final logical = deviceClassOf(context).isPhone
      ? MediaQuery.sizeOf(context).width
      : recipeCardMaxExtent(context);
  return (logical * dpr).round().clamp(280, 720);
}

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
            if (action != null) ...[const SizedBox(height: 20), action!],
          ],
        ),
      ),
    );

    // Do not use LayoutBuilder here — SliverFillRemaining asks its child
    // for intrinsic dimensions, and LayoutBuilder cannot answer that
    // (runtime assert on web). A plain Center + scrollable content works
    // in both sliver and box parents.
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: content,
      ),
    );
  }
}

class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({super.key, this.height = 120});
  final double height;

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sweep;
  var _started = false;

  @override
  void initState() {
    super.initState();
    _sweep = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.of(context).disableAnimations) {
      _sweep.value = 0;
      return;
    }
    _sweep.repeat();
  }

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final base = cs.surfaceContainerHighest;
    final highlight = cs.surfaceContainerHigh;

    return AnimatedBuilder(
      animation: _sweep,
      builder: (context, _) {
        final t = _sweep.value;
        return Container(
          height: widget.height,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment(-1.5 + 3 * t, 0),
              end: Alignment(-0.5 + 3 * t, 0),
              colors: [base, highlight, base],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// Sliver footer for "next page failed" inside an infinite-scroll grid.
///
/// Rendered below the existing items when a follow-up `loadMore()`
/// call errors but the first page is already on-screen. Without
/// this, the user scrolls to the bottom, the network fails, and
/// the spinner just disappears with no signal — they're convinced
/// they've reached the end of the data, even though more pages
/// exist server-side. This widget surfaces the failure AND offers
/// a one-tap retry so the user can recover without hunting for
/// pull-to-refresh.
///
/// Shared between Explore and My Recipes (and any future
/// infinite-scroll grid) so all paginated surfaces have identical
/// recovery affordances.
class LoadMoreErrorFooter extends StatelessWidget {
  const LoadMoreErrorFooter({
    super.key,
    required this.message,
    required this.onRetry,
  });

  /// Localized failure copy (caller is responsible for translating
  /// any sentinel strings via `localizeApiErrorMessage`).
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 28, color: cs.onSurfaceVariant),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(AppL10n.of(context).exploreErrorRetry),
            ),
          ],
        ),
      ),
    );
  }
}

void showAppSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
}

/// Single recipe card used by Explore + Saved.
class RecipeCard extends ConsumerWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    this.fillGridCell = false,
    this.twoLineGridFooter,
  });
  final SpiceRouteSummary recipe;

  /// When true the card stretches to the grid cell's fixed height and
  /// uses fixed-height text slots so every tile in a row is identical.
  final bool fillGridCell;

  /// When set, overrides the default web-only two-line grid footer. Used by
  /// widget tests (`kIsWeb` is false in the test harness).
  final bool? twoLineGridFooter;

  /// Fills the [SliverGrid] cell on tablet+ grids; phones use a compact list.
  static Widget gridCell(BuildContext context, SpiceRouteSummary recipe) =>
      RecipeCard(
        recipe: recipe,
        fillGridCell: deviceClassOf(context).isAtLeastTablet,
      );

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
        margin: EdgeInsets.zero,
        child: fillGridCell
            ? SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: _buildInkWell(context, ref, l, theme, cs, isSaved),
              )
            : _buildInkWell(context, ref, l, theme, cs, isSaved),
      ),
    );
  }

  Widget _buildInkWell(
    BuildContext context,
    WidgetRef ref,
    AppL10n l,
    ThemeData theme,
    ColorScheme cs,
    bool isSaved,
  ) {
    return InkWell(
      onTap: () => context.push('/recipes/${recipe.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: fillGridCell ? MainAxisSize.max : MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: _buildImageStack(context, cs, isSaved, l, ref),
          ),
          if (fillGridCell)
            Expanded(
              child: _buildGridTextBody(
                context,
                l,
                theme,
                cs,
                twoLineFooter: twoLineGridFooter ?? kIsWeb,
              ),
            )
          else
            _buildFlexibleTextBody(l, theme, cs),
        ],
      ),
    );
  }

  Widget _buildImageStack(
    BuildContext context,
    ColorScheme cs,
    bool isSaved,
    AppL10n l,
    WidgetRef ref,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (recipe.imageUrl != null)
          CachedNetworkImage(
            imageUrl: recipe.imageUrl!,
            httpHeaders: recipeImageHttpHeaders(recipe.imageUrl!),
            fit: BoxFit.cover,
            memCacheWidth: recipeThumbnailCachePx(context),
            fadeInDuration: const Duration(milliseconds: 120),
            fadeOutDuration: const Duration(milliseconds: 80),
            placeholder: (_, _) => Container(color: cs.surfaceContainerHighest),
            errorWidget: (_, _, _) => _ImageFallback(recipe: recipe),
          )
        else
          _ImageFallback(recipe: recipe),
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
        Positioned(
          top: 8,
          right: 8,
          child: Material(
            color: cs.surface,
            shape: const CircleBorder(),
            elevation: 1,
            child: IconButton(
              tooltip: isSaved ? l.detailUnsave : l.detailSave,
              onPressed: () =>
                  ref.read(savedRecipesProvider.notifier).toggle(recipe),
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: cs.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFlexibleTextBody(AppL10n l, ThemeData theme, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._cardCuisineHeader(l, theme, recipe),
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
    );
  }

  Widget _buildGridTextBody(
    BuildContext context,
    AppL10n l,
    ThemeData theme,
    ColorScheme cs, {
    required bool twoLineFooter,
  }) {
    final footerSlotHeight = twoLineFooter
        ? _kWebGridCardFooterSlotHeight
        : _kCardFooterSlotHeight;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardCuisineHeaderSlot(
                l,
                theme,
                recipe,
                slotHeight: _kGridCuisineSlotHeight,
              ),
              SizedBox(
                height: _kGridTitleSlotHeight,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    recipe.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 16.5,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: _kGridDescSlotHeight,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    recipe.description ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
              const Spacer(),
              Divider(height: 1, color: cs.outlineVariant),
              const SizedBox(height: 6),
              SizedBox(
                height: footerSlotHeight,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _CardFooter(
                    recipe: recipe,
                    layoutWidth: constraints.maxWidth,
                    twoLineLayout: twoLineFooter,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

List<Widget> _cardCuisineHeader(
  AppL10n l,
  ThemeData theme,
  SpiceRouteSummary recipe,
) {
  final cuisine = recipe.cuisine;
  final wire = recipe.cuisineWire;
  if (cuisine == null && (wire == null || wire.isEmpty)) {
    return const [];
  }

  final cs = theme.colorScheme;
  final displayCuisine = cuisine != null ? cuisineForDisplay(cuisine) : null;
  final cuisineName = displayCuisine != null
      ? cuisineLabel(l, displayCuisine)
      : humanizeCuisineWire(wire!);
  final region = displayCuisine?.region;

  return [
    if (region != null) ...[
      Text(
        regionLabel(l, region).toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelSmall?.copyWith(
          color: cs.onSurfaceVariant,
          fontSize: 10,
          letterSpacing: 0.9,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 2),
    ],
    Text(
      cuisineName.toUpperCase(),
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
  ];
}

/// Fixed-height cuisine band used in grid cards — always reserves space
/// for region + cuisine even when one line is empty.
Widget _cardCuisineHeaderSlot(
  AppL10n l,
  ThemeData theme,
  SpiceRouteSummary recipe, {
  double slotHeight = _kCardCuisineSlotHeight,
}) {
  final cuisine = recipe.cuisine;
  final wire = recipe.cuisineWire;
  final cs = theme.colorScheme;
  final displayCuisine = cuisine != null ? cuisineForDisplay(cuisine) : null;
  final cuisineName = displayCuisine != null
      ? cuisineLabel(l, displayCuisine)
      : (wire != null && wire.isNotEmpty ? humanizeCuisineWire(wire) : null);
  final region = displayCuisine?.region;

  return SizedBox(
    height: slotHeight,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 12,
          child: region != null
              ? Text(
                  regionLabel(l, region).toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontSize: 10,
                    letterSpacing: 0.9,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
        ),
        const SizedBox(height: 2),
        SizedBox(
          height: 14,
          child: cuisineName != null
              ? Text(
                  cuisineName.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _cuisineTagColor,
                    fontSize: 11,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null,
        ),
      ],
    ),
  );
}

/// Three-zone footer row: time pinned left, servings + kcal centered in
/// the middle column, difficulty pill pinned right.
///
/// Every card uses the same layout regardless of cook-time length — the
/// old Stack overlay centered metrics across the *full* card width, so
/// "45 min" cards looked nothing like "1 h 30 min" cards.
///
/// Width budget (measured with TextPainter, same as before):
///   * left  = time (intrinsic)
///   * right = difficulty pill when it fits (intrinsic)
///   * center = Expanded remainder; servings/kcal centered inside it
///
/// Narrow cards drop right-to-left: pill first, then kcal, then
/// servings — time is never ellipsized.
class _CardFooter extends StatelessWidget {
  const _CardFooter({
    required this.recipe,
    this.layoutWidth,
    this.twoLineLayout = false,
  });

  final SpiceRouteSummary recipe;

  /// When set (grid cells), skips an inner [LayoutBuilder] so sliver
  /// grids don't trip intrinsic-dimension assertions on the web.
  final double? layoutWidth;

  /// Web grid Option A: row 1 time + servings, row 2 kcal + difficulty.
  final bool twoLineLayout;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final difficulty = recipeDifficultyLabel(l, recipe.difficulty);
    final timeText = formatRecipeDuration(l, recipe.totalMinutes);

    if (layoutWidth != null) {
      return _buildForWidth(
        context,
        l: l,
        difficulty: difficulty,
        timeText: timeText,
        w: layoutWidth!,
        twoLineLayout: twoLineLayout,
      );
    }

    return LayoutBuilder(
      builder: (context, c) => _buildForWidth(
        context,
        l: l,
        difficulty: difficulty,
        timeText: timeText,
        w: c.maxWidth,
        twoLineLayout: twoLineLayout,
      ),
    );
  }

  Widget _buildForWidth(
    BuildContext context, {
    required AppL10n l,
    required String difficulty,
    required String timeText,
    required double w,
    required bool twoLineLayout,
  }) {
    if (twoLineLayout) {
      return _buildTwoLineFooter(
        context,
        l: l,
        difficulty: difficulty,
        timeText: timeText,
        w: w,
      );
    }

    final kcal = recipe.caloriesPerServing;
    final theme = Theme.of(context);
    final metaStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: 11,
      height: 1.1,
    );

    double measureLabel(String text) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: metaStyle),
        textDirection: Directionality.of(context),
        maxLines: 1,
      )..layout();
      // Icon (12) + gap (3) + measured text.
      return 15 + painter.width;
    }

    double measurePill(String label) {
      final painter = TextPainter(
        text: TextSpan(
          text: label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 9.5,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: Directionality.of(context),
        maxLines: 1,
      )..layout();
      // Match _DifficultyPill padding (7 * 2) + border slack.
      return painter.width + 18;
    }

    const gapWide = 16.0;
    const gapNarrow = 12.0;
    final gap = w < 210 ? gapNarrow : gapWide;

    var servingsLabel = w < 280
        ? '${recipe.servings}'
        : l.recipeServings(recipe.servings);
    final compactKcal = w < 380;
    final kcalLabel = kcal != null
        ? (compactKcal ? '$kcal' : l.recipeKcal(kcal))
        : null;

    double measureServingsWidth(String label) {
      final painter = TextPainter(
        text: TextSpan(text: label, style: metaStyle),
        textDirection: Directionality.of(context),
        maxLines: 1,
      )..layout();
      return 15 + painter.width;
    }

    final timeWidth = measureLabel(timeText);
    final kcalWidth = kcalLabel != null ? measureLabel(kcalLabel) : 0.0;
    final pillWidth = measurePill(difficulty);

    ({bool showServings, bool showKcal, bool showPill}) planFor(
      String servLabel,
    ) {
      final servW = measureServingsWidth(servLabel);

      double centerContentWidth({required bool serv, required bool kcal}) {
        if (!serv && !kcal) return 0;
        if (serv && kcal && kcalLabel != null) {
          return servW + gap + kcalWidth;
        }
        if (serv) return servW;
        if (kcal && kcalLabel != null) return kcalWidth;
        return 0;
      }

      bool rowFits({required bool serv, required bool kcal, required bool pill}) =>
          timeWidth +
              centerContentWidth(serv: serv, kcal: kcal) +
              (pill ? pillWidth : 0) <=
          w + 0.5;

      var showServings = rowFits(serv: true, kcal: false, pill: false);
      var showKcal = false;
      if (kcalLabel != null) {
        showKcal = rowFits(serv: showServings, kcal: true, pill: false);
        if (!showServings) {
          showKcal = rowFits(serv: false, kcal: true, pill: false);
        }
      }
      final showPill = (showServings || showKcal) &&
          rowFits(serv: showServings, kcal: showKcal, pill: true);
      return (showServings: showServings, showKcal: showKcal, showPill: showPill);
    }

    var layout = planFor(servingsLabel);

    // Three-zone layout needs more horizontal space than the old Stack
    // overlay. Retry with a numeric servings label when the pill would
    // otherwise drop but the center metrics still fit.
    if (!layout.showPill &&
        (layout.showServings || layout.showKcal) &&
        w >= 280) {
      final compact = '${recipe.servings}';
      if (compact != servingsLabel) {
        final retry = planFor(compact);
        if (retry.showPill &&
            retry.showServings == layout.showServings &&
            retry.showKcal == layout.showKcal) {
          servingsLabel = compact;
          layout = retry;
        }
      }
    }

    final showServings = layout.showServings;
    final showKcal = layout.showKcal;
    final showPill = layout.showPill;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _MetaItem(icon: Icons.schedule, text: timeText),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showServings)
                _MetaItem(
                  icon: Icons.person_outline,
                  text: servingsLabel,
                ),
              if (showKcal && kcalLabel != null) ...[
                SizedBox(width: gap),
                _MetaItem(
                  icon: Icons.local_fire_department_outlined,
                  text: kcalLabel,
                ),
              ],
            ],
          ),
        ),
        if (showPill) _DifficultyPill(label: difficulty),
      ],
    );
  }

  /// Web grid footer — time/servings on the first row, kcal/pill on the
  /// second. Each row uses the full card width so long cook times no longer
  /// compete with the difficulty pill on a single line.
  Widget _buildTwoLineFooter(
    BuildContext context, {
    required AppL10n l,
    required String difficulty,
    required String timeText,
    required double w,
  }) {
    final kcal = recipe.caloriesPerServing;
    final servingsLabel = w < 280
        ? '${recipe.servings}'
        : l.recipeServings(recipe.servings);
    final kcalLabel = kcal != null ? '$kcal' : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: _MetaItem(icon: Icons.schedule, text: timeText),
              ),
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: _MetaItem(
                  icon: Icons.person_outline,
                  text: servingsLabel,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            if (kcalLabel != null)
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: _MetaItem(
                    icon: Icons.local_fire_department_outlined,
                    text: kcalLabel,
                  ),
                ),
              ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: _DifficultyPill(label: difficulty),
              ),
            ),
          ],
        ),
      ],
    );
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
    // No `Flexible` wrapper around the Text. _CardFooter contracts
    // with each metric to render at its intrinsic width
    // (flex-shrink: 0) and drops optional metrics at narrow widths
    // instead of squeezing any of them. The Text deliberately keeps
    // softWrap: false + maxLines: 1 so even a degenerate parent that
    // tries to constrain us renders one clean line rather than
    // wrapping mid-string.
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 3),
        Text(
          text,
          maxLines: 1,
          softWrap: false,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontSize: 11,
            height: 1.1,
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
                  CuisinePillBar.labelFor(
                    AppL10n.of(context),
                    recipe.cuisine!,
                  ).toUpperCase(),
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
          Icon(
            Icons.soup_kitchen_outlined,
            size: 11,
            color: cs.onInverseSurface,
          ),
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

/// Lays out recipe cards: single-column list on phone (intrinsic height,
/// no stretched footer gap); uniform grid on tablet and desktop.
SliverPadding recipeResultsSliver({
  required BuildContext context,
  required EdgeInsets padding,
  required int itemCount,
  required SpiceRouteSummary Function(int index) recipeAt,
  double? maxCrossAxisExtent,
  bool maxCrossAxisDelegate = false,
}) {
  if (deviceClassOf(context).isPhone) {
    return SliverPadding(
      padding: padding,
      sliver: SliverList.separated(
        itemCount: itemCount,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (_, i) => RecipeCard(recipe: recipeAt(i)),
      ),
    );
  }

  final delegate = maxCrossAxisDelegate
      ? SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: recipeCardMaxExtent(context),
          childAspectRatio: recipeCardAspectRatio(context),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        )
      : SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: recipeGridColumns(context),
          childAspectRatio: recipeCardAspectRatio(context),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        );

  Widget grid = SliverGrid.builder(
    gridDelegate: delegate,
    itemCount: itemCount,
    itemBuilder: (_, i) => RecipeCard.gridCell(context, recipeAt(i)),
  );

  if (maxCrossAxisExtent != null) {
    grid = SliverCrossAxisConstrained(
      maxCrossAxisExtent: maxCrossAxisExtent,
      child: grid,
    );
  }

  return SliverPadding(padding: padding, sliver: grid);
}
