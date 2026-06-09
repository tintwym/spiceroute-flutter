import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/locale.dart';

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

    return Material(
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
              Text(option.flag, style: const TextStyle(fontSize: 13, height: 1)),
              if (showLabel) ...[
                const SizedBox(width: 5),
                Text(
                  option.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 12,
                    color: selected ? cs.onSurface : cs.onSurfaceVariant,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
