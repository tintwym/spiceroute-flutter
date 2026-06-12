import 'package:flutter/material.dart';

/// Color tokens for SpiceRoute — calm, editorial, warm.
///
/// The seven "Natural" tokens are the canonical design-system palette.
/// Each role and its hex value MUST stay in lockstep with the
/// design-system doc; if you need a new color, add it to the doc
/// first, then mirror it here.
///
/// | Token              | HEX       | Role                                                                  |
/// |--------------------|-----------|-----------------------------------------------------------------------|
/// | naturalBackground  | #FAF9F6   | Page surface (the warm cream the whole app sits on)                   |
/// | naturalSage        | #5A5A40   | Primary buttons, active nav, focal headers, focus rings               |
/// | naturalOchre       | #D4A373   | Specialty badges, hover states, active course/category indicators     |
/// | naturalCharcoal    | #423F3B   | High-contrast text — titles, body, bold headers                       |
/// | naturalMuted       | #8C887D   | Secondary text, subheadings, decorative icons, input placeholders     |
/// | naturalBorder      | #E5E1D8   | Dividers, input + dropdown boundaries, table frames                   |
/// | naturalSurface     | #F5F2ED   | Inner surfaces — dropdown items, table headers, card details          |
///
/// (Class was previously `SavorPalette` — kept as `SpiceRoutePalette`
/// to align with the product name. Storage keys in `state/*.dart` are
/// intentionally still `savor_*` to avoid wiping existing users' data
/// on the rename deploy.)
class SpiceRoutePalette {
  SpiceRoutePalette._();

  static const naturalBackground = Color(0xFFFAF9F6);
  static const naturalSurface = Color(0xFFF5F2ED);
  static const naturalSage = Color(0xFF5A5A40);
  static const naturalOchre = Color(0xFFD4A373);
  static const naturalCharcoal = Color(0xFF423F3B);
  static const naturalMuted = Color(0xFF8C887D);
  static const naturalBorder = Color(0xFFE5E1D8);
}

/// Font names to fall back to for emoji + flag glyphs.
///
/// On Flutter web (CanvasKit) the engine does NOT automatically pick
/// the browser's emoji font — if no entry in the active TextStyle's
/// fontFamily / fontFamilyFallback covers the glyph, the character
/// just doesn't render (a missing-glyph box, or nothing at all).
/// Playfair Display, Roboto, and the Noto Sans family all stop at
/// Latin/CJK/Burmese, so 🍣 / 🇰🇷 / 🌮 / 🎉 turn invisible.
///
/// Names ordered by OS coverage:
///   * `Apple Color Emoji` — macOS, iOS, iPadOS (includes flag glyphs)
///   * `Noto Color Emoji`  — Android, ChromeOS, most Linux distros
///                           (includes flag glyphs)
///   * `Segoe UI Emoji`    — Windows 10/11 (does NOT include flag
///                           glyphs by design; falls back to letter
///                           pairs like "KR" / "JP", which is the
///                           best Windows can do natively)
///   * `Twemoji Mozilla`   — Firefox-specific bundled emoji font
///   * `EmojiOne Color` / `Symbola` — older Linux fallbacks
///
/// `emoji` is the W3C generic family name; some browsers honour it
/// and pick whichever emoji font the system advertises.
const List<String> kEmojiFontFallback = <String>[
  'Apple Color Emoji',
  'Noto Color Emoji',
  'Segoe UI Emoji',
  'Twemoji Mozilla',
  'EmojiOne Color',
  'Symbola',
  'emoji',
];

/// Convenience helper for inline emoji `Text(...)` widgets.
///
/// Creates a [TextStyle] sized and line-heighted for an emoji glyph
/// that explicitly includes [kEmojiFontFallback]. Use this anywhere
/// you'd otherwise write `TextStyle(fontSize: X, height: Y)` for a
/// pure-emoji string — without the fallback list, the glyph renders
/// as a missing-glyph box on Flutter web.
TextStyle emojiTextStyle({double fontSize = 16, double height = 1.0}) {
  return TextStyle(
    fontSize: fontSize,
    height: height,
    fontFamilyFallback: kEmojiFontFallback,
  );
}

