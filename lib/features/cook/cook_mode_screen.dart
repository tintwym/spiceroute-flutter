import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/api_client.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/spice_route.dart';
import '../../shared/brand.dart';
import '../../shared/breakpoints.dart';
import '../../shared/widgets.dart';
import '../../state/cook_prefs.dart';
import '../../state/providers.dart';
import 'cook_scaling.dart';

/// Same-shape provider as the modal `_detailProvider` — kept separate so
/// the cook page's lifecycle doesn't accidentally invalidate the detail
/// modal's cached data when it disposes (and vice versa).
final _cookDetailProvider =
    FutureProvider.autoDispose.family<SpiceRouteDetail, String>((ref, id) {
  return ref.read(apiClientProvider).getRecipe(id);
});

/// Full-screen step-by-step "cook with me" view.
///
/// This is intentionally a route (not a modal) — cooking deserves the
/// full viewport with no scrim or floating chrome stealing attention.
/// Direct URL deep-link works too, so a user can bookmark
/// `/recipes/<id>/cook` and jump straight in.
///
/// Layout splits at 760 px:
///
/// - **Phone (< 760)**: `PageView` of one big step at a time. Top bar
///   has Exit + progress. Bottom bar has Back / Next. Tap an
///   "Ingredients" pill in the top bar to open a draggable sheet with
///   the scaled ingredient list.
///
/// - **Tablet+ (>= 760)**: two columns. Left = scaled ingredients
///   (sticky). Right = vertical list of all steps with the active one
///   highlighted; tap a step to mark it complete.
///
/// **What this v1 deliberately does NOT do** (so it ships in scope):
///   - Screen wake lock. Web needs JS interop, native needs the
///     wakelock_plus dep. Tagged TODO; can be a follow-up.
///   - Per-step timers (regex over "simmer 10 minutes" text). Useful
///     but fragile to localize; defer.
///   - Voice readout / hands-free.
///
/// The structure (top bar + body + bottom bar, layered prefs, pure
/// scaling helper) is set up so each of the above can be added without
/// touching this file's UI plumbing.
class CookModeScreen extends ConsumerWidget {
  const CookModeScreen({super.key, required this.recipeId});
  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final async = ref.watch(_cookDetailProvider(recipeId));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: async.when(
          data: (recipe) => _CookModeBody(recipe: recipe),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => CenterMessage(
            icon: Icons.error_outline,
            title: l.commonError,
            subtitle: (e is ApiException) ? e.message : e.toString(),
            action: FilledButton(
              onPressed: () => ref.invalidate(_cookDetailProvider(recipeId)),
              child: Text(l.commonRetry),
            ),
          ),
        ),
      ),
    );
  }
}

class _CookModeBody extends ConsumerStatefulWidget {
  const _CookModeBody({required this.recipe});
  final SpiceRouteDetail recipe;

  @override
  ConsumerState<_CookModeBody> createState() => _CookModeBodyState();
}

class _CookModeBodyState extends ConsumerState<_CookModeBody> {
  late int _servings = widget.recipe.servings.clamp(1, 99);
  late final PageController _pager = PageController();
  int _stepIndex = 0;
  final _completed = <int>{};

  @override
  void dispose() {
    _pager.dispose();
    super.dispose();
  }

