import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/spice_route.dart';
import '../../shared/breakpoints.dart';
import '../../shared/cuisine_chrome.dart';
import '../../shared/widgets.dart';
import '../../state/explore.dart';
import '../../state/user_profile.dart';

// ─────────────────────────────────────────────────────────────────────────
// Model + Firestore data layer
// ─────────────────────────────────────────────────────────────────────────

/// A community-uploaded photo (UGC). Stored in the `community_photos`
/// Firestore collection; the photo is base64-encoded inline so a single
/// `get(snapshot)` round-trip lights up the whole feed without a second
/// fetch from Cloud Storage. We compress aggressively (800×600 JPEG @ 0.7)
/// to keep the doc comfortably under Firestore's 1 MB limit.
class CommunityPhoto {
  const CommunityPhoto({
    required this.id,
    required this.cuisine,
    required this.photoBase64,
    required this.caption,
    required this.author,
    required this.createdAt,
  });

  final String id;

  /// `null` when uploaded with "All cuisines" selected — these post-cards
  /// render with a generic globe label and appear in every cuisine filter.
  final Cuisine? cuisine;

  final String photoBase64;
  final String caption;
  final String author;
  final DateTime? createdAt;

  factory CommunityPhoto.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> d) {
    final data = d.data();
    final cuisineRaw = (data['cuisine'] as String?) ?? '';
    final ts = data['createdAt'];
    return CommunityPhoto(
      id: d.id,
      cuisine: Cuisine.values.firstWhere(
        (c) => c.name == cuisineRaw,
        orElse: () => Cuisine.americanWestern,
      ).let((c) => cuisineRaw.isEmpty ? null : c),
      photoBase64: (data['photoBase64'] as String?) ?? '',
      caption: (data['caption'] as String?) ?? '',
      author: (data['author'] as String?) ?? 'Anonymous Chef',
      createdAt: ts is Timestamp ? ts.toDate() : null,
    );
  }
}

extension _Let<T> on T {
  R let<R>(R Function(T) f) => f(this);
}

/// Reactive feed of every community photo (newest first). Returns an empty
/// list when Firebase isn't configured (dev mode) — the upload form will
/// also no-op in that case, keeping the UI usable.
final communityPhotosProvider =
    StreamProvider<List<CommunityPhoto>>((ref) async* {
  final fs = ref.watch(firestoreProvider);
  if (fs == null) {
    yield const <CommunityPhoto>[];
    return;
  }
  // Order by createdAt desc; we filter by cuisine client-side because a
  // composite index would be overkill for this small feed.
  final stream = fs
      .collection('community_photos')
      .orderBy('createdAt', descending: true)
      .limit(120) // safety cap so a runaway upload bot doesn't blow up memory
      .snapshots();
  await for (final snap in stream) {
    yield snap.docs.map(CommunityPhoto.fromDoc).toList(growable: false);
  }
});

/// Upload status the form watches to render its progress / success / error
/// banner. The notifier owns the picking + compression + write-through.
@immutable
class CommunityUploadState {
  const CommunityUploadState({
    this.uploading = false,
    this.lastSuccess = false,
    this.error,
  });
  final bool uploading;
  final bool lastSuccess;
  final String? error;

  CommunityUploadState copy({
    bool? uploading,
    bool? lastSuccess,
    String? error,
    bool clearError = false,
  }) =>
      CommunityUploadState(
        uploading: uploading ?? this.uploading,
        lastSuccess: lastSuccess ?? this.lastSuccess,
        error: clearError ? null : (error ?? this.error),
      );
}

class CommunityUploadController extends StateNotifier<CommunityUploadState> {
  CommunityUploadController(this._ref) : super(const CommunityUploadState());
  final Ref _ref;

