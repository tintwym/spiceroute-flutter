import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/locale.dart';
import 'theme.dart';

/// Per-locale display metadata for the flag-pill switcher.
class _LangOption {
  const _LangOption(this.locale, this.flag, this.label);
  final Locale locale;

  /// Flag emoji (regional-indicator pair). Renders natively everywhere
  /// except Windows/Chrome-on-Windows, which falls back to the letter
  /// pair — acceptable, and the [label] still disambiguates.
  final String flag;

  /// Endonym — the language's own name, matching the reference design
  /// ("中文", "日本語", "한국어") rather than the English exonym.
  final String label;
}

// Keep this list in sync with `supportedLocales` in `state/locale.dart`.
// `LocaleNotifier.set()` silently rejects any locale that isn't in the
// supported list, so an extra entry here would render a tappable pill
// that does literally nothing — exactly the bug we shipped when Burmese
// was removed as a UI locale but lingered in this catalog.
const _options = <_LangOption>[
  _LangOption(Locale('en'), '🇺🇸', 'English'),
  _LangOption(Locale('zh'), '🇨🇳', '中文'),
  _LangOption(Locale('ja'), '🇯🇵', '日本語'),
  _LangOption(Locale('ko'), '🇰🇷', '한국어'),
  _LangOption(Locale('vi'), '🇻🇳', 'Tiếng Việt'),
];

/// Horizontal row of flag pills for quick language switching — the
/// header treatment from the reference design. This lives *alongside*
/// the language entry inside the account dropdown (hybrid approach):
/// power users get one-tap switching here, while the dropdown keeps the
/// full list tidy on narrow viewports where this row is hidden.
///
/// Visual treatment is a segmented-control "track": the whole row sits
/// inside a warm cream-toned container with rounded corners. The active
/// locale wears a near-white filled pill with a soft drop shadow that
/// lifts it off the track; inactive pills are flat (no border, no fill).
/// On tight widths only the flag shows (no label) so the row stays
/// compact.
class LanguageFlagPills extends ConsumerWidget {
  const LanguageFlagPills({super.key, this.showLabels = true});

  /// When false, renders flag-only pills (used on medium widths where the
  /// endonyms would overflow the bar).
  final bool showLabels;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // Track tone: a tinted surface that contrasts with the page
    // background AND with the active pill, in both light and dark.
    // Picked per-mode rather than via a single ColorScheme token
    // because the light theme's "raised cream" sits a hair DARKER
    // than the page while the dark theme's elevated surface needs
    // to sit a hair LIGHTER — opposite directions, same semantic
    // role. A single cs.* token can't honour both.
    final trackColor = isDark
        ? theme.colorScheme.surfaceContainerHigh
        : Color.alphaBlend(
            SpiceRoutePalette.naturalBorder.withValues(alpha: 0.45),
            SpiceRoutePalette.naturalSurface,
          );
    final trackBorder = isDark
        ? theme.colorScheme.outlineVariant
        : SpiceRoutePalette.naturalBorder;
    return Container(
      // Outer padding gives the active pill room to breathe inside
      // the track — without this the white pill's shadow would clip
      // against the track border on the left/right ends of the row.
      padding: EdgeInsets.symmetric(
        horizontal: showLabels ? 6 : 4,
        vertical: showLabels ? 5 : 3,
      ),
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(32),
        // Hairline outline — same boundary token used on every other
        // input/card edge in the app. Just enough contrast to define
        // the track edge against the page background; without it
        // the track edge melts away on some monitors and the
        // active pill's lift loses its reference point.
        border: Border.all(color: trackBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final o in _options)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: showLabels ? 2 : 1),
              child: _Pill(
                option: o,
                selected: current.languageCode == o.locale.languageCode,
                showLabel: showLabels,
                onTap: () => ref.read(localeProvider.notifier).set(o.locale),
              ),
            ),
        ],
      ),
    );
  }
}

/// Compact globe-icon trigger that opens a popup menu listing every
/// supported locale with its flag + endonym. Designed for the **phone** app
/// bar, where horizontal real-estate is too tight for the full
/// [LanguageFlagPills] row.
///
/// Why this exists: on phone the top nav is a plain Material [AppBar]
/// with just the search field + account/sign-in action. The flag-pill
/// row is hidden below 540 px (see `top_nav_bar.dart`), and the
/// language submenu lives behind the avatar — which is only present
/// when signed-in. Without this button, a signed-out mobile user has
/// **no way at all** to change languages; they're stuck with whatever
/// the platform locale resolved to. This button fixes that by always
/// surfacing the picker, regardless of auth state.
///
/// The current locale's flag is shown next to the globe so it doubles
/// as a status indicator (you can tell which language is active at a
/// glance, without opening the menu).
class LanguageMenuButton extends ConsumerWidget {
  const LanguageMenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final currentOption = _options.firstWhere(
      (o) => o.locale.languageCode == current.languageCode,
      orElse: () => _options.first,
    );

