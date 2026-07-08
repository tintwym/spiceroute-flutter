import 'package:flutter/material.dart';

import '../landing_palette.dart';
import 'landing_shared.dart';

class LandingFooter extends StatelessWidget {
  const LandingFooter({super.key, required this.onEnterApp});

  final VoidCallback onEnterApp;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 640;
    return Container(
      color: LandingPalette.heroDark,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: LandingMaxWidth(
        child: Column(
          children: [
            FilledButton.icon(
              onPressed: onEnterApp,
              style: FilledButton.styleFrom(
                backgroundColor: LandingPalette.red,
                foregroundColor: LandingPalette.cream,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.restaurant_menu, size: 18),
              label: Text(
                'ENTER THE KITCHEN',
                style: LandingPalette.sans(
                  context,
                  size: 13,
                  weight: FontWeight.w700,
                ).copyWith(letterSpacing: 1.2),
              ),
            ),
            const SizedBox(height: 32),
            wide
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
          ],
        ),
      ),
    );
  }
}
