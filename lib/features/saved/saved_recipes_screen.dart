import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../shared/breakpoints.dart';
import '../../shared/page_hero.dart';
import '../../shared/page_tabs.dart';
import '../../shared/site_footer.dart';
import '../../shared/widgets.dart';
import '../../state/auth.dart';
import '../../state/saved.dart';
import '../../state/user_profile.dart';

/// Saved Recipes screen — same editorial chrome as Explore (eyebrow
/// badge + serif headline + page-scoped subtitle + tab row), then a
/// "(N)" section heading, and either the saved-recipe grid or a polished
/// empty-state card with an "Explore Recipes now" CTA.
class SavedRecipesScreen extends ConsumerWidget {
  const SavedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(savedRecipesProvider);
    final controller = ref.read(savedRecipesProvider.notifier);
    final pagePad = pagePadding(context);
    final maxW = contentMaxWidth(context);

    Widget framed(Widget child) => Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: child,
      ),
    );

    // Same shared SpiceRoute hero as every other page — the page-specific
    // heading lives in the section header below the tab row.
    const hero = PageHero();

    // Section heading: "Saved (3)" + cloud-synced badge when
    // signed in + the profile doc has been fetched + optional Clear-all
    // action on the right when there *is* something to clear.
    final user = ref.watch(authControllerProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final synced =
        user != null &&
        profileAsync.maybeWhen(data: (p) => p != null, orElse: () => false);

    final sectionHeader = deviceClassOf(context).isPhone
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l.savedCountHeading(state.recipes.length),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (synced) ...[
                    const SizedBox(width: 12),
                    _CloudSyncedBadge(label: l.savedCloudSyncedBadge),
                  ],
                ],
              ),
              if (state.recipes.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.delete_sweep_outlined),
                    label: Text(l.savedClearAll),
                    onPressed: () => _confirmClear(context, controller, l),
                  ),
                ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  l.savedCountHeading(state.recipes.length),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (synced) ...[
                const SizedBox(width: 12),
                _CloudSyncedBadge(label: l.savedCloudSyncedBadge),
              ],
              const Spacer(),
              if (state.recipes.isNotEmpty)
                TextButton.icon(
                  icon: const Icon(Icons.delete_sweep_outlined),
                  label: Text(l.savedClearAll),
                  onPressed: () => _confirmClear(context, controller, l),
                ),
            ],
          );

    final hasRecipes = state.recipes.isNotEmpty;

    return CustomScrollView(
      scrollCacheExtent: const ScrollCacheExtent.pixels(900), physics: const ClampingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: pagePad.copyWith(top: 32, bottom: 8),
          sliver: SliverToBoxAdapter(child: framed(hero)),
        ),
        SliverPadding(
          padding: pagePad.copyWith(top: 12, bottom: 0),
          sliver: SliverToBoxAdapter(child: framed(const PageTabs())),
        ),
        SliverPadding(
          padding: pagePad.copyWith(top: 24, bottom: 12),
          sliver: SliverToBoxAdapter(child: framed(sectionHeader)),
        ),
        if (state.loading && state.recipes.isEmpty)
          SliverPadding(
            padding: pagePad.copyWith(top: 8),
            sliver: SliverCrossAxisConstrained(
              maxCrossAxisExtent: maxW,
              child: SliverList.builder(
                itemCount: 3,
                itemBuilder: (_, _) => const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: LoadingShimmer(height: 220),
                ),
              ),
            ),
          )
        else if (!hasRecipes)
          SliverPadding(
            padding: pagePad.copyWith(top: 8, bottom: 24),
            sliver: SliverToBoxAdapter(child: framed(const _EmptyStateCard())),
          )
        else
          recipeResultsSliver(
            context: context,
            padding: pagePad,
            itemCount: state.recipes.length,
            recipeAt: (i) => state.recipes[i],
            maxCrossAxisExtent: maxW,
          ),
        SliverPadding(
          padding: pagePad.copyWith(top: 48, bottom: 28),
          sliver: SliverToBoxAdapter(child: framed(const SiteFooter())),
        ),
      ],
    );
  }

  Future<void> _confirmClear(
    BuildContext context,
    SavedRecipesController controller,
    AppL10n l,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.savedClearConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.savedClearConfirmNo),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.savedClearConfirmYes),
          ),
        ],
      ),
    );
    if (ok == true) controller.clearAll();
  }
}

/// Small chip rendered next to the count heading when the user is signed
/// in and the `users/{uid}` profile doc has resolved. Signals (without
/// adding chrome) that saves are mirrored to the cloud and follow the
/// account across devices.
class _CloudSyncedBadge extends StatelessWidget {
  const _CloudSyncedBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const green = Color(0xFF3FA35A);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_done_outlined,
            size: 13,
            color: Color(0xFF2E7D43),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: const Color(0xFF2E7D43),
              letterSpacing: 1.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Polished empty-state card used when there are zero saved recipes —
/// soft card surface, terracotta bookmark icon in a circular badge,
/// instructional copy, and an "Explore Recipes now" CTA that drops the
/// user back on the home grid.
class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard();

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cs.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.04),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: cs.secondary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bookmark_border,
                  color: cs.secondary,
                  size: 26,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l.savedEmptySubtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () => context.go('/'),
                child: Text(l.savedEmptyCta),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
