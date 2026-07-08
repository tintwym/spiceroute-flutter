import 'package:flutter/material.dart';

void main() {
  runApp(const SpiceRouteApp());
}

class SpiceRouteApp extends StatelessWidget {
  const SpiceRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpiceRoute - The Culinary Terminal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9F6F0), // Warm Cream background
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC05621), // Terracotta orange
          primary: const Color(0xFFC05621),
          secondary: const Color(0xFF1E293B), // Slate gray
          surface: Colors.white,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
            height: 1.2,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
            height: 1.2,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: Color(0xFF475569),
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: Color(0xFF64748B),
          ),
          labelSmall: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 11,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF94A3B8),
          ),
        ),
      ),
      home: const SpiceRouteLandingPage(),
    );
  }
}

class SpiceRouteLandingPage extends StatefulWidget {
  const SpiceRouteLandingPage({super.key});

  @override
  State<SpiceRouteLandingPage> createState() => _SpiceRouteLandingPageState();
}

class _SpiceRouteLandingPageState extends State<SpiceRouteLandingPage> {
  // Global States matching the web application
  bool isAnnualBilling = false;
  double seatsCount = 5.0;
  String activeRegion = 'Middle East & Africa';
  int activeRecipeTab = 0; // 0 = Heritage, 1 = Ingredients, 2 = Preparation

  // Dynamic Chat with Chef Tariq mockup state
  final List<Map<String, String>> chatMessages = [
    {
      'role': 'model',
      'text': 'Salaam culinary explorer! I am Chef Tariq, your virtual SpiceRoute travel companion. Ask me anything—from local ingredient substitutions (like what to swap for fresh galangal), blooming secret spices, to building a completely custom spiced menu for your kitchen. Where shall we depart today?'
    }
  ];
  final TextEditingController chatController = TextEditingController();

