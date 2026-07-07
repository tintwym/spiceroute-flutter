import 'package:flutter/material.dart';
import 'dart:ui';

import '../landing_palette.dart';
import '../landing_state.dart';
import 'landing_shared.dart';

class LandingHeader extends StatelessWidget {
  const LandingHeader({
    super.key,
    required this.isSubscribed,
    required this.onScrollTo,
    required this.onScrollTop,
    required this.onScrollToPricing,
    required this.sections,
  });

  final bool isSubscribed;
  final void Function(GlobalKey key) onScrollTo;
  final VoidCallback onScrollTop;
  final VoidCallback onScrollToPricing;
  final LandingSectionKeys sections;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 768;
    final lg = MediaQuery.sizeOf(context).width >= 1024;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: LandingPalette.cream.withValues(alpha: 0.8),
            border: Border(
              bottom: BorderSide(
                color: LandingPalette.charcoal.withValues(alpha: 0.05),
              ),
            ),
          ),
          child: LandingMaxWidth(
            child: SizedBox(
              height: 72,
              child: Row(
                children: [
                  InkWell(
                    onTap: onScrollTop,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'THE CULINARY TERMINAL',
                            style: LandingPalette.mono(
                              context,
                              size: 9,
                              color: LandingPalette.charcoal.withValues(
                                alpha: 0.4,
                              ),
                              letterSpacing: 3.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: LandingPalette.red,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: LandingPalette.red.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(6),
                                child: const _BrandMark(),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'SpiceRoute',
                                style: LandingPalette.serif(
                                  context,
                                  size: 22,
                                  weight: FontWeight.w700,
                                  color: LandingPalette.charcoal,
                                ).copyWith(
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              if (lg) ...[
                                const SizedBox(width: 12),
                                Container(
                                  width: 64,
                                  height: 1,
                                  color: LandingPalette.charcoal.withValues(
                                    alpha: 0.15,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (wide) ...[
                    _NavButton(
                      icon: Icons.public,
                      label: 'The Taste Map',
                      onTap: () => onScrollTo(sections.tasteMap),
                    ),
                    _NavButton(
                      icon: Icons.auto_awesome,
                      label: 'AI Travel Companion',
                      onTap: () => onScrollTo(sections.chefToolkit),
                    ),
                    _NavButton(
                      icon: Icons.hub_outlined,
                      label: 'The Global Terminal',
                      onTap: () => onScrollTo(sections.globalTerminal),
                    ),
                    _NavButton(
                      icon: Icons.explore,
                      label: 'Pricing Tiers',
                      onTap: () => onScrollTo(sections.pricing),
                    ),
                    const SizedBox(width: 16),
                  ],
                  InkWell(
                    onTap: onScrollToPricing,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSubscribed
                            ? LandingPalette.red.withValues(alpha: 0.1)
                            : LandingPalette.charcoal.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: isSubscribed
                              ? LandingPalette.red.withValues(alpha: 0.25)
                              : LandingPalette.charcoal.withValues(alpha: 0.1),
                        ),
                      ),
                      child: _PremiumBadgePulse(
                        active: isSubscribed,
                        label: isSubscribed
                            ? '✨ Premium Pass'
                            : '🔓 Free Plan',
                      ),
                    ),
                  ),
                  if (MediaQuery.sizeOf(context).width >= 640) ...[
                    const SizedBox(width: 10),
                    _BoardingPassButton(
                      onTap: () => onScrollTo(sections.boardingCall),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumBadgePulse extends StatefulWidget {
  const _PremiumBadgePulse({required this.active, required this.label});

  final bool active;
  final String label;

  @override
  State<_PremiumBadgePulse> createState() => _PremiumBadgePulseState();
}

class _PremiumBadgePulseState extends State<_PremiumBadgePulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.active) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _PremiumBadgePulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!widget.active) {
      _pulse.stop();
      _pulse.value = 1;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.active
          ? Tween<double>(begin: 0.85, end: 1).animate(_pulse)
          : const AlwaysStoppedAnimation(1),
      child: Text(
        widget.label,
        style: LandingPalette.mono(
          context,
          size: 10,
          color: widget.active
              ? LandingPalette.red
              : LandingPalette.charcoal.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

class _BoardingPassButton extends StatefulWidget {
  const _BoardingPassButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_BoardingPassButton> createState() => _BoardingPassButtonState();
}

class _BoardingPassButtonState extends State<_BoardingPassButton> {
  var _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Material(
        color: _hover ? LandingPalette.red : LandingPalette.charcoal,
        borderRadius: BorderRadius.circular(12),
        elevation: _hover ? 4 : 1,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _SlowSpinCompass(size: 16),
                const SizedBox(width: 8),
                Text(
                  'GET BOARDING PASS',
                  style: LandingPalette.sans(
                    context,
                    size: 12,
                    weight: FontWeight.w600,
                    color: LandingPalette.cream,
                  ).copyWith(letterSpacing: 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SlowSpinCompass extends StatefulWidget {
  const _SlowSpinCompass({required this.size});

  final double size;

  @override
  State<_SlowSpinCompass> createState() => _SlowSpinCompassState();
}

class _SlowSpinCompassState extends State<_SlowSpinCompass>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _spin,
      child: Icon(
        Icons.explore,
        size: widget.size,
        color: LandingPalette.saffron,
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  const _NavButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  var _hover = false;

  @override
  Widget build(BuildContext context) {
    final color = _hover
        ? LandingPalette.red
        : LandingPalette.charcoal.withValues(alpha: 0.7);
    final iconColor = _hover
        ? LandingPalette.red
        : LandingPalette.charcoal.withValues(alpha: 0.4);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: TextButton.icon(
        onPressed: widget.onTap,
        icon: Icon(widget.icon, size: 16, color: iconColor),
        label: Text(
          widget.label,
          style: LandingPalette.sans(
            context,
            size: 14,
            weight: FontWeight.w500,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BrandMarkPainter(),
      size: const Size.square(28),
    );
  }
}

class _BrandMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final steam = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.6
      ..color = LandingPalette.cream;
    final bowl = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFFAF9F6);

    final s1 = Path()
      ..moveTo(size.width * 0.34, size.height * 0.36)
      ..quadraticBezierTo(
        size.width * 0.42,
        size.height * 0.2,
        size.width * 0.34,
        size.height * 0.06,
      );
    final s2 = Path()
      ..moveTo(size.width * 0.50, size.height * 0.40)
      ..quadraticBezierTo(
        size.width * 0.58,
        size.height * 0.16,
        size.width * 0.50,
        0,
      );
    final s3 = Path()
      ..moveTo(size.width * 0.66, size.height * 0.36)
      ..quadraticBezierTo(
        size.width * 0.74,
        size.height * 0.24,
        size.width * 0.66,
        size.height * 0.10,
      );
    canvas.drawPath(s1, steam);
    canvas.drawPath(s2, steam);
    canvas.drawPath(s3, steam);

    final bowlPath = Path()
      ..moveTo(size.width * 0.1, size.height * 0.58)
      ..cubicTo(
        size.width * 0.1,
        size.height * 0.86,
        size.width * 0.35,
        size.height * 0.92,
        size.width * 0.5,
        size.height * 0.92,
      )
      ..cubicTo(
        size.width * 0.65,
        size.height * 0.92,
        size.width * 0.9,
        size.height * 0.86,
        size.width * 0.9,
        size.height * 0.58,
      )
      ..close();
    canvas.drawPath(bowlPath, bowl);

    final base = Path()
      ..moveTo(size.width * 0.35, size.height * 0.92)
      ..lineTo(size.width * 0.65, size.height * 0.92)
      ..lineTo(size.width * 0.60, size.height)
      ..lineTo(size.width * 0.4, size.height)
      ..close();
    canvas.drawPath(base, bowl);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
