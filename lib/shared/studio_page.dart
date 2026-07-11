import 'package:flutter/material.dart';

import 'breakpoints.dart';
import 'page_hero.dart';
import 'page_tabs.dart';
import 'site_footer.dart';

/// Editorial page wrapper used by the AI Creator / AI Companion pages (and
/// available to any other content page). Lays out, top to bottom:
///   [PageHero]  ->  the page's [child]  ->  [SiteFooter]
/// all centered within the shared content frame so they line up with the
/// sticky header above.
///
/// Explore doesn't use this — it needs a lazy sliver grid, so it assembles
/// the same pieces (hero + footer + community board) by hand.
class StudioPage extends StatelessWidget {
  const StudioPage({
    super.key,
    required this.child,
    this.showHero = true,
    this.heroTitle,
    this.heroSubtitle,
  });

  final Widget child;
  final bool showHero;

  /// Override for the hero headline. When null, [PageHero] falls back to
  /// the Explore default ("SpiceRoute"). Each consumer page passes its
  /// own copy so the Explore subtitle doesn't bleed across tabs.
  final String? heroTitle;

  /// Override for the hero subtitle paragraph.
  final String? heroSubtitle;

  @override
  Widget build(BuildContext context) {
    final pad = pagePadding(context);
    final maxW = contentMaxWidth(context);

    Widget framed(Widget w) => Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: w,
      ),
    );

    // Keyboard-aware bottom padding. The Studio pages (AI Creator,
    // AI Companion) each host a multi-line `TextField` followed by
    // their primary action (Create / Send button). On phone, the
    // soft keyboard reduces the visible viewport by ~270 dp; without
    // this padding, the action sits below the keyboard with no way
    // to scroll it into view (`ensureVisible` only scrolls enough
    // to show the caret, not subsequent siblings). Adding the
    // keyboard inset as bottom padding extends the ListView's
    // scrollExtent so the user can flick up to reach the button.
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    final isPhone = deviceClassOf(context).isPhone;

    return ListView(
      padding: EdgeInsets.only(bottom: keyboardInset),
      physics: const ClampingScrollPhysics(),
      children: [
        if (showHero && !isPhone)
          Padding(
            padding: pad.copyWith(top: 32, bottom: 8),
            child: framed(PageHero(title: heroTitle, subtitle: heroSubtitle)),
          ),
        // Page-level tab row sits between the hero and the page body,
        // matching the reference design where tabs run as a banded
        // sub-nav under the editorial headline. Hidden on phone.
        if (!isPhone)
          Padding(
            padding: pad.copyWith(top: showHero ? 12 : 24, bottom: 0),
            child: framed(const PageTabs()),
          ),
        Padding(
          padding: pad.copyWith(top: isPhone ? 16 : 24),
          child: framed(child),
        ),
        if (!isPhone)
          Padding(
            padding: pad.copyWith(top: 48, bottom: 28),
            child: framed(const SiteFooter()),
          ),
      ],
    );
  }
}
