import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import '../landing_palette.dart';

class LandingPricingModal extends StatelessWidget {
  const LandingPricingModal({
    super.key,
    required this.isSubscribed,
    required this.onClose,
    required this.onSubscribe,
  });

  final bool isSubscribed;
  final VoidCallback onClose;
  final ValueChanged<bool> onSubscribe;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: LandingPalette.charcoal.withValues(alpha: 0.85),
          child: GestureDetector(
            onTap: onClose,
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 760,
                    maxHeight: 640,
                  ),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: LandingPalette.cream,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: LandingPalette.charcoal.withValues(alpha: 0.15),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    children: [
                      if (MediaQuery.sizeOf(context).width >= 640)
                        Expanded(
                          flex: 5,
                          child: Container(
                            color: LandingPalette.charcoal,
                            padding: const EdgeInsets.all(32),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Opacity(
                                  opacity: 0.15,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=600&q=80',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'SPICEROUTE PREMIUM',
                                      style: LandingPalette.mono(
                                        context,
                                        size: 9,
                                        color: LandingPalette.saffron,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Stamp Your Culinary Passport Without Boundaries.',
                                      style: LandingPalette.serif(
                                        context,
                                        size: 22,
                                        color: LandingPalette.cream,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.verified_user,
                                          color: LandingPalette.saffron,
                                          size: 16,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Interactive Sandbox Mode',
                                          style: TextStyle(
                                            color: LandingPalette.saffron,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      Expanded(
                        flex: 7,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Select Your Pass Tier',
                                    style: LandingPalette.serif(
                                      context,
                                      size: 20,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: onClose,
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _PlanCard(
                                      title: 'FREE PASS',
                                      price: '\$0',
                                      period: '/ forever',
                                      active: !isSubscribed,
                                      features: const [
                                        'View complete heritage recipes',
                                        'Interactive world map',
                                      ],
                                      locked: const [
                                        'AI Chat with Chef Tariq',
                                        'Custom AI Recipe Generator',
                                      ],
                                      action: isSubscribed
                                          ? TextButton(
                                              onPressed: () =>
                                                  onSubscribe(false),
                                              child: const Text(
                                                'Downgrade to Free',
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _PlanCard(
                                      title: 'PREMIUM ROUTE PASS',
                                      price: '\$9.99',
                                      period: '/ month',
                                      active: isSubscribed,
                                      highlight: true,
                                      features: const [
                                        'Unlimited AI Chat with Chef Tariq',
                                        'Custom AI Recipe Generator',
                                        'Unlimited Spin the Globe draws',
                                        'Custom community board stamps',
                                      ],
                                      action: FilledButton(
                                        onPressed: isSubscribed
                                            ? null
                                            : () => onSubscribe(true),
                                        style: FilledButton.styleFrom(
                                          backgroundColor: isSubscribed
                                              ? LandingPalette.charcoal
                                              : LandingPalette.red,
                                        ),
                                        child: Text(
                                          isSubscribed
                                              ? 'Maintain Premium Pass'
                                              : 'Unlock Premium Pass',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    required this.active,
    required this.features,
    this.locked = const [],
    this.highlight = false,
    this.action,
  });

  final String title;
  final String price;
  final String period;
  final bool active;
  final bool highlight;
  final List<String> features;
  final List<String> locked;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight ? LandingPalette.alabaster : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: active
              ? (highlight
                    ? LandingPalette.red
                    : LandingPalette.charcoal.withValues(alpha: 0.3))
              : LandingPalette.charcoal.withValues(alpha: 0.1),
          width: active ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: LandingPalette.mono(
              context,
              size: 9,
              color: highlight ? LandingPalette.red : null,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(price, style: LandingPalette.serif(context, size: 28)),
              Text(period, style: LandingPalette.mono(context, size: 10)),
            ],
          ),
          const SizedBox(height: 12),
          for (final f in features)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.check,
                    size: 14,
                    color: highlight
                        ? LandingPalette.red
                        : LandingPalette.emerald,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(f, style: const TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ),
          for (final f in locked)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                f,
                style: TextStyle(
                  fontSize: 11,
                  decoration: TextDecoration.lineThrough,
                  color: LandingPalette.charcoal.withValues(alpha: 0.4),
                ),
              ),
            ),
          if (action != null) ...[
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: action),
          ],
        ],
      ),
    );
  }
}
