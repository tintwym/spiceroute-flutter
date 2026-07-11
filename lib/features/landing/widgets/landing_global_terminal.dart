import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';

import '../landing_models.dart';
import '../landing_palette.dart';
import '../landing_state.dart';
import 'landing_landmarks.dart';
import 'landing_shared.dart';

const _regionEmojis = {
  'East Asia': '🏮',
  'Mainland SE Asia': '🛶',
  'Maritime Southeast Asia': '🥥',
  'South Asia': '🌶️',
  'Europe': '🍕',
  'Americas': '🌮',
  'Middle East & Africa': '🕌',
};

const _regionPhotos = {
  'Europe': [
    (
      'Risotto alla Milanese',
      'https://images.unsplash.com/photo-1476124369491-e7addf5db371?auto=format&fit=crop&w=800&q=80',
    ),
  ],
  'Middle East & Africa': [
    (
      'Moroccan Chicken Tagine',
      'https://images.unsplash.com/photo-1541518763669-27fef04b14ea?auto=format&fit=crop&w=800&q=80',
    ),
  ],
  'South Asia': [
    (
      'Royal Delhi Butter Chicken',
      'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=800&q=80',
    ),
  ],
  'Mainland SE Asia': [
    (
      'Cambodian Fish Amok',
      'https://images.unsplash.com/photo-1559314809-0d155014e29e?auto=format&fit=crop&w=800&q=80',
    ),
  ],
  'Maritime Southeast Asia': [
    (
      'West Sumatran Beef Rendang',
      'https://images.unsplash.com/photo-1546549032-9571cd6b27df?auto=format&fit=crop&w=800&q=80',
    ),
  ],
  'East Asia': [
    (
      'Sichuan Mapo Tofu',
      'https://images.unsplash.com/photo-1627308595229-7830a5c91f9f?auto=format&fit=crop&w=800&q=80',
    ),
  ],
  'Americas': [
    (
      'Artisanal Chicken Mole',
      'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=800&q=80',
    ),
  ],
};

class LandingGlobalTerminal extends ConsumerStatefulWidget {
  const LandingGlobalTerminal({super.key});

  @override
  ConsumerState<LandingGlobalTerminal> createState() =>
      _LandingGlobalTerminalState();
}

class _LandingGlobalTerminalState extends ConsumerState<LandingGlobalTerminal> {
  final _username = TextEditingController();
  final _dish = TextEditingController(text: 'Risotto alla Milanese');
  final _caption = TextEditingController();
  final _tags = TextEditingController();
  var _region = 'Europe';
  var _photoUrl =
      'https://images.unsplash.com/photo-1476124369491-e7addf5db371?auto=format&fit=crop&w=800&q=80';
  String? _customImage;
  var _success = false;

  @override
  void dispose() {
    _username.dispose();
    _dish.dispose();
    _caption.dispose();
    _tags.dispose();
    super.dispose();
  }

  void _onRegion(String region) {
    final photos = _regionPhotos[region];
    setState(() {
      _region = region;
      if (photos != null && photos.isNotEmpty) {
        _photoUrl = photos.first.$2;
        _dish.text = photos.first.$1;
      }
    });
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 65,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (!mounted) return;
    setState(() {
      _customImage = 'data:image/jpeg;base64,${base64Encode(bytes)}';
    });
  }

  void _submit(BuildContext context) {
    if (_username.text.trim().isEmpty || _caption.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add your cook handle and a review before stamping.'),
        ),
      );
      return;
    }
    var handle = _username.text.trim();
    if (!handle.startsWith('@')) handle = '@$handle';
    final tags = _tags.text.trim().isEmpty
        ? [_dish.text.replaceAll(' ', ''), 'SpiceRouteCook']
        : _tags.text
              .split(',')
              .map((t) => t.trim().replaceAll('#', ''))
              .where((t) => t.isNotEmpty)
              .toList();
    ref
        .read(landingCommunityProvider.notifier)
        .addPost(
          LandingCommunityPost(
            id: 'post-${DateTime.now().millisecondsSinceEpoch}',
            username: handle,
            dishName: _dish.text,
            regionName: _region,
            caption: _caption.text,
            imageUrl: _customImage ?? _photoUrl,
            tags: tags,
            timestamp: 'Just now',
            likes: 1,
          ),
        );
    setState(() {
      _username.clear();
      _caption.clear();
      _tags.clear();
      _customImage = null;
      _success = true;
    });
    Future<void>.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _success = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(landingCommunityProvider);
    final wide = MediaQuery.sizeOf(context).width >= 1024;
    return LandingMaxWidth(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
      child: Column(
        children: [
          const LandingSectionHeader(
            badge: 'The Culinary Board',
            title: 'Live From Kitchens Around the Globe',
            subtitle:
                'See how cooks around the world are stamping their culinary passports and sharing real dishes from their kitchens.',
            icon: Icons.forum_outlined,
            center: true,
          ),
          const SizedBox(height: 48),
          LandingResponsiveRow(
            wide: wide,
            spacing: 40,
            children: [
              _FormPanel(
                username: _username,
                dish: _dish,
                caption: _caption,
                tags: _tags,
                region: _region,
                photoUrl: _photoUrl,
                customImage: _customImage,
                success: _success,
                onRegion: _onRegion,
                onPickImage: _pickImage,
                onClearImage: () => setState(() => _customImage = null),
                onSubmit: () => _submit(context),
              ),
              _PostsGrid(posts: posts),
            ],
          ),
        ],
      ),
    );
  }
}

