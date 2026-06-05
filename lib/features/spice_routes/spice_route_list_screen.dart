import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/spice_route.dart';
import '../../shared/widgets.dart';
import '../../state/providers.dart';
import '../../state/spice_routes.dart';

class SpiceRouteListScreen extends ConsumerStatefulWidget {
  const SpiceRouteListScreen({super.key});

  @override
  ConsumerState<SpiceRouteListScreen> createState() =>
      _SpiceRouteListScreenState();
}

class _SpiceRouteListScreenState extends ConsumerState<SpiceRouteListScreen> {
  final _searchCtl = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(spiceRouteListControllerProvider.notifier).setQuery(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(spiceRouteListControllerProvider);
    final tagsAsync = ref.watch(tagsProvider);
    final auth = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          auth.user == null
              ? 'SpiceRoutes'
              : 'Hi, ${auth.user!.displayName.split(' ').first}',
        ),
        actions: [
          IconButton(
            tooltip: 'Favorites',
            icon: const Icon(Icons.favorite_outline),
            onPressed: () => context.go('/favorites'),
          ),
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/spice_routes/new'),
        icon: const Icon(Icons.add),
        label: const Text('New SpiceRoute'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(spiceRouteListControllerProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  controller: _searchCtl,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search SpiceRoutes or ingredients',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: state.q.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchCtl.clear();
                              ref
                                  .read(spiceRouteListControllerProvider
                                      .notifier)
                                  .setQuery('');
                            },
                          ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: const Text('Mine only'),
                        selected: state.mineOnly,
                        onSelected: (v) => ref
                            .read(spiceRouteListControllerProvider.notifier)
                            .setMineOnly(v),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: const Text('Favorites'),
                        selected: state.favoritesOnly,
                        onSelected: (v) => ref
                            .read(spiceRouteListControllerProvider.notifier)
                            .setFavoritesOnly(v),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(
                          state.maxMinutes == null
                              ? 'Any time'
                              : '\u2264 ${state.maxMinutes}m',
                        ),
                        selected: state.maxMinutes != null,
                        onSelected: (_) async {
                          final picked = await _pickMaxMinutes(context);
                          if (!context.mounted) return;
                          ref
                              .read(spiceRouteListControllerProvider.notifier)
                              .setMaxMinutes(picked);
                        },
                      ),
                    ),
                    if (tagsAsync.hasValue)
                      ...tagsAsync.value!.map(
                        (t) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: FilterChip(
                            label: Text(t.name),
                            selected: state.tag == t.name,
                            onSelected: (sel) {
                              ref
                                  .read(spiceRouteListControllerProvider
                                      .notifier)
                                  .setTag(sel ? t.name : null);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            if (state.loading && state.items.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.error != null && state.items.isEmpty)
              SliverFillRemaining(
                child: CenterMessage(
                  icon: Icons.error_outline,
                  title: 'Could not load SpiceRoutes',
                  subtitle: state.error,
                  action: FilledButton(
                    onPressed: () => ref
                        .read(spiceRouteListControllerProvider.notifier)
                        .refresh(),
                    child: const Text('Retry'),
                  ),
                ),
              )
            else if (state.items.isEmpty)
              const SliverFillRemaining(
                child: CenterMessage(
                  icon: Icons.menu_book_outlined,
                  title: 'No SpiceRoutes yet',
                  subtitle: 'Tap the + button to add your first SpiceRoute.',
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                sliver: SliverList.separated(
                  itemCount: state.items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final r = state.items[i];
                    return _SpiceRouteCard(
                      spiceRoute: r,
                      onTap: () => context.go('/spice_routes/${r.id}'),
                      onFavorite: () async {
                        try {
                          await ref
                              .read(spiceRouteListControllerProvider.notifier)
                              .toggleFavoriteLocal(r.id);
                        } catch (_) {}
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<int?> _pickMaxMinutes(BuildContext context) {
    return showModalBottomSheet<int?>(
      context: context,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const ListTile(title: Text('Max total time')),
            for (final m in [15, 30, 45, 60, 90])
              ListTile(
                title: Text('$m minutes or less'),
                onTap: () => Navigator.of(context).pop(m),
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.clear),
              title: const Text('Any time'),
              onTap: () => Navigator.of(context).pop(null),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpiceRouteCard extends StatelessWidget {
  const _SpiceRouteCard({
    required this.spiceRoute,
    required this.onTap,
    required this.onFavorite,
  });

  final SpiceRouteSummary spiceRoute;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 110,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 110,
                child: spiceRoute.imageUrl == null
                    ? Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.restaurant,
                          color: theme.colorScheme.outline,
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: spiceRoute.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                        errorWidget: (_, _, _) => Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.broken_image_outlined),
                        ),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              spiceRoute.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: onFavorite,
                            icon: Icon(
                              spiceRoute.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: spiceRoute.isFavorite
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      if (spiceRoute.description != null &&
                          spiceRoute.description!.isNotEmpty)
                        Text(
                          spiceRoute.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${spiceRoute.prepMinutes + spiceRoute.cookMinutes} min',
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.restaurant_outlined,
                            size: 16,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${spiceRoute.servings}',
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(width: 12),
                          if (spiceRoute.tags.isNotEmpty)
                            Expanded(
                              child: Text(
                                spiceRoute.tags
                                    .map((t) => '#${t.name}')
                                    .join(' '),
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
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
