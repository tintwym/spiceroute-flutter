import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/api_client.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/spice_route.dart';
import '../../shared/breakpoints.dart';
import '../../shared/cuisine_pill_bar.dart';
import '../../shared/format.dart';
import '../../shared/widgets.dart';
import '../../state/providers.dart';
import '../../state/saved.dart';
import 'recipe_reviews.dart';

/// `.autoDispose` is critical here: this is a `family` provider keyed by
/// recipe id, and without auto-dispose every recipe the user has ever
/// opened stays cached in memory for the lifetime of the app. On a long
/// browsing session the cache grows unbounded — each entry holds a full
/// `SpiceRouteDetail` (with all steps, ingredients, image URLs, and the
/// detached `recipe['photos']` byte payloads on signed-in users).
/// Auto-dispose tears the entry down as soon as no widget watches it,
/// which for a modal detail screen is immediately on close.
final _detailProvider =
    FutureProvider.autoDispose.family<SpiceRouteDetail, String>((ref, id) async {
  return ref.read(apiClientProvider).getRecipe(id);
});

/// Recipe detail, presented as a centered **modal box** over the dimmed
/// page that launched it (see the transparent route in `router.dart`).
///
/// Layout inside the card:
///   - wide  : two columns — sticky image + meta on the left, scrollable
///             ingredients + instructions on the right.
///   - narrow: a single scroll column.
class RecipeDetailScreen extends ConsumerWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});
  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final async = ref.watch(_detailProvider(recipeId));
    final myId = ref.watch(meProvider).valueOrNull;
    final size = MediaQuery.sizeOf(context);
    final dc = deviceClassOf(context);

    // Phone: near-fullscreen sheet. Tablet+: a roomy floating card.
    final margin = dc.isPhone ? 10.0 : 28.0;
    final maxW = dc.isAtLeastDesktop ? 1040.0 : 760.0;
    final maxH = size.height - margin * 2;

    Widget actionsFor(SpiceRouteDetail recipe) {
      final isOwner = myId != null && recipe.owner?.id == myId;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isOwner)
            _CircleIconButton(
              icon: Icons.delete_outline,
              tooltip: l.detailDelete,
              onTap: () => _confirmDelete(context, ref, recipe.id),
            ),
          _CircleIconButton(
            icon: Icons.close,
            tooltip: l.detailClose,
            onTap: () => _close(context),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Full-screen tap-catcher: clicking the dimmed area dismisses.
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _close(context),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(margin),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW, maxHeight: maxH),
                child: Material(
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 16,
                  borderRadius: BorderRadius.circular(24),
                  clipBehavior: Clip.antiAlias,
                  // Swallow taps so clicking the card doesn't fall through
                  // to the dismiss catcher behind it.
                  child: GestureDetector(
                    onTap: () {},
                    child: Stack(
                      children: [
                        async.when(
                          data: (recipe) => _ModalContent(recipe: recipe),
                          loading: () => const SizedBox(
                            height: 320,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (e, _) => SizedBox(
                            height: 320,
                            child: CenterMessage(
                              icon: Icons.error_outline,
                              title: l.commonError,
                              subtitle:
                                  (e is ApiException) ? e.message : e.toString(),
                              action: FilledButton(
                                onPressed: () =>
                                    ref.invalidate(_detailProvider(recipeId)),
                                child: Text(l.commonRetry),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: async.maybeWhen(
                            data: actionsFor,
                            orElse: () => _CircleIconButton(
                              icon: Icons.close,
                              tooltip: l.detailClose,
                              onTap: () => _close(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _close(BuildContext context) async {
    final navigator = Navigator.of(context);
    final router = GoRouter.of(context);
    final popped = await navigator.maybePop();
    if (!popped) router.go('/');
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

class _ModalContent extends ConsumerWidget {
  const _ModalContent({required this.recipe});
  final SpiceRouteDetail recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 720;
      if (!wide) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LeftColumn(recipe: recipe, scrollable: false),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: _RightColumn(recipe: recipe),
              ),
            ],
          ),
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left: image + meta. Fixed (image pinned), meta scrolls if tall.
          Expanded(flex: 5, child: _LeftColumn(recipe: recipe, scrollable: true)),
          // Right: ingredients + instructions, independently scrollable.
          Expanded(
            flex: 7,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(28, 56, 28, 28),
              child: _RightColumn(recipe: recipe),
            ),
          ),
        ],
      );
    });
  }
}

/// Image + title + description + stat cards + save. On wide layouts the
/// image is pinned and the meta beneath it scrolls; on narrow it's just a
/// plain column inside the page scroll.
class _LeftColumn extends ConsumerWidget {
  const _LeftColumn({required this.recipe, required this.scrollable});
  final SpiceRouteDetail recipe;
  final bool scrollable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isSaved = ref.watch(
      savedRecipesProvider.select((s) => s.ids.contains(recipe.id)),
    );
    final myId = ref.watch(meProvider).valueOrNull;
    final ownerLabel = recipe.owner == null
        ? null
        : (myId == recipe.owner!.id
            ? l.recipeOwnerYou
            : l.recipeOwnerBy(recipe.owner!.displayName));

    final meta = Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DifficultyPill(label: _difficulty(l, recipe)),
          const SizedBox(height: 12),
          Text(recipe.title, style: theme.textTheme.displaySmall),
          if (ownerLabel != null) ...[
            const SizedBox(height: 4),
            Text(
              ownerLabel,
              style: theme.textTheme.labelMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            (recipe.description ?? '').isNotEmpty
                ? recipe.description!
                : l.detailNoDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Divider(color: cs.outlineVariant, height: 1),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.schedule,
                  label: l.detailPrepTime,
                  value: formatRecipeDuration(l, recipe.prepMinutes),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  icon: Icons.local_fire_department_outlined,
                  label: l.detailCookTime,
                  value: formatRecipeDuration(l, recipe.cookMinutes),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  icon: Icons.groups_outlined,
                  label: l.detailServingsShort,
                  value: '${recipe.servings}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () =>
                  ref.read(savedRecipesProvider.notifier).toggle(recipe),
              icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
              label: Text(isSaved ? l.detailSaved : l.detailSave),
            ),
          ),
        ],
      ),
    );

    return Container(
      color: cs.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeroImage(recipe: recipe),
          if (scrollable)
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: meta,
              ),
            )
          else
            meta,
        ],
      ),
    );
  }

  String _difficulty(AppL10n l, SpiceRouteDetail r) =>
      recipeDifficultyLabel(l, totalMinutes: r.totalMinutes, steps: r.steps.length);
}

