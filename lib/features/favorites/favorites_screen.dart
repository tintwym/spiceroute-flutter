import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/api_client.dart';
import '../../models/spice_route.dart';
import '../../shared/widgets.dart';
import '../../state/providers.dart';
import '../../state/spice_routes.dart';

final favoritesProvider = FutureProvider<List<SpiceRouteSummary>>((ref) async {
  return ref.read(apiClientProvider).listMyFavorites();
});

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(favoritesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => CenterMessage(
          icon: Icons.error_outline,
          title: 'Could not load favorites',
          subtitle: apiErrorMessage(e),
          action: FilledButton(
            onPressed: () => ref.invalidate(favoritesProvider),
            child: const Text('Retry'),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const CenterMessage(
              icon: Icons.favorite_outline,
              title: 'No favorites yet',
              subtitle: 'Tap the heart on a SpiceRoute to save it here.',
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(favoritesProvider),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _FavoriteRow(
                spiceRoute: items[i],
                onTap: () => context.go('/spice_routes/${items[i].id}'),
                onUnfavorite: () async {
                  try {
                    await ref
                        .read(apiClientProvider)
                        .toggleFavorite(items[i].id);
                    ref.invalidate(favoritesProvider);
                    ref
                        .read(spiceRouteListControllerProvider.notifier)
                        .refresh();
                  } catch (e) {
                    if (context.mounted) {
                      showErrorSnack(context, apiErrorMessage(e));
                    }
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FavoriteRow extends StatelessWidget {
  const _FavoriteRow({
    required this.spiceRoute,
    required this.onTap,
    required this.onUnfavorite,
  });

  final SpiceRouteSummary spiceRoute;
  final VoidCallback onTap;
  final VoidCallback onUnfavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: SizedBox(
          width: 60,
          height: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: spiceRoute.imageUrl == null
                ? Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Icon(Icons.restaurant,
                        color: theme.colorScheme.outline),
                  )
                : CachedNetworkImage(
                    imageUrl: spiceRoute.imageUrl!,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        title: Text(spiceRoute.title),
        subtitle: Text(
          '${spiceRoute.prepMinutes + spiceRoute.cookMinutes} min  by ${spiceRoute.owner.displayName}',
        ),
        trailing: IconButton(
          icon: Icon(Icons.favorite, color: theme.colorScheme.primary),
          onPressed: onUnfavorite,
        ),
        onTap: onTap,
      ),
    );
  }
}