ThemeData buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final base = ColorScheme.fromSeed(
    seedColor: SpiceRoutePalette.naturalSage,
    brightness: brightness,
  );

  // Light mode wires every Natural token explicitly so the ColorScheme
  // mirrors the design-system doc 1:1 (rather than letting Material's
  // `fromSeed` derive surface variants from the olive seed and ending
  // up with subtly off-palette browns for placeholders / dividers).
  //
  // Dark mode keeps the desaturated, higher-contrast values it already
  // had — the "Natural" tokens are tuned for the cream-on-charcoal
  // light reading experience and look murky inverted. Re-derive a dark
  // palette later if/when we ship a true dark theme.
  final colorScheme = isDark
      ? base.copyWith(
          primary: const Color(0xFF8FA46A),
          onPrimary: const Color(0xFF1B2010),
          surface: const Color(0xFF1B1F15),
          onSurface: const Color(0xFFEDE6D5),
          surfaceContainerHighest: const Color(0xFF272C1F),
        )
      : base.copyWith(
          primary: SpiceRoutePalette.naturalSage,
          onPrimary: SpiceRoutePalette.naturalBackground,
          secondary: SpiceRoutePalette.naturalOchre,
          onSecondary: SpiceRoutePalette.naturalCharcoal,
          surface: SpiceRoutePalette.naturalBackground,
          onSurface: SpiceRoutePalette.naturalCharcoal,
          // Inner surfaces (dropdown items, table headers, card
          // details) use the slightly raised cream so they stand
          // out a hair from the page background.
          surfaceContainerHighest: SpiceRoutePalette.naturalSurface,
          // Borders + dividers. `outlineVariant` is what
          // Material's Divider / OutlineInputBorder pick up by
          // default, so wiring it here means we don't have to
          // pass `color: ...` at every Divider callsite.
          outlineVariant: SpiceRoutePalette.naturalBorder,
          // Stronger outline used by [OutlinedButton] etc. — slightly
          // darker than `naturalBorder` so a clickable outline still
          // reads as a clickable target.
          outline: SpiceRoutePalette.naturalMuted,
          // CRITICAL: this is what M3 widgets pull for "secondary
          // text" — subheadings, helper text, input hint text, the
          // muted timestamp under a card title, etc. Without this
          // explicit wire, `fromSeed` derived a brownish ~#79… from
          // the olive seed and our placeholders looked sepia.
          onSurfaceVariant: SpiceRoutePalette.naturalMuted,
        );

  final textTheme = _buildTextTheme(
    onSurface: colorScheme.onSurface,
    muted: colorScheme.onSurfaceVariant,
  );

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

