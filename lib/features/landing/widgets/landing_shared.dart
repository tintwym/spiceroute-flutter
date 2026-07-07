import 'package:flutter/material.dart';

import '../landing_palette.dart';

/// Shared marketing landing widgets.
class LandingSectionHeader extends StatelessWidget {
  const LandingSectionHeader({
    super.key,
    required this.badge,
    required this.title,
    this.subtitle,
    this.icon,
    this.center = false,
  });

  final String badge;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final align = center ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = center ? TextAlign.center : TextAlign.start;
    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: LandingPalette.alabaster,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: LandingPalette.charcoal.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 12, color: LandingPalette.red),
                const SizedBox(width: 6),
              ],
              Text(
                badge.toUpperCase(),
                style: LandingPalette.mono(
                  context,
                  size: 11,
                  color: LandingPalette.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: textAlign,
          style: LandingPalette.serif(
            context,
            size: 32,
            color: LandingPalette.charcoal,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              subtitle!,
              textAlign: textAlign,
              style: LandingPalette.sans(
                context,
                size: 15,
                color: LandingPalette.charcoal.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class LandingMaxWidth extends StatelessWidget {
  const LandingMaxWidth({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: LandingPalette.maxContentWidth,
        ),
        child: Padding(
          padding: padding ?? LandingPalette.sectionPaddingOf(context),
          child: child,
        ),
      ),
    );
  }
}

class LandingBarcode extends StatelessWidget {
  const LandingBarcode({super.key, this.height = 24});

  final double height;

  static const _widths = [
    1.0,
    1.5,
    6.0,
    0.5,
    1.0,
    1.5,
    0.5,
    8.0,
    0.5,
    1.5,
    1.0,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final w in _widths)
          Container(
            width: w,
            height: height,
            margin: const EdgeInsets.only(right: 1.5),
            color: LandingPalette.charcoal.withValues(alpha: 0.4),
          ),
      ],
    );
  }
}

class LandingPerforatedTicket extends StatelessWidget {
  const LandingPerforatedTicket({
    super.key,
    required this.child,
    this.backgroundColor = LandingPalette.cream,
    this.onTap,
    this.minWidth,
  });

  final Widget child;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final double? minWidth;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: minWidth ?? 0),
                child: child,
              ),
            ),
            Positioned(
              left: -10,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: LandingPalette.charcoal,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: LandingPalette.charcoal.withValues(alpha: 0.05),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: -10,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: LandingPalette.charcoal,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: LandingPalette.charcoal.withValues(alpha: 0.05),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LandingPassportStamp extends StatelessWidget {
  const LandingPassportStamp({
    super.key,
    this.lines = const ['APPROVED', 'ENTRY 2026'],
  });

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.21,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: LandingPalette.saffron, width: 2),
          color: LandingPalette.cream.withValues(alpha: 0.4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final line in lines)
              Text(
                line,
                style: LandingPalette.serif(
                  context,
                  size: 9,
                  weight: FontWeight.w700,
                  color: LandingPalette.saffron,
                ).copyWith(letterSpacing: 2.2, height: 1.1),
              ),
          ],
        ),
      ),
    );
  }
}

/// React `.badge-pill` — white pill with hover/active red state.
class LandingBadgePill extends StatefulWidget {
  const LandingBadgePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? icon;

  @override
  State<LandingBadgePill> createState() => _LandingBadgePillState();
}

class _LandingBadgePillState extends State<LandingBadgePill> {
  var _hover = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || _hover;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          transform: widget.selected
              ? Matrix4.diagonal3Values(1.05, 1.05, 1.0)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: active ? LandingPalette.red : Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: active
                  ? LandingPalette.red
                  : LandingPalette.charcoal.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Text(widget.icon!, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: active ? Colors.white : LandingPalette.charcoal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// React `.boarding-pass-btn` — red CTA with left cream perforation.
class LandingBoardingPassButton extends StatelessWidget {
  const LandingBoardingPassButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.pulse = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool pulse;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -8,
          top: 0,
          bottom: 0,
          child: Center(
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: LandingPalette.cream,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: LandingPalette.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          child: Text(label.toUpperCase()),
        ),
      ],
    );
  }
}

String landingFormatMarkdown(String text) => text;

/// Horizontal [Row] + [Expanded] on wide viewports; vertical [Column]
/// without [Expanded] on narrow (safe inside scroll views).
class LandingResponsiveRow extends StatelessWidget {
  const LandingResponsiveRow({
    super.key,
    required this.wide,
    required this.children,
    this.spacing = 24,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final bool wide;
  final List<Widget> children;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    if (wide) {
      return Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            Expanded(child: children[i]),
          ],
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: spacing),
          children[i],
        ],
      ],
    );
  }
}
