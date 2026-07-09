import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:native_liquid_glass/native_liquid_glass.dart';

import 'responsive_scaffold.dart';
import 'theme.dart';

/// True on native iPhone/iPad builds where we prefer native UIKit chrome.
/// Safari on iOS also reports [TargetPlatform.iOS] but must NOT take this
/// path — [LiquidGlassTabBar] has no web implementation and paints
/// [SizedBox.shrink], which looks like a missing bottom tab bar.
bool get preferIosLiquidGlass =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

/// True on Android where we apply explicit Material 3 navigation /
/// control styling (parallel to [preferIosLiquidGlass] on iOS).
bool get preferAndroidMaterial =>
    defaultTargetPlatform == TargetPlatform.android;

/// Bottom tab bar for the phone shell: Explore · Chat · + · Saved · Me.
class PhoneShellTabBar extends StatelessWidget {
  const PhoneShellTabBar({
    super.key,
    required this.destinations,
    required this.selectedBarIndex,
    required this.onBarIndexSelected,
    required this.onPlusPressed,
  });

  /// Four tab destinations (Explore, Chat, Saved, Me) — not including [+].
  final List<ShellDestination> destinations;
  final int selectedBarIndex;
  final ValueChanged<int> onBarIndexSelected;
  final VoidCallback onPlusPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 3,
      shadowColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.12),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              Expanded(child: _TabSlot(
                destination: destinations[0],
                selected: selectedBarIndex == 0,
                onTap: () => onBarIndexSelected(0),
              )),
              Expanded(child: _TabSlot(
                destination: destinations[1],
                selected: selectedBarIndex == 1,
                onTap: () => onBarIndexSelected(1),
              )),
              _PlusSlot(onPressed: onPlusPressed),
              Expanded(child: _TabSlot(
                destination: destinations[2],
                selected: selectedBarIndex == 3,
                onTap: () => onBarIndexSelected(3),
              )),
              Expanded(child: _TabSlot(
                destination: destinations[3],
                selected: selectedBarIndex == 4,
                onTap: () => onBarIndexSelected(4),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabSlot extends StatelessWidget {
  const _TabSlot({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final ShellDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final fg = selected ? cs.onSurface : cs.onSurfaceVariant;
    final labelStyle = (theme.textTheme.labelSmall ?? const TextStyle()).copyWith(
      fontSize: 11,
      height: 1.1,
      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
      color: fg,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: selected
                    ? cs.primary.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                selected ? destination.selectedIcon : destination.icon,
                size: 22,
                color: selected ? cs.primary : cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              destination.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: labelStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlusSlot extends StatelessWidget {
  const _PlusSlot({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 56,
      child: Center(
        child: Material(
          color: SpiceRoutePalette.naturalSage,
          elevation: 2,
          shadowColor: cs.shadow.withValues(alpha: 0.2),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Icon(Icons.add, color: Colors.white, size: 26),
            ),
          ),
        ),
      ),
    );
  }
}

/// Boolean on/off control.
///
///   * iOS → native [LiquidGlassToggle] (UISwitch)
///   * Android → Material 3 [Switch] with brand primary track
///   * Web / desktop → Material [Switch]
class AdaptiveLiquidGlassSwitch extends StatelessWidget {
  const AdaptiveLiquidGlassSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    if (preferIosLiquidGlass) {
      return LiquidGlassToggle(
        value: value,
        onChanged: (v) => onChanged?.call(v),
        enabled: onChanged != null,
        color: activeColor ?? SpiceRoutePalette.naturalSage,
      );
    }

    final cs = Theme.of(context).colorScheme;
    final on = activeColor ?? cs.primary;

    if (preferAndroidMaterial) {
      return Switch(
        value: value,
        onChanged: onChanged,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        activeThumbColor: cs.onPrimary,
        activeTrackColor: on,
        inactiveThumbColor: cs.outline,
        inactiveTrackColor: cs.surfaceContainerHighest,
      );
    }

    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: on,
    );
  }
}

/// Segmented on/off (or multi-choice) control.
///
///   * iOS → native [LiquidGlassSegmentedControl]
///   * Android → Material 3 [SegmentedButton] with filled selection
///   * Web / desktop → [SegmentedButton]
class AdaptiveLiquidGlassSegments<T> extends StatelessWidget {
  const AdaptiveLiquidGlassSegments({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
    required this.labelFor,
  });

  final List<T> segments;
  final T selected;
  final ValueChanged<T> onSelectionChanged;
  final String Function(T value) labelFor;

  @override
  Widget build(BuildContext context) {
    if (preferIosLiquidGlass) {
      final index = segments.indexOf(selected).clamp(0, segments.length - 1);
      return LiquidGlassSegmentedControl(
        labels: [for (final s in segments) labelFor(s)],
        selectedIndex: index,
        onValueChanged: (i) => onSelectionChanged(segments[i]),
      );
    }

    final cs = Theme.of(context).colorScheme;
    final segmentStyle = preferAndroidMaterial
        ? SegmentedButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            selectedBackgroundColor: cs.primary,
            selectedForegroundColor: cs.onPrimary,
            foregroundColor: cs.onSurface,
            side: BorderSide(color: cs.outlineVariant),
          )
        : const ButtonStyle(
            visualDensity: VisualDensity.compact,
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            ),
          );

    return SegmentedButton<T>(
      style: segmentStyle,
      showSelectedIcon: false,
      segments: [
        for (final s in segments)
          ButtonSegment<T>(value: s, label: Text(labelFor(s))),
      ],
      selected: {selected},
      onSelectionChanged: (s) => onSelectionChanged(s.first),
    );
  }
}
