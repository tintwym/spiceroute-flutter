import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'landing_state.dart';
import 'landing_data.dart';
import 'landing_palette.dart';
import 'widgets/landing_taste_map.dart';

/// Compact labels for the hero quick-sectors ticker (full names live on the map).
const _quickSectorTicker = <({String id, String label})>[
  (id: 'europe', label: 'Europe'),
  (id: 'me-africa', label: 'Mid East & Africa'),
  (id: 'south-asia', label: 'South Asia'),
  (id: 'se-asia', label: 'Mainland SE Asia'),
  (id: 'maritime-se-asia', label: 'Maritime SE Asia'),
  (id: 'east-asia', label: 'East Asia'),
  (id: 'americas', label: 'Americas'),
];

class SpiceRouteLandingPage extends ConsumerStatefulWidget {
  const SpiceRouteLandingPage({super.key});

  @override
  ConsumerState<SpiceRouteLandingPage> createState() =>
      _SpiceRouteLandingPageState();
}

class _SpiceRouteLandingPageState extends ConsumerState<SpiceRouteLandingPage> {
  // Global States matching the web application
  bool isAnnualBilling = false;
  double seatsCount = 5.0;
  String activeRegionId = 'me-africa';
  // Dynamic Chat with Chef Tariq mockup state
  final List<Map<String, String>> chatMessages = [
    {
      'role': 'model',
      'text': 'Salaam culinary explorer! I am Chef Tariq, your virtual SpiceRoute travel companion. Ask me anything—from local ingredient substitutions (like what to swap for fresh galangal), blooming secret spices, to building a completely custom spiced menu for your kitchen. Where shall we depart today?'
    }
  ];
  final TextEditingController chatController = TextEditingController();
  final TextEditingController handleController = TextEditingController();
  final TextEditingController dishController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final GlobalKey _tasteMapKey = GlobalKey();
  final GlobalKey _toolkitKey = GlobalKey();
  final GlobalKey _terminalKey = GlobalKey();
  final GlobalKey _pricingKey = GlobalKey();

  String selectedStampRegion = 'Europe';
  String recipeStyle = '🌏 SE Asia';
  String heatLevel = 'Hot';

  @override
  void dispose() {
    chatController.dispose();
    handleController.dispose();
    dishController.dispose();
    reviewController.dispose();
    ingredientsController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }

  Future<void> _enterApp() async {
    await ref.read(landingGateProvider.notifier).completeOnboarding();
    if (!mounted) return;
    context.go('/');
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _showChefHelp() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Chef Tariq'),
        content: const Text(
          'Ask about ingredient swaps, spice pairings, or regional cooking '
          'techniques. Suggestion chips send a starter question for you.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  void _submitStamp() {
    final handle = handleController.text.trim();
    final dish = dishController.text.trim();
    final review = reviewController.text.trim();
    if (handle.isEmpty || dish.isEmpty || review.isEmpty) {
      _toast('Fill in your handle, dish name, and review before stamping.');
      return;
    }
    setState(() {
      socialFeed.insert(0, {
        'handle': handle.startsWith('@') ? handle : '@$handle',
        'dish': dish,
        'review': review,
        'time': 'Just now',
        'region': selectedStampRegion,
        'stamps': 0,
        'imageUrl':
            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&auto=format&fit=crop&q=60',
        'tags': [selectedStampRegion.split(' ').first, 'HomeKitchen'],
      });
    });
    handleController.clear();
    dishController.clear();
    reviewController.clear();
    _toast('Stamp posted to the global culinary board!');
  }

  void _generateRecipe() {
    final ingredients = ingredientsController.text.trim();
    if (ingredients.isEmpty) {
      _toast('List a few ingredients to generate a heritage-style recipe.');
      return;
    }
    _toast(
      'Generating a $heatLevel $recipeStyle dish with: $ingredients',
    );
  }

  void _joinHub() {
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _toast('Enter a valid email to join the hub.');
      return;
    }
    _enterApp();
  }

