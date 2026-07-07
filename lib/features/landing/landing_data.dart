import 'package:flutter/material.dart';

import 'landing_models.dart';

const List<LandingRegion> landingRegionsData = [
  LandingRegion(
    id: 'europe',
    name: 'Europe',
    icon: '🍕',
    description:
        'An elegant display of golden saffron threads, rich cold-pressed olive oils, fresh garlic, and vine-ripened heritage herbs.',
    markerOffset: Offset(0.48, 0.38),
    recipes: [
      LandingRecipe(
        id: 'risotto-milanese',
        name: 'Risotto alla Milanese',
        regionId: 'europe',
        regionName: 'Europe',
        cookingTime: '30 min',
        calories: 450,
        difficulty: LandingDifficulty.medium,
        spiceLevel: LandingSpiceLevel.mild,
        aromaProfile: 'Saffron & Parmesan',
        description:
            "Milan's ultimate comfort food. This creamy risotto gets its legendary golden-sunshine hue and delicate earthiness from hand-harvested saffron threads, slowly emulsified with Arborio rice, dry white wine, beef bone broth, and aged Parmigiano-Reggiano.",
        imageUrl:
            'https://images.unsplash.com/photo-1476124369491-e7addf5db371?auto=format&fit=crop&w=800&q=80',
        servings: 3,
        ingredients: [
          '1.5 cups Arborio rice',
          '1/2 tsp high-quality saffron threads',
          '1 medium yellow onion, finely diced',
          '1/2 cup dry white wine',
          '4 cups hot chicken or beef bone broth',
          '1/2 cup Parmigiano-Reggiano, freshly grated',
          '3 tbsp unsalted butter',
          '1 tbsp extra virgin olive oil',
        ],
        instructions: [
          'Steep saffron threads in 1/4 cup of warm broth for 15 minutes to unlock the full color and aroma.',
          'Heat olive oil and 1 tbsp butter in a large pan. Cook onion over low heat until soft and translucent.',
          'Add Arborio rice and toast for 2 minutes, stirring constantly until the grains look translucent at the edges.',
          'Pour in white wine and cook until completely absorbed by the rice grains.',
          'Add hot broth, one ladle at a time, stirring constantly. Wait for each ladle to be absorbed before adding the next.',
          'Halfway through, stir in the concentrated saffron-steeped broth.',
          'Once the rice is al dente (about 18-20 minutes total), turn off heat. Vigorously beat in the remaining butter and Parmigiano-Reggiano (the traditional "Mantecatura" process) to achieve ultimate creaminess.',
        ],
        localTradition: 'Lombardy Mantecatura Emulsification',
      ),
    ],
  ),
  LandingRegion(
    id: 'me-africa',
    name: 'Middle East & Africa',
    icon: '🕌',
    description:
        'Land of slow-simmered clay pots, aromatic saffron, sweet rosewater, dried stone fruits, and complex spice blends like Ras el Hanout.',
    markerOffset: Offset(0.53, 0.56),
    recipes: [
      LandingRecipe(
        id: 'chicken-tagine',
        name: 'Chicken Tagine with Apricots',
        regionId: 'me-africa',
        regionName: 'Middle East & Africa',
        cookingTime: '45 min',
        calories: 585,
        difficulty: LandingDifficulty.medium,
        spiceLevel: LandingSpiceLevel.medium,
        aromaProfile: 'Saffron & Cumin',
        description:
            'An authentic Moroccan masterpiece cooked slowly in an earthen tagine pot. Tender chicken is braised with onions, saffron, ginger, and cinnamon, finished with sweet Turkish apricots and toasted almonds.',
        imageUrl:
            'https://images.unsplash.com/photo-1541518763669-27fef04b14ea?auto=format&fit=crop&w=800&q=80',
        servings: 4,
        ingredients: [
          '4 bone-in chicken thighs',
          '1 large red onion, finely chopped',
          '3 cloves garlic, minced',
          '1/2 cup dried apricots, halved',
          '1/4 cup whole almonds, toasted',
          '1 tsp saffron threads, steeped in hot water',
          '1 tsp ground cumin',
          '1 tsp ground ginger',
          '1 cinnamon stick',
          '2 cups chicken stock',
          'Fresh cilantro and mint for garnish',
        ],
        instructions: [
          'Heat olive oil in a heavy pot or tagine over medium heat. Brown the chicken thighs on both sides and set aside.',
          'Sauté chopped onion and garlic until soft and translucent.',
          'Add cumin, ginger, cinnamon, and salt. Stir for 1 minute until highly aromatic.',
          'Return chicken to the pot, pour in the saffron water and chicken stock. Cover and simmer on low for 30 minutes.',
          'Add the halved dried apricots and cook uncovered for another 15 minutes until the sauce is glossy and thick.',
          'Garnish with toasted almonds, fresh cilantro, and chopped mint. Serve with fluffy couscous.',
        ],
        localTradition: 'Traditional Atlas Mountain Slow Braise',
      ),
    ],
  ),
  LandingRegion(
    id: 'south-asia',
    name: 'South Asia',
    icon: '🌶️',
    description:
        'The global epicenter of spices. Famous for layered masala roasting, rich ghee infusions, slow-simmered gravies, and tandoor artistry.',
    markerOffset: Offset(0.68, 0.52),
    recipes: [
      LandingRecipe(
        id: 'butter-chicken',
        name: 'Royal Delhi Butter Chicken',
        regionId: 'south-asia',
        regionName: 'South Asia',
        cookingTime: '35 min',
        calories: 610,
        difficulty: LandingDifficulty.medium,
        spiceLevel: LandingSpiceLevel.medium,
        aromaProfile: 'Garam Masala & Fenugreek',
        description:
            'Originally born in the iconic kitchens of Moti Mahal in Delhi. Charcoal-singed tandoori chicken pieces are bathed in a luxurious, silky tomato gravy rich with cashew butter, local spices, and toasted Kasuri Methi.',
        imageUrl:
            'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=800&q=80',
        servings: 4,
        ingredients: [
          '500g chicken thighs, cut into bite-sized pieces',
          '1 cup heavy yogurt (for marinade)',
          '2 tbsp tandoori masala powder',
          '3 tbsp unsalted butter',
          '1 cup pureed plum tomatoes',
          '1/2 cup heavy cream',
          '2 tbsp cashew butter or paste',
          '1 tbsp ground garam masala',
          '1 tbsp dried fenugreek leaves (Kasuri Methi)',
          '1 tbsp ginger-garlic paste',
        ],
        instructions: [
          'Marinate chicken in yogurt, tandoori masala, ginger-garlic paste, and lemon juice for at least 2 hours (or overnight).',
          'Grill or pan-sear marinated chicken at high heat to achieve a charred, smoky edge. Set aside.',
          'Melt butter in a large pan, add tomato puree, cashew butter, and garam masala. Simmer for 10 minutes.',
          'Fold in cream and cook on a gentle low flame until the sauce turns an elegant orange hue.',
          'Slide in the charred chicken pieces and simmer for 5-8 minutes.',
          'Rub Kasuri Methi leaves between your palms to release their aromatics, sprinkle over the dish, and stir. Serve hot with buttery garlic naan.',
        ],
        localTradition: 'Tandoori-Style Charcoal Sear',
      ),
    ],
  ),
  LandingRegion(
    id: 'se-asia',
    name: 'Mainland SE Asia',
    icon: '🛶',
    description:
        'A delicate harmony of salty, sweet, sour, and spicy, anchored by fresh lemongrass, galangal, fish sauce, and kaffir lime leaves.',
    markerOffset: Offset(0.74, 0.58),
    recipes: [
      LandingRecipe(
        id: 'fish-amok',
        name: 'Cambodian Fish Amok',
        regionId: 'se-asia',
        regionName: 'Mainland SE Asia',
        cookingTime: '40 min',
        calories: 420,
        difficulty: LandingDifficulty.easy,
        spiceLevel: LandingSpiceLevel.medium,
        aromaProfile: 'Lemongrass & Coconut',
        description:
            "Cambodia's national treasure. A light, mousse-like fish curry steamed gently in banana leaf cups. The secret lies in the hand-ground \"Kroeung\" paste—a golden blend of lemongrass, galangal, kaffir lime zest, and fresh turmeric.",
        imageUrl:
            'https://images.unsplash.com/photo-1559314809-0d155014e29e?auto=format&fit=crop&w=800&q=80',
        servings: 2,
        ingredients: [
          '300g firm white fish fillets (cod or snapper), cubed',
          '1 cup thick organic coconut cream',
          '1 egg, lightly beaten',
          '1 tbsp fish sauce',
          '2 fresh banana leaves (or parchment paper bowls)',
          '3 lemongrass stalks, chopped',
          '1 inch fresh galangal, sliced',
          '2 kaffir lime leaves, shredded',
          '1 tsp fresh turmeric, grated',
          '2 shallots and 2 cloves garlic',
        ],
        instructions: [
          'Prepare the Kroeung paste: Blend lemongrass, galangal, turmeric, garlic, shallots, and lime leaves in a food processor until it forms a smooth, rich paste.',
          'In a bowl, whisk the paste with beaten egg, fish sauce, and coconut cream until well integrated.',
          'Gently fold the white fish cubes into the spice curry mixture.',
          'Construct banana leaf boats or use ceramic ramekins. Spoon the mixture in evenly.',
          'Steam in a bamboo steamer over boiling water for 25 minutes until the fish is cooked and the curry is semi-firm.',
          'Top with a drizzle of coconut cream and thin strips of red chili. Serve alongside jasmine rice.',
        ],
        localTradition: 'Mekong River Bamboo Steaming',
      ),
    ],
  ),
  LandingRegion(
    id: 'maritime-se-asia',
    name: 'Maritime Southeast Asia',
    icon: '🥥',
    description:
        'The historic Spice Islands. Defined by coconut caramelization, candlenuts, ginger flower, fresh turmeric, lemongrass, and fiery sambals.',
    markerOffset: Offset(0.78, 0.66),
    recipes: [
      LandingRecipe(
        id: 'beef-rendang',
        name: 'West Sumatran Beef Rendang',
        regionId: 'maritime-se-asia',
        regionName: 'Maritime Southeast Asia',
        cookingTime: '180 min',
        calories: 650,
        difficulty: LandingDifficulty.hard,
        spiceLevel: LandingSpiceLevel.hot,
        aromaProfile: 'Toasted Coconut & Lemongrass',
        description:
            "Frequently crowned the world's most delicious dish. This dry curry from the Minangkabau people of West Sumatra is slowly simmered in rich coconut milk and a roasted paste of shallots, ginger, galangal, and red chilies, until all liquid evaporates and the beef caramelizes into deep mahogany perfection.",
        imageUrl:
            'https://images.unsplash.com/photo-1546549032-9571cd6b27df?auto=format&fit=crop&w=800&q=80',
        servings: 4,
        ingredients: [
          '600g beef chuck or brisket, cut into thick cubes',
          '2 cans (800ml) premium thick coconut milk',
          '2 stalks fresh lemongrass, bruised and knotted',
          '4 kaffir lime leaves, torn',
          '2 turmeric leaves (or fresh bay leaves)',
          '1 piece asam keping (dried tamarind slice)',
          '1/2 cup kerisik (toasted, pounded grated coconut)',
          'Spice paste: 10 shallots, 5 cloves garlic, 1 inch ginger',
          '1.5 inches fresh galangal, sliced',
          '10 dried curly red chilies, rehydrated',
        ],
        instructions: [
          'Blend all spice paste ingredients (shallots, garlic, ginger, galangal, chilies) into a fine, aromatic paste with a splash of oil.',
          'In a deep wok, combine the blended spice paste, coconut milk, lemongrass, kaffir lime leaves, turmeric leaves, and tamarind slice. Bring to a boil over medium-high heat.',
          'Add the beef cubes, stirring well. Reduce heat to low and let it simmer uncovered, stirring occasionally.',
          'As the coconut milk reduces, the oil will separate. Continue simmering and stirring. The curry will turn brown (the kalio phase) after about 1.5 to 2 hours.',
          'Add the toasted kerisik and salt. From this point, stir continuously to prevent scorching. The beef will slowly turn deep dark brown, almost dry, as the coconut oil cooks the beef. This takes about 3 hours in total.',
          'Once the beef is tender, dark mahogany, and the liquid has completely evaporated, remove from heat. Serve with warm steamed jasmine rice.',
        ],
        localTradition: 'Minangkabau Coconut Oil Caramelization',
      ),
    ],
  ),
  LandingRegion(
    id: 'east-asia',
    name: 'East Asia',
    icon: '🏮',
    description:
        'Masters of depth, fermentation, and texture—featuring rich soybean pastes, toasted sesame oils, ginger, scallions, and tongue-numbing Sichuan peppercorn.',
    markerOffset: Offset(0.79, 0.44),
    recipes: [
      LandingRecipe(
        id: 'mapo-tofu',
        name: 'Sichuan Mapo Tofu',
        regionId: 'east-asia',
        regionName: 'East Asia',
        cookingTime: '25 min',
        calories: 320,
        difficulty: LandingDifficulty.medium,
        spiceLevel: LandingSpiceLevel.numbing,
        aromaProfile: 'Sichuan Peppercorn & Chili Paste',
        description:
            'An explosive culinary journey from Chengdu. Silken tofu cubes are simmered in a deeply savory, fiery chili sauce spiked with Pixian Doubanjiang (fermented broad bean paste) and a generous dusting of hand-toasted numbing Sichuan peppercorns.',
        imageUrl:
            'https://images.unsplash.com/photo-1627308595229-7830a5c91f9f?auto=format&fit=crop&w=800&q=80',
        servings: 3,
        ingredients: [
          '1 block (400g) silken tofu, cubed',
          '100g minced beef or shiitake mushrooms',
          '2 tbsp authentic Pixian Doubanjiang (chili bean paste)',
          '1 tbsp Sichuan peppercorns, toasted and ground',
          '3 cloves garlic and 1 inch ginger, minced',
          '2 green onions, chopped',
          '1 tbsp chili oil',
          '1 tsp cornstarch mixed with 2 tbsp water (slurry)',
          '1 cup chicken or vegetable stock',
        ],
        instructions: [
          'Gently blanch silken tofu cubes in salted boiling water for 1 minute to firm them up; drain carefully.',
          'Heat oil in a wok over medium heat. Fry minced beef or mushrooms until dry and crispy.',
          'Add garlic, ginger, and Pixian Doubanjiang. Stir-fry until the oil turns a bright, aromatic red.',
          'Pour in the stock and slide in the tofu cubes. Simmer gently for 5 minutes so tofu absorbs the deep flavors.',
          'Drizzle in the cornstarch slurry to thicken the sauce into a glossy coat.',
          'Drizzle chili oil, toss in green onions, and finish with a heavy dusting of freshly ground Sichuan peppercorns for the signature numbing sensation.',
        ],
        localTradition: 'Chengdu Wok Toss & Sichuan Peppercorn Dusting',
      ),
    ],
  ),
  LandingRegion(
    id: 'americas',
    name: 'Americas',
    icon: '🌮',
    description:
        'Deep, ancient foundations showcasing smoky dried heirloom chilies, raw cacao, sweet Mexican cinnamon, roasted pepitas, and fresh herbs.',
    markerOffset: Offset(0.22, 0.52),
    recipes: [
      LandingRecipe(
        id: 'chicken-mole',
        name: 'Artisanal Chicken Mole Poblano',
        regionId: 'americas',
        regionName: 'Americas',
        cookingTime: '50 min',
        calories: 680,
        difficulty: LandingDifficulty.hard,
        spiceLevel: LandingSpiceLevel.medium,
        aromaProfile: 'Cacao & Ancho Chili',
        description:
            'The ancient culinary soul of Puebla, Mexico. An incredibly complex, multi-layered sauce combining roasted Ancho, Pasilla, and Mulato chilies, warm spices like cinnamon and cloves, toasted seeds, and rich, bittersweet dark Mexican cacao.',
        imageUrl:
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=800&q=80',
        servings: 4,
        ingredients: [
          '4 chicken breast or thigh pieces, cooked',
          '2 dried Ancho chilies, stemmed and seeded',
          '2 dried Pasilla chilies, stemmed and seeded',
          '50g dark Mexican chocolate (70%+ cacao), chopped',
          '1/2 cup roasted plantain or banana slices',
          '1/4 cup toasted sesame seeds and pumpkin seeds',
          '1/2 tsp ground cinnamon and a pinch of cloves',
          '1 medium onion and 3 cloves garlic, charred',
          '2 cups chicken broth',
        ],
        instructions: [
          'Toast the dried chilies in a dry skillet for 10-20 seconds per side until fragrant. Submerge in boiling water for 15 minutes to rehydrate.',
          'Toast sesame seeds, pumpkin seeds, cinnamon, and cloves in the skillet until toasted.',
          'Blend rehydrated chilies, toasted seeds, spices, charred onion, garlic, plantain, and 1 cup of broth until perfectly smooth.',
          'Heat oil in a deep pot, pour in the blended paste, and cook on low heat for 10 minutes, stirring continuously.',
          'Add remaining broth and the chopped dark chocolate. Simmer gently until chocolate melts and the sauce turns deep mahogany.',
          'Add cooked chicken to the mole and simmer for another 10 minutes to infuse. Serve sprinkled with toasted sesame seeds.',
        ],
        localTradition: 'Oaxacan Multi-Day Chili-Cacao Stone Grind',
      ),
    ],
  ),
];

