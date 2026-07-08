import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../landing_data.dart';
import '../landing_models.dart';
import '../landing_palette.dart';
import 'landing_shared.dart';

class LandingTasteMap extends StatefulWidget {
  const LandingTasteMap({super.key});

  @override
  State<LandingTasteMap> createState() => _LandingTasteMapState();
}

class _LandingTasteMapState extends State<LandingTasteMap> {
  String _activeRegionId = 'me-africa';
  LandingRecipeTab _tab = LandingRecipeTab.heritage;
  final _checkedIngredients = <int>{};

  LandingRegion get _region => landingRegionsData.firstWhere(
    (r) => r.id == _activeRegionId,
    orElse: () => landingRegionsData.first,
  );

  LandingRecipe get _recipe => _region.recipes.first;

  void _selectRegion(String id) {
    setState(() {
      _activeRegionId = id;
      _tab = LandingRecipeTab.heritage;
      _checkedIngredients.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1024;
    return LandingMaxWidth(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LandingSectionHeader(
            badge: 'Visual Route Navigator',
            title: 'The Taste Map',
            subtitle:
                'Select a region on our digital passport grid to decode its signature spice profile and authentic regional dishes.',
            icon: Icons.map_outlined,
          ),
          const SizedBox(height: 40),
          LandingResponsiveRow(
            wide: wide,
            spacing: 48,
            children: [
              _MapPanel(
                activeRegionId: _activeRegionId,
                onSelect: _selectRegion,
              ),
              _RecipePassCard(
                recipe: _recipe,
                tab: _tab,
                onTab: (t) => setState(() => _tab = t),
                checked: _checkedIngredients,
                onToggleIngredient: (i) => setState(() {
                  if (_checkedIngredients.contains(i)) {
                    _checkedIngredients.remove(i);
                  } else {
                    _checkedIngredients.add(i);
                  }
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapPanel extends StatelessWidget {
  const _MapPanel({required this.activeRegionId, required this.onSelect});

  final String activeRegionId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: LandingPalette.alabaster,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: LandingPalette.charcoal.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      ColoredBox(
                        color: LandingPalette.cream.withValues(alpha: 0.6),
                      ),
                      SvgPicture.string(
                        _tasteMapSvg(activeRegionId),
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 12,
                        left: 16,
                        child: Text(
                          'LAT: 25.109N // LNG: 55.138E',
                          style: LandingPalette.mono(
                            context,
                            size: 9,
                            color: LandingPalette.charcoal.withValues(
                              alpha: 0.25,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 16,
                        child: Text(
                          'GRID SCALE: METRIC / SPICE_ROUTE_V1',
                          style: LandingPalette.mono(
                            context,
                            size: 9,
                            color: LandingPalette.charcoal.withValues(
                              alpha: 0.25,
                            ),
                          ),
                        ),
                      ),
                      for (final region in landingRegionsData)
                        Positioned(
                          left: region.markerOffset.dx * constraints.maxWidth,
                          top: region.markerOffset.dy * constraints.maxHeight,
                          child: _RegionPin(
                            region: region,
                            isActive: region.id == activeRegionId,
                            onTap: () => onSelect(region.id),
                          ),
                        ),
                      ..._regionHotspots(onSelect, constraints),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final region in landingRegionsData)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: LandingBadgePill(
                      label: region.name.toUpperCase(),
                      icon: region.icon,
                      selected: region.id == activeRegionId,
                      onTap: () => onSelect(region.id),
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

List<Widget> _regionHotspots(ValueChanged<String> onSelect, BoxConstraints c) {
  Widget box(String id, double left, double top, double width, double height) {
    return Positioned(
      left: left * c.maxWidth,
      top: top * c.maxHeight,
      width: width * c.maxWidth,
      height: height * c.maxHeight,
      child: GestureDetector(
        onTap: () => onSelect(id),
        child: const ColoredBox(color: Colors.transparent),
      ),
    );
  }

  return [
    box('americas', 0.02, 0.08, 0.30, 0.86),
    box('europe', 0.38, 0.08, 0.15, 0.34),
    box('me-africa', 0.39, 0.30, 0.25, 0.55),
    box('south-asia', 0.61, 0.40, 0.10, 0.25),
    box('se-asia', 0.69, 0.42, 0.10, 0.30),
    box('east-asia', 0.53, 0.16, 0.43, 0.40),
    box('maritime-se-asia', 0.71, 0.58, 0.25, 0.35),
  ];
}

String _tasteMapSvg(String activeRegionId) {
  String fillFor(String id) =>
      activeRegionId == id ? 'rgba(192,86,33,0.35)' : 'rgba(30,41,59,0.15)';
  String strokeFor(String id) =>
      activeRegionId == id ? 'rgba(192,86,33,0.45)' : 'rgba(30,41,59,0.12)';
  return '''
<svg viewBox="0 0 1000 600" xmlns="http://www.w3.org/2000/svg">
  <g opacity="0.15" stroke="#1E293B" stroke-width="0.5" stroke-dasharray="3,6">
    <line x1="0" y1="100" x2="1000" y2="100"/><line x1="0" y1="200" x2="1000" y2="200"/>
    <line x1="0" y1="300" x2="1000" y2="300"/><line x1="0" y1="400" x2="1000" y2="400"/>
    <line x1="0" y1="500" x2="1000" y2="500"/><line x1="100" y1="0" x2="100" y2="600"/>
    <line x1="200" y1="0" x2="200" y2="600"/><line x1="300" y1="0" x2="300" y2="600"/>
    <line x1="400" y1="0" x2="400" y2="600"/><line x1="500" y1="0" x2="500" y2="600"/>
    <line x1="600" y1="0" x2="600" y2="600"/><line x1="700" y1="0" x2="700" y2="600"/>
    <line x1="800" y1="0" x2="800" y2="600"/><line x1="900" y1="0" x2="900" y2="600"/>
  </g>
  <path fill="${fillFor('americas')}" stroke="${strokeFor('americas')}" stroke-width="1.2"
    d="M 40,85 C 45,75 55,70 70,75 C 80,72 100,75 110,65 C 120,60 140,55 160,65 C 170,70 175,80 185,80 C 190,80 190,110 185,120 C 180,125 195,135 210,135 C 220,135 225,120 230,110 C 235,110 240,115 250,110 C 255,100 250,90 260,95 C 270,100 275,115 270,125 C 265,130 275,140 260,150 C 250,155 240,150 235,160 C 230,170 240,185 235,200 C 230,210 215,225 210,240 C 205,255 208,275 205,280 C 200,285 195,275 190,268 C 185,260 180,260 170,255 C 160,250 150,255 145,265 C 148,272 155,275 160,280 C 165,285 160,295 155,300 C 150,305 145,315 150,320 C 155,325 165,310 175,325 C 180,335 170,350 165,360 C 155,350 145,335 140,320 C 135,310 125,300 120,290 C 115,285 115,260 110,250 C 105,240 100,250 98,260 C 95,270 92,260 90,245 C 88,230 92,215 95,200 C 98,185 92,175 88,165 C 82,150 75,140 70,130 C 65,120 55,122 50,118 C 42,110 32,122 28,125 C 25,126 25,120 30,115 C 35,110 40,110 45,105 C 50,100 40,95 40,85 Z" />
  <path fill="${fillFor('europe')}" stroke="${strokeFor('europe')}" stroke-width="1.2"
    d="M 410,215 C 402,205 408,185 425,182 C 430,175 435,160 440,155 C 445,150 455,150 460,140 C 465,135 460,120 455,105 C 452,90 460,70 475,60 C 488,55 495,65 495,80 C 492,95 485,110 480,120 C 478,130 488,140 495,145 C 505,140 515,120 520,105 C 525,95 530,85 535,90 C 540,100 535,115 530,125 C 525,135 528,145 535,148 C 540,150 540,165 535,175 C 525,180 520,190 525,198 C 520,205 510,210 505,215 C 500,225 490,225 482,215 C 478,205 470,200 465,200 C 460,195 450,192 445,195 C 435,198 425,215 410,215 Z" />
  <path fill="${fillFor('me-africa')}" stroke="${strokeFor('me-africa')}" stroke-width="1.2"
    d="M 430,240 C 420,245 408,255 402,270 C 395,285 400,305 415,312 C 430,318 440,310 450,325 C 458,335 465,345 475,348 C 485,350 492,375 498,400 C 505,430 512,460 518,485 C 522,488 528,485 532,475 C 538,455 545,420 545,395 C 550,380 565,370 575,355 C 585,342 595,335 598,325 C 598,318 585,315 572,310 C 560,305 550,290 545,280 C 540,270 548,258 535,258 C 525,258 510,255 495,255 C 475,252 450,242 430,240 Z" />
  <path fill="${fillFor('south-asia')}" stroke="${strokeFor('south-asia')}" stroke-width="1.2"
    d="M 630,260 C 638,280 642,300 648,320 C 654,340 662,355 665,360 C 668,355 674,340 678,325 C 682,310 688,295 695,280 C 685,275 670,270 655,268 C 645,265 635,262 630,260 Z" />
  <path fill="${fillFor('se-asia')}" stroke="${strokeFor('se-asia')}" stroke-width="1.2"
    d="M 695,280 C 702,295 705,315 710,330 C 715,345 722,380 730,410 C 732,420 736,425 735,430 C 734,425 736,400 740,385 C 744,375 750,370 758,372 C 766,374 772,365 768,350 C 764,335 758,320 754,300 C 750,290 730,285 715,282 C 705,280 698,280 695,280 Z" />
  <path fill="${fillFor('east-asia')}" stroke="${strokeFor('east-asia')}" stroke-width="1.2"
    d="M 540,150 C 580,140 640,125 700,118 C 760,110 820,105 880,100 C 910,98 940,102 950,115 C 955,122 942,145 935,160 C 928,175 910,185 895,190 C 885,192 870,202 860,208 C 850,212 848,220 845,230 C 842,238 845,242 838,242 C 830,242 825,232 820,240 C 815,248 808,260 798,272 C 788,285 770,285 758,292 C 748,295 735,290 725,288 C 715,285 680,285 650,280 C 620,275 580,265 560,250 C 540,235 535,215 530,195 C 525,175 530,158 540,150 Z" />
  <path fill="${fillFor('maritime-se-asia')}" stroke="${strokeFor('maritime-se-asia')}" stroke-width="1.2"
    d="M 815,495 C 825,485 845,488 855,492 C 860,490 862,482 865,485 C 868,495 860,510 865,520 C 872,530 882,540 885,550 C 888,560 880,570 872,572 C 865,575 860,580 855,572 C 845,565 830,565 820,560 C 812,555 805,545 805,535 C 805,520 810,505 815,495 Z" />
  <g stroke="#C05621" stroke-width="1.5" stroke-dasharray="4,6" fill="none" opacity="0.35">
    <path d="M180,260 Q340,160 480,180 T680,300 T760,390" />
    <path d="M480,180 Q520,300 535,420" />
    <path d="M680,365 Q740,460 835,480" />
  </g>
</svg>
''';
}

class _RegionPin extends StatelessWidget {
  const _RegionPin({
    required this.region,
    required this.isActive,
    required this.onTap,
  });

  final LandingRegion region;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.translate(
        offset: const Offset(-14, -14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? LandingPalette.red : LandingPalette.cream,
                border: Border.all(
                  color: isActive
                      ? LandingPalette.cream
                      : LandingPalette.charcoal.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4),
                ],
              ),
              alignment: Alignment.center,
              child: Text(region.icon, style: const TextStyle(fontSize: 12)),
            ),
            if (isActive) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: LandingPalette.charcoal,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  region.name,
                  style: const TextStyle(
                    color: LandingPalette.cream,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RecipePassCard extends StatelessWidget {
  const _RecipePassCard({
    required this.recipe,
    required this.tab,
    required this.onTab,
    required this.checked,
    required this.onToggleIngredient,
  });

  final LandingRecipe recipe;
  final LandingRecipeTab tab;
  final ValueChanged<LandingRecipeTab> onTab;
  final Set<int> checked;
  final ValueChanged<int> onToggleIngredient;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LandingPalette.cream,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: LandingPalette.charcoal.withValues(alpha: 0.1),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 8,
            child: ColoredBox(color: LandingPalette.red),
          ),
          SizedBox(
            height: 192,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: recipe.imageUrl,
                  fit: BoxFit.cover,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: LandingPalette.red.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          recipe.localTradition.toUpperCase(),
                          style: LandingPalette.mono(
                            context,
                            size: 9,
                            color: LandingPalette.cream,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        recipe.name,
                        style: LandingPalette.serif(
                          context,
                          size: 22,
                          color: LandingPalette.cream,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                _Metric(
                  icon: Icons.schedule,
                  value: recipe.cookingTime.toUpperCase(),
                  label: 'COOK TIME',
                ),
                _Metric(
                  icon: Icons.local_fire_department,
                  value: '${recipe.calories} KCAL',
                  label: 'CALORIES',
                ),
                _Metric(
                  icon: Icons.emoji_events,
                  value: recipe.difficultyLabel.toUpperCase(),
                  label: 'DIFFICULTY',
                ),
                _Metric(
                  icon: Icons.restaurant,
                  value: '${recipe.servings} PAX',
                  label: 'SERVINGS',
                ),
              ],
            ),
          ),
          Row(
            children: [
              _TabButton(
                label: 'The Heritage',
                icon: Icons.menu_book,
                selected: tab == LandingRecipeTab.heritage,
                onTap: () => onTab(LandingRecipeTab.heritage),
              ),
              _TabButton(
                label: 'Ingredients',
                icon: Icons.list,
                selected: tab == LandingRecipeTab.ingredients,
                onTap: () => onTab(LandingRecipeTab.ingredients),
              ),
              _TabButton(
                label: 'Preparation',
                icon: Icons.chevron_right,
                selected: tab == LandingRecipeTab.steps,
                onTap: () => onTab(LandingRecipeTab.steps),
              ),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 320),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: switch (tab) {
                  LandingRecipeTab.heritage => _HeritageTab(recipe: recipe),
                  LandingRecipeTab.ingredients => _IngredientsTab(
                    recipe: recipe,
                    checked: checked,
                    onToggle: onToggleIngredient,
                  ),
                  LandingRecipeTab.steps => _StepsTab(recipe: recipe),
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: LandingPalette.alabaster,
              border: Border(
                top: BorderSide(
                  color: LandingPalette.charcoal.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const LandingBarcode(height: 28),
                      Text(
                        '30+ authentic regional cuisines waiting.\nFind yours.',
                        textAlign: TextAlign.right,
                        style: LandingPalette.mono(
                          context,
                          size: 9,
                          color: LandingPalette.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: -10,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: LandingPalette.cream,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: -10,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: LandingPalette.cream,
                        shape: BoxShape.circle,
                      ),
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

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: LandingPalette.alabaster,
          border: Border(
            right: BorderSide(
              color: LandingPalette.charcoal.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 14, color: LandingPalette.red),
            const SizedBox(height: 4),
            Text(
              value,
              style: LandingPalette.mono(
                context,
                size: 10,
                weight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: LandingPalette.mono(
                context,
                size: 8,
                color: LandingPalette.charcoal.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? LandingPalette.alabaster.withValues(alpha: 0.3)
                : null,
            border: Border(
              bottom: BorderSide(
                color: selected ? LandingPalette.red : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: selected
                    ? LandingPalette.red
                    : LandingPalette.charcoal.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: LandingPalette.sans(
                    context,
                    size: 12,
                    weight: FontWeight.w600,
                    color: selected
                        ? LandingPalette.red
                        : LandingPalette.charcoal.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeritageTab extends StatelessWidget {
  const _HeritageTab({required this.recipe});

  final LandingRecipe recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('heritage'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(recipe.description, style: LandingPalette.sans(context, size: 14)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: LandingPalette.alabaster,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: LandingPalette.charcoal.withValues(alpha: 0.05),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'AROMA PROFILE:',
                    style: LandingPalette.sans(
                      context,
                      size: 12,
                      weight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    recipe.aromaProfile,
                    style: LandingPalette.mono(
                      context,
                      size: 11,
                      color: LandingPalette.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SPICE INTENSITY:',
                    style: LandingPalette.sans(
                      context,
                      size: 12,
                      weight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: LandingPalette.saffron.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      recipe.spiceLevelLabel.toUpperCase(),
                      style: LandingPalette.mono(context, size: 9),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IngredientsTab extends StatelessWidget {
  const _IngredientsTab({
    required this.recipe,
    required this.checked,
    required this.onToggle,
  });

  final LandingRecipe recipe;
  final Set<int> checked;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('ingredients'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Check off gathered items:',
          style: LandingPalette.mono(context, size: 10),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < recipe.ingredients.length; i++)
          CheckboxListTile(
            value: checked.contains(i),
            onChanged: (_) => onToggle(i),
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(
              recipe.ingredients[i],
              style: TextStyle(
                decoration: checked.contains(i)
                    ? TextDecoration.lineThrough
                    : null,
                fontSize: 14,
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: LandingPalette.cardamom,
          ),
      ],
    );
  }
}

class _StepsTab extends StatelessWidget {
  const _StepsTab({required this.recipe});

  final LandingRecipe recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('steps'),
      children: [
        for (var i = 0; i < recipe.instructions.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: LandingPalette.charcoal,
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(
                      color: LandingPalette.cream,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    recipe.instructions[i],
                    style: LandingPalette.sans(context, size: 14),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
