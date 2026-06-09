import 'package:flutter/material.dart';

/// Color tokens for SpiceRoute — calm, editorial, warm.
///
/// Aligned with the AI-Studio reference prototype:
///   primary olive   #5A5A40
///   accent terracotta #D4A373
///   text     charcoal  #423F3B
///   surface  cream     #FAF9F6 (pages) / #F5F2ED (raised)
///   borders  lineSoft  #E5E1D8
///   muted    stone     #8C887D
class SavorPalette {
  SavorPalette._();

  static const cream = Color(0xFFFAF9F6);
  static const cream2 = Color(0xFFF5F2ED);
  static const olive = Color(0xFF5A5A40);
  static const oliveDeep = Color(0xFF3F3F2C);
  static const terracotta = Color(0xFFD4A373);
  static const charcoal = Color(0xFF423F3B);
  static const stone = Color(0xFF8C887D);
  static const lineSoft = Color(0xFFE5E1D8);
}

ThemeData buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final base = ColorScheme.fromSeed(
    seedColor: SavorPalette.olive,
    brightness: brightness,
  );

  final colorScheme = isDark
      ? base.copyWith(
          primary: const Color(0xFF8FA46A),
          onPrimary: const Color(0xFF1B2010),
          surface: const Color(0xFF1B1F15),
          onSurface: const Color(0xFFEDE6D5),
          surfaceContainerHighest: const Color(0xFF272C1F),
        )
      : base.copyWith(
          primary: SavorPalette.olive,
          onPrimary: SavorPalette.cream,
          secondary: SavorPalette.terracotta,
          surface: SavorPalette.cream,
          onSurface: SavorPalette.charcoal,
          surfaceContainerHighest: SavorPalette.cream2,
          outlineVariant: SavorPalette.lineSoft,
        );

  final textTheme = _buildTextTheme(colorScheme.onSurface);

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: colorScheme.surface,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: textTheme,
    // Material 3's default `InkSparkle` uses a fragment shader that is
    // notoriously slow on Flutter web — every tap drops a frame while the
    // shader compiles. `InkRipple` runs entirely on the existing layer
    // pipeline, so taps feel instant. Lossless visual change for our use
    // case (we're not relying on the sparkle particle effect).
    splashFactory: InkRipple.splashFactory,
    // Same idea for hover/focus highlights on web.
    hoverColor: colorScheme.primary.withValues(alpha: 0.06),
    splashColor: colorScheme.primary.withValues(alpha: 0.12),
    highlightColor: Colors.transparent,
    // The default `ZoomPageTransitionsBuilder` (used on non-Android)
    // animates a scale + fade per route push and feels stuttery on web,
    // particularly for hover-triggered nav. `FadeUpwardsPageTransitionsBuilder`
    // is much cheaper and matches the editorial vibe.
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: textTheme.titleLarge,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: colorScheme.outline),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        foregroundColor: colorScheme.onSurface,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: colorScheme.surfaceContainerHighest,
      selectedColor: colorScheme.primary,
      checkmarkColor: colorScheme.onPrimary,
      labelStyle: textTheme.labelMedium ?? const TextStyle(),
      secondaryLabelStyle: (textTheme.labelMedium ?? const TextStyle())
          .copyWith(color: colorScheme.onPrimary, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      shape: const StadiumBorder(),
      side: BorderSide(color: colorScheme.outlineVariant),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.primary.withValues(alpha: 0.18),
      labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
      iconTheme: WidgetStatePropertyAll(
        IconThemeData(color: colorScheme.onSurface),
      ),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: colorScheme.surface,
      selectedIconTheme: IconThemeData(color: colorScheme.primary),
      unselectedIconTheme: IconThemeData(color: colorScheme.onSurface),
      indicatorColor: colorScheme.primary.withValues(alpha: 0.18),
      labelType: NavigationRailLabelType.all,
    ),
    dividerColor: colorScheme.outlineVariant,
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: colorScheme.onSurface,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.surface,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}

TextTheme _buildTextTheme(Color onSurface) {
  // Editorial pairing matching the reference design:
  //   - Display + headline + title  -> Playfair Display (high-contrast serif)
  //     for the magazine-y "SpiceRoute" headline, section titles,
  //     and recipe card names.
  //   - Body + label                -> default sans (Roboto, framework-bundled)
  //     for legibility at small sizes and full glyph coverage of the
  //     typographic punctuation we use (em-dash, ellipsis, curly quotes).
  //
  // The serif is bundled as a local asset (see pubspec.yaml `fonts:`)
  // so it works offline and never fires the runtime "Failed to load
  // font" exception the google_fonts package logs when fonts.gstatic.com
  // is unreachable.
  const serif = 'PlayfairDisplay';

  return TextTheme(
    displayLarge: TextStyle(
      fontFamily: serif,
      fontSize: 48,
      height: 1.05,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: onSurface,
    ),
    displayMedium: TextStyle(
      fontFamily: serif,
      fontSize: 36,
      height: 1.1,
      fontWeight: FontWeight.w700,
      color: onSurface,
    ),
    headlineLarge: TextStyle(
      fontFamily: serif,
      fontSize: 28,
      height: 1.15,
      fontWeight: FontWeight.w700,
      color: onSurface,
    ),
    headlineMedium: TextStyle(
      fontFamily: serif,
      fontSize: 22,
      height: 1.2,
      fontWeight: FontWeight.w700,
      color: onSurface,
    ),
    titleLarge: TextStyle(
      fontFamily: serif,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: onSurface,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: onSurface,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      height: 1.5,
      color: onSurface,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      height: 1.45,
      color: onSurface,
    ),
    bodySmall: TextStyle(
      fontSize: 12.5,
      height: 1.4,
      color: onSurface.withValues(alpha: 0.7),
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: onSurface,
    ),
    labelMedium: TextStyle(
      fontSize: 12.5,
      fontWeight: FontWeight.w500,
      color: onSurface,
    ),
  );
}
