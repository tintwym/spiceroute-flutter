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

/// Bottom tab bar for the phone shell.
///
///   * iOS → native [LiquidGlassTabBar] (Liquid Glass on iOS 26+)
///   * Android → Material 3 [NavigationBar] with brand-tuned theme
///   * Web / desktop → shared Material [NavigationBar]
class PhoneShellTabBar extends StatelessWidget {
  const PhoneShellTabBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<ShellDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    if (preferIosLiquidGlass &&
        NativeLiquidGlassUtils.supportsLiquidGlass) {
      return _iosLiquidGlassTabBar(context);
    }
    if (!kIsWeb && preferAndroidMaterial) {
      return _androidMaterialTabBar(context);
    }
    return _materialTabBar(context);
  }

  Widget _iosLiquidGlassTabBar(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final baseLabelStyle = (theme.textTheme.labelMedium ?? const TextStyle())
        .copyWith(fontSize: 12, height: 1.15, letterSpacing: 0.1);

    return LiquidGlassTabBar(
      items: [
        for (final d in destinations) _liquidGlassTabItem(d),
      ],
      currentIndex: selectedIndex.clamp(0, destinations.length - 1),
      onTabSelected: onDestinationSelected,
      height: 56,
      selectedItemColor: SpiceRoutePalette.naturalSage,
      labelTextStyle: baseLabelStyle.copyWith(
        color: cs.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// Material 3 bottom nav tuned for Android (system gesture inset + M3
  /// indicator / label behavior).
  Widget _androidMaterialTabBar(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final baseLabelStyle = (theme.textTheme.labelMedium ?? const TextStyle())
        .copyWith(fontSize: 12, height: 1.15, letterSpacing: 0.1);

    return Material(
      color: cs.surface,
      elevation: 3,
      shadowColor: cs.shadow.withValues(alpha: 0.12),
      child: SafeArea(
        top: false,
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            height: 80,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            indicatorColor: cs.primary.withValues(alpha: 0.14),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return IconThemeData(
                color: selected ? cs.primary : cs.onSurfaceVariant,
                size: 24,
              );
            }),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return baseLabelStyle.copyWith(
                color: selected ? cs.primary : cs.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              );
            }),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return cs.primary.withValues(alpha: 0.08);
              }
              return null;
            }),
          ),
          child: NavigationBar(
            selectedIndex: selectedIndex.clamp(0, destinations.length - 1),
            onDestinationSelected: onDestinationSelected,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            animationDuration: const Duration(milliseconds: 250),
            destinations: [
              for (final d in destinations)
                NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: d.label,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _materialTabBar(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final baseLabelStyle = (theme.textTheme.labelMedium ?? const TextStyle())
        .copyWith(fontSize: 12, height: 1.15, letterSpacing: 0.1);

    final bar = NavigationBarTheme(
      data: NavigationBarThemeData(
        height: 80,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return baseLabelStyle.copyWith(
            color: selected ? cs.onSurface : cs.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          );
        }),
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex.clamp(0, destinations.length - 1),
        onDestinationSelected: onDestinationSelected,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          for (final d in destinations)
            NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon),
              label: d.label,
            ),
        ],
      ),
    );

    // Web (incl. mobile Safari) doesn't get the native shell's safe-area
    // handling. Without this the bar often renders under the browser's
    // URL/home toolbar and looks like "no tab bar".
    return Material(
      color: cs.surface,
      elevation: 3,
      shadowColor: cs.shadow.withValues(alpha: 0.12),
      child: SafeArea(top: false, child: bar),
    );
  }
}

LiquidGlassTabItem _liquidGlassTabItem(ShellDestination d) {
  final selectedSf = _sfSymbolForPath(d.path, selected: true);
  final unselectedSf = _sfSymbolForPath(d.path, selected: false);
  return LiquidGlassTabItem(
    label: d.label,
    icon: selectedSf != null
        ? NativeLiquidGlassIcon.sfSymbol(unselectedSf ?? selectedSf)
        : NativeLiquidGlassIcon.iconData(d.icon),
    selectedIcon: selectedSf != null
        ? NativeLiquidGlassIcon.sfSymbol(selectedSf)
        : NativeLiquidGlassIcon.iconData(d.selectedIcon),
    selectedItemColor: SpiceRoutePalette.naturalSage,
  );
}

/// SF Symbol names per primary route — reads closer to Apple's system
/// tab vocabulary than Material icons rasterized into the glass bar.
String? _sfSymbolForPath(String path, {required bool selected}) {
  switch (path) {
    case '/':
      return selected ? 'safari.fill' : 'safari';
    case '/ai/creator':
      return selected ? 'sparkles' : 'sparkle';
    case '/ai/companion':
      return selected
          ? 'bubble.left.and.bubble.right.fill'
          : 'bubble.left.and.bubble.right';
    case '/saved':
      return selected ? 'bookmark.fill' : 'bookmark';
    case '/my-recipes':
      return selected ? 'fork.knife' : 'fork.knife';
    default:
      return null;
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