const List<LandingCommunityPost> landingInitialCommunityPosts = [
  LandingCommunityPost(
    id: 'post-1',
    username: '@marco_eats',
    dishName: 'Risotto alla Milanese',
    regionName: 'Europe',
    caption:
        'Perfectly golden! The saffron aroma is absolutely intoxicating. Grounded it in my stone mortar and did the traditional Lombardo Mantecatura technique.',
    imageUrl:
        'https://images.unsplash.com/photo-1476124369491-e7addf5db371?auto=format&fit=crop&w=800&q=80',
    tags: ['Saffron', 'ItalianTradition', 'Risotto'],
    timestamp: '2 hours ago',
    likes: 42,
  ),
  LandingCommunityPost(
    id: 'post-2',
    username: '@sara_travels',
    dishName: 'Cambodian Fish Amok',
    regionName: 'Mainland SE Asia',
    caption:
        "Took me straight back to Siem Reap! Hand-ground the Kroeung paste using fresh lemongrass from the farmer's market. Steamed in real banana leaves!",
    imageUrl:
        'https://images.unsplash.com/photo-1559314809-0d155014e29e?auto=format&fit=crop&w=800&q=80',
    tags: ['Amok', 'KhmerCuisine', 'Lemongrass'],
    timestamp: '5 hours ago',
    likes: 89,
  ),
  LandingCommunityPost(
    id: 'post-3',
    username: '@yasmine_k',
    dishName: 'Chicken Tagine',
    regionName: 'Middle East & Africa',
    caption:
        'Made this in my beautiful clay tagine today. The slow braise caramelizes the dried apricots perfectly with the ginger-saffron broth. Absolute heaven.',
    imageUrl:
        'https://images.unsplash.com/photo-1541518763669-27fef04b14ea?auto=format&fit=crop&w=800&q=80',
    tags: ['Tagine', 'MoroccanFood', 'SlowCook'],
    timestamp: '1 day ago',
    likes: 124,
  ),
  LandingCommunityPost(
    id: 'post-4',
    username: '@wei_chef',
    dishName: 'Sichuan Mapo Tofu',
    regionName: 'East Asia',
    caption:
        'Highly authentic, numbing, and fiery! Pixian Doubanjiang is a non-negotiable. Finished with a heavy dusting of freshly roasted and ground Sichuan peppercorns.',
    imageUrl:
        'https://images.unsplash.com/photo-1627308595229-7830a5c91f9f?auto=format&fit=crop&w=800&q=80',
    tags: ['MapoTofu', 'SichuanPepper', 'SpicyWok'],
    timestamp: '2 days ago',
    likes: 156,
  ),
  LandingCommunityPost(
    id: 'post-5',
    username: '@nasi_rendang',
    dishName: 'West Sumatran Beef Rendang',
    regionName: 'Maritime Southeast Asia',
    caption:
        'Took 3 hours but absolutely worth every second. The toasted kerisik and coconut oil caramelization coated the beef in the most delicious mahogany crust!',
    imageUrl:
        'https://images.unsplash.com/photo-1546549032-9571cd6b27df?auto=format&fit=crop&w=800&q=80',
    tags: ['BeefRendang', 'Sumatra', 'SpiceIslands'],
    timestamp: '3 days ago',
    likes: 198,
  ),
];

