import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
import 'widgets/landing_shared.dart';
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

  Future<void> _enterApp() async {
    await ref.read(landingGateProvider.notifier).completeOnboarding();
    if (!mounted) return;
    context.go('/');
  }

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
                    builder: (shrinkOffset, overlapsContent) => LandingHeader(
                      elevated: shrinkOffset > 8 || overlapsContent,
                      isSubscribed: isSubscribed,
                      onScrollTo: (k) => _sections.scrollTo(k, _scroll),
                      onScrollTop: () => _scroll.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      ),
                      onScrollToPricing: () =>
                          _sections.scrollTo(_sections.pricing, _scroll),
                      onEnterApp: _enterApp,
                      sections: _sections,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: LandingHero(
                    onSpinGlobe: _openSpin,
                    onBrowseMap: () =>
                        _sections.scrollTo(_sections.tasteMap, _scroll),
                    onEnterApp: _enterApp,
                    sections: _sections,
                  ),
                ),
                SliverToBoxAdapter(
                  child: LandingScrollReveal(
                    scrollController: _scroll,
                    child: KeyedSubtree(
                    key: _sections.tasteMap,
                    child: const LandingTasteMap(),
                  ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: LandingScrollReveal(
                    scrollController: _scroll,
                    delay: const Duration(milliseconds: 60),
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
                ),
                SliverToBoxAdapter(
                  child: LandingScrollReveal(
                    scrollController: _scroll,
                    delay: const Duration(milliseconds: 60),
                    child: KeyedSubtree(
                    key: _sections.globalTerminal,
                    child: const LandingGlobalTerminal(),
                  ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: LandingScrollReveal(
                    scrollController: _scroll,
                    delay: const Duration(milliseconds: 60),
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
                ),
                SliverToBoxAdapter(
                  child: LandingScrollReveal(
                    scrollController: _scroll,
                    delay: const Duration(milliseconds: 60),
                    child: KeyedSubtree(
                    key: _sections.boardingCall,
                    child: LandingBoardingPassForm(onEnteredApp: _enterApp),
                  ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: LandingScrollReveal(
                    scrollController: _scroll,
                    delay: const Duration(milliseconds: 60),
                    child: LandingFooter(onEnterApp: _enterApp),
                  ),
                ),
              ],
            ),
            if (_spinOpen)
              LandingModalShell(
                onDismissed: _closeSpin,
                builder: (close) => LandingSpinModal(
                  onClose: close,
                  onExploreMap: () {
                    close();
                    _sections.scrollTo(_sections.tasteMap, _scroll);
                  },
                ),
              ),
            if (_pricingOpen)
              LandingModalShell(
                onDismissed: _closePricing,
                builder: (close) => LandingPricingModal(
                  isSubscribed: isSubscribed,
                  onClose: close,
                  onSubscribe: (v) {
                    ref.read(landingPremiumProvider.notifier).setSubscribed(v);
                    close();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LandingHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _LandingHeaderDelegate({required this.builder});

  final Widget Function(double shrinkOffset, bool overlapsContent) builder;

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
    return builder(shrinkOffset, overlapsContent);
  }

  @override
  bool shouldRebuild(covariant _LandingHeaderDelegate oldDelegate) {
    return true;
  }
}
