import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../landing_data.dart';
import '../landing_models.dart';
import '../landing_palette.dart';

class LandingSpinModal extends StatefulWidget {
  const LandingSpinModal({
    super.key,
    required this.onClose,
    required this.onExploreMap,
  });

  final VoidCallback onClose;
  final VoidCallback onExploreMap;

  @override
  State<LandingSpinModal> createState() => _LandingSpinModalState();
}

class _LandingSpinModalState extends State<LandingSpinModal> {
  var _spinning = false;
  var _activeIdx = 0;
  LandingSpinDestination? _award;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startSpin() {
    if (_spinning) return;
    setState(() {
      _spinning = true;
      _award = null;
    });
    var speed = 60;
    var iterations = 0;
    const maxIterations = 25;

    void run() {
      if (!mounted) return;
      setState(
        () => _activeIdx = (_activeIdx + 1) % landingSpinDestinations.length,
      );
      iterations++;
      if (iterations < maxIterations) {
        speed += 12;
        _timer = Timer(Duration(milliseconds: speed), run);
      } else {
        final landing = Random().nextInt(landingSpinDestinations.length);
        if (!mounted) return;
        setState(() {
          _activeIdx = landing;
          _award = landingSpinDestinations[landing];
          _spinning = false;
        });
      }
    }

    _timer = Timer(Duration(milliseconds: speed), run);
  }

  @override
  Widget build(BuildContext context) {
    final dest = landingSpinDestinations[_activeIdx];
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: LandingPalette.charcoal.withValues(alpha: 0.85),
          child: GestureDetector(
            onTap: _spinning ? null : widget.onClose,
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: LandingPalette.cream,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: LandingPalette.charcoal.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: _spinning ? null : widget.onClose,
                          icon: const Icon(Icons.close),
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: LandingPalette.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: LandingPalette.red.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Icon(
                          Icons.explore,
                          color: LandingPalette.red,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Spin the Globe',
                        style: LandingPalette.serif(context, size: 24),
                      ),
                      Text(
                        'WHERE SHALL YOUR KITCHEN DEPART TODAY?',
                        style: LandingPalette.mono(context, size: 10),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: LandingPalette.alabaster,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: LandingPalette.charcoal.withValues(
                              alpha: 0.05,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 176,
                              height: 176,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: LandingPalette.charcoal
                                            .withValues(alpha: 0.15),
                                        width: 4,
                                        style: BorderStyle.solid,
                                      ),
                                      color: LandingPalette.cream,
                                    ),
                                  ),
                                  Transform.rotate(
                                    angle:
                                        (_activeIdx *
                                            (pi *
                                                2 /
                                                landingSpinDestinations
                                                    .length)) +
                                        0.78,
                                    child: Container(
                                      width: 8,
                                      height: 112,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            LandingPalette.red,
                                            LandingPalette.charcoal.withValues(
                                              alpha: 0.35,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: LandingPalette.cream,
                                      border: Border.all(
                                        color: LandingPalette.charcoal
                                            .withValues(alpha: 0.1),
                                        width: 2,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      dest.stamp,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    child: Text(
                                      'N',
                                      style: LandingPalette.mono(
                                        context,
                                        size: 8,
                                        color: LandingPalette.charcoal
                                            .withValues(alpha: 0.35),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    child: Text(
                                      'S',
                                      style: LandingPalette.mono(
                                        context,
                                        size: 8,
                                        color: LandingPalette.charcoal
                                            .withValues(alpha: 0.35),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 8,
                                    child: Text(
                                      'W',
                                      style: LandingPalette.mono(
                                        context,
                                        size: 8,
                                        color: LandingPalette.charcoal
                                            .withValues(alpha: 0.35),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 8,
                                    child: Text(
                                      'E',
                                      style: LandingPalette.mono(
                                        context,
                                        size: 8,
                                        color: LandingPalette.charcoal
                                            .withValues(alpha: 0.35),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'CURRENT ROUTE',
                              style: LandingPalette.mono(context, size: 9),
                            ),
                            Text(
                              '${dest.stamp} ${dest.city}, ${dest.country}',
                              style: LandingPalette.serif(context, size: 20),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              dest.dish.toUpperCase(),
                              style: LandingPalette.mono(
                                context,
                                size: 10,
                                color: LandingPalette.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _spinning ? null : _startSpin,
                          style: FilledButton.styleFrom(
                            backgroundColor: LandingPalette.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          icon: Icon(
                            _spinning ? Icons.hourglass_top : Icons.explore,
                            size: 18,
                          ),
                          label: Text(
                            _spinning
                                ? 'SPINNING NAVIGATION...'
                                : 'SPIN THE COMPASS',
                          ),
                        ),
                      ),
                      if (_award != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: LandingPalette.saffron.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: LandingPalette.saffron.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CULINARY VISA APPROVED',
                                style: LandingPalette.mono(
                                  context,
                                  size: 9,
                                  color: LandingPalette.saffron,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Depart to ${_award!.city}, ${_award!.country}!',
                                style: LandingPalette.serif(context, size: 18),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Prepare ${_award!.dish} tonight. Key flavors: ${_award!.aroma}.',
                                style: LandingPalette.sans(context, size: 13),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '💡 ${_award!.tip}',
                                style: LandingPalette.sans(
                                  context,
                                  size: 12,
                                ).copyWith(fontStyle: FontStyle.italic),
                              ),
                              TextButton.icon(
                                onPressed: widget.onExploreMap,
                                icon: const Icon(Icons.arrow_forward, size: 14),
                                label: const Text(
                                  'Explore fully in The Taste Map',
                                ),
                              ),
                            ],
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
    );
  }
}