  void _goToStep(int idx) {
    final steps = widget.recipe.steps;
    if (steps.isEmpty) return;
    final clamped = idx.clamp(0, steps.length - 1);
    setState(() => _stepIndex = clamped);
    if (_pager.hasClients) {
      _pager.animateToPage(
        clamped,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _toggleDone(int idx) {
    setState(() {
      if (!_completed.add(idx)) _completed.remove(idx);
    });
    HapticFeedback.selectionClick();
  }

  void _exit() {
    final navigator = Navigator.of(context);
    final router = GoRouter.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }
    // Cold-load case: user landed directly on /recipes/<id>/cook
    // (bookmark, shared link, browser refresh). There's nothing on the
    // navigation stack to pop to — falling through to the recipe
    // modal would leave the user staring at a half-rendered modal
    // floating on a black scrim because the underlying shell page
    // never mounted. Send them to the explore home instead; if they
    // wanted to peek at the recipe afterwards, that's one click away
    // from any recipe card.
    router.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final recipe = widget.recipe;
    final steps = recipe.steps;
    final units = ref.watch(cookUnitsProvider);
    final scaled = scaleIngredients(
      recipe.ingredients,
      originalServings: recipe.servings,
      targetServings: _servings,
      units: units,
    );

    if (steps.isEmpty) {
      return _NoStepsState(recipe: recipe, onExit: _exit);
    }

    final progress = (_stepIndex + 1) / steps.length;
    final dc = deviceClassOf(context);
    final wide = MediaQuery.sizeOf(context).width >= 760;

    return Column(
      children: [
        _TopBar(
          recipe: recipe,
          stepLabel: l.cookStepOf(_stepIndex + 1, steps.length),
          progress: progress,
          onExit: _exit,
          servings: _servings,
          originalServings: recipe.servings,
          onServingsChanged: (n) => setState(() => _servings = n),
          units: units,
          onUnitsChanged: (u) =>
              ref.read(cookUnitsProvider.notifier).setUnits(u),
          ingredientCount: scaled.length,
          // The phone layout uses a bottom sheet for ingredients; the
          // tablet+ layout has them in a sticky side panel and doesn't
          // need this button.
          onShowIngredients: wide
              ? null
              : () => _showIngredientsSheet(context, scaled),
        ),
        Expanded(
          child: wide
              ? _WideBody(
                  ingredients: scaled,
                  steps: steps,
                  activeIndex: _stepIndex,
                  completed: _completed,
                  onSelectStep: _goToStep,
                  onToggleDone: _toggleDone,
                )
              : _PhoneBody(
                  steps: steps,
                  completed: _completed,
                  pager: _pager,
                  onPageChanged: (i) => setState(() => _stepIndex = i),
                  onToggleDone: _toggleDone,
                ),
        ),
        _BottomBar(
          onBack: _stepIndex == 0 ? null : () => _goToStep(_stepIndex - 1),
          onNext: _stepIndex == steps.length - 1
              ? null
              : () => _goToStep(_stepIndex + 1),
          onFinish: _stepIndex == steps.length - 1
              ? () => _showFinishedDialog(context, recipe)
              : null,
          // Phone keeps icons compact; desktop has the room for full labels.
          compact: dc.isPhone,
        ),
      ],
    );
  }

  void _showIngredientsSheet(
    BuildContext context,
    List<ScaledIngredient> scaled,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          builder: (ctx, controller) => SingleChildScrollView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: _IngredientList(items: scaled),
          ),
        );
      },
    );
  }

  Future<void> _showFinishedDialog(
    BuildContext context,
    SpiceRouteDetail recipe,
  ) async {
    final l = AppL10n.of(context);
    HapticFeedback.mediumImpact();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.cookFinishedTitle),
        content: Text(l.cookFinishedBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cookFinishedStay),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.cookFinishedExit),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) _exit();
  }
}

