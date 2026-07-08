import 'package:flutter/material.dart';

/// Marketing landing page palette — mirrors the React `index.css` tokens.
class LandingPalette {
  LandingPalette._();

  static const red = Color(0xFFC05621);
  static const accent = Color(0xFFE28743);
  static const charcoal = Color(0xFF1E293B);
  static const cream = Color(0xFFF9F6F0);
  static const toolkitBg = Color(0xFFFAF7F2);
  static const heroDark = Color(0xFF18181B);
  static const quickSectorsBg = Color(0xFF101012);
  static const boardingPaper = Color(0xFFF4EFE6);
  static const alabaster = Color(0xFFEFEBE4);
  static const saffron = Color(0xFFD4AF37);
  static const cardamom = Color(0xFF5A5A40);
  static const blue = Color(0xFF2563EB);
  static const blueLight = Color(0xFFEFF6FF);
  static const emerald = Color(0xFF10B981);
  static const slateDark = Color(0xFF0F172A);

  static const maxContentWidth = 1280.0;

  static EdgeInsets sectionPaddingOf(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1024) return const EdgeInsets.symmetric(horizontal: 32);
    if (w >= 640) return const EdgeInsets.symmetric(horizontal: 24);
    return const EdgeInsets.symmetric(horizontal: 16);
  }

  static TextStyle serif(
    BuildContext context, {
    double size = 16,
    FontWeight weight = FontWeight.w700,
    Color? color,
  }) {
    return Theme.of(context).textTheme.displaySmall!.copyWith(
      fontFamily: 'PlayfairDisplay',
      fontSize: size,
      fontWeight: weight,
      color: color ?? charcoal,
      height: 1.1,
    );
  }

  static TextStyle sans(
    BuildContext context, {
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color? color,
  }) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontFamily: 'Inter',
      fontSize: size,
      fontWeight: weight,
      color: color ?? charcoal,
    );
  }

  static TextStyle mono(
    BuildContext context, {
    double size = 10,
    FontWeight weight = FontWeight.w600,
    Color? color,
    double letterSpacing = 1.2,
  }) {
    return TextStyle(
      fontFamily: 'JetBrainsMono',
      fontSize: size,
      fontWeight: weight,
      color: color ?? charcoal.withValues(alpha: 0.6),
      letterSpacing: letterSpacing,
    );
  }
}