/// Right column: ingredients checklist + numbered cooking instructions +
/// community reviews & photo gallery. The reviews block lives at the
/// bottom so the cook can jump straight from the steps into "see what
/// other people did with this".
class _RightColumn extends StatelessWidget {
  const _RightColumn({required this.recipe});
  final SpiceRouteDetail recipe;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: l.detailIngredients),
        const SizedBox(height: 12),
        _IngredientChecklist(recipe: recipe),
        const SizedBox(height: 28),
        _SectionHeader(text: l.detailCookingInstructions),
        const SizedBox(height: 12),
        _InstructionChecklist(recipe: recipe),
        const SizedBox(height: 32),
        Divider(color: cs.outlineVariant, height: 1),
        const SizedBox(height: 24),
        RecipeReviewsSection(recipe: recipe),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text.toUpperCase(),
          style: theme.textTheme.titleMedium?.copyWith(
            letterSpacing: 1.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// Stateful so each ingredient row can be ticked off while cooking.
class _IngredientChecklist extends StatefulWidget {
  const _IngredientChecklist({required this.recipe});
  final SpiceRouteDetail recipe;

  @override
  State<_IngredientChecklist> createState() => _IngredientChecklistState();
}

class _IngredientChecklistState extends State<_IngredientChecklist> {
  final _checked = <int>{};

  String _fmtQty(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v
        .toStringAsFixed(2)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final ings = widget.recipe.ingredients;
    return LayoutBuilder(builder: (context, constraints) {
      // Two columns when there's room, single column otherwise.
      final twoCol = constraints.maxWidth >= 460;
      final colWidth =
          twoCol ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;
      return Wrap(
        spacing: 16,
        runSpacing: 4,
        children: [
          for (var i = 0; i < ings.length; i++)
            SizedBox(
              width: colWidth,
              child: _IngredientRow(
                text: [
                  if (ings[i].quantity != null) _fmtQty(ings[i].quantity!),
                  if (ings[i].unit != null) ings[i].unit,
                  ings[i].name,
                ].whereType<String>().join(' '),
                checked: _checked.contains(i),
                onChanged: (v) => setState(() {
                  if (v) {
                    _checked.add(i);
                  } else {
                    _checked.remove(i);
                  }
                }),
              ),
            ),
        ],
      );
    });
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.text,
    required this.checked,
    required this.onChanged,
  });
  final String text;
  final bool checked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return InkWell(
      onTap: () => onChanged(!checked),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom check box (the Material Checkbox has chunky padding).
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              margin: const EdgeInsets.only(top: 1, right: 12),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: checked ? cs.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: checked ? cs.primary : cs.outlineVariant,
                  width: 1.5,
                ),
              ),
              child: checked
                  ? Icon(Icons.check, size: 14, color: cs.onPrimary)
                  : null,
            ),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: checked ? cs.onSurfaceVariant : cs.onSurface,
                  decoration:
                      checked ? TextDecoration.lineThrough : TextDecoration.none,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tap-to-tick cooking steps. Mirrors the React recipe modal where
