import 'package:flutter/material.dart';

import '../landing_palette.dart';
import 'landing_shared.dart';

class LandingFooter extends StatelessWidget {
  const LandingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 640;
    return Container(
      color: LandingPalette.charcoal,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: LandingMaxWidth(
        child: wide
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '© 2026 SpiceRoute Airlines. No flight required. Built with premium culinary wisdom.',
                    style: LandingPalette.mono(
                      context,
                      size: 11,
                      color: LandingPalette.cream.withValues(alpha: 0.4),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.verified_user,
                        size: 14,
                        color: LandingPalette.emerald,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Secure Server-Side API',
                        style: LandingPalette.mono(
                          context,
                          size: 11,
                          color: LandingPalette.cream.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
                  Text(
                    '© 2026 SpiceRoute Airlines. No flight required.',
                    textAlign: TextAlign.center,
                    style: LandingPalette.mono(
                      context,
                      size: 11,
                      color: LandingPalette.cream.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.verified_user,
                        size: 14,
                        color: LandingPalette.emerald,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Secure Server-Side API',
                        style: LandingPalette.mono(
                          context,
                          size: 11,
                          color: LandingPalette.cream.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
