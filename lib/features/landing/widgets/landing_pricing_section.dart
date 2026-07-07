import 'package:flutter/material.dart';

import '../landing_palette.dart';
import 'landing_shared.dart';

class LandingPricingSection extends StatefulWidget {
  const LandingPricingSection({
    super.key,
    required this.isSubscribed,
    required this.onSubscribe,
  });

  final bool isSubscribed;
  final ValueChanged<bool> onSubscribe;

  @override
  State<LandingPricingSection> createState() => _LandingPricingSectionState();
}

class _LandingPricingSectionState extends State<LandingPricingSection> {
  var _annual = false;
  var _crewCount = 25.0;

  double get _basePerCook => _annual ? 4.80 : 6.00;
  int get _estimatedBilling => (_crewCount * _basePerCook).round();

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1024;
    return Container(
      color: LandingPalette.cream,
      padding: const EdgeInsets.symmetric(vertical: 96),
      child: LandingMaxWidth(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: LandingPalette.blueLight,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFDBEAFE)),
              ),
              child: Text(
                'TRANSPARENT PRICING',
                style: LandingPalette.mono(
                  context,
                  size: 11,
                  color: LandingPalette.blue,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Predictable passport tiers scaled to fits cooks of all sizes.',
              textAlign: TextAlign.center,
              style: LandingPalette.serif(context, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              'Choose a fixed package or estimate your custom restaurant crew size below.',
              textAlign: TextAlign.center,
              style: LandingPalette.sans(
                context,
                size: 14,
                color: LandingPalette.charcoal.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Monthly Billing',
                  style: LandingPalette.mono(
                    context,
                    size: 11,
                    color: !_annual ? LandingPalette.charcoal : null,
                  ),
                ),
                const SizedBox(width: 12),
                Switch(
                  value: _annual,
                  onChanged: (v) => setState(() => _annual = v),
                ),
                const SizedBox(width: 12),
                Text(
                  'Annual Billing',
                  style: LandingPalette.mono(context, size: 11),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: LandingPalette.blueLight,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'SAVE 20%',
                    style: LandingPalette.mono(
                      context,
                      size: 9,
                      color: LandingPalette.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            LandingResponsiveRow(
              wide: wide,
              children: [
                _TierCard(
                  label: 'GROWTH / FREE',
                  price: '\$0',
                  period: '/ cook/mo',
                  subtitle: 'Up to 1 solo adventurer',
                  active: !widget.isSubscribed,
                  features: const [
                    'View complete heritage recipes',
                    'Interactive world map',
                  ],
                  locked: const [
                    'AI Chatbot with Chef Tariq',
                    'Custom AI Recipe Generator',
                  ],
                  buttonLabel: !widget.isSubscribed
                      ? 'Active Plan'
                      : 'Downgrade to Free',
                  onPressed: widget.isSubscribed
                      ? () => widget.onSubscribe(false)
                      : null,
                ),
                _TierCard(
                  label: 'PRO / PASS',
                  price: _annual ? '\$7.99' : '\$9.99',
                  period: '/ cook/mo',
                  subtitle: 'Up to 5 custom devices',
                  active: widget.isSubscribed,
                  popular: true,
                  features: const [
                    'Everything in Growth Free Pass',
                    'Unlimited AI Chat with Chef Tariq',
                    'Custom AI Recipe Generator',
                    'Unlimited Spin the Globe draws',
                  ],
                  buttonLabel: widget.isSubscribed
                      ? 'Maintain Premium Pass'
                      : 'Start Premium Trial',
                  onPressed: widget.isSubscribed
                      ? null
                      : () => widget.onSubscribe(true),
                ),
                _TierCard(
                  label: 'ENTERPRISE',
                  price: 'Custom',
                  period: '',
                  subtitle: 'Unlimited cook licenses',
                  features: const [
                    'Everything in Premium Pass',
                    'Dedicated Private Server Nodes',
                    'Localized menu database sync',
                    'Shared workspace & custom billing',
                  ],
                  buttonLabel: 'Contact Sales',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Connecting with the SpiceRoute Culinary Sales team...',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: LandingPalette.charcoal.withValues(alpha: 0.1),
                ),
              ),
              child: Flex(
                direction: wide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (wide)
                    Expanded(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CUSTOM ESTIMATOR',
                          style: LandingPalette.mono(context, size: 9),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Need custom passes for specific crews?',
                          style: LandingPalette.serif(context, size: 20),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Calculated Seats:'),
                            Text(
                              '${_crewCount.round()}',
                              style: const TextStyle(
                                color: LandingPalette.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _crewCount,
                          min: 5,
                          max: 150,
                          divisions: 29,
                          label: _crewCount.round().toString(),
                          onChanged: (v) => setState(() => _crewCount = v),
                          activeColor: LandingPalette.blue,
                        ),
                      ],
                    ),
                  ),
                  if (!wide)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CUSTOM ESTIMATOR',
                          style: LandingPalette.mono(context, size: 9),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Need custom passes for specific crews?',
                          style: LandingPalette.serif(context, size: 20),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Calculated Seats:'),
                            Text(
                              '${_crewCount.round()}',
                              style: const TextStyle(
                                color: LandingPalette.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _crewCount,
                          min: 5,
                          max: 150,
                          divisions: 29,
                          label: _crewCount.round().toString(),
                          onChanged: (v) => setState(() => _crewCount = v),
                          activeColor: LandingPalette.blue,
                        ),
                      ],
                    ),
                  SizedBox(width: wide ? 32 : 0, height: wide ? 0 : 24),
                  Container(
                    width: wide ? 280 : double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: LandingPalette.slateDark,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ESTIMATED BILLING',
                          style: LandingPalette.mono(
                            context,
                            size: 9,
                            color: LandingPalette.cream.withValues(alpha: 0.45),
                          ),
                        ),
                        Text(
                          '\$$_estimatedBilling',
                          style: LandingPalette.serif(
                            context,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _annual
                              ? 'Billed annually (\$${_estimatedBilling * 12}/yr)'
                              : 'Billed monthly',
                          style: LandingPalette.mono(
                            context,
                            size: 10,
                            color: LandingPalette.blue,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Estimating contract lock-in for ${_crewCount.round()} employees...',
                                ),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: LandingPalette.blue,
                          ),
                          child: const Text('LOCK IN PRICE'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({
    required this.label,
    required this.price,
    required this.period,
    required this.subtitle,
    required this.features,
    required this.buttonLabel,
    this.locked = const [],
    this.active = false,
    this.popular = false,
    this.onPressed,
  });

  final String label;
  final String price;
  final String period;
  final String subtitle;
  final List<String> features;
  final List<String> locked;
  final String buttonLabel;
  final bool active;
  final bool popular;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: popular && active
              ? LandingPalette.blue
              : LandingPalette.charcoal.withValues(alpha: 0.1),
          width: popular && active ? 2 : 1,
        ),
        boxShadow: popular
            ? [
                BoxShadow(
                  color: LandingPalette.blue.withValues(alpha: 0.1),
                  blurRadius: 16,
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (popular)
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: LandingPalette.blue,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                ),
                child: Text(
                  'MOST POPULAR',
                  style: LandingPalette.mono(
                    context,
                    size: 8,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          Text(
            label,
            style: LandingPalette.mono(
              context,
              size: 10,
              color: popular ? LandingPalette.blue : null,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(price, style: LandingPalette.serif(context, size: 36)),
              Text(period, style: LandingPalette.mono(context, size: 11)),
            ],
          ),
          Text(
            subtitle.toUpperCase(),
            style: LandingPalette.mono(context, size: 10),
          ),
          const SizedBox(height: 16),
          for (final f in features)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check, size: 16, color: LandingPalette.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(f, style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          for (final f in locked)
            Text(
              f,
              style: TextStyle(
                fontSize: 12,
                decoration: TextDecoration.lineThrough,
                color: LandingPalette.charcoal.withValues(alpha: 0.35),
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: popular && !active
                    ? LandingPalette.blue
                    : LandingPalette.charcoal,
                disabledBackgroundColor: LandingPalette.charcoal.withValues(
                  alpha: 0.05,
                ),
                disabledForegroundColor: LandingPalette.charcoal.withValues(
                  alpha: 0.4,
                ),
              ),
              child: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}