class _FormPanel extends StatelessWidget {
  const _FormPanel({
    required this.username,
    required this.dish,
    required this.caption,
    required this.tags,
    required this.region,
    required this.photoUrl,
    required this.customImage,
    required this.success,
    required this.onRegion,
    required this.onPickImage,
    required this.onClearImage,
    required this.onSubmit,
  });

  final TextEditingController username;
  final TextEditingController dish;
  final TextEditingController caption;
  final TextEditingController tags;
  final String region;
  final String photoUrl;
  final String? customImage;
  final bool success;
  final ValueChanged<String> onRegion;
  final VoidCallback onPickImage;
  final VoidCallback onClearImage;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: LandingPalette.cream,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: LandingPalette.charcoal.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Share Your Culinary Stamp',
            style: LandingPalette.serif(context, size: 16),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: username,
            decoration: const InputDecoration(
              labelText: 'Cook Profile Handle',
              hintText: '@chef_clara',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'SELECT PASSPORT STAMP',
            style: LandingPalette.mono(context, size: 10),
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.9,
            children: [
              for (final r in _regionEmojis.entries)
                InkWell(
                  onTap: () => onRegion(r.key),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: region == r.key
                            ? LandingPalette.red
                            : LandingPalette.charcoal.withValues(alpha: 0.12),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LandingLandmarkIcon(regionName: r.key, size: 28),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            r.key,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: LandingPalette.mono(
                              context,
                              size: 8,
                              color: region == r.key
                                  ? LandingPalette.red
                                  : LandingPalette.charcoal.withValues(
                                      alpha: 0.6,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: dish,
            decoration: const InputDecoration(labelText: 'Dish Name'),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onPickImage,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: LandingPalette.charcoal.withValues(alpha: 0.2),
                    width: 2,
                  ),
                  color: LandingPalette.alabaster,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (customImage != null || photoUrl.isNotEmpty)
                      _landingPostImage(customImage ?? photoUrl),
                    if (customImage == null)
                      Center(
                        child: Text(
                          'Upload Custom Dish Photo',
                          style: LandingPalette.sans(
                            context,
                            size: 12,
                            color: LandingPalette.charcoal.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    if (customImage != null)
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: onClearImage,
                          icon: const Icon(Icons.close),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: caption,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Review & Experience'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: tags,
            decoration: const InputDecoration(
              labelText: 'Tags (comma-separated)',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onSubmit,
            style: FilledButton.styleFrom(
              backgroundColor: LandingPalette.charcoal,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: const Icon(Icons.explore),
            label: const Text('STAMP CULINARY PASSPORT'),
          ),
          if (success)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: LandingPalette.emerald.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: LandingPalette.emerald.withValues(alpha: 0.25),
                ),
              ),
              child: const Text(
                'Passport stamp successfully cataloged!',
                style: TextStyle(color: LandingPalette.emerald, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }
}

class _PostsGrid extends ConsumerWidget {
  const _PostsGrid({required this.posts});

  final List<LandingCommunityPost> posts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MasonryGridView.count(
      crossAxisCount: MediaQuery.sizeOf(context).width >= 640 ? 2 : 1,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return _PostCard(
          post: post,
          onLike: () =>
              ref.read(landingCommunityProvider.notifier).like(post.id),
          onDelete: () =>
              ref.read(landingCommunityProvider.notifier).deletePost(post.id),
        );
      },
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.post,
    required this.onLike,
    required this.onDelete,
  });

  final LandingCommunityPost post;
  final VoidCallback onLike;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final imageWidget = _buildPostImage(post.imageUrl);
    return Container(
      decoration: BoxDecoration(
        color: LandingPalette.cream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: LandingPalette.charcoal.withValues(alpha: 0.1),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              imageWidget,
              Positioned(
                top: 12,
                left: 12,
                child: LandingLandmarkInk(regionName: post.regionName),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      post.username,
                      style: LandingPalette.mono(
                        context,
                        size: 11,
                        color: LandingPalette.red,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          post.timestamp,
                          style: LandingPalette.mono(context, size: 9),
                        ),
                        IconButton(
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete_outline, size: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  post.dishName,
                  style: LandingPalette.serif(context, size: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  '"${post.caption}"',
                  style: LandingPalette.sans(
                    context,
                    size: 13,
                  ).copyWith(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  children: [
                    for (final t in post.tags)
                      Chip(
                        label: Text(t, style: const TextStyle(fontSize: 9)),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
                TextButton.icon(
                  onPressed: onLike,
                  icon: const Icon(
                    Icons.favorite,
                    color: LandingPalette.red,
                    size: 16,
                  ),
                  label: Text('${post.likes} stamps'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage(String url) {
    return _landingPostImage(url, height: 200);
  }
}

Widget _landingPostImage(String url, {double height = 120}) {
  if (url.startsWith('data:')) {
    final comma = url.indexOf(',');
    if (comma > 0) {
      try {
        final bytes = base64Decode(url.substring(comma + 1));
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          height: height,
          width: double.infinity,
        );
      } catch (_) {
        return SizedBox(
          height: height,
          child: const Center(child: Icon(Icons.broken_image_outlined)),
        );
      }
    }
  }
  return CachedNetworkImage(
    imageUrl: url,
    fit: BoxFit.cover,
    height: height,
    width: double.infinity,
  );
}
