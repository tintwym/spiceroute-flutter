import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/cuisine_region.dart';
import '../models/spice_route.dart';
import 'breakpoints.dart';
import 'cuisine_pill_bar.dart';
import 'theme.dart';

/// Two-tier geographic cuisine filter.
///
/// Layout (top to bottom):
///   1. "EXPLORE BY GEOGRAPHIC REGION" eyebrow.
///   2. A wrap of [_RegionPill]s — one per region with at least one
///      cuisine. Tap to switch which region's cuisines appear below.
///      Selected region has a charcoal fill + light text, others are
///      cream surface with a hairline outline.
///   3. A card-framed section containing the eyebrow "SELECT CUISINE
///      TRADITION" and a wrap of [_CuisinePill]s for the cuisines in
///      the currently-selected region. Selected cuisine uses the same
///      charcoal-fill treatment as the active region pill.
///
/// State model:
///   - [cuisine] is the single source of truth — the actual filter
///     applied to the recipe grid. Lives in [ExploreState].
///   - The active *region* is purely UI state, derived from [cuisine]
///     on the first build and tracked locally after that. If the user
///     picks a region without picking a cuisine, the recipe grid does
///     NOT filter — the region row is navigation, not a filter. (Once
///     they tap a cuisine inside it, that's when the grid narrows.)
///
/// Animation: the cuisine sub-row is wrapped in [AnimatedSwitcher]
/// with a crossfade + slight slide so switching regions feels
/// responsive but not jumpy.
///
/// Empty regions are hidden automatically via [populatedRegions]. As
/// the cuisine catalog grows, this widget needs zero changes — it
/// picks up new cuisines via the [CuisineRegionLookup] extension and
/// new regions appear once they have a member.
class RegionFilterBar extends StatefulWidget {
  const RegionFilterBar({
    super.key,
    required this.cuisine,
    required this.onCuisineChanged,
  });

  /// Currently-filtered cuisine, or null if no cuisine filter is
  /// active. The same value passed to the recipe grid.
  final Cuisine? cuisine;

  /// Tapping a cuisine pill calls this with the new value. Tapping the
  /// already-active cuisine clears the filter (passes null).
  final ValueChanged<Cuisine?> onCuisineChanged;

  @override
  State<RegionFilterBar> createState() => _RegionFilterBarState();
}

class _RegionFilterBarState extends State<RegionFilterBar> {
  late CuisineRegion _activeRegion;

  @override
  void initState() {
    super.initState();
    _activeRegion = _initialRegion();
  }

