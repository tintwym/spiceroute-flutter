import 'package:flutter/material.dart';

import '../landing_palette.dart';

/// Region landmark stamp icons ported from React `GlobalTerminal.tsx`.
class LandingLandmarkIcon extends StatelessWidget {
  const LandingLandmarkIcon({super.key, required this.regionName, this.size = 36});

  final String regionName;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LandmarkPainter(regionName),
      ),
    );
  }
}

class LandingLandmarkInk extends StatelessWidget {
  const LandingLandmarkInk({super.key, required this.regionName});

  final String regionName;

  static const _styles = {
    'East Asia': (Color(0xFF059669), Color(0xFF065F46)),
    'Mainland SE Asia': (Color(0xFF0D9488), Color(0xFF115E59)),
    'Maritime Southeast Asia': (Color(0xFF0891B2), Color(0xFF155E75)),
    'South Asia': (Color(0xFFD97706), Color(0xFF92400E)),
    'Europe': (Color(0xFF4F46E5), Color(0xFF3730A3)),
    'Americas': (Color(0xFFE11D48), Color(0xFF9F1239)),
    'Middle East & Africa': (Color(0xFFEA580C), Color(0xFF9A3412)),
  };

  @override
  Widget build(BuildContext context) {
    final colors = _styles[regionName] ?? (LandingPalette.charcoal, LandingPalette.charcoal);
    return Transform.rotate(
      angle: -0.05,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: colors.$1.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.$1.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            LandingLandmarkIcon(regionName: regionName, size: 20),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  regionName.toUpperCase(),
                  style: LandingPalette.mono(
                    context,
                    size: 7,
                    color: colors.$2,
                  ),
                ),
                Text(
                  'STAMPED',
                  style: LandingPalette.mono(
                    context,
                    size: 7,
                    color: colors.$2.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LandmarkPainter extends CustomPainter {
  _LandmarkPainter(this.region);

  final String region;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = LandingPalette.charcoal.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    final scale = size.width / 64;
    canvas.scale(scale);

    switch (region) {
      case 'East Asia':
        _pagoda(canvas, paint);
      case 'Europe':
        _eiffel(canvas, paint);
      case 'Mainland SE Asia':
        _temple(canvas, paint);
      case 'Maritime Southeast Asia':
        _palm(canvas, paint);
      case 'South Asia':
        _taj(canvas, paint);
      case 'Americas':
        _pyramid(canvas, paint);
      case 'Middle East & Africa':
        _oasis(canvas, paint);
      default:
        canvas.drawCircle(const Offset(32, 32), 12, paint);
    }
  }

  void _pagoda(Canvas c, Paint p) {
    c.drawLine(const Offset(32, 4), const Offset(32, 12), p);
    c.drawPath(Path()..moveTo(27, 15)..lineTo(32, 12)..lineTo(37, 15), p);
    c.drawRect(const Rect.fromLTWH(27, 23, 10, 6), p);
    c.drawRect(const Rect.fromLTWH(24, 33, 16, 8), p);
    c.drawRect(const Rect.fromLTWH(20, 45, 24, 12), p);
    c.drawLine(const Offset(8, 57), const Offset(56, 57), p);
  }

  void _eiffel(Canvas c, Paint p) {
    c.drawLine(const Offset(32, 4), const Offset(32, 12), p);
    c.drawPath(Path()..moveTo(30, 12)..lineTo(34, 12)..lineTo(32, 32)..lineTo(28, 32)..close(), p);
    c.drawLine(const Offset(20, 58), const Offset(44, 58), p);
    c.drawLine(const Offset(28, 35), const Offset(36, 26), p);
    c.drawLine(const Offset(36, 35), const Offset(28, 26), p);
  }

  void _temple(Canvas c, Paint p) {
    c.drawLine(const Offset(32, 6), const Offset(32, 14), p);
    c.drawPath(Path()..moveTo(28, 14)..lineTo(32, 28)..lineTo(36, 14)..close(), p);
    c.drawPath(Path()..moveTo(24, 28)..lineTo(32, 46)..lineTo(40, 28)..close(), p);
    c.drawRect(const Rect.fromLTWH(8, 46, 48, 8), p);
  }

  void _palm(Canvas c, Paint p) {
    c.drawCircle(const Offset(24, 22), 6, p);
    c.drawPath(Path()..moveTo(6, 50)..lineTo(20, 30)..lineTo(40, 24)..lineTo(56, 50)..close(), p);
    c.drawLine(const Offset(48, 30), const Offset(52, 34), p);
    c.drawLine(const Offset(48, 30), const Offset(56, 26), p);
  }

  void _taj(Canvas c, Paint p) {
    c.drawLine(const Offset(32, 6), const Offset(32, 12), p);
    c.drawPath(Path()..moveTo(32, 12)..quadraticBezierTo(25, 20, 32, 28)..quadraticBezierTo(39, 20, 32, 12), p);
    c.drawRect(const Rect.fromLTWH(24, 28, 16, 18), p);
    c.drawLine(const Offset(4, 46), const Offset(60, 46), p);
  }

  void _pyramid(Canvas c, Paint p) {
    c.drawRect(const Rect.fromLTWH(26, 14, 12, 8), p);
    c.drawPath(Path()..moveTo(23, 22)..lineTo(41, 22)..lineTo(43, 28)..lineTo(21, 28)..close(), p);
    c.drawPath(Path()..moveTo(15, 36)..lineTo(49, 36)..lineTo(51, 46)..lineTo(13, 46)..close(), p);
    c.drawPath(Path()..moveTo(10, 46)..lineTo(54, 46)..lineTo(57, 56)..lineTo(7, 56)..close(), p);
  }

  void _oasis(Canvas c, Paint p) {
    c.drawCircle(const Offset(44, 20), 6, p);
    c.drawPath(Path()..moveTo(10, 52)..lineTo(30, 18)..lineTo(50, 52)..close(), p);
    c.drawPath(Path()..moveTo(38, 52)..lineTo(48, 30)..lineTo(58, 52)..close(), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
