import 'dart:math';

import 'package:flutter/material.dart';

import '../landing_palette.dart';
import 'landing_shared.dart';

class LandingBoardingPassForm extends StatefulWidget {
  const LandingBoardingPassForm({super.key, this.onEnteredApp});

  final VoidCallback? onEnteredApp;

  @override
  State<LandingBoardingPassForm> createState() =>
      _LandingBoardingPassFormState();
}

class _LandingBoardingPassFormState extends State<LandingBoardingPassForm> {
  final _email = TextEditingController();
  var _joined = false;
  var _ticketNo = '';
  var _seatNo = '';

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _email.text.trim();
    if (!email.contains('@')) return;
    final seats = ['12A', '08F', '14C', '21B', '03D', '15E'];
    setState(() {
      _ticketNo = 'SR-${100000 + Random().nextInt(900000)}';
      _seatNo = seats[Random().nextInt(seats.length)];
      _joined = true;
    });
  }

  void _reset() {
    setState(() {
      _email.clear();
      _joined = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LandingPalette.cream,
      padding: const EdgeInsets.symmetric(vertical: 96),
      child: LandingMaxWidth(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _joined
              ? _TicketView(
                  key: const ValueKey('ticket'),
                  email: _email.text,
                  ticketNo: _ticketNo,
                  seatNo: _seatNo,
                  onReset: _reset,
                  onEnterApp: widget.onEnteredApp,
                )
              : _FormView(
                  key: const ValueKey('form'),
                  controller: _email,
                  onSubmit: _submit,
                ),
        ),
      ),
    );
  }
}

class _FormView extends StatelessWidget {
  const _FormView({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LandingSectionHeader(
          badge: 'Final Boarding Call',
          title: 'Ready for departure?\nYour kitchen is the destination.',
          subtitle:
              'Join 14,000+ home chefs mapping the silk routes in their kitchens. Get weekly curated heritage spice kits, localized recipes, and unlimited cooking chats.',
          icon: Icons.explore,
          center: true,
        ),
        const SizedBox(height: 32),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email address...',
                    prefixIcon: const Icon(Icons.mail_outline),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onSubmitted: (_) => onSubmit(),
                ),
              ),
              const SizedBox(width: 12),
              LandingBoardingPassButton(
                label: 'Join the Hub',
                onPressed: onSubmit,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'NO SEAT FEES REQUIRED. CANCEL SUBSCRIPTIONS AT ANY TERMINAL.',
          style: LandingPalette.mono(
            context,
            size: 10,
            color: LandingPalette.charcoal.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }
}

class _TicketView extends StatelessWidget {
  const _TicketView({
    super.key,
    required this.email,
    required this.ticketNo,
    required this.seatNo,
    required this.onReset,
    this.onEnterApp,
  });

  final String email;
  final String ticketNo;
  final String seatNo;
  final VoidCallback onReset;
  final VoidCallback? onEnterApp;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 640;
    return Column(
      children: [
        const Icon(Icons.check_circle, color: LandingPalette.emerald, size: 40),
        const SizedBox(height: 8),
        Text(
          'Departure Booked!',
          style: LandingPalette.serif(context, size: 24),
        ),
        Text(
          'YOUR BOARDING PASS HAS BEEN CATALOGED',
          style: LandingPalette.mono(context, size: 10),
        ),
        const SizedBox(height: 24),
        Container(
          constraints: const BoxConstraints(maxWidth: 640),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: LandingPalette.charcoal.withValues(alpha: 0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 3, child: _ticketMain(context, email, ticketNo, seatNo)),
                    _ticketStamp(context, ticketNo),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ticketMain(context, email, ticketNo, seatNo),
                    _ticketStamp(context, ticketNo),
                  ],
                ),
        ),
        const SizedBox(height: 16),
        if (onEnterApp != null) ...[
          LandingBoardingPassButton(
            label: 'Enter the Kitchen',
            onPressed: onEnterApp!,
          ),
          const SizedBox(height: 8),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Use your browser print dialog (⌘P / Ctrl+P) to save your pass.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.print),
              label: const Text('Print Pass'),
            ),
            TextButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh),
              label: const Text('Register Another Email'),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _ticketMain(
  BuildContext context,
  String email,
  String ticketNo,
  String seatNo,
) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: LandingPalette.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Text(
                  'S',
                  style: TextStyle(
                    color: LandingPalette.cream,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'SPICEROUTE AIRLINES',
              style: LandingPalette.mono(context, size: 10),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DEPARTURE', style: LandingPalette.mono(context, size: 9)),
                  Text(
                    'HOME',
                    style: LandingPalette.serif(
                      context,
                      size: 24,
                      color: LandingPalette.red,
                    ),
                  ),
                  Text(
                    'YOUR KITCHEN',
                    style: LandingPalette.mono(context, size: 9),
                  ),
                ],
              ),
            ),
            const Icon(Icons.explore, color: LandingPalette.charcoal),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('DESTINATION', style: LandingPalette.mono(context, size: 9)),
                  Text(
                    'GLOBE',
                    style: LandingPalette.serif(
                      context,
                      size: 24,
                      color: LandingPalette.red,
                    ),
                  ),
                  Text(
                    '30+ CUISINES',
                    style: LandingPalette.mono(context, size: 9),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _GridRow('PASSENGER NAME', email),
        _GridRow('FLIGHT DATE', '06 JUL 2026'),
        _GridRow('BOARDING GATE', 'GATE 3B // SPICEROUTE'),
        _GridRow('FLIGHT NO // SEAT', '$ticketNo // $seatNo'),
      ],
    ),
  );
}

Widget _ticketStamp(BuildContext context, String ticketNo) {
  return Container(
    width: MediaQuery.sizeOf(context).width >= 640 ? 200 : double.infinity,
    color: LandingPalette.alabaster,
    padding: const EdgeInsets.all(24),
    child: Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: LandingPalette.red, width: 2),
          ),
          child: const Center(
            child: Text(
              'VIP',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'CULINARY STAMP',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 16),
        const LandingBarcode(height: 40),
        Text(ticketNo, style: LandingPalette.mono(context, size: 8)),
      ],
    ),
  );
}

class _GridRow extends StatelessWidget {
  const _GridRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: LandingPalette.mono(
              context,
              size: 9,
              color: LandingPalette.charcoal.withValues(alpha: 0.5),
            ),
          ),
          Text(
            value,
            style: LandingPalette.sans(
              context,
              size: 12,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
