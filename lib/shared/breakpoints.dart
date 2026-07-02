import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';

/// Material-aligned breakpoints. Note these are the *minimum* widths each
/// device class is willing to serve, so we always pick the largest that fits.
class Breakpoints {
  Breakpoints._();
  static const double phone = 0;
  static const double tablet = 600;
  static const double desktop = 1024;
  static const double wide = 1440;
}

enum DeviceClass { phone, tablet, desktop, wide }

DeviceClass deviceClassOf(BuildContext context) {
  final w = MediaQuery.sizeOf(context).width;
  if (w >= Breakpoints.wide) return DeviceClass.wide;
  if (w >= Breakpoints.desktop) return DeviceClass.desktop;
  if (w >= Breakpoints.tablet) return DeviceClass.tablet;
  return DeviceClass.phone;
}

extension DeviceClassX on DeviceClass {
  bool get isPhone => this == DeviceClass.phone;
  bool get isAtLeastTablet =>
      this == DeviceClass.tablet ||
      this == DeviceClass.desktop ||
      this == DeviceClass.wide;
  bool get isAtLeastDesktop =>
      this == DeviceClass.desktop || this == DeviceClass.wide;
}

/// Page-level horizontal padding chosen to keep line lengths readable on wide
/// screens without feeling cramped on phones.
EdgeInsets pagePadding(BuildContext context) {
  switch (deviceClassOf(context)) {
    case DeviceClass.phone:
      return const EdgeInsets.symmetric(horizontal: 16);
    case DeviceClass.tablet:
      return const EdgeInsets.symmetric(horizontal: 32);
    case DeviceClass.desktop:
      return const EdgeInsets.symmetric(horizontal: 64);
    case DeviceClass.wide:
      return const EdgeInsets.symmetric(horizontal: 96);
  }
}

/// Width of the centred content column after [pagePadding] and
/// [contentMaxWidth] are applied — matches the `ConstrainedBox` every
/// `framed(...)` helper wraps page content in. Use this instead of
/// raw [MediaQuery.sizeOf] when a layout decision depends on how wide
/// the recipe grid / filter row / hero actually render on tablet,
/// where the viewport can be 650 dp but the framed column is only
/// ~586 dp after padding + max-width cap.
double framedContentWidth(BuildContext context) {
  final mq = MediaQuery.sizeOf(context).width;
  final pad = pagePadding(context).horizontal;
  final maxW = contentMaxWidth(context);
  final inner = mq - pad;
  if (inner <= 0) return 0;
  return inner < maxW ? inner : maxW;
}

/// Responsive max-width content frame so even on a 4k display the layout
/// stays book-like.
double contentMaxWidth(BuildContext context) {
  switch (deviceClassOf(context)) {
    case DeviceClass.phone:
      return double.infinity;
    case DeviceClass.tablet:
      return 720;
    case DeviceClass.desktop:
      return 1080;
    case DeviceClass.wide:
      return 1280;
  }
}

/// Responsive grid: max card width so columns fall out naturally.
double recipeCardMaxExtent(BuildContext context) {
  switch (deviceClassOf(context)) {
    case DeviceClass.phone:
      return 360;
    case DeviceClass.tablet:
      return 320;
    case DeviceClass.desktop:
      return 320;
    case DeviceClass.wide:
      return 320;
  }
}

/// Fixed column count for the main Explore grid. The design calls for
/// exactly 4 cards per row on desktop/wide; smaller classes step down so
/// the rich card footer (time · servings · kcal · difficulty) still fits
/// without clipping.
int recipeGridColumns(BuildContext context) {
  switch (deviceClassOf(context)) {
    case DeviceClass.phone:
      return 1;
    case DeviceClass.tablet:
      return 2;
    case DeviceClass.desktop:
      return 4;
    case DeviceClass.wide:
      return 4;
  }
}

/// Width / height ratio for grid cards, tuned per column count so the
/// worst case (2-line title + 2-line description + footer) never overflows
/// the cell. Lower = taller cell.
double recipeCardAspectRatio(BuildContext context) {
  final dc = deviceClassOf(context);
  final base = switch (dc) {
    DeviceClass.phone => 0.88,
    DeviceClass.tablet => 0.80,
    DeviceClass.desktop => 0.72,
    DeviceClass.wide => 0.76,
  };
  // Web grid cards use a taller two-line footer; nudge aspect ratio down
  // so the fixed text slots still fit without overflow.
  if (kIsWeb && dc.isAtLeastTablet) {
    return base - 0.05;
  }
  return base;
}