    return PopupMenuButton<Locale>(
      tooltip: currentOption.label,
      position: PopupMenuPosition.under,
      // Match the AccountMenu's surface so the two action buttons feel
      // like part of the same family.
      color: cs.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: cs.outlineVariant),
      ),
      offset: const Offset(0, 8),
      onSelected: (locale) => ref.read(localeProvider.notifier).set(locale),
      itemBuilder: (ctx) => [
        for (final o in _options)
          PopupMenuItem<Locale>(
            value: o.locale,
            child: Row(
              children: [
                // Leading check (or transparent placeholder so the
                // labels line up).
                Icon(
                  current.languageCode == o.locale.languageCode
                      ? Icons.check
                      : Icons.translate_outlined,
                  size: 18,
                  color: current.languageCode == o.locale.languageCode
                      ? cs.primary
                      : Colors.transparent,
                ),
                const SizedBox(width: 10),
                Text(o.flag, style: emojiTextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Text(
                  o.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: current.languageCode == o.locale.languageCode
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
      ],
      // Trigger: a small soft-bordered pill containing a globe icon +
      // the current locale's flag. Same visual weight as the avatar
      // ring next to it so the two actions read as a balanced pair.
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: cs.outlineVariant),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.language, size: 16, color: cs.onSurface),
              const SizedBox(width: 6),
              Text(currentOption.flag, style: emojiTextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.option,
    required this.selected,
    required this.showLabel,
    required this.onTap,
  });

  final _LangOption option;
  final bool selected;
  final bool showLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Active pill: a "lifted" surface that pops OFF the track in both
    // brightnesses. In light mode it's near-white cream (sits one
    // step BRIGHTER than the slightly darker cream track). In dark
    // mode it's the brightest olive in the surface ladder (sits
    // brighter than the elevated dark track). Either way the
    // semantic is the same: lifted chip, single visual anchor.
    final pillFill = selected
        ? (isDark ? cs.surfaceBright : SpiceRoutePalette.naturalBackground)
        : Colors.transparent;

    // Drop-shadow color flips with brightness too: a warm dark-brown
    // shadow reads on the cream track but vanishes on dark olive;
    // a near-black shadow gives the active pill a real lift in
    // dark mode without bleeding warm undertones into the cool
    // dark surface.
    final shadowBase = isDark ? Colors.black : const Color(0xFF4A3F2F);

    final borderRadius = BorderRadius.circular(22);

    // The flag-only variant lives in the top nav for compactness — the
    // endonym is the only thing that tells you "this is Chinese vs
    // Japanese" once labels are gone, so wrap the pill in a Tooltip so
    // hovering on web / long-pressing on mobile reveals the language
    // name. The labelled variant still shows the endonym inline, but
    // the tooltip stays for keyboard / screen-reader users.
    final pill = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      padding: EdgeInsets.symmetric(
        horizontal: showLabel ? 14 : 9,
        vertical: showLabel ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: pillFill,
        borderRadius: borderRadius,
        // Shadow only on the active pill — keeps the row visually
        // calm and the active state unambiguous. Two-stop shadow
        // for a soft, diffuse lift (matches Material 3 elevation 1
        // shadow envelope tuned for our warm palette). Alpha is
        // bumped up in dark mode so the lift is still legible
        // against the low-contrast dark olive surfaces.
        boxShadow: selected
            ? [
                BoxShadow(
                  color: shadowBase.withValues(alpha: isDark ? 0.55 : 0.10),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: shadowBase.withValues(alpha: isDark ? 0.35 : 0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            option.flag,
            // Emoji-safe TextStyle so CanvasKit can locate a flag
            // glyph. Plain `TextStyle(fontSize: 16)` on web
            // rendered as a blank box on macOS and tofu squares
            // elsewhere.
            style: emojiTextStyle(fontSize: showLabel ? 16 : 14),
          ),
          if (showLabel) ...[
            const SizedBox(width: 8),
            Text(
              option.label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: 14,
                // `cs.onSurface` is dark charcoal in light, cream in
                // dark — gives high-contrast labels in both modes
                // without hardcoding a single literal.
                color: cs.onSurface,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ],
      ),
    );

    return Tooltip(
      message: option.label,
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(onTap: onTap, borderRadius: borderRadius, child: pill),
      ),
    );
  }
}