// ---------------------------------------------------------------------------
// Top bar — exit, progress, scaler, units, ingredients button.
// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.recipe,
    required this.stepLabel,
    required this.progress,
    required this.onExit,
    required this.servings,
    required this.originalServings,
    required this.onServingsChanged,
    required this.units,
    required this.onUnitsChanged,
    required this.ingredientCount,
    required this.onShowIngredients,
  });

  final SpiceRouteDetail recipe;
  final String stepLabel;
  final double progress;
  final VoidCallback onExit;
  final int servings;
  final int originalServings;
  final ValueChanged<int> onServingsChanged;
  final UnitSystem units;
  final ValueChanged<UnitSystem> onUnitsChanged;
  final int ingredientCount;
  final VoidCallback? onShowIngredients;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final hasImage = recipe.imageUrl != null;

    // Title + step counter, plus a cuisine pill when present. Kept
    // as a local sub-row so we can reuse it both as the standalone
    // title row (no image) and as the floating overlay on the image
    // band (with image).
    Widget titleColumn() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              recipe.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                // titleLarge already pulls the serif via theme;
                // bump weight so it competes with the imagery.
                fontWeight: FontWeight.w700,
                color: hasImage ? Colors.white : cs.onSurface,
                fontSize: 18,
                shadows: hasImage
                    ? const [
                        Shadow(
                          color: Color(0x66000000),
                          blurRadius: 6,
                          offset: Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              stepLabel,
              style: theme.textTheme.labelSmall?.copyWith(
                color: hasImage
                    ? Colors.white.withValues(alpha: 0.85)
                    : cs.onSurfaceVariant,
                letterSpacing: 0.6,
                shadows: hasImage
                    ? const [
                        Shadow(
                          color: Color(0x66000000),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        );

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          bottom: BorderSide(color: cs.outlineVariant, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // -------------------------------------------------------
          // Visual band: either the recipe hero strip (image + title
          // overlay), or the plain title row when the recipe has no
          // image. Ties the cook page to the recipe detail modal's
          // hero treatment so the user feels they're "still in" that
          // recipe, not in some generic flow.
          // -------------------------------------------------------
          if (hasImage)
            _HeroBand(
              imageUrl: recipe.imageUrl!,
              cuisine: recipe.cuisine,
              onExit: onExit,
              child: titleColumn(),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    tooltip: l.cookExit,
                    icon: const Icon(Icons.close),
                    onPressed: onExit,
                  ),
                  Expanded(child: titleColumn()),
                  // Mirror the spacing used in [_HeroBand] so the
                  // cuisine pill never butts up against the
                  // ellipsized title on narrow phones.
                  if (recipe.cuisine != null) ...[
                    const SizedBox(width: 8),
                    BrandCuisinePill(cuisine: recipe.cuisine!, dense: true),
                  ],
                ],
              ),
            ),
          // -------------------------------------------------------
          // Slim progress strip — separate from the hero band so it
          // sits flush across both image- and no-image variants and
          // reads as the divider between hero chrome and controls.
          // -------------------------------------------------------
          SizedBox(
            height: 3,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 3,
              backgroundColor: cs.surfaceContainerHighest,
              color: cs.primary,
            ),
          ),
          // -------------------------------------------------------
          // Controls row: scaler, unit toggle, ingredients button.
          // -------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _ServingsStepper(
                  value: servings,
                  original: originalServings,
                  onChanged: onServingsChanged,
                ),
                _UnitsToggle(value: units, onChanged: onUnitsChanged),
                if (onShowIngredients != null) ...[
                  const SizedBox(width: 4),
                  TextButton.icon(
                    onPressed: onShowIngredients,
                    icon: const Icon(Icons.list_alt, size: 18),
                    label: Text(l.cookIngredientsCount(ingredientCount)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Thin recipe-image hero strip used when the recipe has an
/// `imageUrl`. Renders the image full-bleed, dims it with a bottom
/// gradient so overlaid text stays legible, and floats:
///   - Exit button (top-left)
///   - Title + step counter (centered vertically)
///   - Cuisine pill (bottom-right)
///
/// Same visual vocabulary as the recipe-detail modal's hero, scaled
/// down so it doesn't dominate the cook page.
class _HeroBand extends StatelessWidget {
  const _HeroBand({
    required this.imageUrl,
    required this.cuisine,
    required this.onExit,
    required this.child,
  });

  final String imageUrl;
  final Cuisine? cuisine;
  final VoidCallback onExit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 96,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (_, _) =>
                Container(color: cs.surfaceContainerHighest),
            errorWidget: (_, _, _) =>
                Container(color: cs.surfaceContainerHighest),
          ),
          // Dark gradient so the title + cuisine pill overlay stay
          // readable regardless of the photo's content. Top alpha was
          // 0.05 in the first cut, but that wasn't enough when the
          // image failed to load (the placeholder is light grey, so
          // white text + 5% darkening = unreadable). Bumping the top
          // to 0.22 makes the band reliably legible on the grey
          // fallback AND keeps photos looking like photos (still very
          // light tinting at the top).
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.22),
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 12, 8),
            child: Row(
              // Use `center` (not `stretch`) so the IconButton keeps
              // its native 48x48 circle size. With `stretch` the
              // button was inflated to the full 84-px band height,
              // and the new dark backdrop disc grew to match — a
              // gigantic black blob in the top-left of every cook
              // hero. Center crossAxisAlignment also reads more
              // naturally against the bottom-aligned cuisine pill.
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Dark backdrop circle so the white close glyph is
                // visible even on a bright photo (white-on-snow) or
                // the image-error grey fallback (white-on-grey). The
                // gradient alone isn't enough for either edge case.
                IconButton(
                  tooltip: l.cookExit,
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: onExit,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.35),
                  ),
                ),
                Expanded(child: child),
                if (cuisine != null) ...[
                  const SizedBox(width: 8),
                  BrandCuisinePill(cuisine: cuisine!, dense: true),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServingsStepper extends StatelessWidget {
  const _ServingsStepper({
    required this.value,
    required this.original,
    required this.onChanged,
  });

  final int value;
  final int original;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: l.cookServingsDecrease,
            icon: const Icon(Icons.remove, size: 18),
            // Clamp at 1 so we never divide-by-zero or produce a "0
            // serving" recipe (silly).
            onPressed: value <= 1 ? null : () => onChanged(value - 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              l.cookServingsLabel(value),
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            tooltip: l.cookServingsIncrease,
            icon: const Icon(Icons.add, size: 18),
            // 24 is an arbitrary kitchen cap — past that the scaled
            // quantities (e.g. 12 cups of rice) stop being useful and
            // it's likely a party-planning use case beyond this v1.
            onPressed: value >= 24 ? null : () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class _UnitsToggle extends StatelessWidget {
  const _UnitsToggle({required this.value, required this.onChanged});

  final UnitSystem value;
  final ValueChanged<UnitSystem> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return SegmentedButton<UnitSystem>(
      style: ButtonStyle(
        // Material's default SegmentedButton is fairly tall — shrink
        // visual density so it doesn't dominate the top bar on phones.
        visualDensity: VisualDensity.compact,
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        ),
      ),
      showSelectedIcon: false,
      segments: [
        ButtonSegment(value: UnitSystem.original, label: Text(l.cookUnitsOriginal)),
        ButtonSegment(value: UnitSystem.metric, label: Text(l.cookUnitsMetric)),
        ButtonSegment(value: UnitSystem.imperial, label: Text(l.cookUnitsImperial)),
      ],
      selected: {value},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}

// ---------------------------------------------------------------------------
// Phone body: one full step at a time, swipeable PageView.
// ---------------------------------------------------------------------------

class _PhoneBody extends StatelessWidget {
  const _PhoneBody({
    required this.steps,
    required this.completed,
    required this.pager,
    required this.onPageChanged,
    required this.onToggleDone,
  });

  final List<RecipeStep> steps;
  final Set<int> completed;
  final PageController pager;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onToggleDone;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pager,
      onPageChanged: onPageChanged,
      itemCount: steps.length,
      itemBuilder: (ctx, i) => _BigStep(
        index: i,
        body: steps[i].body,
        done: completed.contains(i),
        onToggleDone: () => onToggleDone(i),
      ),
    );
  }
}

class _BigStep extends StatelessWidget {
  const _BigStep({
    required this.index,
    required this.body,
    required this.done,
    required this.onToggleDone,
  });

  final int index;
  final String body;
  final bool done;
  final VoidCallback onToggleDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l = AppL10n.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step badge — large variant of the canonical brand step
          // badge. Serif numeral ties it to the brand wordmark; the
          // top bar already spells "Step N of M" in words, so the
          // badge here is just the visual anchor.
          BrandStepBadge(number: index + 1, done: done, size: 56),
          const SizedBox(height: 20),
          Text(
            body,
            style: theme.textTheme.headlineSmall?.copyWith(
              height: 1.45,
              fontWeight: FontWeight.w500,
              // Strike-through-but-readable when done. We keep the body
              // legible so the cook can re-read a completed step if
              // they swipe back to double-check ("did I add the salt?").
              decoration:
                  done ? TextDecoration.lineThrough : TextDecoration.none,
              color: done ? cs.onSurfaceVariant : cs.onSurface,
            ),
          ),
          const SizedBox(height: 28),
          OutlinedButton.icon(
            onPressed: onToggleDone,
            icon: Icon(
              done ? Icons.refresh : Icons.check_circle_outline,
              size: 18,
            ),
            label: Text(done ? l.cookStepUndo : l.cookStepDone),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tablet+/desktop body: ingredients column + steps column side-by-side.
// ---------------------------------------------------------------------------

class _WideBody extends StatelessWidget {
  const _WideBody({
    required this.ingredients,
    required this.steps,
    required this.activeIndex,
    required this.completed,
    required this.onSelectStep,
    required this.onToggleDone,
  });

  final List<ScaledIngredient> ingredients;
  final List<RecipeStep> steps;
  final int activeIndex;
  final Set<int> completed;
  final ValueChanged<int> onSelectStep;
  final ValueChanged<int> onToggleDone;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 340,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: cs.outlineVariant, width: 1),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: _IngredientList(items: ingredients),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < steps.length; i++)
                  _StepRow(
                    index: i,
                    body: steps[i].body,
                    active: i == activeIndex,
                    done: completed.contains(i),
                    onTap: () => onSelectStep(i),
                    onToggleDone: () => onToggleDone(i),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.index,
    required this.body,
    required this.active,
    required this.done,
    required this.onTap,
    required this.onToggleDone,
  });

  final int index;
  final String body;
  final bool active;
  final bool done;
  final VoidCallback onTap;
  final VoidCallback onToggleDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final border = active
        ? cs.primary.withValues(alpha: 0.55)
        : (done ? cs.primary.withValues(alpha: 0.35) : cs.outlineVariant);
    final fillColor = active
        ? cs.primary.withValues(alpha: 0.06)
        : (done ? cs.surfaceContainerHighest : cs.surface);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onToggleDone,
                  child: BrandStepBadge(
                    number: index + 1,
                    done: done,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      body,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                        decoration: done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: done
                            ? cs.onSurfaceVariant
                            : cs.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ingredient list used in both the wide layout's side panel and the
// phone layout's bottom sheet.
// ---------------------------------------------------------------------------

class _IngredientList extends StatelessWidget {
  const _IngredientList({required this.items});
  final List<ScaledIngredient> items;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BrandSectionHeader(text: l.cookIngredients),
        const SizedBox(height: 12),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 7, right: 12),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                        color: cs.onSurface,
                      ),
                      children: [
                        if (item.display.text.isNotEmpty)
                          TextSpan(
                            text: '${item.display.text}  ',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        TextSpan(text: item.name),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom nav: Back / Next / Finish.
// ---------------------------------------------------------------------------

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.onBack,
    required this.onNext,
    required this.onFinish,
    required this.compact,
  });

  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final VoidCallback? onFinish;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final cs = Theme.of(context).colorScheme;
    final viewPadding = MediaQuery.viewPaddingOf(context);

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          top: BorderSide(color: cs.outlineVariant, width: 1),
        ),
      ),
      // Pad for the iPhone gesture bar / Android nav bar.
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + viewPadding.bottom),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back, size: 18),
              label: Text(l.cookPrev),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: onFinish != null
                ? FilledButton.icon(
                    onPressed: onFinish,
                    icon: const Icon(Icons.celebration, size: 18),
                    label: Text(compact ? l.cookFinishShort : l.cookFinish),
                  )
                : FilledButton.icon(
                    onPressed: onNext,
                    // Material puts the icon BEFORE the label by default;
                    // for a "next" action it reads more naturally to put
                    // the arrow after — but FilledButton.icon doesn't
                    // expose iconAlignment, so swap to row layout.
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: Text(l.cookNext),
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Fallback when a recipe somehow has zero steps (legacy seed data,
// half-imported AI recipe, etc.).
// ---------------------------------------------------------------------------

class _NoStepsState extends StatelessWidget {
  const _NoStepsState({required this.recipe, required this.onExit});
  final SpiceRouteDetail recipe;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return CenterMessage(
      icon: Icons.menu_book_outlined,
      title: l.cookNoStepsTitle,
      subtitle: l.cookNoStepsBody,
      action: FilledButton(
        onPressed: onExit,
        child: Text(l.cookBackToRecipe),
      ),
    );
  }
}