  // Social feed live list
  final List<Map<String, dynamic>> socialFeed = [
    {
      'handle': '@marco_eats',
      'dish': 'Risotto alla Milanese',
      'review': 'Perfectly golden! The saffron aroma is absolutely intoxicating. Grounded it in my stone mortar and did the traditional Lombardo Mantecatura technique.',
      'time': '2 hours ago',
      'region': 'Europe',
      'stamps': 42,
      'imageUrl': 'https://images.unsplash.com/photo-1595908129746-57ca1a63dd4d?w=600&auto=format&fit=crop&q=60',
      'tags': ['Saffron', 'ItalianTradition', 'Risotto']
    },
    {
      'handle': '@wei_chef',
      'dish': 'Sichuan Mapo Tofu',
      'review': 'Highly authentic, numbing, and fiery! Finished with a heavy dusting of freshly roasted and ground Sichuan peppercorns.',
      'time': '2 days ago',
      'region': 'East Asia',
      'stamps': 156,
      'imageUrl': 'https://images.unsplash.com/photo-1541832676-9b763b0239ab?w=600&auto=format&fit=crop&q=60',
      'tags': ['MapoTofu', 'SichuanPepper', 'SpicyWok']
    },
    {
      'handle': '@sara_travels',
      'dish': 'Cambodian Fish Amok',
      'review': 'Took me straight back to Siem Reap! Hand-ground the Kroeung paste using fresh lemongrass from the farmer\'s market. Steamed in real banana leaves!',
      'time': '5 hours ago',
      'region': 'Mainland SE Asia',
      'stamps': 89,
      'imageUrl': 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=60',
      'tags': ['Amok', 'KhmerCuisine', 'Lemongrass']
    },
    {
      'handle': '@nasi_rendang',
      'dish': 'West Sumatran Beef Rendang',
      'review': 'Took 3 hours but absolutely worth every second. The toasted kerisik and coconut oil caramelization coated the beef in the most delicious mahogany crust!',
      'time': '3 days ago',
      'region': 'Mainland SE Asia',
      'stamps': 198,
      'imageUrl': 'https://images.unsplash.com/photo-1601050690597-df056fb4ce78?w=600&auto=format&fit=crop&q=60',
      'tags': ['BeefRendang', 'Sumatra', 'SpiceIslands']
    },
  ];

  // Boarding card random dynamic state
  String ticketDestination = 'Marrakesh, Morocco';
  String ticketDuration = '45 MIN';
  String ticketGate = 'GATE 3B';