  Future<void> upload({
    required Uint8List photoBytes,
    required Cuisine? cuisine,
    required String author,
    required String caption,
  }) async {
    final fs = _ref.read(firestoreProvider);
    if (fs == null) {
      state = state.copy(error: 'firebase-not-configured');
      return;
    }
    state = state.copy(uploading: true, lastSuccess: false, clearError: true);
    try {
      final compressed = await _maybeCompress(photoBytes);
      final b64 = base64Encode(compressed);
      // Firestore docs cap at 1 MB; base64 adds ~33% overhead so we cap
      // the compressed JPEG at ~700 KB just to be safe.
      if (b64.length > 750 * 1024) {
        state = state.copy(uploading: false, error: 'photo-too-large');
        return;
      }
      await fs.collection('community_photos').add({
        'cuisine': cuisine?.name ?? '',
        'photoBase64': b64,
        'caption': caption.trim(),
        'author': author.trim().isEmpty ? 'Anonymous Chef' : author.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      state = state.copy(uploading: false, lastSuccess: true);
    } catch (e) {
      state = state.copy(uploading: false, error: e.toString());
    }
  }

  /// Mobile platforms get the native compressor for big HEIC/JPEG; on web
  /// the plugin isn't wired up so we just return the raw bytes (image_picker
  /// already gives us reasonable JPEGs from `<input type="file">`).
  Future<Uint8List> _maybeCompress(Uint8List src) async {
    if (kIsWeb) return src;
    try {
      final out = await FlutterImageCompress.compressWithList(
        src,
        minWidth: 800,
        minHeight: 600,
        quality: 70,
        format: CompressFormat.jpeg,
      );
      return Uint8List.fromList(out);
    } catch (_) {
      // Codec missing on this platform — fall back to the raw bytes.
      return src;
    }
  }

  void dismissSuccess() => state = state.copy(lastSuccess: false);
}

final communityUploadProvider = StateNotifierProvider<
    CommunityUploadController, CommunityUploadState>(
  (ref) => CommunityUploadController(ref),
);

// ─────────────────────────────────────────────────────────────────────────
// UI
// ─────────────────────────────────────────────────────────────────────────

/// "Community Culinary Board" section: a showcase/upload form on the left
/// and the live feed on the right (stacked on narrow viewports).
class CommunityBoard extends ConsumerWidget {
  const CommunityBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final dc = deviceClassOf(context);
    final twoCol = dc.isAtLeastTablet;

    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GreenBadge(text: l.communityBadge),
        const SizedBox(height: 12),
        Text(l.communityTitle, style: theme.textTheme.headlineLarge),
        const SizedBox(height: 6),
        Text(
          l.communitySubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
      ],
    );

    final showcase = const _ShowcaseCard();
    final feed = const _LiveFeed();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: cs.outlineVariant, height: 1),
        const SizedBox(height: 28),
        header,
        const SizedBox(height: 24),
        if (twoCol)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: showcase),
                const SizedBox(width: 24),
                Expanded(flex: 6, child: feed),
              ],
            ),
          )
        else ...[
          showcase,
          const SizedBox(height: 20),
          SizedBox(height: 360, child: feed),
        ],
      ],
    );
  }
}