  // Social feed live list
  final List<Map<String, dynamic>> socialFeed = [
    {
      'handle': '@marco_eats',
      'dish': 'Risotto alla Milanese',
      'review': 'Perfecty golden! The saffron aroma is absolutely intoxicating. Grounded it in my stone mortar and did the traditional Lombardo Mantecatura technique.',
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
          // Web Nav mock for Flutter web, hidden on small screens
          if (MediaQuery.of(context).size.width > 768)
            Row(
              children: [
                _buildHeaderLink('The Taste Map', true),
                _buildHeaderLink('AI Travel Companion', false),
                _buildHeaderLink('The Global Terminal', false),
                _buildHeaderLink('Pricing Tiers', false),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
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

  Widget _buildHeaderLink(String label, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: active ? FontWeight.bold : FontWeight.w500,
          color: active ? const Color(0xFFC05621) : const Color(0xFF64748B),
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
                onPressed: () {},
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
                onPressed: () {},
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
    final sectors = [
      {'name': 'Middle East & Africa', 'icon': '🕌'},
      {'name': 'Mainland SE Asia', 'icon': '🍜'},
      {'name': 'South Asia', 'icon': '🌶️'},
      {'name': 'East Asia', 'icon': '🍣'},
      {'name': 'Mediterranean', 'icon': '🫒'},
      {'name': 'Latin America', 'icon': '🌮'},
    ];

    return Container(
      color: const Color(0xFF101012),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Text(
              'QUICK SECTORS: ',
              style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            ...sectors.map((sec) {
              final isSecActive = activeRegion == sec['name'];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      activeRegion = sec['name']!;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSecActive ? const Color(0xFFC05621) : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        Text(sec['icon']!),
                        const SizedBox(width: 6),
                        Text(
                          sec['name']!,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: isSecActive ? FontWeight.bold : FontWeight.w500,
                            color: isSecActive ? Colors.white : Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTasteMapSection(BuildContext context, bool isDesktop) {
    // Info based on region
    final Map<String, Map<String, dynamic>> regionDishes = {
      'Middle East & Africa': {
        'name': 'Chicken Tagine with Apricots',
        'sub': 'TRADITIONAL ATLAS MOUNTAIN SLOW BRAISE',
        'cookTime': '45 MIN',
        'calories': '585 KCAL',
        'difficulty': 'MEDIUM',
        'servings': '4 PAX',
        'aroma': 'Saffron & Cumin',
        'heritage': 'An authentic Moroccan masterpiece cooked slowly in an earthen tagine pot. Tender chicken is braised with onions, saffron, ginger, and cinnamon, finished with sweet Turkish apricots and toasted almonds.',
        'ingredients': ['Chicken thighs (bone-in)', 'Saffron threads', 'Moroccan cinnamon', 'Dried Turkish apricots', 'Toasted almonds', 'Cumin & Ginger'],
        'prep': ['Bloom the saffron in warm water.', 'Sear chicken thighs in tagine with cumin and olive oil.', 'Slow cook with dried apricots and cinnamon for 45 minutes.', 'Garnish with toasted sliced almonds.'],
      },
      'Mainland SE Asia': {
        'name': 'Cambodian Fish Amok',
        'sub': 'KHMER STEAMED CURRY SENSATION',
        'cookTime': '55 MIN',
        'calories': '420 KCAL',
        'difficulty': 'HARD',
        'servings': '3 PAX',
        'aroma': 'Lemongrass & Kaffir Lime',
        'heritage': 'A traditional Khmer steamed fish curry. Fresh white fish fillet is coated in a rich, hand-ground Kroeung lemongrass paste, combined with coconut milk and steamed in custom folded banana leaf cups.',
        'ingredients': ['White fish fillet', 'Lemongrass stalks', 'Galangal root', 'Kaffir lime leaves', 'Coconut cream', 'Banana leaf cups'],
        'prep': ['Pound fresh lemongrass, galangal, turmeric, and garlic in a mortar.', 'Whisk coconut cream with eggs and the prepared spice paste.', 'Fold fish fillets into the mixture, then scoop into banana leaf cups.', 'Steam for 20 minutes until custardy.'],
      },
      'South Asia': {
        'name': 'Kerala Malabar Prawn Curry',
        'sub': 'COASTAL INDIAN COCONUT SPICE BLEND',
        'cookTime': '30 MIN',
        'calories': '380 KCAL',
        'difficulty': 'EASY',
        'servings': '4 PAX',
        'aroma': 'Mustard seeds & Curry leaves',
        'heritage': 'A coastal Indian delicacy that combines plump fresh prawns with a spicy, sour tamarind base, tempered with fresh curry leaves and coconut milk for a luxurious texture.',
        'ingredients': ['King prawns', 'Coconut milk', 'Tamarind paste', 'Black mustard seeds', 'Fresh curry leaves', 'Kashmiri chili powder'],
        'prep': ['Temper mustard seeds and curry leaves in hot coconut oil.', 'Sauté chopped shallots and green chilies with chili powder.', 'Add tamarind water and coconut milk, simmer.', 'Drop prawns in and cook for 5 minutes.'],
      }
    };

    final dish = regionDishes[activeRegion] ?? regionDishes['Middle East & Africa']!;

    return Container(
      width: double.infinity,
      color: const Color(0xFFF9F6F0),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFC05621).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'VISUAL ROUTE NAVIGATOR',
                  style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFC05621)),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'The Taste Map',
                style: TextStyle(fontFamily: 'Playfair Display', fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const Text(
                'Select or hover over a region on our digital passport grid to decode its signature spice profile and authentic regional dishes.',
                style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 40),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 11, child: _buildTasteMapLeft(context)),
                    const SizedBox(width: 40),
                    Expanded(flex: 9, child: _buildTasteMapRight(context, dish)),
                  ],
                )
              else
                Column(
                  children: [
                    _buildTasteMapLeft(context),
                    const SizedBox(height: 40),
                    _buildTasteMapRight(context, dish),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasteMapLeft(BuildContext context) {
    final mapPins = [
      {'region': 'Europe', 'icon': '🍕', 'left': 0.35, 'top': 0.32},
      {'region': 'Middle East & Africa', 'icon': '🕌', 'left': 0.48, 'top': 0.48},
      {'region': 'South Asia', 'icon': '🌶️', 'left': 0.58, 'top': 0.50},
      {'region': 'Mainland SE Asia', 'icon': '🍜', 'left': 0.65, 'top': 0.55},
      {'region': 'East Asia', 'icon': '🍣', 'left': 0.70, 'top': 0.40},
      {'region': 'Latin America', 'icon': '🌮', 'left': 0.25, 'top': 0.60},
    ];

    return Container(
      height: 380,
      decoration: BoxDecoration(
        color: const Color(0xFFEFEBE4), // Map cardboard background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Grid Background Lines
              Opacity(
                opacity: 0.1,
                child: CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: GridPainter(),
                ),
              ),
              // Lat / Lng text indicators
              const Positioned(
                left: 16,
                top: 16,
                child: Text(
                  'LAT: 25.109N // LNG: 55.138E',
                  style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10, color: Colors.grey, letterSpacing: 1.0),
                ),
              ),
              // Map World Outline (Simulated using subtle shaded shapes)
              Positioned(
                left: constraints.maxWidth * 0.15,
                top: constraints.maxHeight * 0.25,
                child: Container(
                  width: constraints.maxWidth * 0.7,
                  height: constraints.maxHeight * 0.55,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.02),
                    borderRadius: BorderRadius.circular(200),
                  ),
                ),
              ),
              // Pins
              ...mapPins.map((pin) {
                final isSelected = activeRegion == pin['region'];
                return Positioned(
                  left: constraints.maxWidth * (pin['left'] as double),
                  top: constraints.maxHeight * (pin['top'] as double),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        activeRegion = pin['region'] as String;
                      });
                    },
                    child: Tooltip(
                      message: pin['region'] as String,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFC05621) : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(pin['icon'] as String, style: const TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                );
              }),
              // Active Region Banner Overlay
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Active Sector: $activeRegion',
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Text(
                      'GRID SCALE: METRIC // SPICE_ROUTE_V1',
                      style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 9, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTasteMapRight(BuildContext context, Map<String, dynamic> dish) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header banner style image placeholder
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1541518763669-27fef04b14ea?w=800&auto=format&fit=crop&q=80'),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFC05621),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                dish['sub']!,
                style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dish['name']!,
                  style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 16),
                // Cooking stats grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCurryStat(Icons.schedule, 'COOK TIME', dish['cookTime']!),
                    _buildCurryStat(Icons.local_fire_department, 'CALORIES', dish['calories']!),
                    _buildCurryStat(Icons.analytics, 'DIFFICULTY', dish['difficulty']!),
                    _buildCurryStat(Icons.people, 'SERVINGS', dish['servings']!),
                  ],
                ),
                const SizedBox(height: 24),
                // Tabs header
                Row(
                  children: [
                    _buildRecipeTabButton('The Heritage', 0),
                    _buildRecipeTabButton('Ingredients', 1),
                    _buildRecipeTabButton('Preparation', 2),
                  ],
                ),
                const Divider(height: 1, thickness: 1, color: Colors.black12),
                const SizedBox(height: 16),
                // Dynamic tab content
                _buildActiveTabContent(dish),
                const SizedBox(height: 24),
                // Aroma Profile Panel
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF7F2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE28743).withValues(alpha: 0.15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('AROMA PROFILE:', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                          Text(dish['aroma']!, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFC05621))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('SPICE INTENSITY:', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                          Text('MEDIUM', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurryStat(IconData icon, String label, String val) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 8, color: Colors.grey)),
        Text(val, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
      ],
    );
  }

  Widget _buildRecipeTabButton(String label, int idx) {
    final isSelected = activeRecipeTab == idx;
    return InkWell(
      onTap: () {
        setState(() {
          activeRecipeTab = idx;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFFC05621) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? const Color(0xFFC05621) : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabContent(Map<String, dynamic> dish) {
    if (activeRecipeTab == 0) {
      return Text(
        dish['heritage']!,
        style: const TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF475569)),
      );
    } else if (activeRecipeTab == 1) {
      final List<String> list = dish['ingredients'] as List<String>;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list.map((ing) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    size: 14, color: Color(0xFFC05621)),
                const SizedBox(width: 8),
                Text(
                  ing,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    } else {
      final List<String> list = dish['prep'] as List<String>;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(list.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index + 1}. ',
                  style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFC05621)),
                ),
                Expanded(
                  child: Text(
                    list[index],
                    style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
                  ),
                ),
              ],
            ),
          );
        }),
      );
    }
  }

  Widget _buildInteractiveToolkitSection(BuildContext context, bool isDesktop) {
    return Container(
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
            onPressed: () {},
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
                IconButton(onPressed: () {}, icon: const Icon(Icons.help_outline, size: 18)),
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
              _buildStyleChip('🌏 SE Asia', true),
              _buildStyleChip('🌾 South Asia', false),
              _buildStyleChip('🕌 Mid East', false),
              _buildStyleChip('🥢 East Asia', false),
            ],
          ),
          const Spacer(),
          const Text('HEAT & SPICE LEVEL', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 9, color: Colors.grey)),
          const SizedBox(height: 6),
          Row(
            children: [
              _buildHeatChip('Mild', false),
              _buildHeatChip('Medium', false),
              _buildHeatChip('Hot', true),
              _buildHeatChip('Numbing', false),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
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

  Widget _buildStyleChip(String label, bool active) {
    return Container(
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
    );
  }

  Widget _buildHeatChip(String label, bool active) {
    return Expanded(
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
    );
  }

  Widget _buildCulinaryBoardSection(BuildContext context, bool isDesktop) {
    return Container(
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
              onPressed: () {},
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
    final isSelected = label == 'Europe';
    return InkWell(
      onTap: () {},
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: socialFeed.length,
      itemBuilder: (context, idx) {
        final item = socialFeed[idx];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.black.withValues(alpha: 0.04)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  image: DecorationImage(
                    image: NetworkImage(item['imageUrl']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item['handle'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFC05621))),
                        Text(item['time'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(item['dish'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    const SizedBox(height: 4),
                    Text(
                      item['review'],
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF475569), height: 1.4),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 4,
                          children: (item['tags'] as List<String>)
                              .map((t) {
                            return Text(
                              '#$t',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            );
                          }).toList(),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.stars, size: 12, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text('${item['stamps']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
      },
    );
  }

  Widget _buildPricingSection(BuildContext context, bool isDesktop) {
    double tierPrice = 9.99;
    double estimatedMonthly = seatsCount * tierPrice;
    if (isAnnualBilling) {
      estimatedMonthly = estimatedMonthly * 0.8; // 20% discount
    }

    return Container(
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
                    Expanded(child: _buildPriceCard('GROWTH / FREE', '\$0', 'Perfect for casual home cooks exploring authentic heritage recipes and our Interactive world map.', ['View complete heritage recipes', 'Interactive world map', 'AI Chatbot with Chef Tariq', 'Custom AI Recipe Generator'], 'ACTIVE PLAN', false)),
                    const SizedBox(width: 24),
                    Expanded(child: _buildPriceCard('PRO / PASS', isAnnualBilling ? '\$7.99' : '\$9.99', 'The standard choice for curious epicureans seeking Instant culinary knowledge, custom menus, and unlimited co-creation.', ['Everything in Growth Free Pass', 'Unlimited AI Chat with Chef Tariq', 'Custom AI Recipe Generator', 'Unlimited Spin the Globe draws'], 'START PREMIUM TRIAL', true)),
                    const SizedBox(width: 24),
                    Expanded(child: _buildPriceCard('ENTERPRISE', 'Custom', 'Custom setups for culinary schools, commercial kitchens, and restaurant chains requiring private API limits.', ['Everything in Premium Pass', 'Dedicated Private Server Nodes', 'Localized menu database sync', 'Shared workspace & custom billing'], 'CONTACT SALES', false)),
                  ],
                )
              else
                Column(
                  children: [
                    _buildPriceCard('GROWTH / FREE', '\$0', 'Perfect for casual home cooks exploring authentic heritage recipes.', ['View complete heritage recipes', 'Interactive world map', 'AI Chatbot with Chef Tariq', 'Custom AI Recipe Generator'], 'ACTIVE PLAN', false),
                    const SizedBox(height: 24),
                    _buildPriceCard('PRO / PASS', isAnnualBilling ? '\$7.99' : '\$9.99', 'The standard choice for curious epicureans.', ['Everything in Growth Free Pass', 'Unlimited AI Chat with Chef Tariq', 'Custom AI Recipe Generator', 'Unlimited Spin the Globe draws'], 'START PREMIUM TRIAL', true),
                    const SizedBox(height: 24),
                    _buildPriceCard('ENTERPRISE', 'Custom', 'Custom setups for culinary schools.', ['Everything in Premium Pass', 'Dedicated Private Server Nodes', 'Localized menu database sync', 'Shared workspace & custom billing'], 'CONTACT SALES', false),
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
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Calculated Seats: ${seatsCount.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Text('ESTIMATED BILLING', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 8, color: Colors.grey)),
                                Text('\$${estimatedMonthly.toStringAsFixed(2)}/mo', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                                Text(isAnnualBilling ? 'Billed annually (20% off)' : 'Billed monthly', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFC05621),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('LOCK IN PRICE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                              ],
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
    );
  }

  Widget _buildPriceCard(String tier, String price, String desc, List<String> bulletPoints, String btnLabel, bool isPopular) {
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
              onPressed: () {},
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
                    onPressed: () {},
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
    return Container(
      color: const Color(0xFF18181B),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '© 2026 SpiceRoute Airlines. No flight required. Built with premium culinary wisdom.',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              Row(
                children: [
                  const Icon(Icons.verified_user, color: Colors.green, size: 12),
                  const SizedBox(width: 6),
                  const Text(
                    'Secure Server-Side API',
                    style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold),
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

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 0.5;

    final double step = 20.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