/// completing a step strikes it through + swaps the number badge for a
/// check icon so cooks can keep their place while juggling pans.
class _InstructionChecklist extends StatefulWidget {
  const _InstructionChecklist({required this.recipe});
  final SpiceRouteDetail recipe;

  @override
  State<_InstructionChecklist> createState() => _InstructionChecklistState();
}

class _InstructionChecklistState extends State<_InstructionChecklist> {
  final _done = <int>{};

  @override
  Widget build(BuildContext context) {
    final steps = widget.recipe.steps;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < steps.length; i++)
          _InstructionCard(
            number: i + 1,
            body: steps[i].body,
            done: _done.contains(i),
            onToggle: () => setState(() {
              if (!_done.add(i)) _done.remove(i);
            }),
          ),
      ],
    );
  }
}

class _InstructionCard extends StatelessWidget {
  const _InstructionCard({
    required this.number,
    required this.body,
    required this.done,
    required this.onToggle,
  });
  final int number;
  final String body;
  final bool done;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: done ? cs.surfaceContainerHighest : cs.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: done ? cs.primary.withValues(alpha: 0.40) : cs.outlineVariant,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 140),
                child: done
                    ? Icon(
                        Icons.check_circle,
                        key: const ValueKey('check'),
                        size: 26,
                        color: cs.primary,
                      )
                    : Container(
                        key: const ValueKey('num'),
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$number',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: done
                          ? cs.onSurfaceVariant.withValues(alpha: 0.75)
                          : cs.onSurface,
                      decoration: done
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Capped-height hero with a cuisine pill overlaid on the bottom-left,
/// matching the reference design.
class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.recipe});
  final SpiceRouteDetail recipe;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final dc = deviceClassOf(context);
    final double cap = switch (dc) {
      DeviceClass.phone => 220,
      DeviceClass.tablet => 280,
      DeviceClass.desktop => 300,
      DeviceClass.wide => 320,
    };

    return SizedBox(
      height: cap,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (recipe.imageUrl != null)
            CachedNetworkImage(
              imageUrl: recipe.imageUrl!,
              fit: BoxFit.cover,
              placeholder: (_, _) =>
                  Container(color: cs.surfaceContainerHighest),
              errorWidget: (_, _, _) => Container(
                color: cs.surfaceContainerHighest,
                child: const Icon(Icons.restaurant_menu, size: 48),
              ),
            )
          else
            Container(
              color: cs.surfaceContainerHighest,
              child: const Icon(Icons.restaurant_menu, size: 48),
            ),
          if (recipe.cuisine != null)
            Positioned(
              left: 14,
              bottom: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  CuisinePillBar.labelFor(l, recipe.cuisine!).toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DifficultyPill extends StatelessWidget {
  const _DifficultyPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: cs.secondary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: cs.onSurfaceVariant,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: cs.onSurfaceVariant),
          const SizedBox(height: 8),
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Small circular icon button used for the modal's close / delete actions.
class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Material(
        color: cs.surface,
        shape: const CircleBorder(),
        elevation: 2,
        child: IconButton(
          tooltip: tooltip,
          iconSize: 20,
          icon: Icon(icon, color: cs.onSurface),
          onPressed: onTap,
        ),
      ),
    );
  }
}