TextTheme _buildTextTheme({required Color onSurface, required Color muted}) {
  // Editorial pairing matching the reference design:
  //   - Display + headline + titleLarge -> Playfair Display (high-contrast
  //     serif) for the magazine-y "SpiceRoute" headline, section titles,
  //     and recipe card names.
  //   - titleMedium + body + label      -> Inter (geometric sans) for
  //     legibility at small sizes, tight letterforms in form fields,
  //     and full glyph coverage of the typographic punctuation we
  //     use (em-dash, ellipsis, curly quotes). Pairs with Playfair
  //     in the classic "decorative serif on quiet sans" editorial
  //     stack — see The Atlantic, The New York Times Cooking, etc.
  //
  // BOTH faces are bundled as local assets (see pubspec.yaml `fonts:`)
  // so they work offline and never fire the runtime "Failed to load
  // font" exception the google_fonts package logs when
  // fonts.gstatic.com is unreachable.
  const serif = 'PlayfairDisplay';
  const sans = 'Inter';

  // fontFamilyFallback — fixes the "Could not find a set of Noto fonts
  // to display all missing characters" console warning on Flutter web.
  //
  // Playfair Display only covers Latin glyphs, and Flutter web's default
  // sans (Roboto) doesn't cover CJK or Burmese. Without an explicit
  // fallback chain, Flutter's auto-fallback hits fonts.gstatic.com per
  // missing glyph subset; if that fails or doesn't cover every char it
  // spams the console.
  //
  // Declaring the chain here makes Flutter pick a font from the user's
  // OS directly — every modern OS ships at least one of these:
  //   * macOS / iOS: PingFang SC (zh), Hiragino Sans (ja), Apple SD
  //                  Gothic Neo (ko), Myanmar Sangam MN (my)
  //   * Windows:     Microsoft YaHei (zh), Yu Gothic (ja), Malgun Gothic
  //                  (ko), Myanmar Text (my)
  //   * Android:     Noto Sans CJK, Noto Sans Myanmar
  //   * ChromeOS:    Noto fonts
  //
  // We list the Noto family names first (they're the most consistent
  // cross-platform) and the OS-specific names after as backup, then
  // generic `sans-serif` as final fallback so the browser picks a
  // reasonable system font on the web.
  // Append the emoji fallback list AT THE END so non-emoji glyphs
  // still pick a Noto/system font first (faster + sharper); only
  // characters none of those fonts cover (i.e. emoji + flags) reach
  // the color emoji fonts.
  final fallback = <String>[
    'Noto Sans',
    'Noto Sans CJK SC',
    'Noto Sans CJK JP',
    'Noto Sans CJK KR',
    'Noto Sans Myanmar',
    'PingFang SC',
    'Hiragino Sans',
    'Apple SD Gothic Neo',
    'Myanmar MN',
    'Microsoft YaHei',
    'Yu Gothic',
    'Malgun Gothic',
    'Myanmar Text',
    'sans-serif',
    ...kEmojiFontFallback,
  ];

  return TextTheme(
    displayLarge: TextStyle(
      fontFamily: serif,
      fontFamilyFallback: fallback,
      fontSize: 48,
      height: 1.05,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: onSurface,
    ),
    displayMedium: TextStyle(
      fontFamily: serif,
      fontFamilyFallback: fallback,
      fontSize: 36,
      height: 1.1,
      fontWeight: FontWeight.w700,
      color: onSurface,
    ),
    headlineLarge: TextStyle(
      fontFamily: serif,
      fontFamilyFallback: fallback,
      fontSize: 28,
      height: 1.15,
      fontWeight: FontWeight.w700,
      color: onSurface,
    ),
    headlineMedium: TextStyle(
      fontFamily: serif,
      fontFamilyFallback: fallback,
      fontSize: 22,
      height: 1.2,
      fontWeight: FontWeight.w700,
      color: onSurface,
    ),
    titleLarge: TextStyle(
      fontFamily: serif,
      fontFamilyFallback: fallback,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: onSurface,
    ),
    titleMedium: TextStyle(
      fontFamily: sans,
      fontFamilyFallback: fallback,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: onSurface,
    ),
    bodyLarge: TextStyle(
      fontFamily: sans,
      fontFamilyFallback: fallback,
      fontSize: 16,
      height: 1.5,
      color: onSurface,
    ),
    bodyMedium: TextStyle(
      fontFamily: sans,
      fontFamilyFallback: fallback,
      fontSize: 14,
      height: 1.45,
      color: onSurface,
    ),
    bodySmall: TextStyle(
      fontFamily: sans,
      fontFamilyFallback: fallback,
      fontSize: 12.5,
      height: 1.4,
      // Use the explicit "Natural Muted" token rather than alpha-
      // blending onSurface. The blend approximated the muted color
      // but landed at ~#797773 over the cream background, which is
      // a couple of points darker than the canonical #8C887D. The
      // explicit color also reads correctly when this text is
      // placed over `naturalSurface` (raised cream) where the
      // alpha blend would have produced a slightly different shade.
      color: muted,
    ),
    labelLarge: TextStyle(
      fontFamily: sans,
      fontFamilyFallback: fallback,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: onSurface,
    ),
    labelMedium: TextStyle(
      fontFamily: sans,
      fontFamilyFallback: fallback,
      fontSize: 12.5,
      fontWeight: FontWeight.w500,
      color: onSurface,
    ),
    // `labelSmall` is widely used for tracked uppercase eyebrows
    // ("CULINARY STUDIO", "EXPLORE BY GEOGRAPHIC REGION",
    // "REAL-TIME SYNC", etc.). Without this entry, the slot
    // inherits the framework's Material 3 default — which is
    // Roboto / system sans — so the eyebrows render in a DIFFERENT
    // family than every other label around them once the rest of
    // the theme is swapped to Inter. Pin the family + fallback;
    // numerical values are copied verbatim from the M3 spec
    // (fontSize 11, weight 500, letterSpacing 0.5, height 1.45)
    // so adding this entry can't drift the rendered metrics of
    // any existing call site. Color picks `muted` so eyebrow text
    // reads as secondary by default; call sites that need the
    // primary tone keep `copyWith(color: ...)` in place.
    labelSmall: TextStyle(
      fontFamily: sans,
      fontFamilyFallback: fallback,
      fontSize: 11,
      height: 1.45,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: muted,
    ),
  );
}
