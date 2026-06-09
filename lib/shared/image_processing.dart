import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// First few bytes that uniquely identify each web-friendly format
/// (used by [detectImageMime] when stamping a `data:` URL).
const _kJpegMagic = <int>[0xFF, 0xD8, 0xFF];
const _kPngMagic = <int>[0x89, 0x50, 0x4E, 0x47];

/// Returns photo bytes that are safe to upload to Firestore as base64.
///
/// "Safe" means three things:
///
///   1. **No EXIF metadata** — phone cameras embed GPS coordinates,
///      device model, and timestamps inside JPEG EXIF tags. Posting
///      those publicly is a real privacy leak (a stranger can geo-locate
///      you from a photo of your dinner). Both code paths below strip
///      EXIF as a side effect of decoding + re-encoding.
///
///   2. **Bounded dimensions** — Firestore caps documents at 1 MB total,
///      and base64 encoding inflates payload by ~33%. We bound the
///      LONG side (orientation-aware) so a portrait phone photo and a
///      landscape DSLR shot both come out roughly the same byte size.
///
///   3. **Plain JPEG/PNG** — Firestore doesn't care, but a downstream
///      consumer rendering `<img src="data:image/...">` does. Native
///      flutter_image_compress emits JPEG; the web fallback emits PNG.
///      Use [detectImageMime] to stamp the correct prefix on the data
///      URL — hardcoding `image/jpeg` is wrong on web.
///
/// Strategy:
///
/// - **Mobile / desktop**: use `flutter_image_compress`. Its native
///   codec decodes + resizes + JPEG-encodes in one pass and explicitly
///   does NOT copy EXIF into the output (see plugin docs).
///
/// - **Web**: `flutter_image_compress` has no web implementation —
///   the previous code path just returned the raw bytes, EXIF intact.
///   We use `dart:ui.instantiateImageCodec` to decode + resize via the
///   browser's image pipeline, then `toByteData(ImageByteFormat.png)`
///   to re-encode. The browser's decode/encode pipeline never sees
///   EXIF and never emits it. Note: dart:ui only emits PNG; for a
///   typical food photo at the default 720 px long-side cap, a PNG
///   re-encode is usually 250 - 700 KB which fits the per-doc cap
///   after base64. Larger sources may still hit the per-doc cap —
///   the upload path is expected to bail with `photo-too-large`.
Future<Uint8List> compressForUpload(
  Uint8List src, {
  int targetMaxDimension = 800,
  int jpegQuality = 70,
}) async {
  if (kIsWeb) {
    // Slightly smaller on web to offset PNG's worse compression vs JPEG —
    // a 720 px PNG and an 800 px JPEG end up at roughly the same byte
    // size for the same photo.
    final webDim = targetMaxDimension > 720 ? 720 : targetMaxDimension;
    return _webDecodeReencode(src, targetMaxDimension: webDim);
  }
  try {
    final out = await FlutterImageCompress.compressWithList(
      src,
      minWidth: targetMaxDimension,
      minHeight: (targetMaxDimension * 0.75).round(),
      quality: jpegQuality,
      format: CompressFormat.jpeg,
      // Plugin doesn't preserve EXIF by default, but be explicit.
      keepExif: false,
    );
    return Uint8List.fromList(out);
  } catch (_) {
    // Codec missing or unsupported input — fall back to the
    // dart:ui path so we still strip EXIF.
    return _webDecodeReencode(src, targetMaxDimension: targetMaxDimension);
  }
}

/// Pure-Flutter decode → resize → re-encode. Used on web (where
/// flutter_image_compress is a no-op) and as a fallback when the
/// native compressor can't handle the input format.
///
/// The resulting bytes are PNG, which is larger than the equivalent
/// JPEG would be (dart:ui only ships a PNG encoder), but PNG is
/// lossless so quality stays high.
Future<Uint8List> _webDecodeReencode(
  Uint8List src, {
  required int targetMaxDimension,
}) async {
  // Peek the source dimensions FIRST so we can clamp the *long* axis
  // (not the width). Naively passing `targetWidth: 800` to a 3000x4000
  // portrait gave 800x1067 — long axis = 1067, 30 % bigger than asked,
  // and a noticeable PNG-size bump that often spilled past the
  // per-document cap.
  ui.Codec headerCodec;
  try {
    headerCodec = await ui.instantiateImageCodec(src);
  } catch (_) {
    // Can't even decode — let the upload path reject this on its own
    // rather than silently treat a corrupt file as a successful
    // compression.
    return src;
  }

  int srcW;
  int srcH;
  try {
    final headerFrame = await headerCodec.getNextFrame();
    try {
      srcW = headerFrame.image.width;
      srcH = headerFrame.image.height;
    } finally {
      headerFrame.image.dispose();
    }
  } finally {
    headerCodec.dispose();
  }

  if (srcW <= 0 || srcH <= 0) return src;

  // Source is already smaller than the cap — re-encode at native size
  // (still strips EXIF, just doesn't downscale).
  final longSide = srcW > srcH ? srcW : srcH;
  final scale = longSide > targetMaxDimension
      ? targetMaxDimension / longSide
      : 1.0;

  final targetW = (srcW * scale).round().clamp(1, srcW);
  final targetH = (srcH * scale).round().clamp(1, srcH);

  ui.Codec scaledCodec;
  try {
    scaledCodec = await ui.instantiateImageCodec(
      src,
      targetWidth: targetW,
      targetHeight: targetH,
    );
  } catch (_) {
    return src;
  }

  ui.FrameInfo frame;
  try {
    frame = await scaledCodec.getNextFrame();
  } finally {
    scaledCodec.dispose();
  }

  final image = frame.image;
  try {
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) return src;
    return bytes.buffer.asUint8List();
  } finally {
    image.dispose();
  }
}

/// Returns the appropriate `image/*` MIME type for [bytes] by sniffing
/// the magic header. Defaults to `image/jpeg` (the most common phone-
/// camera format) when nothing matches, so the data URL is at least
/// permissive instead of empty.
///
/// Required because the compressed output format depends on platform:
/// mobile re-encodes to JPEG via `flutter_image_compress`, but the
/// web path uses dart:ui's PNG encoder. Stamping `data:image/jpeg`
/// onto PNG bytes makes strict data-URL parsers and downstream
/// analytics misclassify the payload.
String detectImageMime(Uint8List bytes) {
  if (bytes.length >= 3 &&
      bytes[0] == _kJpegMagic[0] &&
      bytes[1] == _kJpegMagic[1] &&
      bytes[2] == _kJpegMagic[2]) {
    return 'image/jpeg';
  }
  if (bytes.length >= 4 &&
      bytes[0] == _kPngMagic[0] &&
      bytes[1] == _kPngMagic[1] &&
      bytes[2] == _kPngMagic[2] &&
      bytes[3] == _kPngMagic[3]) {
    return 'image/png';
  }
  return 'image/jpeg';
}
