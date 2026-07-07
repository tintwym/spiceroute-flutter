import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../landing_models.dart';
import '../landing_palette.dart';
import 'landing_markdown.dart';
import 'landing_shared.dart';

class LandingChefCompanion extends ConsumerStatefulWidget {
  const LandingChefCompanion({
    super.key,
    required this.isSubscribed,
    required this.onOpenPricing,
    required this.onBrowseHeritage,
  });

  final bool isSubscribed;
  final VoidCallback onOpenPricing;
  final VoidCallback onBrowseHeritage;

  @override
  ConsumerState<LandingChefCompanion> createState() =>
      _LandingChefCompanionState();
}

class _LandingChefCompanionState extends ConsumerState<LandingChefCompanion> {
  final _messages = <LandingChefMessage>[
    LandingChefMessage(
      id: 'welcome',
      isChef: true,
      text:
          'Salaam culinary explorer! I am Chef Tariq, your virtual SpiceRoute travel companion. Ask me anything—from local ingredient substitutions (like what to swap for fresh galangal), blooming secret spices, to building a completely custom spiced menu for your kitchen. Where shall we depart today?',
      timestamp: DateTime.now(),
    ),
  ];
  final _input = TextEditingController();
  final _scroll = ScrollController();
  var _loading = false;

  late final _ingredientCtl = TextEditingController(text: 'Organic Tofu & Mushrooms');
  var _style = 'Southeast Asia';
  var _spice = 'Hot';
  var _generating = false;
  String? _generatedRecipe;