  void spinTheGlobe() {
    final destinations = [
      {'dest': 'Marrakesh, Morocco', 'dur': '45 MIN', 'gate': 'GATE 3B'},
      {'dest': 'Chengdu, China', 'dur': '30 MIN', 'gate': 'GATE 8A'},
      {'dest': 'Solo, Indonesia', 'dur': '3 HOURS', 'gate': 'GATE 12C'},
      {'dest': 'Kochi, India', 'dur': '1 HOUR', 'gate': 'GATE 5F'},
      {'dest': 'Oaxaca, Mexico', 'dur': '2 HOURS', 'gate': 'GATE 2B'},
    ];
    final randomIdx = (DateTime.now().millisecondsSinceEpoch % destinations.length);
    setState(() {
      ticketDestination = destinations[randomIdx]['dest']!;
      ticketDuration = destinations[randomIdx]['dur']!;
      ticketGate = destinations[randomIdx]['gate']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildHero(context, isDesktop),
            _buildQuickSectors(context),
            _buildTasteMapSection(context, isDesktop),
            _buildInteractiveToolkitSection(context, isDesktop),
            _buildCulinaryBoardSection(context, isDesktop),
            _buildPricingSection(context, isDesktop),
            _buildReadyToDepartSection(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFC05621),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.restaurant, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'SpiceRoute',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1E293B),
                    ),
              ),
            ],
          ),
          if (MediaQuery.of(context).size.width <= 768)
            IconButton(
              onPressed: _enterApp,
              tooltip: 'Get boarding pass',
              icon: const Icon(Icons.airplane_ticket, color: Color(0xFF1E293B)),
            )
          else
            Row(
              children: [
                _buildHeaderLink('The Taste Map', () => _scrollTo(_tasteMapKey)),
                _buildHeaderLink('AI Travel Companion', () => _scrollTo(_toolkitKey)),
                _buildHeaderLink('The Global Terminal', () => _scrollTo(_terminalKey)),
                _buildHeaderLink('Pricing Tiers', () => _scrollTo(_pricingKey)),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _enterApp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.airplane_ticket, size: 16),
                      SizedBox(width: 8),
                      Text('GET BOARDING PASS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderLink(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF18181B), // Dark rustic charcoal background
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=1600&auto=format&fit=crop&q=80'),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.stars, color: Colors.orange.shade400, size: 14),
                    const SizedBox(width: 6),
                    const Text(
                      'SOCIETY OF GLOBAL COOKS',
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildHeroLeft(context)),
                    const SizedBox(width: 48),
                    Expanded(flex: 2, child: _buildHeroRight(context)),
                  ],
                )
              else
                Column(
                  children: [
                    _buildHeroLeft(context),
                    const SizedBox(height: 40),
                    _buildHeroRight(context),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroLeft(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 520;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.1,
            ),
            children: [
              TextSpan(text: 'Stamp Your\n'),
              TextSpan(text: 'Culinary Passport.\n', style: TextStyle(color: Color(0xFFE28743))),
              TextSpan(text: 'No Flight Required.'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Explore authentic heritage recipes, unearth localized cooking secrets, and co-create bespoke spiced menus with Chef Tariq—your interactive virtual travel chef.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: Colors.grey.shade400,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        if (narrow)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: spinTheGlobe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1E293B),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.public, color: Color(0xFFC05621)),
                    SizedBox(width: 8),
                    Text(
                      'SPIN THE GLOBE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _scrollTo(_tasteMapKey),
                child: Row(
                  children: [
                    Text(
                      'OR BROWSE MAP',
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.grey.shade300,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              ElevatedButton(
                onPressed: spinTheGlobe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1E293B),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.public, color: Color(0xFFC05621)),
                    SizedBox(width: 8),
                    Text(
                      'SPIN THE GLOBE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () => _scrollTo(_tasteMapKey),
                child: Row(
                  children: [
                    Text(
                      'OR BROWSE MAP',
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.grey.shade300,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        const SizedBox(height: 48),
        // Stats
        if (narrow)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatItem('30+', 'REGIONAL HUBS'),
              const SizedBox(height: 24),
              _buildStatItem('1k+', 'EXPERT RECIPES'),
              const SizedBox(height: 24),
              _buildStatItem('24/7', 'AI CHEF SUPPORT'),
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildStatItem('30+', 'REGIONAL HUBS'),
              const SizedBox(width: 32),
              _buildStatItem('1k+', 'EXPERT RECIPES'),
              const SizedBox(width: 32),
              _buildStatItem('24/7', 'AI CHEF SUPPORT'),
            ],
          ),
      ],
    );
  }

  Widget _buildStatItem(String val, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          val,
          style: const TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE28743),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroRight(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4EFE6), // Authentic retro boarding ticket paper color
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'BOARDING PASS VOUCHER',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC05621),
                ),
              ),
              Text(
                'SPICEROUTE',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1, color: Colors.black12),
          const SizedBox(height: 8),
          const Text('PASSENGER LEVEL', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 9, color: Colors.grey)),
          const Text('Culinary Enthusiast', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('FLIGHT ROUTE DESTINATION', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 9, color: Colors.grey)),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Color(0xFFC05621)),
                      const SizedBox(width: 4),
                      Text(ticketDestination, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('FLIGHT GATE', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 9, color: Colors.grey)),
                  Text(ticketGate, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFFC05621))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('DURATION ESTIMATE', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 9, color: Colors.grey)),
          Text('$ticketDuration // READY FOR IMMERSIVE TASTE', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
          const SizedBox(height: 24),
          // Barcode representation
          Container(
            height: 48,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1543269865-cbf427effbad?w=200&auto=format&fit=crop&q=40'), // Fallback barcode style
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
              color: Colors.white70,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(40, (index) {
                final double width = (index % 3 == 0) ? 4.0 : (index % 2 == 0) ? 2.0 : 1.0;
                return Container(
                  width: width,
                  color: Colors.black87,
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'SR-PASS-2026-IMMERSIVE-PORTAL',
              style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 8, letterSpacing: 1.0, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSectors(BuildContext context) {
    return ColoredBox(
      color: LandingPalette.quickSectorsBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 24, right: 12),
              child: Text(
                'QUICK SECTORS:',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9CA3AF),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 24),
                child: Row(
                  children: [
                    for (var i = 0; i < _quickSectorTicker.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      _buildQuickSectorChip(_quickSectorTicker[i]),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSectorChip(({String id, String label}) sector) {
    final region = landingRegionsData.firstWhere((r) => r.id == sector.id);
    final isActive = activeRegionId == sector.id;
    return InkWell(
      onTap: () => setState(() => activeRegionId = sector.id),
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFFC05621)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isActive
                ? const Color(0xFFC05621)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(region.icon),
            const SizedBox(width: 6),
            Text(
              sector.label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? Colors.white : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasteMapSection(BuildContext context, bool isDesktop) {
    return KeyedSubtree(
      key: _tasteMapKey,
      child: LandingTasteMap(
        embedded: true,
        activeRegionId: activeRegionId,
        onRegionChanged: (id) => setState(() => activeRegionId = id),
      ),
    );
  }

  Widget _buildInteractiveToolkitSection(BuildContext context, bool isDesktop) {
    return Container(
      key: _toolkitKey,
      color: const Color(0xFFFAF7F2), // Very soft cream tint
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFC05621).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'TRAVEL TOOLKIT',
                  style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFC05621)),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Interactive Travel Toolkit',
                style: TextStyle(fontFamily: 'Playfair Display', fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const Text(
                'Step away from generic static lists. Experiment with modular AI engines crafted to deliver personalized, heritage-informed culinary guidance.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 48),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildToolkitCardOne(context)),
                    const SizedBox(width: 24),
                    Expanded(child: _buildToolkitCardTwo(context)),
                    const SizedBox(width: 24),
                    Expanded(child: _buildToolkitCardThree(context)),
                  ],
                )
              else
                Column(
                  children: [
                    _buildToolkitCardOne(context),
                    const SizedBox(height: 24),
                    _buildToolkitCardTwo(context),
                    const SizedBox(height: 24),
                    _buildToolkitCardThree(context),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolkitCardOne(BuildContext context) {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFFBE9E7), shape: BoxShape.circle),
            child: const Icon(Icons.map, color: Color(0xFFC05621)),
          ),
          const SizedBox(height: 24),
          const Text('Hyper-Local Exploration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 12),
          const Text(
            'Filter and discover dishes by highly specific local traditions and historic heritage cooking processes rather than generic country labels.',
            style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF64748B)),
          ),
          const Spacer(),
          _buildDetailRow('🗺️', 'Micro-region culinary heritages'),
          _buildDetailRow('🏺', 'Clay pot, tandoor, & steamer charts'),
          _buildDetailRow('🍂', 'Ancient spice route timelines & tracing'),
          const Spacer(),
          TextButton(
            onPressed: () => _scrollTo(_tasteMapKey),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Learn culinary histories', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(emoji),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
        ],
      ),
    );
  }

  Widget _buildToolkitCardTwo(BuildContext context) {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chef Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFC05621),
                  child: Text('👨‍🍳'),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Chef Tariq 🌟', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text('AI CHAT COMPANION', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 8, color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: _showChefHelp,
                  icon: const Icon(Icons.help_outline, size: 18),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.black12),
          // Chat Body
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: chatMessages.length,
              itemBuilder: (context, idx) {
                final msg = chatMessages[idx];
                final isChef = msg['role'] == 'model';
                return Align(
                  alignment: isChef ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isChef ? const Color(0xFFF5EFEB) : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg['text']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isChef ? const Color(0xFF1E293B) : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Suggestions Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSuggestChip('Substitute Galangal'),
                  _buildSuggestChip('Saffron Pairing Ideas'),
                ],
              ),
            ),
          ),
          // Chat input bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatController,
                    decoration: InputDecoration(
                      hintText: 'Ask Tariq about spices...',
                      hintStyle: const TextStyle(fontSize: 12),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFFC05621),
                  child: IconButton(
                    onPressed: () {
                      if (chatController.text.trim().isEmpty) return;
                      setState(() {
                        chatMessages.add({'role': 'user', 'text': chatController.text});
                        chatMessages.add({
                          'role': 'model',
                          'text': 'Ah, a fascinating question! When substituting, you can often approximate with similar root rhizomes. Let me consult my virtual terminal archives...'
                        });
                        chatController.clear();
                      });
                    },
                    icon: const Icon(Icons.send, color: Colors.white, size: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestChip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () {
          setState(() {
            chatMessages.add({'role': 'user', 'text': text});
            chatMessages.add({
              'role': 'model',
              'text': 'Let me generate the substitution guidance for your chosen spice right away!'
            });
          });
        },
        child: Chip(
          label: Text(text, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.grey.shade100,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildToolkitCardThree(BuildContext context) {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Color(0xFFFFF3E0), shape: BoxShape.circle),
                child: const Icon(Icons.eco, color: Colors.orange),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recipe Generator', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text('CO-CREATE HERITAGE DISHES', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 8, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const Spacer(),
          const Text('WHAT INGREDIENTS DO YOU HAVE?', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 9, color: Colors.grey)),
          const SizedBox(height: 6),
          TextField(
            controller: ingredientsController,
            decoration: InputDecoration(
              hintText: 'e.g. Organic Tofu & Mushrooms',
              hintStyle: const TextStyle(fontSize: 12),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
            ),
          ),
          const Spacer(),
          const Text('PREFERRED REGIONAL STYLE', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 9, color: Colors.grey)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildStyleChip('🌏 SE Asia'),
              _buildStyleChip('🌾 South Asia'),
              _buildStyleChip('🕌 Mid East'),
              _buildStyleChip('🥢 East Asia'),
            ],
          ),
          const Spacer(),
          const Text('HEAT & SPICE LEVEL', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 9, color: Colors.grey)),
          const SizedBox(height: 6),
          Row(
            children: [
              _buildHeatChip('Mild'),
              _buildHeatChip('Medium'),
              _buildHeatChip('Hot'),
              _buildHeatChip('Numbing'),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _generateRecipe,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC05621),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, size: 16),
                  SizedBox(width: 8),
                  Text('GENERATE CUSTOM RECIPE', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleChip(String label) {
    final active = recipeStyle == label;
    return InkWell(
      onTap: () => setState(() => recipeStyle = label),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? Colors.transparent : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: active ? Colors.white : const Color(0xFF1E293B)),
        ),
      ),
    );
  }

  Widget _buildHeatChip(String label) {
    final active = heatLevel == label;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => heatLevel = label),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFC05621) : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: active ? Colors.transparent : Colors.grey.shade300),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: active ? Colors.white : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCulinaryBoardSection(BuildContext context, bool isDesktop) {
    return Container(
      key: _terminalKey,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFC05621).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'THE CULINARY BOARD',
                  style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFC05621)),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Live From Kitchens Around the Globe',
                style: TextStyle(fontFamily: 'Playfair Display', fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const Text(
                'See how our virtual boarding tier is performing. Real cooks stamping their physical culinary passports and cooking real dishes right now.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 48),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildCulinaryBoardLeft(context)),
                    const SizedBox(width: 32),
                    Expanded(flex: 3, child: _buildCulinaryBoardRight(context)),
                  ],
                )
              else
                Column(
                  children: [
                    _buildCulinaryBoardLeft(context),
                    const SizedBox(height: 40),
                    _buildCulinaryBoardRight(context),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCulinaryBoardLeft(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Share Your Culinary Stamp', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const Text('POST TO THE GLOBAL BOARD', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 8, color: Colors.grey)),
          const SizedBox(height: 24),
          const Text('COOK PROFILE HANDLE', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 9, color: Colors.grey)),
          const SizedBox(height: 6),
          TextField(
            controller: handleController,
            decoration: InputDecoration(
              hintText: 'e.g. @chef_clara',
              hintStyle: const TextStyle(fontSize: 12),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),
          const Text('SELECT PASSPORT STAMP', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 9, color: Colors.grey)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStampSel('East Asia', '🍣'),
              _buildStampSel('Mainland SE Asia', '🍜'),
              _buildStampSel('South Asia', '🌶️'),
              _buildStampSel('Europe', '🍕'),
            ],
          ),
          const SizedBox(height: 16),
          const Text('DISH NAME', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 9, color: Colors.grey)),
          const SizedBox(height: 6),
          TextField(
            controller: dishController,
            decoration: InputDecoration(
              hintText: 'Risotto alla Milanese',
              hintStyle: const TextStyle(fontSize: 12),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),
          const Text('REVIEW & EXPERIENCE', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 9, color: Colors.grey)),
          const SizedBox(height: 6),
          TextField(
            controller: reviewController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Describe your kitchen departure experience...',
              hintStyle: const TextStyle(fontSize: 12),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitStamp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E293B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.approval, size: 16),
                  SizedBox(width: 8),
                  Text('STAMP CULINARY PASSPORT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStampSel(String label, String emoji) {
    final isSelected = selectedStampRegion == label;
    return InkWell(
      onTap: () => setState(() => selectedStampRegion = label),
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC05621).withValues(alpha: 0.1) : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: isSelected ? const Color(0xFFC05621) : Colors.black12),
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget _buildCulinaryBoardRight(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 600;
    if (!isWide) {
      return Column(
        children: [
          for (var idx = 0; idx < socialFeed.length; idx++) ...[
            if (idx > 0) const SizedBox(height: 16),
            _buildSocialFeedCard(socialFeed[idx]),
          ],
        ],
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.92,
      ),
      itemCount: socialFeed.length,
      itemBuilder: (context, idx) => _buildSocialFeedCard(socialFeed[idx]),
    );
  }

  Widget _buildSocialFeedCard(Map<String, dynamic> item) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.black.withValues(alpha: 0.04)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSocialFeedImage(item['imageUrl'] as String),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['handle'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC05621),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item['time'] as String,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item['dish'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['review'] as String,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF475569),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: (item['tags'] as List<String>)
                            .map(
                              (t) => Text(
                                '#$t',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.stars, size: 12, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text(
                          '${item['stamps']}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialFeedImage(String imageUrl) {
    return SizedBox(
      width: double.infinity,
      height: 140,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          color: const Color(0xFFF1F5F9),
          alignment: Alignment.center,
          child: const Icon(
            Icons.restaurant_outlined,
            size: 36,
            color: Color(0xFF94A3B8),
          ),
        ),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: const Color(0xFFF1F5F9),
            alignment: Alignment.center,
            child: const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context, bool isDesktop) {
    double tierPrice = 9.99;
    double estimatedMonthly = seatsCount * tierPrice;
    if (isAnnualBilling) {
      estimatedMonthly = estimatedMonthly * 0.8; // 20% discount
    }

    return Container(
      key: _pricingKey,
      color: const Color(0xFFFAF7F2),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFC05621).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'TRANSPARENT PRICING',
                  style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFC05621)),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Predictable passport tiers scaled to fits cooks of all sizes.',
                style: TextStyle(fontFamily: 'Playfair Display', fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const Text(
                'Choose a fixed package or estimate your custom restaurant crew size below. No hidden fees. Lock in the annual savings discount today.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 32),
              // Billing switch
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Monthly Billing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Switch(
                    value: isAnnualBilling,
                    onChanged: (val) {
                      setState(() {
                        isAnnualBilling = val;
                      });
                    },
                    activeThumbColor: const Color(0xFFC05621),
                  ),
                  Row(
                    children: [
                      const Text('Annual Billing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(4)),
                        child: const Text('SAVE 20%', style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 48),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildPriceCard('GROWTH / FREE', '\$0', 'Perfect for casual home cooks exploring authentic heritage recipes and our Interactive world map.', ['View complete heritage recipes', 'Interactive world map', 'AI Chatbot with Chef Tariq', 'Custom AI Recipe Generator'], 'ACTIVE PLAN', false, _enterApp)),
                    const SizedBox(width: 24),
                    Expanded(child: _buildPriceCard('PRO / PASS', isAnnualBilling ? '\$7.99' : '\$9.99', 'The standard choice for curious epicureans seeking Instant culinary knowledge, custom menus, and unlimited co-creation.', ['Everything in Growth Free Pass', 'Unlimited AI Chat with Chef Tariq', 'Custom AI Recipe Generator', 'Unlimited Spin the Globe draws'], 'START PREMIUM TRIAL', true, () {
                      _toast('Premium trial started — welcome aboard!');
                      _enterApp();
                    })),
                    const SizedBox(width: 24),
                    Expanded(child: _buildPriceCard('ENTERPRISE', 'Custom', 'Custom setups for culinary schools, commercial kitchens, and restaurant chains requiring private API limits.', ['Everything in Premium Pass', 'Dedicated Private Server Nodes', 'Localized menu database sync', 'Shared workspace & custom billing'], 'CONTACT SALES', false, () => _toast('Email sales@spiceroute.app for enterprise pricing.'))),
                  ],
                )
              else
                Column(
                  children: [
                    _buildPriceCard('GROWTH / FREE', '\$0', 'Perfect for casual home cooks exploring authentic heritage recipes.', ['View complete heritage recipes', 'Interactive world map', 'AI Chatbot with Chef Tariq', 'Custom AI Recipe Generator'], 'ACTIVE PLAN', false, _enterApp),
                    const SizedBox(height: 24),
                    _buildPriceCard('PRO / PASS', isAnnualBilling ? '\$7.99' : '\$9.99', 'The standard choice for curious epicureans.', ['Everything in Growth Free Pass', 'Unlimited AI Chat with Chef Tariq', 'Custom AI Recipe Generator', 'Unlimited Spin the Globe draws'], 'START PREMIUM TRIAL', true, () {
                      _toast('Premium trial started — welcome aboard!');
                      _enterApp();
                    }),
                    const SizedBox(height: 24),
                    _buildPriceCard('ENTERPRISE', 'Custom', 'Custom setups for culinary schools.', ['Everything in Premium Pass', 'Dedicated Private Server Nodes', 'Localized menu database sync', 'Shared workspace & custom billing'], 'CONTACT SALES', false, () => _toast('Email sales@spiceroute.app for enterprise pricing.')),
                  ],
                ),
              const SizedBox(height: 64),
              // Custom Estimator Card
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('CUSTOM ESTIMATOR', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 9, color: Colors.grey)),
                    ),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Need custom passes for specific crews?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Drag the estimator slider below to calculate precise monthly pricing for your exact staff count.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ),
                    const SizedBox(height: 32),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final stackEstimator = constraints.maxWidth < 560;
                        final sliderColumn = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Calculated Seats: ${seatsCount.toInt()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Slider(
                              value: seatsCount,
                              min: 1,
                              max: 50,
                              activeColor: const Color(0xFFC05621),
                              onChanged: (val) {
                                setState(() {
                                  seatsCount = val;
                                });
                              },
                            ),
                          ],
                        );
                        final billingCard = Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'ESTIMATED BILLING',
                                style: TextStyle(
                                  fontFamily: 'JetBrains Mono',
                                  fontSize: 8,
                                  color: Colors.grey,
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '\$${estimatedMonthly.toStringAsFixed(2)}/mo',
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                isAnnualBilling
                                    ? 'Billed annually (20% off)'
                                    : 'Billed monthly',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => _toast(
                                    'Locked \$${estimatedMonthly.toStringAsFixed(2)}/mo for ${seatsCount.toInt()} seats.',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFC05621),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'LOCK IN PRICE',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (stackEstimator) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              sliderColumn,
                              const SizedBox(height: 20),
                              billingCard,
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: sliderColumn),
                            const SizedBox(width: 24),
                            Expanded(flex: 2, child: billingCard),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceCard(String tier, String price, String desc, List<String> bulletPoints, String btnLabel, bool isPopular, VoidCallback onPressed) {
    return Container(
      height: 480,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isPopular ? const Color(0xFFC05621) : Colors.black.withValues(alpha: 0.04), width: isPopular ? 2 : 1),
        boxShadow: [
          if (isPopular)
            BoxShadow(
              color: const Color(0xFFC05621).withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tier, style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
              if (isPopular)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFC05621), borderRadius: BorderRadius.circular(4)),
                  child: const Text('MOST POPULAR', style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(price, style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 12),
          Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.4)),
          const SizedBox(height: 24),
          const Divider(color: Colors.black12),
          const SizedBox(height: 16),
          ...bulletPoints.map((bp) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 14, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(child: Text(bp, style: const TextStyle(fontSize: 12, color: Color(0xFF475569)))),
                ],
              ),
            );
          }),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isPopular ? const Color(0xFFC05621) : const Color(0xFF1E293B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(btnLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyToDepartSection(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFC05621).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Text(
                'FINAL BOARDING CALL',
                style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFC05621)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ready for departure?\nYour kitchen is the destination.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Playfair Display', fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), height: 1.2),
            ),
            const SizedBox(height: 16),
            const Text(
              'Join 14,000+ home chefs mapping the silk routes in their kitchens. Get weekly curated heritage spice kits, localized recipes, and unlimited cooking chats.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 32),
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your email address...',
                        hintStyle: const TextStyle(fontSize: 13),
                        prefixIcon: const Icon(Icons.email, size: 16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _joinHub,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC05621),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('JOIN THE HUB', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'NO SEAT FEES REQUIRED. CANCEL SUBSCRIPTIONS AT ANY TERMINAL.',
              style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 8, letterSpacing: 1.0, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 640;
    return Container(
      color: const Color(0xFF18181B),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: wide
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        '© 2026 SpiceRoute Airlines. No flight required. Built with premium culinary wisdom.',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_user, color: Colors.green, size: 12),
                        SizedBox(width: 6),
                        Text(
                          'Secure Server-Side API',
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 10,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: const [
                    Text(
                      '© 2026 SpiceRoute Airlines. No flight required. Built with premium culinary wisdom.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.grey, height: 1.5),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_user, color: Colors.green, size: 12),
                        SizedBox(width: 6),
                        Text(
                          'Secure Server-Side API',
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 10,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
