import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../landing_palette.dart';
import '../landing_state.dart';
import 'landing_shared.dart';

class LandingHero extends StatelessWidget {
  const LandingHero({
    super.key,
    required this.onSpinGlobe,
    required this.onBrowseMap,
    required this.onEnterApp,
    required this.sections,
  });

  final VoidCallback onSpinGlobe;
  final VoidCallback onBrowseMap;
  final VoidCallback onEnterApp;
  final LandingSectionKeys sections;

  static const _heroImage =
      'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=1600&q=80';

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 768;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.35,
            child: ColorFiltered(
              colorFilter: _saturationMatrix(0.75),
              child: CachedNetworkImage(
                imageUrl: _heroImage,
                fit: BoxFit.cover,
                color: Colors.white,
                colorBlendMode: BlendMode.luminosity,
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  LandingPalette.charcoal,
                  LandingPalette.charcoal.withValues(alpha: 0.8),
                  wide
                      ? LandingPalette.charcoal.withValues(alpha: 0.1)
                      : LandingPalette.charcoal.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [LandingPalette.charcoal, Colors.transparent],
                stops: const [0.0, 0.45],
              ),
            ),
          ),
          LandingMaxWidth(
            padding: const EdgeInsets.fromLTRB(0, 80, 0, 100),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: wide ? 7 : 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LandingEntrance(
                        child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: LandingPalette.cream.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: LandingPalette.cream.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const _SlowSpinCompass(size: 14),
                            const SizedBox(width: 8),
                            Text(
                              'SOCIETY OF GLOBAL COOKS',
                              style: LandingPalette.mono(
                                context,
                                size: 11,
                                color: LandingPalette.saffron,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ),
                      const SizedBox(height: 24),
                      LandingEntrance(
                        delay: const Duration(milliseconds: 80),
                        child: Builder(
                        builder: (context) {
                          final w = MediaQuery.sizeOf(context).width;
                          final h1 = w >= 1024 ? 72.0 : (w >= 640 ? 48.0 : 36.0);
                          final h2 = w >= 1024 ? 48.0 : (w >= 640 ? 36.0 : 30.0);
                          return RichText(
                            text: TextSpan(
                              style: LandingPalette.serif(
                                context,
                                size: h1,
                                weight: FontWeight.w700,
                                color: LandingPalette.cream,
                              ).copyWith(height: 1.05, letterSpacing: -0.5),
                              children: [
                                const TextSpan(text: 'Stamp Your '),
                                TextSpan(
                                  text: 'Culinary',
                                  style: LandingPalette.serif(
                                    context,
                                    size: h1,
                                    weight: FontWeight.w700,
                                    color: LandingPalette.red,
                                  ),
                                ),
                                const TextSpan(text: ' Passport.\n'),
                                TextSpan(
                                  text: 'No Flight Required.',
                                  style: LandingPalette.serif(
                                    context,
                                    size: h2,
                                    weight: FontWeight.w300,
                                    color: LandingPalette.cream,
                                  ).copyWith(height: 1.2),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ),
                      const SizedBox(height: 16),
                      LandingEntrance(
                        delay: const Duration(milliseconds: 160),
                        child: Text(
                        'Explore authentic heritage recipes, unearth localized cooking secrets, and co-create bespoke spiced menus with Chef Tariq—your interactive virtual travel chef.',
                        style: LandingPalette.sans(
                          context,
                          size: 16,
                          color: LandingPalette.cream.withValues(alpha: 0.85),
                        ),
                      ),
                      ),
                      const SizedBox(height: 24),
                      LandingEntrance(
                        delay: const Duration(milliseconds: 240),
                        child: Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          LandingPerforatedTicket(
                            backgroundColor: LandingPalette.cream,
                            onTap: onSpinGlobe,
                            minWidth: 280,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.confirmation_number,
                                  color: LandingPalette.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'SPIN THE GLOBE',
                                  style: LandingPalette.mono(
                                    context,
                                    size: 11,
                                    color: LandingPalette.charcoal,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 16),
                                  padding: const EdgeInsets.only(left: 16),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: LandingPalette.charcoal
                                            .withValues(alpha: 0.15),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'DEPART',
                                        style: LandingPalette.mono(
                                          context,
                                          size: 11,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_forward, size: 14),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton.icon(
                            onPressed: onBrowseMap,
                            icon: const Icon(
                              Icons.arrow_forward,
                              size: 14,
                              color: LandingPalette.cream,
                            ),
                            label: Text(
                              'OR BROWSE MAP',
                              style: LandingPalette.mono(
                                context,
                                size: 11,
                                color: LandingPalette.cream.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: onEnterApp,
                            child: Text(
                              'SKIP TO APP →',
                              style: LandingPalette.mono(
                                context,
                                size: 11,
                                color: LandingPalette.cream.withValues(
                                  alpha: 0.55,
                                ),
                              ),
                            ),
                          ),
                          const LandingPassportStamp(),
                        ],
                      ),
                      ),
                      const SizedBox(height: 48),
                      const Divider(color: Color(0x33F9F7F2), height: 1),
                      const SizedBox(height: 24),
                      LandingEntrance(
                        delay: const Duration(milliseconds: 320),
                        child: Row(
                        children: const [
                          _Stat(value: '30+', label: 'Regional Hubs'),
                          SizedBox(width: 24),
                          _Stat(value: '1k+', label: 'Expert Recipes'),
                          SizedBox(width: 24),
                          _Stat(value: '24/7', label: 'AI Chef Support'),
                        ],
                      ),
                      ),
                    ],
                  ),
                ),
                if (wide)
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: LandingEntrance(
                        delay: const Duration(milliseconds: 400),
                        offsetY: 28,
                        child: Transform.rotate(
                        angle: 0.035,
                        child: _GatePassCard(),
                      ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LandingEntrance(
              delay: const Duration(milliseconds: 480),
              child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: LandingPalette.charcoal.withValues(alpha: 0.8),
                    border: Border(
                      top: BorderSide(
                        color: LandingPalette.cream.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  child: LandingMaxWidth(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        'QUICK SECTORS:',
                        style: LandingPalette.mono(
                          context,
                          size: 9,
                          color: LandingPalette.cream.withValues(alpha: 0.4),
                        ),
                      ),
                      const SizedBox(width: 16),
                      for (final s in _sectors) ...[
                        _SectorChip(
                          label: s.$1,
                          emoji: s.$2,
                          onTap: onBrowseMap,
                        ),
                        if (s != _sectors.last)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '|',
                              style: TextStyle(
                                color: LandingPalette.cream.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
                  ),
                ),
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }

  static const _sectors = [
    ('Middle East & Africa', '🕌'),
    ('Mainland SE Asia', '🛶'),
    ('South Asia', '🌶️'),
    ('East Asia', '🏮'),
    ('Mediterranean', '🍕'),
    ('Latin America', '🌮'),
  ];
}

ColorFilter _saturationMatrix(double s) {
  const r = 0.2126;
  const g = 0.7152;
  const b = 0.0722;
  return ColorFilter.matrix([
    r + (1 - r) * s, g - g * s, b - b * s, 0, 0,
    r - r * s, g + (1 - g) * s, b - b * s, 0, 0,
    r - r * s, g - g * s, b + (1 - b) * s, 0, 0,
    0, 0, 0, 1, 0,
  ]);
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

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: LandingPalette.serif(
              context,
              size: 24,
              weight: FontWeight.w400,
              color: LandingPalette.saffron,
            ).copyWith(fontStyle: FontStyle.italic),
          ),
          Text(
            label.toUpperCase(),
            style: LandingPalette.mono(
              context,
              size: 9,
              color: LandingPalette.cream.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectorChip extends StatelessWidget {
  const _SectorChip({
    required this.label,
    required this.emoji,
    required this.onTap,
  });

  final String label;
  final String emoji;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Text(emoji),
      label: Text(
        label,
        style: LandingPalette.sans(
          context,
          size: 12,
          weight: FontWeight.w600,
          color: LandingPalette.cream.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class _GatePassCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: LandingPalette.cream,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'GATE PASS VOUCHER',
                    style: LandingPalette.mono(context, size: 8),
                  ),
                  Text(
                    'SPICEROUTE',
                    style: LandingPalette.serif(
                      context,
                      size: 14,
                      color: LandingPalette.red,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PASSENGER LEVEL',
                        style: LandingPalette.mono(context, size: 8),
                      ),
                      Text(
                        'Culinary Enthusiast',
                        style: LandingPalette.sans(
                          context,
                          size: 13,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'FLIGHT GATE',
                        style: LandingPalette.mono(context, size: 8),
                      ),
                      Text(
                        'GATE 3B',
                        style: LandingPalette.mono(
                          context,
                          size: 11,
                          color: LandingPalette.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'DESTINATION RADAR',
                style: LandingPalette.mono(context, size: 8),
              ),
              const SizedBox(height: 4),
              const Row(
                children: [
                  Text('🕌', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Marrakesh, Morocco // 45 MIN',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const LandingBarcode(height: 24),
                  Text(
                    'SR-PASS-98',
                    style: LandingPalette.mono(context, size: 8),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: -20,
            bottom: -20,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: LandingPalette.cream,
                border: Border.all(
                  color: LandingPalette.saffron,
                  style: BorderStyle.solid,
                  width: 1,
                ),
              ),
              child: const Center(
                child: Text('⭐', style: TextStyle(fontSize: 24)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
