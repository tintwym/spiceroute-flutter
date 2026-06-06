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
