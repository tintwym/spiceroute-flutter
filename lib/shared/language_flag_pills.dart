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

const _options = <_LangOption>[
  _LangOption(Locale('en'), '🇬🇧', 'English'),
  _LangOption(Locale('zh'), '🇨🇳', '中文'),
  _LangOption(Locale('my'), '🇲🇲', 'မြန်မာ'),
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
/// The active locale wears a filled surface pill with a soft border; the
/// rest are flat. On tight widths only the flag shows (no label) so the
/// row stays compact.
class LanguageFlagPills extends ConsumerWidget {
  const LanguageFlagPills({super.key, this.showLabels = true});

  /// When false, renders flag-only pills (used on medium widths where the
  /// endonyms would overflow the bar).
  final bool showLabels;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeProvider);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final o in _options)
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: _Pill(
              option: o,
              selected: current.languageCode == o.locale.languageCode,
              showLabel: showLabels,
              onTap: () => ref.read(localeProvider.notifier).set(o.locale),
            ),
          ),
      ],
    );
  }
}

/// Compact globe-icon trigger that opens a popup menu listing all six
/// locales with their flag + endonym. Designed for the **phone** app
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
      onSelected: (locale) =>
          ref.read(localeProvider.notifier).set(locale),
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
                    fontWeight:
                        current.languageCode == o.locale.languageCode
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
              Text(
                currentOption.flag,
                style: emojiTextStyle(fontSize: 14),
              ),
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

    // Active pill: vibrant blue OUTLINE (no fill) — matches the reference
    // design and visually rhymes with the dropdown menu's active row.
    // Inactive pills are completely flat — no border, no fill — so the
    // selected language reads as the obvious anchor of the row.
    const Color activeBorder = Color(0xFF3D8BFD);

    // The flag-only variant lives in the top nav for compactness — the
    // endonym is the only thing that tells you "this is Burmese vs
    // Japanese" once labels are gone, so wrap the pill in a Tooltip so
    // hovering on web / long-pressing on mobile reveals the language
    // name. The labelled variant still shows the endonym inline, but
    // the tooltip stays for keyboard / screen-reader users.
    return Tooltip(
      message: option.label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(
              horizontal: showLabel ? 9 : 7,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? activeBorder : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  option.flag,
                  // Emoji-safe TextStyle so CanvasKit can locate a
                  // flag glyph. Plain `TextStyle(fontSize: 13)` on
                  // web rendered as a blank box on macOS and tofu
                  // squares elsewhere.
                  style: emojiTextStyle(fontSize: 13),
                ),
                if (showLabel) ...[
                  const SizedBox(width: 5),
                  Text(
                    option.label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 12,
                      color: selected ? cs.onSurface : cs.onSurfaceVariant,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
