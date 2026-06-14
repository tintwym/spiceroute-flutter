import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/spice_route.dart';
import '../../shared/cuisine_pill_bar.dart';
import '../../shared/format.dart';
import '../../shared/studio_page.dart';
import '../../shared/widgets.dart';
import '../../state/ai_recipe.dart';
import '../../state/auth.dart';
import '../../state/locale.dart';
import '../auth/sign_in_prompt.dart';
import '../my_recipes/my_recipes_screen.dart' show invalidateMyRecipes;

class AiCreatorScreen extends ConsumerStatefulWidget {
  const AiCreatorScreen({super.key});

  @override
  ConsumerState<AiCreatorScreen> createState() => _AiCreatorScreenState();
}

class _AiCreatorScreenState extends ConsumerState<AiCreatorScreen> {
  final _ideaCtl = TextEditingController();

  @override
  void dispose() {
    _ideaCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final state = ref.watch(aiRecipeProvider);
    final controller = ref.read(aiRecipeProvider.notifier);
    final locale = ref.watch(localeProvider);

    ref.listen<AiRecipeState>(aiRecipeProvider, (prev, next) {
      if (prev?.saved == null && next.saved != null) {
        showAppSnack(context, l.aiCreatorSavedToast);
        // Invalidate /my-recipes so the user's newly-saved AI
        // recipe shows up there on the next visit instead of
        // requiring a pull-to-refresh. /my-recipes caches its
        // listing on a State-side fence keyed by (uid, locale,
        // revision); bumping the revision is the only thing the
        // screen needs to drop its cache and re-fetch.
        invalidateMyRecipes(ref);
      }
    });

    return StudioPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CreatorCard(
            ideaController: _ideaCtl,
            state: state,
            onIdeaChanged: controller.setIdea,
            onCuisineChanged: controller.setCuisine,
            onGenerate: () => controller.generate(language: locale.languageCode),
            onSave: () async {
              final user = ref.read(authControllerProvider);
              if (user == null) {
                await showSignInPrompt(context, nextPath: '/ai/creator');
                return;
              }
              controller.generate(language: locale.languageCode, save: true);
            },
          ),
          // While the AI is thinking, rotate through chef-flavoured loading
          // quotes ("Sharpening the knives…", etc.) so the user has a clear
          // signal that work is in flight — a bare spinner makes a multi-
          // second latency feel like a freeze.
          if (state.loading) ...[
            const SizedBox(height: 16),
            const _LoadingPanel(),
          ],
          const SizedBox(height: 20),
          if (state.error != null) _ErrorBanner(state: state, l: l),
          if (state.hasRecipe) _GeneratedRecipePreview(recipe: state.recipe!),
          if (state.saved != null) ...[
            const SizedBox(height: 20),
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: Text(state.saved!.title),
                onPressed: () => context.push('/recipes/${state.saved!.id}'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Dashed-bordered "AI is cooking" panel that swaps a quote every 3.5s.
///
/// Five quotes total, all localised — the timer cycles by index so the
/// effect feels like a real assistant narrating the work rather than a
/// canned spinner.
class _LoadingPanel extends StatefulWidget {
  const _LoadingPanel();

  @override
  State<_LoadingPanel> createState() => _LoadingPanelState();
}

class _LoadingPanelState extends State<_LoadingPanel> {
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 3500), (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % 5);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final quotes = [
      l.aiCreatorQuote1,
      l.aiCreatorQuote2,
      l.aiCreatorQuote3,
      l.aiCreatorQuote4,
      l.aiCreatorQuote5,
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const CircularProgressIndicator(strokeWidth: 3),
                Icon(Icons.soup_kitchen_outlined,
                    size: 22, color: cs.onSurface),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            l.aiCreatorGenerate,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          // Soft cross-fade between quotes so the swap doesn't pop.
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            child: Text(
              quotes[_index],
              key: ValueKey(_index),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The "Generate Custom AI Recipe" card — chef header, ingredients/idea
/// input with an inline Create button, cuisine pills, and Save.
class _CreatorCard extends StatelessWidget {
  const _CreatorCard({
    required this.ideaController,
    required this.state,
    required this.onIdeaChanged,
    required this.onCuisineChanged,
    required this.onGenerate,
    required this.onSave,
  });

  final TextEditingController ideaController;
  final AiRecipeState state;
  final ValueChanged<String> onIdeaChanged;
  final ValueChanged<Cuisine?> onCuisineChanged;
  final VoidCallback onGenerate;
  final VoidCallback onSave;

  bool get _canGenerate => state.idea.trim().isNotEmpty && !state.loading;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final field = TextField(
      controller: ideaController,
      minLines: 1,
      maxLines: 3,
      textInputAction: TextInputAction.send,
      onChanged: onIdeaChanged,
      onSubmitted: (_) {
        if (_canGenerate) onGenerate();
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.auto_awesome, size: 20),
        hintText: l.aiCreatorIdeaHintLong,
      ),
    );

    final createButton = FilledButton.icon(
      onPressed: _canGenerate ? onGenerate : null,
      icon: state.loading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Icon(Icons.auto_awesome, size: 18),
      label: Text(state.hasRecipe ? l.aiCreatorRegenerate : l.aiCreatorCreateBtn),
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.soup_kitchen_outlined,
                    size: 22, color: cs.onSurface),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.aiCreatorCardTitle,
                        style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 4),
                    Text(
                      l.aiCreatorCardSubtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _Label(l.aiCreatorIngredientsLabel),
          const SizedBox(height: 8),
          LayoutBuilder(builder: (context, constraints) {
            // Inline button when there's room; stacked on tight widths.
            if (constraints.maxWidth < 460) {
              return Column(
                children: [
                  field,
                  const SizedBox(height: 12),
                  SizedBox(width: double.infinity, child: createButton),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: field),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: createButton,
                ),
              ],
            );
          }),
          const SizedBox(height: 20),
          _Label(l.aiCreatorCuisineLabel),
          const SizedBox(height: 10),
          CuisinePillBar(value: state.cuisine, onChanged: onCuisineChanged),
          if (state.hasRecipe && state.saved == null) ...[
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: state.loading ? null : onSave,
              icon: const Icon(Icons.bookmark_add_outlined),
              label: Text(l.aiCreatorSaveBtn),
            ),
          ],
        ],
      ),
    );
  }
}

