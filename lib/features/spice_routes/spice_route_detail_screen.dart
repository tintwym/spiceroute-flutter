import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../api/api_client.dart';
import '../../models/spice_route.dart';
import '../../shared/widgets.dart';
import '../../state/providers.dart';
import '../../state/spice_routes.dart';

class SpiceRouteDetailScreen extends ConsumerStatefulWidget {
  const SpiceRouteDetailScreen({super.key, required this.spiceRouteId});

  final String spiceRouteId;

  @override
  ConsumerState<SpiceRouteDetailScreen> createState() =>
      _SpiceRouteDetailScreenState();
}

class _SpiceRouteDetailScreenState
    extends ConsumerState<SpiceRouteDetailScreen> {
  int? _displayServings;
  bool _uploading = false;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(spiceRouteDetailProvider(widget.spiceRouteId));
    final me = ref.watch(authControllerProvider).user;

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: CenterMessage(
          icon: Icons.error_outline,
          title: 'Could not load SpiceRoute',
          subtitle: apiErrorMessage(e),
        ),
      ),
      data: (spiceRoute) {
        final ownerHere = me != null && me.id == spiceRoute.owner.id;
        final displayServings = _displayServings ?? spiceRoute.servings;
        final scale = displayServings / spiceRoute.servings;
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                tooltip: spiceRoute.isFavorite ? 'Unfavorite' : 'Favorite',
                icon: Icon(
                  spiceRoute.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_outline,
                ),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  try {
                    await ref
                        .read(apiClientProvider)
                        .toggleFavorite(spiceRoute.id);
                    ref.invalidate(
                        spiceRouteDetailProvider(widget.spiceRouteId));
                    ref
                        .read(spiceRouteListControllerProvider.notifier)
                        .refresh();
                  } catch (e) {
                    messenger.showSnackBar(
                      SnackBar(content: Text(apiErrorMessage(e))),
                    );
                  }
                },
              ),
              if (ownerHere) ...[
                IconButton(
                  tooltip: 'Edit',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () =>
                      context.go('/spice_routes/${spiceRoute.id}/edit'),
                ),
                IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmDelete(context, spiceRoute),
                ),
              ],
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              GestureDetector(
                onTap: ownerHere
                    ? () => _pickAndUpload(context, spiceRoute.id)
                    : null,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (spiceRoute.imageUrl != null)
                        CachedNetworkImage(
                          imageUrl: spiceRoute.imageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => _imagePlaceholder(context),
                        )
                      else
                        _imagePlaceholder(context),
                      if (_uploading)
                        const ColoredBox(
                          color: Colors.black38,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      if (ownerHere)
                        Positioned(
                          right: 12,
                          bottom: 12,
                          child: FilledButton.tonalIcon(
                            onPressed: _uploading
                                ? null
                                : () => _pickAndUpload(context, spiceRoute.id),
                            icon: const Icon(Icons.camera_alt_outlined),
                            label: Text(spiceRoute.imageUrl == null
                                ? 'Add photo'
                                : 'Replace'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spiceRoute.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'by ${spiceRoute.owner.displayName}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    if (spiceRoute.description != null &&
                        spiceRoute.description!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(spiceRoute.description!),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _stat(
                            context,
                            Icons.timer_outlined,
                            '${spiceRoute.prepMinutes + spiceRoute.cookMinutes} min',
                            'prep ${spiceRoute.prepMinutes} / cook ${spiceRoute.cookMinutes}'),
                        const SizedBox(width: 16),
                        _stat(context, Icons.restaurant_outlined,
                            '$displayServings servings', 'tap +/- to scale'),
                      ],
                    ),
                    if (spiceRoute.tags.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        children: [
                          for (final t in spiceRoute.tags)
                            Chip(label: Text(t.name)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _Section(
                title: 'Ingredients',
                trailing: _ServingsScaler(
                  servings: displayServings,
                  onChanged: (v) => setState(() => _displayServings = v),
                  onReset: displayServings == spiceRoute.servings
                      ? null
                      : () => setState(() => _displayServings = null),
                ),
                child: Column(
                  children: [
                    for (final ing in spiceRoute.ingredients)
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.fiber_manual_record, size: 10),
                        title: Text(_formatIngredient(ing, scale)),
                      ),
                  ],
                ),
              ),
              _Section(
                title: 'Steps',
                child: Column(
                  children: [
                    for (var i = 0; i < spiceRoute.steps.length; i++)
                      ListTile(
                        leading: CircleAvatar(
                          radius: 14,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        title: Text(spiceRoute.steps[i].body),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _imagePlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.restaurant,
        size: 64,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }

  Widget _stat(BuildContext context, IconData icon, String main, String sub) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(main, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              sub,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatIngredient(Ingredient ing, double scale) {
    final parts = <String>[];
    if (ing.quantity != null) {
      final v = ing.quantity! * scale;
      parts.add(_formatNumber(v));
    }
    if (ing.unit != null && ing.unit!.isNotEmpty) parts.add(ing.unit!);
    parts.add(ing.name);
    return parts.join(' ');
  }

  String _formatNumber(double v) {
    if ((v - v.round()).abs() < 0.01) return v.round().toString();
    return NumberFormat('#.##').format(v);
  }

  Future<void> _confirmDelete(BuildContext context, SpiceRouteDetail r) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete SpiceRoute?'),
        content: Text('"${r.title}" will be permanently removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (yes != true || !context.mounted) return;
    try {
      await ref.read(apiClientProvider).deleteSpiceRoute(r.id);
      ref.read(spiceRouteListControllerProvider.notifier).refresh();
      if (context.mounted) context.go('/');
    } catch (e) {
      if (context.mounted) showErrorSnack(context, apiErrorMessage(e));
    }
  }

  Future<void> _pickAndUpload(BuildContext context, String spiceRouteId) async {
    final messenger = ScaffoldMessenger.of(context);
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2000,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() => _uploading = true);
    try {
      final bytes = await picked.readAsBytes();
      final mime = picked.mimeType ?? _guessMime(picked.name);
      await ref.read(apiClientProvider).uploadImage(
            spiceRouteId,
            bytes: bytes,
            filename: picked.name,
            mimeType: mime,
          );
      ref.invalidate(spiceRouteDetailProvider(spiceRouteId));
      ref.read(spiceRouteListControllerProvider.notifier).refresh();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(apiErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  String _guessMime(String filename) {
    final ext = filename.toLowerCase().split('.').last;
    return switch (ext) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      _ => 'image/jpeg',
    };
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.trailing});
  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}

class _ServingsScaler extends StatelessWidget {
  const _ServingsScaler({
    required this.servings,
    required this.onChanged,
    required this.onReset,
  });

  final int servings;
  final ValueChanged<int> onChanged;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: servings > 1 ? () => onChanged(servings - 1) : null,
        ),
        Text('$servings', style: Theme.of(context).textTheme.titleMedium),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: servings < 99 ? () => onChanged(servings + 1) : null,
        ),
        if (onReset != null)
          TextButton(onPressed: onReset, child: const Text('Reset')),
      ],
    );
  }
}
