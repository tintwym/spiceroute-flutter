import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/spice_route.dart';
import '../../state/auth.dart';
import '../../state/recipe_reviews.dart';
import '../auth/sign_in_prompt.dart';

/// "Community Gallery & Reviews" block rendered at the bottom of the
/// recipe detail modal. Composes four sub-sections:
///
///   1. [_RatingSummary]  — average stars + review count + photo count
///   2. [_PhotoGallery]   — horizontal scroller of cooked-dish photos
///   3. [_ReviewForm]     — inline rating/photo/comment composer
///   4. [_ReviewList]     — chronological feed of community reviews
///
/// Tapping any photo opens a fullscreen [_PhotoLightbox] so the user can
/// see the cook's submission at full resolution.
class RecipeReviewsSection extends ConsumerWidget {
  const RecipeReviewsSection({super.key, required this.recipe});

  final SpiceRouteDetail recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final async = ref.watch(recipeReviewsProvider(recipe.id));
    final reviews = async.maybeWhen(
      data: (xs) => xs,
      orElse: () => const <RecipeReview>[],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.photo_library_outlined, size: 18, color: cs.onSurface),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l.reviewsTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          l.reviewsSubtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 16),
        _RatingSummary(reviews: reviews),
        const SizedBox(height: 16),
        _PhotoGallery(reviews: reviews),
        const SizedBox(height: 16),
        _ReviewForm(recipe: recipe),
        const SizedBox(height: 16),
        _ReviewList(reviews: reviews),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Average rating summary
// ─────────────────────────────────────────────────────────────────────

class _RatingSummary extends StatelessWidget {
  const _RatingSummary({required this.reviews});
  final List<RecipeReview> reviews;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // 4.8 is the fallback used by the React companion when no community
    // reviews exist yet — keeps the average "looking populated" instead
    // of an empty 0/5. Once a real review lands, this falls away.
    final double avg = reviews.isEmpty
        ? 4.8
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
    final photoCount = reviews.where((r) => r.hasPhoto).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.reviewsAverage,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      avg.toStringAsFixed(1),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: _StarRow(value: avg, size: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l.reviewsCount(reviews.length),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                l.reviewsUploadedCooks(photoCount),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Renders 5 stars with a fractional fill based on [value] (1..5).
class _StarRow extends StatelessWidget {
  const _StarRow({required this.value, this.size = 14});
  final double value;
  final double size;

  @override
  Widget build(BuildContext context) {
    const fill = Color(0xFFD4A373);
    final empty = Theme.of(context).colorScheme.outlineVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            i <= value.round() ? Icons.star : Icons.star_border,
            size: size,
            color: i <= value.round() ? fill : empty,
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Horizontal photo gallery (clickable thumbs → fullscreen lightbox)
// ─────────────────────────────────────────────────────────────────────

class _PhotoGallery extends StatelessWidget {
  const _PhotoGallery({required this.reviews});
  final List<RecipeReview> reviews;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final photos = reviews.where((r) => r.hasPhoto).toList(growable: false);

    if (photos.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: cs.outlineVariant,
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        child: Text(
          l.reviewsEmptyState,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
      );
    }

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        itemCount: photos.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) => _PhotoThumb(review: photos[i]),
      ),
    );
  }
}