/// Small uppercase field label used inside the creator card.
class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        letterSpacing: 1.1,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.state, required this.l});
  final AiRecipeState state;
  final AppL10n l;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = state.rateLimited ? l.aiCreatorRateLimited : state.error!;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline,
              color: theme.colorScheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tolerant numeric coercion for fields the LLM is *supposed* to
/// return as integers per our JSON schema, but occasionally emits as
/// floats (e.g. `35.0` instead of `35`). A naked `value as int?` cast
/// would throw `TypeError: 'double' is not a subtype of 'int?'` and
/// blow up the entire generation preview, even though the underlying
/// number is semantically integer-valued.
///
/// Accepts `int`, `double`, numeric strings, and null. Returns null
/// for anything that can't be coerced.
int? _asInt(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? double.tryParse(value)?.round();
  return null;
}

class _GeneratedRecipePreview extends ConsumerWidget {
  const _GeneratedRecipePreview({required this.recipe});
  final Map<String, dynamic> recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final saved = ref.watch(aiRecipeProvider).saved;
    final ingredients =
        (recipe['ingredients'] as List?)?.cast<Map<String, dynamic>>() ??
            const [];
    final steps =
        (recipe['steps'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    final cuisineWire = recipe['cuisine'] as String?;
    final cuisine = Cuisine.fromWire(cuisineWire);
    final title = (recipe['title'] as String?) ?? '';
    final description = (recipe['description'] as String?) ?? '';
    final prep = _asInt(recipe['prep_minutes']) ?? 0;
    final cook = _asInt(recipe['cook_minutes']) ?? 0;
    final servings = _asInt(recipe['servings']) ?? 1;
    final calories = _asInt(recipe['calories_per_serving']);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (cuisine != null)
                Chip(label: Text(CuisinePillBar.labelFor(l, cuisine))),
              Chip(label: Text(l.recipeAiBadge)),
              if (saved != null)
                Chip(
                  label: Text(l.detailSaved),
                  backgroundColor:
                      theme.colorScheme.primary.withValues(alpha: 0.18),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: theme.textTheme.headlineMedium),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(description, style: theme.textTheme.bodyMedium),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              _MetaPair(
                icon: Icons.schedule,
                label: formatRecipeDuration(l, prep + cook),
              ),
              _MetaPair(
                icon: Icons.restaurant,
                label: l.recipeServings(servings),
              ),
              if (calories != null)
                _MetaPair(
                  icon: Icons.local_fire_department_outlined,
                  label: l.recipeKcal(calories),
                ),
            ],
          ),
          const Divider(height: 32),
          Text(l.detailIngredients, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final ing in ingredients)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                '• ${[
                  if (ing['quantity'] != null) ing['quantity'].toString(),
                  if (ing['unit'] != null) ing['unit'].toString(),
                  if (ing['name'] != null) ing['name'].toString(),
                ].join(' ')}',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          const SizedBox(height: 16),
          Text(l.detailSteps, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          for (var i = 0; i < steps.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    child: Text('${i + 1}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      (steps[i]['body'] as String?) ?? '',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaPair extends StatelessWidget {
  const _MetaPair({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.outline),
        const SizedBox(width: 6),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