class _GreenBadge extends StatelessWidget {
  const _GreenBadge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const green = Color(0xFF3FA35A);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(color: green, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: const Color(0xFF2E7D43),
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// The left card: upload zone + chef name + caption + share button.
///
/// Wired to a real `image_picker` (gallery on mobile, file input on web)
/// and `flutter_image_compress` (mobile only — the plugin doesn't ship a
/// web impl, see [CommunityUploadController._maybeCompress]).
class _ShowcaseCard extends ConsumerStatefulWidget {
  const _ShowcaseCard();

  @override
  ConsumerState<_ShowcaseCard> createState() => _ShowcaseCardState();
}

class _ShowcaseCardState extends ConsumerState<_ShowcaseCard> {
  final _chef = TextEditingController();
  final _caption = TextEditingController();
  final _picker = ImagePicker();
  Uint8List? _photoBytes;

  @override
  void dispose() {
    _chef.dispose();
    _caption.dispose();
    super.dispose();
  }

  bool get _canShare =>
      _chef.text.trim().isNotEmpty &&
      _photoBytes != null &&
      !ref.read(communityUploadProvider).uploading;

  Future<void> _pickPhoto() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        // The compressor we run afterwards downsizes further; this is just
        // a "don't try to load a 50 MP RAW into memory" guard for picking.
        maxWidth: 1600,
        imageQuality: 90,
      );
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      setState(() => _photoBytes = bytes);
    } catch (_) {
      // Picker can throw on permission denial or web cancel — silently bail.
    }
  }

  Future<void> _share() async {
    final bytes = _photoBytes;
    if (bytes == null) return;
    final l = AppL10n.of(context);
    final cuisine = ref.read(exploreProvider).cuisine;
    await ref.read(communityUploadProvider.notifier).upload(
          photoBytes: bytes,
          cuisine: cuisine,
          author: _chef.text,
          caption: _caption.text,
        );
    if (!mounted) return;
    final st = ref.read(communityUploadProvider);
    if (st.lastSuccess) {
      setState(() {
        _chef.clear();
        _caption.clear();
        _photoBytes = null;
      });
      showAppSnack(context, l.communitySharedToast);
      // Clear the success flag after a beat so the inline banner disappears.
      Future<void>.delayed(const Duration(seconds: 4), () {
        if (mounted) ref.read(communityUploadProvider.notifier).dismissSuccess();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final upload = ref.watch(communityUploadProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.photo_camera_outlined, size: 18, color: cs.onSurface),
              const SizedBox(width: 8),
              Text(
                l.communityShowcaseTitle,
                style: theme.textTheme.labelLarge?.copyWith(letterSpacing: 0.6),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _UploadZone(
            bytes: _photoBytes,
            onPick: _pickPhoto,
            onRemove: () => setState(() => _photoBytes = null),
          ),
          const SizedBox(height: 18),
          _FieldLabel(l.communityChefLabel),
          const SizedBox(height: 6),
          TextField(
            controller: _chef,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(hintText: l.communityChefHint),
          ),
          const SizedBox(height: 14),
          _FieldLabel(l.communityCaptionLabel),
          const SizedBox(height: 6),
          TextField(
            controller: _caption,
            minLines: 2,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: l.communityCaptionHint,
              border: _boxBorder(cs.outlineVariant),
              enabledBorder: _boxBorder(cs.outlineVariant),
              focusedBorder: _boxBorder(cs.primary),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _canShare && !upload.uploading ? _share : null,
              child: Text(
                upload.uploading ? l.communityUploading : l.communityShareBtn,
              ),
            ),
          ),
          if (upload.lastSuccess) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF3FA35A).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF3FA35A).withValues(alpha: 0.35),
                ),
              ),
              child: Text(
                '🎉  ${l.communityUploaded}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF2E7D43),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  OutlineInputBorder _boxBorder(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c),
      );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        letterSpacing: 1.0,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