const List<LandingSpinDestination> landingSpinDestinations = [
  LandingSpinDestination(
    country: 'Morocco',
    city: 'Marrakesh',
    stamp: '🇲🇦',
    dish: 'Chicken Tagine',
    aroma: 'Saffron, Ginger & Cumin',
    tip:
        'Steep saffron threads in hot bone broth to release their signature golden compounds.',
  ),
  LandingSpinDestination(
    country: 'Cambodia',
    city: 'Siem Reap',
    stamp: '🇰🇭',
    dish: 'Fish Amok',
    aroma: 'Lemongrass & Turmeric',
    tip:
        'Gently steam the amok custard inside a banana leaf cup for maximum aromatic depth.',
  ),
  LandingSpinDestination(
    country: 'Indonesia',
    city: 'Padang',
    stamp: '🇮🇩',
    dish: 'West Sumatran Beef Rendang',
    aroma: 'Toasted Coconut & Lemongrass',
    tip:
        'Stir the rendang slowly and constantly towards the end to prevent the concentrated coconut solids from burning.',
  ),
  LandingSpinDestination(
    country: 'India',
    city: 'Delhi',
    stamp: '🇮🇳',
    dish: 'Royal Butter Chicken',
    aroma: 'Garam Masala & Fenugreek',
    tip:
        'To release the maximum spice profile, rub kasuri methi leaves vigorously between your palms before serving.',
  ),
  LandingSpinDestination(
    country: 'China',
    city: 'Chengdu',
    stamp: '🇨🇳',
    dish: 'Sichuan Mapo Tofu',
    aroma: 'Sichuan Peppercorn & Chili Paste',
    tip:
        'Always toast and grind your Sichuan peppercorns fresh right before dusting.',
  ),
  LandingSpinDestination(
    country: 'Italy',
    city: 'Milan',
    stamp: '🇮🇹',
    dish: 'Risotto alla Milanese',
    aroma: 'Saffron & Aged Parmigiano',
    tip:
        'Never skip the Mantecatura step! Vigorously beat cold butter and cheese off-heat to emulsify the rice starch.',
  ),
  LandingSpinDestination(
    country: 'Mexico',
    city: 'Oaxaca',
    stamp: '🇲🇽',
    dish: 'Chicken Mole Poblano',
    aroma: 'Charred Chilies & Dark Cacao',
    tip:
        'Toast the dried ancho and pasilla chilies in a dry wok to release their smoky essential oils.',
  ),
];