  @override
  void didUpdateWidget(covariant RegionFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If a cuisine selection arrives from outside (URL param, deep
    // link, "filter applied from somewhere else") and it points to a
    // different region than we're showing, jump to that region so the
    // active pill is visible. Without this the user could end up
    // looking at "European" cuisines with `cuisine = Korean` quietly
    // filtering the grid — no visible affordance to clear it.
    final next = widget.cuisine;
    if (next != null && next.region != _activeRegion) {
      _activeRegion = next.region;
    }
  }

  /// Pick the initial region: prefer the region of the already-active
  /// cuisine; fall back to the first populated region (the natural
  /// "default tab" of the catalog).
  CuisineRegion _initialRegion() {
    final c = widget.cuisine;
    if (c != null) return c.region;
    final populated = populatedRegions();
    return populated.isNotEmpty
        ? populated.first
        : CuisineRegion.eastAsia; // unreachable while we have any cuisine
  }

  void _selectRegion(CuisineRegion region) {
    if (region == _activeRegion) return;
    setState(() => _activeRegion = region);
    // If the previously-active cuisine no longer belongs to the new
    // region, clear it — keeping a hidden filter would feel like a
    // bug ("I switched regions but the grid still shows old stuff").
    final current = widget.cuisine;
    if (current != null && current.region != region) {
      widget.onCuisineChanged(null);
    }
  }

  void _selectCuisine(Cuisine cuisine) {
    // Re-tap to clear is a common pill-bar affordance — saves a
    // separate "x" button per pill and matches the behavior of the
    // dropdown filter (which has an explicit "All Cuisines" option
    // serving the same purpose).
    if (widget.cuisine == cuisine) {
      widget.onCuisineChanged(null);
      return;
    }
    widget.onCuisineChanged(cuisine);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final regions = populatedRegions();
    // Defensive: if the catalog is somehow empty (shouldn't happen
    // since `Cuisine.values` is non-empty by definition) render
    // nothing rather than crashing on `populated.first`.
    if (regions.isEmpty) return const SizedBox.shrink();

    final cuisinesInRegion = _activeRegion.cuisines;
    final isPhone = deviceClassOf(context).isPhone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -----------------------------------------------------------
        // Top tier: region eyebrow + region pills.
        // -----------------------------------------------------------
        _Eyebrow(
          icon: _regionEyebrowIcon,
          text: l.exploreByRegion,
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final r in regions)
              _RegionPill(
                emoji: _regionEmoji(r),
                label: _regionLabel(l, r),
                selected: r == _activeRegion,
                onTap: () => _selectRegion(r),
              ),
          ],
        ),
        const SizedBox(height: 18),
        // -----------------------------------------------------------
        // Bottom tier: card-framed cuisine row, eyebrow + pills.
        //
        // AnimatedSwitcher lives HERE (the persistent ancestor) and
        // crossfades between two _CuisineTraditionCard instances that
        // differ only in their ValueKey(region). If the switcher
        // lived inside the swapped widget, swapping `key` would
        // destroy the switcher itself and there'd be no transition.
        // -----------------------------------------------------------
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            // Default layoutBuilder centers children in a Stack — fine
            // for icons but bad for left-aligned cards because the
            // shorter card's left edge drifts during the crossfade.
            // Pin top-left so both cards line up exactly with the page
            // edge while transitioning.
            layoutBuilder: (currentChild, previousChildren) {
              return Stack(
                alignment: Alignment.topLeft,
                children: [
                  ...previousChildren,
                  ?currentChild,
                ],
              );
            },
            transitionBuilder: (child, animation) {
              // Slide-in from the right paired with a fade so the
              // swap reads as "content slid into view," not a jarring
              // pop. 0.03 = ~3% of width, subtle on purpose.
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.03, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _CuisineTraditionCard(
              // Distinct key per region drives the crossfade.
              key: ValueKey(_activeRegion),
              eyebrow: l.selectCuisineTradition,
              compact: isPhone,
              children: [
                for (final c in cuisinesInRegion)
                  _CuisinePill(
                    emoji: CuisinePillBar.emojiFor(c),
                    label: CuisinePillBar.labelFor(l, c),
                    selected: widget.cuisine == c,
                    onTap: () => _selectCuisine(c),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Card that frames the cuisine row. Keyed by region in the parent
/// so AnimatedSwitcher can crossfade between region payloads.
///
/// `compact` shrinks horizontal padding from 20 → 14 on phone-class
/// viewports. The 6px difference per side is invisible on desktop but
/// frees 12px of horizontal pill space on a 343px-wide phone — enough
/// to fit one more pill per row in most locales.
class _CuisineTraditionCard extends StatelessWidget {
  const _CuisineTraditionCard({
    super.key,
    required this.eyebrow,
    required this.children,
    this.compact = false,
  });

  final String eyebrow;
  final List<Widget> children;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hPad = compact ? 14.0 : 20.0;
    final vPad = compact ? 16.0 : 18.0;
    return Container(
      padding: EdgeInsets.fromLTRB(hPad, vPad, hPad, vPad),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Eyebrow(icon: _cuisineEyebrowIcon, text: eyebrow),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: children,
          ),
        ],
      ),
    );
  }
}

/// Eyebrow label: small icon + uppercase tracked text. Used for
/// "EXPLORE BY GEOGRAPHIC REGION" and "SELECT CUISINE TRADITION".
/// Matches the reference design's small ochre-tinted prefix glyph.
class _Eyebrow extends StatelessWidget {
  const _Eyebrow({required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Row(
      children: [
        // Decorative — the eyebrow text is the meaningful payload.
        ExcludeSemantics(
          child: Text(icon, style: emojiTextStyle(fontSize: 14)),
        ),
        const SizedBox(width: 8),
        // Flexible + softWrap=true so long labels (notably the
        // Burmese region eyebrow which is wordy) wrap to a second
        // line on narrow phones instead of overflowing off the right
        // edge. Without this the row would silently RenderFlex-
        // overflow and we'd ship the trademark yellow-and-black
        // diagonal bars in production.
        Flexible(
          child: Text(
            text,
            softWrap: true,
            style: theme.textTheme.labelMedium?.copyWith(
              color: cs.secondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

/// Region pill. Selected = charcoal fill + cream text. Unselected =
/// cream fill + thin outline + charcoal text.
///
/// Both states share padding/radius so toggling doesn't jiggle the
/// layout. Wraps emoji in [emojiTextStyle] so flag/region glyphs
/// render on Flutter web (CanvasKit doesn't auto-fallback to emoji
/// fonts — see [kEmojiFontFallback]).
class _RegionPill extends StatelessWidget {
  const _RegionPill({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _PillButton(
      selected: selected,
      semanticLabel: label,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Emoji is decorative — already covered by the semantic
          // label of the pill; let screen readers skip the codepoint
          // (otherwise SR announces "🏯 East Asian Countries" verbatim,
          // which is noise).
          ExcludeSemantics(
            child: Text(emoji, style: emojiTextStyle(fontSize: 14)),
          ),
          const SizedBox(width: 8),
          // Flexible so a long label ("Mainland Southeast Asia",
          // and worse in Burmese) wraps to a second line on narrow
          // phones instead of triggering RenderFlex overflow. Wrap
          // (the parent) hands the pill at most `Wrap.maxWidth` of
          // space; without Flexible the inner Row demands its
          // intrinsic width and bleeds past the right edge.
          Flexible(child: _PillLabel(text: label, selected: selected)),
        ],
      ),
    );
  }
}

/// Cuisine pill. Same chrome as [_RegionPill] (intentionally — the
/// reference design uses identical pill geometry for both tiers); the
/// only difference is the icon comes from [CuisinePillBar.emojiFor]
/// so each pill shows the country flag rather than a region glyph.
class _CuisinePill extends StatelessWidget {
  const _CuisinePill({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _PillButton(
      selected: selected,
      semanticLabel: label,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: Text(emoji, style: emojiTextStyle(fontSize: 14)),
          ),
          const SizedBox(width: 8),
          // See _RegionPill for the rationale — same overflow shield.
          Flexible(child: _PillLabel(text: label, selected: selected)),
        ],
      ),
    );
  }
}

/// Bare pill chrome — handles the shape, fill, border, padding, and
/// hover/tap interaction. The two pill variants delegate the contents.
///
/// Structure intentionally inverts the obvious order:
///   AnimatedContainer  (paints fill + border + animates the color flip)
///     └── Material      (transparent — gives the InkWell something to
///                        ink onto)
///         └── InkWell  (paints ripple/hover/focus on top of the fill)
///             └── Padding + child
///
/// If `Material` lived OUTSIDE `AnimatedContainer`, the InkWell would
/// ink onto the Material's transparent surface — then `AnimatedContainer`
/// would paint its opaque fill ON TOP, hiding the ripple entirely.
/// We hit exactly that bug in the first cut; this layout is the fix.
class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.selected,
    required this.semanticLabel,
    required this.onTap,
    required this.child,
  });

  final bool selected;

  /// Kept on the API even though we no longer pass it through to the
  /// outer Semantics node — the inner Text widget supplies the label
  /// via its implicit semantics, and adding it here too produced a
  /// duplicated "Korean Korean" announcement on screen readers. The
  /// param remains so call-sites self-document which label belongs to
  /// which pill (avoids passing only the icon child and losing the
  /// readable affordance).
  // ignore: unused_element_parameter
  final String semanticLabel;

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Charcoal-on-cream when selected matches the reference design's
    // near-black active state. We use `onSurface` (the canonical
    // text color) rather than literal black so dark mode inverts
    // gracefully (selected pills become cream on charcoal).
    final fill = selected ? cs.onSurface : cs.surface;
    final border = selected ? cs.onSurface : cs.outlineVariant;
    return Semantics(
      container: true,
      button: true,
      // Toggle semantics — VoiceOver / TalkBack announce
      // "selected, button" or "not selected, button" so users
      // hear the current state of each pill. The label itself comes
      // from the inner Text widget's implicit semantics.
      selected: selected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: border, width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(40),
            // Min 44px tall to meet Apple HIG / Material Design
            // touch-target guidance. labelMedium text is only ~16px
            // tall, so without this the pill would land around 36-38
            // px and miss the spec on phones (where finger taps are
            // the only input mode). Mouse hits on desktop are fine
            // either way, so 44 is a no-op constraint there.
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 44),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Center(
                  widthFactor: 1,
                  heightFactor: 1,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PillLabel extends StatelessWidget {
  const _PillLabel({required this.text, required this.selected});

  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Text(
      text,
      style: theme.textTheme.labelMedium?.copyWith(
        color: selected ? cs.surface : cs.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// Eyebrow glyphs picked to read at 14px and mirror the reference
/// design's category icons. Kept inline (not constants on a class)
/// because they're never read from outside this file.
const String _regionEyebrowIcon = '🏯';
const String _cuisineEyebrowIcon = '✨';

String _regionLabel(AppL10n l, CuisineRegion r) {
  switch (r) {
    case CuisineRegion.eastAsia:
      return l.regionEastAsia;
    case CuisineRegion.mainlandSoutheastAsia:
      return l.regionMainlandSoutheastAsia;
    case CuisineRegion.maritimeSoutheastAsia:
      return l.regionMaritimeSoutheastAsia;
    case CuisineRegion.southAsia:
      return l.regionSouthAsia;
    case CuisineRegion.europe:
      return l.regionEurope;
    case CuisineRegion.americas:
      return l.regionAmericas;
    case CuisineRegion.middleEastAfrica:
      return l.regionMiddleEastAfrica;
  }
}

/// Region-row emoji. Choices match the reference design's iconography
/// vocabulary — a recognisable single-glyph proxy for each region.
String _regionEmoji(CuisineRegion r) {
  switch (r) {
    case CuisineRegion.eastAsia:
      return '🏯';
    case CuisineRegion.mainlandSoutheastAsia:
      return '🌶️';
    case CuisineRegion.maritimeSoutheastAsia:
      return '🛶';
    case CuisineRegion.southAsia:
      return '🍛';
    case CuisineRegion.europe:
      return '🏰';
    case CuisineRegion.americas:
      return '🥑';
    case CuisineRegion.middleEastAfrica:
      return '🐪';
  }
}
