import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/spice_route.dart';
import '../../shared/breakpoints.dart';
import '../../shared/cuisine_pill_bar.dart';
import '../../shared/format.dart';
import '../../shared/widgets.dart';
import '../../state/ai_recipe.dart';
import '../../state/auth.dart';
import '../../state/locale.dart';
import '../auth/sign_in_prompt.dart';

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
    final theme = Theme.of(context);
    final state = ref.watch(aiRecipeProvider);
    final controller = ref.read(aiRecipeProvider.notifier);
    final locale = ref.watch(localeProvider);

    ref.listen<AiRecipeState>(aiRecipeProvider, (prev, next) {
      if (prev?.saved == null && next.saved != null) {
        showAppSnack(context, l.aiCreatorSavedToast);
      }
    });

    return ListView(
      padding: pagePadding(context).copyWith(top: 16, bottom: 32),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentMaxWidth(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.aiCreatorTitle, style: theme.textTheme.headlineLarge),
                const SizedBox(height: 24),
                Text(l.aiCreatorIdeaLabel,
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                TextField(
                  controller: _ideaCtl,
                  // Grow-on-demand: starts as a normal single-line pill (so
                  // the hint isn't stranded at the top of a tall empty box
                  // like before) but expands up to 3 lines if the user
                  // really wants to type a longer idea.
                  minLines: 1,
                  maxLines: 3,
                  textInputAction: TextInputAction.send,
                  onChanged: controller.setIdea,
                  onSubmitted: (_) {
                    if (state.idea.trim().isEmpty || state.loading) return;
                    controller.generate(language: locale.languageCode);
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.auto_awesome),
                    hintText: l.aiCreatorIdeaHint,
                  ),
                ),
                const SizedBox(height: 20),
                Text(l.aiCreatorCuisineLabel,
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                CuisinePillBar(
                  value: state.cuisine,
                  onChanged: controller.setCuisine,
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton.icon(
                      onPressed: state.idea.trim().isEmpty || state.loading
                          ? null
                          : () => controller.generate(
                                language: locale.languageCode,
                              ),
                      icon: state.loading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.auto_awesome),
                      label: Text(state.hasRecipe
                          ? l.aiCreatorRegenerate
                          : l.aiCreatorGenerate),
                    ),
                    if (state.hasRecipe && state.saved == null)
                      OutlinedButton.icon(
                        onPressed: state.loading
                            ? null
                            : () async {
                                final user = ref.read(authControllerProvider);
                                if (user == null) {
                                  final go = await showSignInPrompt(
                                    context,
                                    nextPath: '/ai/creator',
                                  );
                                  if (!go) return;
                                  return;
                                }
                                controller.generate(
                                  language: locale.languageCode,
                                  save: true,
                                );
                              },
                        icon: const Icon(Icons.bookmark_add_outlined),
                        label: Text(l.aiCreatorSaveBtn),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                if (state.error != null) _ErrorBanner(state: state, l: l),
                if (state.hasRecipe)
                  _GeneratedRecipePreview(recipe: state.recipe!),
                if (state.saved != null) ...[
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton.icon(
                      icon: const Icon(Icons.open_in_new),
                      label: Text(state.saved!.title),
                      onPressed: () =>
                          context.push('/recipes/${state.saved!.id}'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
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
    final prep = (recipe['prep_minutes'] as int?) ?? 0;
    final cook = (recipe['cook_minutes'] as int?) ?? 0;
    final servings = (recipe['servings'] as int?) ?? 1;
    final calories = recipe['calories_per_serving'] as int?;

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
