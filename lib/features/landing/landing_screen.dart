import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'landing_palette.dart';
import 'landing_state.dart';
import 'widgets/landing_boarding_pass.dart';
import 'widgets/landing_chef_companion.dart';
import 'widgets/landing_footer.dart';
import 'widgets/landing_global_terminal.dart';
import 'widgets/landing_header.dart';
import 'widgets/landing_hero.dart';
import 'widgets/landing_pricing_modal.dart';
import 'widgets/landing_pricing_section.dart';
import 'widgets/landing_spin_modal.dart';
import 'widgets/landing_taste_map.dart';

class LandingScreen extends ConsumerStatefulWidget {
  const LandingScreen({super.key});

  @override
  ConsumerState<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  final _scroll = ScrollController();
  final _sections = LandingSectionKeys();
  var _spinOpen = false;
  var _pricingOpen = false;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _openSpin() => setState(() => _spinOpen = true);
  void _closeSpin() => setState(() => _spinOpen = false);
  void _openPricing() => setState(() => _pricingOpen = true);
  void _closePricing() => setState(() => _pricingOpen = false);

  @override
  Widget build(BuildContext context) {
    final isSubscribed = ref.watch(landingPremiumProvider);

    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: LandingPalette.cream,
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: LandingPalette.red,
          surface: LandingPalette.cream,
        ),
      ),
      child: Scaffold(
        backgroundColor: LandingPalette.cream,
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scroll,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _LandingHeaderDelegate(
                    child: LandingHeader(
                      isSubscribed: isSubscribed,
                      onScrollTo: (k) => _sections.scrollTo(k, _scroll),
                      onScrollTop: () => _scroll.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      ),
                      onScrollToPricing: () =>
                          _sections.scrollTo(_sections.pricing, _scroll),
                      sections: _sections,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: LandingHero(
                    onSpinGlobe: _openSpin,
                    onBrowseMap: () =>
                        _sections.scrollTo(_sections.tasteMap, _scroll),
                    sections: _sections,
                  ),
                ),
                SliverToBoxAdapter(
                  child: KeyedSubtree(
                    key: _sections.tasteMap,
                    child: const LandingTasteMap(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: KeyedSubtree(
                    key: _sections.chefToolkit,
                    child: LandingChefCompanion(
                      isSubscribed: isSubscribed,
                      onOpenPricing: _openPricing,
                      onBrowseHeritage: () {
                        _sections.scrollTo(_sections.tasteMap, _scroll);
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: KeyedSubtree(
                    key: _sections.globalTerminal,
                    child: const LandingGlobalTerminal(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: KeyedSubtree(
                    key: _sections.pricing,
                    child: LandingPricingSection(
                      isSubscribed: isSubscribed,
                      onSubscribe: (v) => ref
                          .read(landingPremiumProvider.notifier)
                          .setSubscribed(v),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: KeyedSubtree(
                    key: _sections.boardingCall,
                    child: const LandingBoardingPassForm(),
                  ),
                ),
                const SliverToBoxAdapter(child: LandingFooter()),
              ],
            ),
            if (_spinOpen)
              LandingSpinModal(
                onClose: _closeSpin,
                onExploreMap: () {
                  _closeSpin();
                  _sections.scrollTo(_sections.tasteMap, _scroll);
                },
              ),
            if (_pricingOpen)
              LandingPricingModal(
                isSubscribed: isSubscribed,
                onClose: _closePricing,
                onSubscribe: (v) {
                  ref.read(landingPremiumProvider.notifier).setSubscribed(v);
                  _closePricing();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _LandingHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _LandingHeaderDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 72;

  @override
  double get maxExtent => 72;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _LandingHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