class _PhotoThumb extends StatelessWidget {
  const _PhotoThumb({required this.review});
  final RecipeReview review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final bytes = decodeReviewPhoto(review.photoBase64);
    return SizedBox(
      width: 140,
      child: InkWell(
        onTap: () => _openLightbox(context, review),
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (bytes != null)
                Image.memory(bytes, fit: BoxFit.cover, gaplessPlayback: true)
              else
                Container(color: cs.surfaceContainerHighest),
              // Dark gradient + author/rating overlay so the thumb reads
              // like a magazine contact sheet, not a flat tile.
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.72),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Text(
                    review.userName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star,
                          size: 10, color: Color(0xFFFFC940)),
                      const SizedBox(width: 2),
                      Text(
                        '${review.rating}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: const Color(0xFFFFC940),
                          fontWeight: FontWeight.w800,
                        ),
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

void _openLightbox(BuildContext context, RecipeReview review) {
  Navigator.of(context).push(PageRouteBuilder<void>(
    opaque: false,
    barrierColor: Colors.black.withValues(alpha: 0.92),
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (_, _, _) => _PhotoLightbox(review: review),
  ));
}

class _PhotoLightbox extends StatelessWidget {
  const _PhotoLightbox({required this.review});
  final RecipeReview review;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final bytes = decodeReviewPhoto(review.photoBase64);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Tap-anywhere-to-dismiss backdrop.
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (bytes != null)
                      InteractiveViewer(
                        // Pinch-to-zoom on touch / scroll-wheel zoom on web.
                        minScale: 1,
                        maxScale: 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.memory(
                            bytes,
                            fit: BoxFit.contain,
                            gaplessPlayback: true,
                          ),
                        ),
                      ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          review.userName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 10),
                        _StarRow(
                          value: review.rating.toDouble(),
                          size: 16,
                        ),
                      ],
                    ),
                    if (review.comment.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        '“${review.comment}”',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 24,
            right: 24,
            child: IconButton(
              tooltip: l.reviewsLightboxCloseTooltip,
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Inline composer (rating + photo + caption + post button)
// ─────────────────────────────────────────────────────────────────────

class _ReviewForm extends ConsumerStatefulWidget {
  const _ReviewForm({required this.recipe});
  final SpiceRouteDetail recipe;

  @override
  ConsumerState<_ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends ConsumerState<_ReviewForm> {
  final _author = TextEditingController();
  final _comment = TextEditingController();
  final _picker = ImagePicker();
  int _rating = 5;
  Uint8List? _photoBytes;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill author with the signed-in display name so the most common
    // case (sign in → review my recipe) is one less field to touch.
    final user = ref.read(authControllerProvider);
    if (user != null) {
      _author.text = user.displayName ?? '';
    }
  }

  @override
  void dispose() {
    _author.dispose();
    _comment.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 90,
      );
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      setState(() => _photoBytes = bytes);
    } catch (_) {
      // Silent — picker can throw on web cancellations / permission denial,
      // which we treat as "user changed their mind" rather than failure.
    }
  }

  Future<void> _submit() async {
    if (_comment.text.trim().isEmpty) return;
    await ref.read(reviewSubmitProvider.notifier).submit(
          recipeId: widget.recipe.id,
          userName: _author.text,
          rating: _rating,
          comment: _comment.text,
          photoBytes: _photoBytes,
          cuisine: widget.recipe.cuisine,
        );
    if (!mounted) return;
    final st = ref.read(reviewSubmitProvider);
    if (st.lastSuccess) {
      setState(() {
        _comment.clear();
        _photoBytes = null;
        _rating = 5;
        _showSuccess = true;
      });
      // Auto-dismiss the success banner after a beat so the form is ready
      // for the next post without needing manual tap.
      Future<void>.delayed(const Duration(seconds: 4), () {
        if (!mounted) return;
        setState(() => _showSuccess = false);
        ref.read(reviewSubmitProvider.notifier).dismissSuccess();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final user = ref.watch(authControllerProvider);
    final state = ref.watch(reviewSubmitProvider);

    if (user == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          children: [
            Text(
              l.reviewsLoginPrompt,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.login, size: 18),
              label: Text(l.reviewsLoginCta),
              onPressed: () => showSignInPrompt(
                context,
                nextPath: '/recipes/${widget.recipe.id}',
              ),
            ),
          ],
        ),
      );
    }

    if (_showSuccess) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF3FA35A).withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF3FA35A).withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF2E7D43), size: 28),
            const SizedBox(height: 8),
            Text(
              l.reviewsSubmitted,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF2E7D43),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () => setState(() => _showSuccess = false),
              child: Text(l.reviewsPostAnother),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.photo_camera_outlined, size: 16, color: cs.onSurface),
              const SizedBox(width: 8),
              Text(
                l.reviewsFormTitle,
                style: theme.textTheme.labelLarge?.copyWith(
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PhotoPicker(
            bytes: _photoBytes,
            onPick: _pickPhoto,
            onRemove: () => setState(() => _photoBytes = null),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth >= 360;
            final rating = _RatingPicker(
              value: _rating,
              onChanged: (v) => setState(() => _rating = v),
            );
            final author = TextField(
              controller: _author,
              decoration: InputDecoration(
                labelText: l.reviewsAuthorLabel,
                hintText: l.reviewsAuthorHint,
              ),
            );
            if (!wide) {
              return Column(children: [rating, const SizedBox(height: 12), author]);
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                rating,
                const SizedBox(width: 12),
                Expanded(child: author),
              ],
            );
          }),
          const SizedBox(height: 14),
          TextField(
            controller: _comment,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: l.reviewsCommentLabel,
              hintText: l.reviewsCommentHint,
            ),
          ),
          if (state.error != null) ...[
            const SizedBox(height: 12),
            Text(
              state.error == 'photo-too-large'
                  ? l.reviewsPhotoTooLarge
                  : l.reviewsErrorGeneric,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.error,
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed:
                  state.submitting || _comment.text.trim().isEmpty ? null : _submit,
              child: Text(
                state.submitting ? l.reviewsPublishing : l.reviewsPublishBtn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Photo-picker tile inside the composer — empty state has a camera icon
/// + hint, selected state shows a thumbnail with a remove affordance.
class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({
    required this.bytes,
    required this.onPick,
    required this.onRemove,
  });

  final Uint8List? bytes;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final hasPhoto = bytes != null;

    return InkWell(
      onTap: hasPhoto ? null : onPick,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasPhoto ? cs.primary : cs.outlineVariant,
            width: hasPhoto ? 1.5 : 1,
          ),
        ),
        child: hasPhoto
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(bytes!, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 2,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onRemove,
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.close,
                              size: 14, color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined,
                      size: 26, color: cs.onSurfaceVariant),
                  const SizedBox(height: 8),
                  Text(
                    l.reviewsPhotoHint,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _RatingPicker extends StatelessWidget {
  const _RatingPicker({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const fill = Color(0xFFD4A373);
    final empty = Theme.of(context).colorScheme.outlineVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            constraints: const BoxConstraints(),
            onPressed: () => onChanged(i),
            icon: Icon(
              i <= value ? Icons.star : Icons.star_border,
              color: i <= value ? fill : empty,
              size: 22,
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Review feed
// ─────────────────────────────────────────────────────────────────────

class _ReviewList extends ConsumerWidget {
  const _ReviewList({required this.reviews});
  final List<RecipeReview> reviews;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (reviews.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final r in reviews)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ReviewTile(review: r),
          ),
      ],
    );
  }
}

class _ReviewTile extends ConsumerWidget {
  const _ReviewTile({required this.review});
  final RecipeReview review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final user = ref.watch(authControllerProvider);
    final canDelete = !review.isPreset &&
        user != null &&
        review.userId != null &&
        review.userId == user.uid;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.userName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (review.createdAt != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            '· ${DateFormat.yMMMd().format(review.createdAt!)}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: cs.onSurfaceVariant,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    _StarRow(value: review.rating.toDouble(), size: 12),
                  ],
                ),
              ),
              if (canDelete)
                IconButton(
                  tooltip: l.reviewsDeleteTooltip,
                  visualDensity: VisualDensity.compact,
                  iconSize: 16,
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l.reviewsDeleteConfirm),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(l.commonCancel),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text(l.commonDelete),
                          ),
                        ],
                      ),
                    );
                    if (ok == true) {
                      await ref
                          .read(reviewSubmitProvider.notifier)
                          .delete(review.id);
                    }
                  },
                  icon: Icon(Icons.delete_outline, color: cs.onSurfaceVariant),
                ),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              review.comment,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          ],
          if (review.hasPhoto) ...[
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 220, maxHeight: 140),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: InkWell(
                  onTap: () => _openLightbox(context, review),
                  borderRadius: BorderRadius.circular(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Builder(builder: (_) {
                      final bytes = decodeReviewPhoto(review.photoBase64);
                      if (bytes == null) {
                        return Container(color: cs.surfaceContainerHighest);
                      }
                      return Image.memory(bytes,
                          fit: BoxFit.cover, gaplessPlayback: true);
                    }),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