/// Dashed-border upload target. Tapping triggers the real native picker;
/// when an image has been selected the zone shows a preview thumb and a
/// "remove" affordance.
class _UploadZone extends StatelessWidget {
  const _UploadZone({
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
    final picked = bytes != null;

    return InkWell(
      onTap: picked ? null : onPick,
      borderRadius: BorderRadius.circular(14),
      child: DottedBorder(
        color: picked ? cs.primary : cs.outlineVariant,
        radius: 14,
        child: Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: picked
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
                        shape: const StadiumBorder(),
                        elevation: 2,
                        child: InkWell(
                          customBorder: const StadiumBorder(),
                          onTap: onRemove,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.close,
                                    size: 14, color: Colors.redAccent),
                                const SizedBox(width: 4),
                                Text(
                                  l.communityRemovePhoto,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.photo_camera_outlined,
                        size: 30, color: cs.onSurfaceVariant),
                    const SizedBox(height: 10),
                    Text(
                      l.communityUploadCta,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l.communityUploadHint,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// The right column: live feed header + grid of posts (or empty state).
///
/// Reads the cuisine filter from `exploreProvider` and narrows the feed
/// client-side so the same Firestore stream powers both "All cuisines" and
/// the per-cuisine views — no extra query, no composite index needed.
class _LiveFeed extends ConsumerWidget {
  const _LiveFeed();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final cuisine = ref.watch(exploreProvider.select((s) => s.cuisine));
    final async = ref.watch(communityPhotosProvider);

    final all = async.maybeWhen(
      data: (xs) => xs,
      orElse: () => const <CommunityPhoto>[],
    );
    final visible = cuisine == null
        ? all
        : all.where((p) => p.cuisine == null || p.cuisine == cuisine).toList(
              growable: false,
            );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.dynamic_feed_outlined, size: 18, color: cs.onSurface),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l.communityFeedTitle(visible.length),
                style: theme.textTheme.labelLarge?.copyWith(letterSpacing: 0.6),
              ),
            ),
            if (cuisine != null)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Text(
                  l.communityFilteredTo(cuisineLabel(l, cuisine)),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: async.isLoading && visible.isEmpty
                ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                : visible.isEmpty
                    ? Center(
                        child: CenterMessage(
                          icon: Icons.restaurant,
                          title: l.communityEmptyTitle,
                          subtitle: l.communityEmptySubtitle,
                        ),
                      )
                    : GridView.builder(
                        physics: const ClampingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 0.78,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: visible.length,
                        itemBuilder: (_, i) => _PostTile(post: visible[i]),
                      ),
          ),
        ),
      ],
    );
  }
}

class _PostTile extends StatelessWidget {
  const _PostTile({required this.post});
  final CommunityPhoto post;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);

    // Decode the base64 once per build — cheap, but we wrap in a memo via
    // `RepaintBoundary` so re-layout (e.g. from a sibling rebuilding) doesn't
    // force a redecode on every paint.
    Uint8List? bytes;
    try {
      bytes = base64Decode(post.photoBase64);
    } catch (_) {
      bytes = null;
    }

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (bytes != null)
              Image.memory(bytes, fit: BoxFit.cover, gaplessPlayback: true)
            else
              Container(color: theme.colorScheme.surfaceContainerHighest),
            // Top-left cuisine pill, mirroring the React reference.
            if (post.cuisine != null)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${cuisineFlag(post.cuisine!)}  ${cuisineLabel(l, post.cuisine!)}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      fontSize: 9.5,
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.65),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (post.caption.isNotEmpty)
                      Text(
                        post.caption,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l.communityByLine(post.author),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (post.createdAt != null)
                          Text(
                            DateFormat.MMMd().add_Hm().format(post.createdAt!),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontFeatures: const [FontFeature.tabularFigures()],
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Dashed border (unchanged from the previous impl — kept here so we don't
// scatter the helper across files)
// ─────────────────────────────────────────────────────────────────────────

class DottedBorder extends StatelessWidget {
  const DottedBorder({
    super.key,
    required this.child,
    required this.color,
    this.radius = 12,
    this.dash = 6,
    this.gap = 4,
    this.strokeWidth = 1.5,
  });

  final Widget child;
  final Color color;
  final double radius;
  final double dash;
  final double gap;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRectPainter(
        color: color,
        radius: radius,
        dash: dash,
        gap: gap,
        strokeWidth: strokeWidth,
      ),
      child: child,
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  _DashedRectPainter({
    required this.color,
    required this.radius,
    required this.dash,
    required this.gap,
    required this.strokeWidth,
  });

  final Color color;
  final double radius;
  final double dash;
  final double gap;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dash;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRectPainter old) =>
      old.color != color ||
      old.radius != radius ||
      old.dash != dash ||
      old.gap != gap ||
      old.strokeWidth != strokeWidth;
}