  static const _chips = [
    (
      '🌿 Substitute Galangal',
      'What can I substitute for fresh galangal in SE Asian curries?',
    ),
    (
      '🌾 Saffron Pairing Ideas',
      'How do I pair saffron threads in Mediterranean or Persian cooking?',
    ),
    (
      '🔥 Secrets to Bloom Cumin',
      'Explain the chef secrets of blooming whole cumin seeds in oils.',
    ),
  ];

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    _ingredientCtl.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _loading) return;
    setState(() {
      _messages.add(
        LandingChefMessage(
          id: '${DateTime.now().millisecondsSinceEpoch}',
          isChef: false,
          text: trimmed,
          timestamp: DateTime.now(),
        ),
      );
      _input.clear();
      _loading = true;
    });
    _scrollToEnd();
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _messages.add(
        LandingChefMessage(
          id: '${DateTime.now().millisecondsSinceEpoch + 1}',
          isChef: true,
          text: _demoChefReply(trimmed),
          timestamp: DateTime.now(),
        ),
      );
      _loading = false;
    });
    _scrollToEnd();
  }

  String _demoChefReply(String prompt) {
    return 'Chef Tariq suggests: for "$prompt", start with whole spices toasted in neutral oil until fragrant, then build your base with layered acid and sweetness. Bloom cumin seeds in oil until they crackle—that is the secret handshake of the spice route.';
  }

  Future<void> _generateRecipe() async {
    if (_ingredientCtl.text.trim().isEmpty || _generating) return;
    setState(() {
      _generating = true;
      _generatedRecipe = null;
    });
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _generatedRecipe =
          '### $_style $_spice Creation\n\n'
          '**Hero ingredient:** ${_ingredientCtl.text}\n\n'
          '- Bloom aromatics in oil until the kitchen smells like the spice route\n'
          '- Layer acid and sweetness to balance the $_spice heat profile\n'
          '- Finish with fresh herbs and a squeeze of citrus';
      _generating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1024;
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0x1A1A1A1A)),
          bottom: BorderSide(color: Color(0x1A1A1A1A)),
        ),
      ),
      color: LandingPalette.alabaster,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: LandingMaxWidth(
        child: Column(
          children: [
            const LandingSectionHeader(
              badge: 'Travel Toolkit',
              title: 'Interactive Travel Toolkit',
              subtitle:
                  'Step away from generic static lists. Experiment with modular AI engines crafted to deliver personalized, heritage-informed culinary guidance.',
              icon: Icons.explore,
              center: true,
            ),
            const SizedBox(height: 48),
            LandingResponsiveRow(
              wide: wide,
              children: [
                _ExplorationCard(
                  onBrowseHeritage: widget.onBrowseHeritage,
                ),
                _ChatCard(
                  messages: _messages,
                  loading: _loading,
                  input: _input,
                  scroll: _scroll,
                  onSend: _send,
                  chips: _chips,
                ),
                _GeneratorCard(
                  ingredientCtl: _ingredientCtl,
                  style: _style,
                  spice: _spice,
                  generating: _generating,
                  generated: _generatedRecipe,
                  onStyle: (v) => setState(() => _style = v),
                  onSpice: (v) => setState(() => _spice = v),
                  onGenerate: _generateRecipe,
                  onClear: () => setState(() => _generatedRecipe = null),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExplorationCard extends StatelessWidget {
  const _ExplorationCard({required this.onBrowseHeritage});

  final VoidCallback onBrowseHeritage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: Icon(
              Icons.map,
              size: 160,
              color: LandingPalette.charcoal.withValues(alpha: 0.05),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: LandingPalette.cream,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: LandingPalette.charcoal.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: LandingPalette.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.map, color: LandingPalette.red),
                ),
                const SizedBox(height: 16),
                Text(
                  'Hyper-Local Exploration',
                  style: LandingPalette.serif(context, size: 20),
                ),
                const SizedBox(height: 12),
                Text(
                  'Filter and discover dishes by highly specific local traditions and historic heritage cooking processes rather than generic country labels.',
                  style: LandingPalette.sans(
                    context,
                    size: 14,
                    color: LandingPalette.charcoal.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 16),
                const _ExplorationBullet(
                  text: 'Decode regional spice profiles by sub-continent',
                ),
                const _ExplorationBullet(
                  text: 'Trace ingredient lineages across trade routes',
                ),
                const _ExplorationBullet(
                  text: 'Unlock heritage cooking techniques per hub',
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onBrowseHeritage,
                  icon: const Icon(Icons.arrow_forward, size: 14),
                  label: const Text('Learn culinary histories'),
                  style: TextButton.styleFrom(
                    foregroundColor: LandingPalette.red,
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatCard extends StatelessWidget {
  const _ChatCard({
    required this.messages,
    required this.loading,
    required this.input,
    required this.scroll,
    required this.onSend,
    required this.chips,
  });

  final List<LandingChefMessage> messages;
  final bool loading;
  final TextEditingController input;
  final ScrollController scroll;
  final Future<void> Function(String) onSend;
  final List<(String, String)> chips;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(minHeight: 480),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: LandingPalette.charcoal.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: LandingPalette.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('👨‍🍳', style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chef Tariq',
                      style: LandingPalette.serif(context, size: 14),
                    ),
                    Text(
                      'AI CHAT COMPANION',
                      style: LandingPalette.mono(context, size: 9),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.help_outline,
                size: 18,
                color: LandingPalette.charcoal.withValues(alpha: 0.45),
              ),
            ],
          ),
          const Divider(height: 24),
          SizedBox(
            height: 360,
            child: ListView.builder(
              controller: scroll,
              itemCount: messages.length + (loading ? 1 : 0),
              itemBuilder: (context, i) {
                if (loading && i == messages.length) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: LandingPalette.red.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tariq is grinding spices...',
                          style: LandingPalette.mono(
                            context,
                            size: 10,
                            color: LandingPalette.charcoal.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final m = messages[i];
                return Align(
                  alignment: m.isChef
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 280),
                    decoration: BoxDecoration(
                      color: m.isChef
                          ? LandingPalette.alabaster
                          : LandingPalette.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: m.isChef
                        ? LandingMarkdownBody(text: m.text, chef: true)
                        : Text(
                            m.text,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final chip in chips)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _ChefChip(
                      label: chip.$1,
                      onTap: loading ? null : () => onSend(chip.$2),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: input,
                  decoration: InputDecoration(
                    hintText: 'Ask Tariq about any ingredient...',
                    filled: true,
                    fillColor: LandingPalette.alabaster,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: LandingPalette.charcoal.withValues(alpha: 0.1),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: LandingPalette.charcoal.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  onSubmitted: onSend,
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: loading ? null : () => onSend(input.text),
                style: FilledButton.styleFrom(
                  backgroundColor: LandingPalette.red,
                  minimumSize: const Size(48, 48),
                ),
                child: const Icon(Icons.send, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GeneratorCard extends StatelessWidget {
  const _GeneratorCard({
    required this.ingredientCtl,
    required this.style,
    required this.spice,
    required this.generating,
    required this.generated,
    required this.onStyle,
    required this.onSpice,
    required this.onGenerate,
    required this.onClear,
  });

  final TextEditingController ingredientCtl;
  final String style;
  final String spice;
  final bool generating;
  final String? generated;
  final ValueChanged<String> onStyle;
  final ValueChanged<String> onSpice;
  final VoidCallback onGenerate;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(minHeight: 480),
      decoration: BoxDecoration(
        color: LandingPalette.cream,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: LandingPalette.charcoal.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: LandingPalette.charcoal,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  color: LandingPalette.saffron,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recipe Generator',
                      style: LandingPalette.serif(context, size: 14),
                    ),
                    Text(
                      'CO-CREATE HERITAGE DISHES',
                      style: LandingPalette.mono(context, size: 9),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.layers_outlined,
                size: 16,
                color: LandingPalette.charcoal.withValues(alpha: 0.4),
              ),
            ],
          ),
          const Divider(height: 24),
          if (generated == null) ...[
            Text(
              'WHAT INGREDIENTS DO YOU HAVE?',
              style: LandingPalette.mono(context, size: 9),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: ingredientCtl,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'PREFERRED REGIONAL STYLE',
              style: LandingPalette.mono(context, size: 9),
            ),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.8,
              children: [
                for (final entry in const {
                  'Southeast Asia': '🌏 SE Asia',
                  'South Asia': '🌾 South Asia',
                  'Middle East': '🏺 Mid East',
                  'East Asia': '🥢 East Asia',
                }.entries)
                  _StyleButton(
                    label: entry.value,
                    selected: style == entry.key,
                    onTap: generating ? null : () => onStyle(entry.key),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'HEAT & SPICE LEVEL',
              style: LandingPalette.mono(context, size: 9),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final l in ['Mild', 'Medium', 'Hot', 'Numbing'])
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: l != 'Numbing' ? 6 : 0,
                      ),
                      child: _SpiceButton(
                        label: l == 'Numbing' ? '🌶️🌶️ $l' : l,
                        selected: spice == l,
                        onTap: generating ? null : () => onSpice(l),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: generating ? null : onGenerate,
                style: FilledButton.styleFrom(
                  backgroundColor: LandingPalette.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: Icon(
                  generating ? Icons.hourglass_top : Icons.auto_awesome,
                  size: 16,
                ),
                label: Text(
                  generating
                      ? 'COMPOUNDING SPICE AROMAS...'
                      : 'GENERATE CUSTOM RECIPE',
                ),
              ),
            ),
          ] else ...[
            SizedBox(
              height: 280,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: LandingPalette.charcoal.withValues(alpha: 0.15),
                    ),
                  ),
                  child: LandingMarkdownBody(
                    text: generated!,
                    chef: false,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onClear,
                    child: const Text('Create Another'),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: generated!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Recipe copied!')),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: LandingPalette.charcoal,
                  ),
                  child: const Text('Copy Recipe'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ExplorationBullet extends StatelessWidget {
  const _ExplorationBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: LandingPalette.red)),
          Expanded(
            child: Text(
              text,
              style: LandingPalette.sans(
                context,
                size: 13,
                color: LandingPalette.charcoal.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChefChip extends StatefulWidget {
  const _ChefChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  State<_ChefChip> createState() => _ChefChipState();
}

class _ChefChipState extends State<_ChefChip> {
  var _hover = false;

  @override
  Widget build(BuildContext context) {
    final active = _hover;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: active ? LandingPalette.red : LandingPalette.alabaster,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: active
                  ? LandingPalette.red
                  : LandingPalette.charcoal.withValues(alpha: 0.1),
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: active
                  ? Colors.white
                  : LandingPalette.charcoal.withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}

class _StyleButton extends StatelessWidget {
  const _StyleButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? LandingPalette.charcoal : Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? LandingPalette.charcoal
                  : LandingPalette.charcoal.withValues(alpha: 0.1),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: selected
                  ? Colors.white
                  : LandingPalette.charcoal.withValues(alpha: 0.8),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _SpiceButton extends StatelessWidget {
  const _SpiceButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? LandingPalette.red : Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? LandingPalette.red
                  : LandingPalette.charcoal.withValues(alpha: 0.1),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: selected
                  ? Colors.white
                  : LandingPalette.charcoal.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}
