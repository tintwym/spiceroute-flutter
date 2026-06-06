import 'package:flutter/material.dart';

/// Color tokens for Savor Global Recipes — calm, editorial, warm.
class SavorPalette {
  SavorPalette._();

  static const cream = Color(0xFFF5EFE2);
  static const cream2 = Color(0xFFEDE5D2);
  static const olive = Color(0xFF5B6E3F);
  static const oliveDeep = Color(0xFF3F4D2C);
  static const terracotta = Color(0xFFC9663A);
  static const charcoal = Color(0xFF2A2A24);
  static const stone = Color(0xFF7A7868);
  static const lineSoft = Color(0xFFDED5C2);
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
  // We avoid Google Fonts to keep web first paint fast and offline-friendly.
  // The system serif handles editorial display sizes acceptably.
  const display = 'Georgia';
  const body = 'Helvetica';
  return TextTheme(
    displayLarge: TextStyle(
      fontFamily: display,
      fontSize: 48,
      height: 1.05,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.5,
      color: onSurface,
    ),
    displayMedium: TextStyle(
      fontFamily: display,
      fontSize: 36,
      height: 1.1,
      fontWeight: FontWeight.w500,
      color: onSurface,
    ),
    headlineLarge: TextStyle(
      fontFamily: display,
      fontSize: 28,
      height: 1.15,
      fontWeight: FontWeight.w500,
      color: onSurface,
    ),
    headlineMedium: TextStyle(
      fontFamily: display,
      fontSize: 22,
      height: 1.2,
      fontWeight: FontWeight.w500,
      color: onSurface,
    ),
    titleLarge: TextStyle(
      fontFamily: display,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: onSurface,
    ),
    titleMedium: TextStyle(
      fontFamily: body,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: onSurface,
    ),
    bodyLarge: TextStyle(
      fontFamily: body,
      fontSize: 16,
      height: 1.5,
      color: onSurface,
    ),
    bodyMedium: TextStyle(
      fontFamily: body,
      fontSize: 14,
      height: 1.45,
      color: onSurface,
    ),
    bodySmall: TextStyle(
      fontFamily: body,
      fontSize: 12.5,
      height: 1.4,
      color: onSurface.withValues(alpha: 0.7),
    ),
    labelLarge: TextStyle(
      fontFamily: body,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: onSurface,
    ),
    labelMedium: TextStyle(
      fontFamily: body,
      fontSize: 12.5,
      fontWeight: FontWeight.w500,
      color: onSurface,
    ),
  );
}
