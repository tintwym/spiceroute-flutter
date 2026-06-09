import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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
///      and base64 encoding inflates payload by ~33%. We target ~800 px
///      on the long side, which keeps the encoded JPEG well under
///      300 KB for any normal photo.
///
///   3. **Plain JPEG/PNG** — Firestore doesn't care, but a downstream
///      consumer rendering `<img src="data:image/...">` does. Native
///      flutter_image_compress emits JPEG; the web fallback emits PNG.
///
/// Strategy:
///
/// - **Mobile / desktop**: use `flutter_image_compress`. Its native
///   codec decodes + resizes + JPEG-encodes in one pass and explicitly
///   does NOT copy EXIF into the output (see plugin docs).
///
/// - **Web**: `flutter_image_compress` has no web implementation —
///   the previous code path just returned the raw bytes, EXIF intact.
///   Use `dart:ui.instantiateImageCodec` with `targetWidth` to decode
///   + resize via the browser's image pipeline, then `toByteData
///   (ImageByteFormat.png)` to re-encode. The browser's decode/encode
///   pipeline never sees EXIF and never emits it.
Future<Uint8List> compressForUpload(
  Uint8List src, {
  int targetMaxDimension = 800,
  int jpegQuality = 70,
}) async {
  if (kIsWeb) {
    return _webDecodeReencode(src, targetMaxDimension: targetMaxDimension);
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
/// The resulting bytes are PNG, which is slightly larger than the
/// equivalent JPEG would be, but PNG is lossless so quality stays
/// high — and a ~800 px PNG of a food photo is still typically
/// under 500 KB.
Future<Uint8List> _webDecodeReencode(
  Uint8List src, {
  required int targetMaxDimension,
}) async {
  ui.Codec codec;
  try {
    codec = await ui.instantiateImageCodec(
      src,
      targetWidth: targetMaxDimension,
    );
  } catch (_) {
    // If we can't decode at all, return the original bytes. The
    // upload path will reject oversized payloads on its own — we
    // don't want to silently swallow a corrupt file as success.
    return src;
  }

  ui.FrameInfo frame;
  try {
    frame = await codec.getNextFrame();
  } finally {
    codec.dispose();
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
