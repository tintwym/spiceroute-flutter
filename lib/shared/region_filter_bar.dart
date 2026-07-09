import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/cuisine_catalog.dart';
import '../models/cuisine_region.dart';
import '../models/spice_route.dart';
import 'breakpoints.dart';
import 'cuisine_pill_bar.dart';
import 'mobile_filter_trigger.dart';
import 'theme.dart';

/// Two-tier geographic cuisine filter.
///
/// Layout (top to bottom):
///   1. "EXPLORE BY GEOGRAPHIC REGION" eyebrow.
///   2. Region pills — one per [populatedRegions] entry. On phone-class
///      viewports the full grid is **collapsed by default**: a single
///      summary row ("Choose a region" or the selected region) expands
///      into the pill row on tap. Tablet and desktop always show the
///      full wrap / scroll row.
///   3. A card-framed section containing the eyebrow "SELECT CUISINE
///      TRADITION" and cuisine pills for the cuisines in the
///      currently-selected region. Phone: horizontal scroll; tablet+:
///      wrap. ONLY rendered when a region is selected — see "blank-slate
///      state" below. Selected cuisine uses the same charcoal-fill
///      treatment as the active region pill.
///
/// State model:
///   - [cuisine] is the single source of truth — the actual filter
///     applied to the recipe grid. Lives in [ExploreState].
///   - The active *region* is purely UI state, NULLABLE, derived from
///     [cuisine] on the first build and tracked locally after that:
///       * `null`  → blank slate, the cuisine card is hidden entirely.
///                   Initial state when no cuisine filter is active.
///       * non-null → that region's cuisines are listed below.
///     Tapping the active region pill again returns to `null`
///     (matches the "tap to clear" affordance on cuisine pills).
///   - Picking a region without picking a cuisine does NOT filter the
///     grid — the region row is navigation, not a filter. The grid
///     narrows only when the user taps a cuisine pill inside it.
///
/// Why nullable: an earlier version auto-selected the first populated
/// region (East Asia) on every fresh open. Users hit the filter sheet
/// and saw East Asian cuisines pre-listed without having tapped
/// anything, which read as "the app already filtered for me" and was
/// confusing. The blank-slate default removes that surprise — the
/// cascade only opens when the user explicitly chooses a region.
///
/// Animation: the cuisine sub-row is wrapped in [AnimatedSwitcher]
/// + [AnimatedSize] so opening/closing/switching crossfades + slides
/// the height in or out. The same machinery handles
///   region A → region B (key change),
///   region   → null     (child swap to SizedBox sentinel),
///   null     → region   (child swap back),
/// uniformly, so we get one animation contract for all three.
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
    this.phonePreferencesTrigger,
    this.preferencesActive = false,
  });

  /// Currently-filtered cuisine, or null if no cuisine filter is
  /// active. The same value passed to the recipe grid.
  final Cuisine? cuisine;

  /// Tapping a cuisine pill calls this with the new value. Tapping the
  /// already-active cuisine clears the filter (passes null).
  final ValueChanged<Cuisine?> onCuisineChanged;

  /// Phone-only: right half of the combined region + preferences row.
  /// When set, [RegionFilterBar] renders Option A (one card, two
  /// columns) instead of a full-width region pill with [FilterBar]
  /// stacked below.
  final Widget? phonePreferencesTrigger;

  /// True when course/dietary filters are active — drives the combined
  /// refine card's active chrome when only preferences are set.
  final bool preferencesActive;

  @override
  State<RegionFilterBar> createState() => _RegionFilterBarState();
}

class _RegionFilterBarState extends State<RegionFilterBar> {
  /// Active region for the cuisine drawer below. `null` means
  /// blank-slate — no region picked, drawer hidden. See class doc on
  /// [RegionFilterBar] for the rationale.
  CuisineRegion? _activeRegion;

  /// Phone-only: whether the full region pill row is visible. Collapsed
  /// by default so the filter block doesn't consume multiple rows before
  /// recipes. Tablet/desktop ignore this flag.
  bool _regionPickerExpanded = false;

  @override
  void initState() {
    super.initState();
    // If a cuisine filter is already active when the bar mounts (e.g.
    // the sheet was reopened with `Cuisine.korean` already filtered),
    // start with that cuisine's region open so the user can see and
    // unpick it. Otherwise stay in the blank-slate state — no
    // auto-pick of "the first region in enum order".
    _activeRegion = widget.cuisine?.region;
  }

  @override
  void didUpdateWidget(covariant RegionFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync local UI state to outside-driven cuisine changes:
    //   * Cuisine arrived (URL param, deep link, "filter applied from
    //     somewhere else") in a region that's NOT the one the user is
    //     currently viewing → jump to that region so the active
    //     cuisine pill is visible. Without this the user could end up
    //     looking at "European" cuisines with `cuisine = Korean`
    //     quietly filtering the grid — no visible affordance to
    //     clear it.
    //   * Cuisine cleared from outside → leave the drawer alone. If
    //     the user has explicitly opened a region we shouldn't
    //     collapse it just because a programmatic clear arrived; they
    //     can re-tap the region pill themselves to close.
    final next = widget.cuisine;
    if (next != null && next.region != _activeRegion) {
      _activeRegion = next.region;
    }
  }

  void _selectRegion(CuisineRegion region) {
    final wasSame = _activeRegion == region;
    setState(() {
      // Re-tap to deselect — same affordance as the cuisine pills,
      // and the only way back to the blank-slate state without
      // dismissing the whole sheet.
      _activeRegion = wasSame ? null : region;
      // Collapse the phone region row after every pick/deselect.
      _regionPickerExpanded = false;
    });
    // Clear any cuisine filter that no longer makes sense:
    //   * Closing the drawer (region → null) with a cuisine still
    //     filtered would leave the grid narrowed with no visible
    //     pill to un-pick.
    //   * Switching to a different region likewise orphans the old
    //     cuisine.
    final current = widget.cuisine;
    final newRegion = _activeRegion;
    if (current != null && (newRegion == null || current.region != newRegion)) {
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

  void _toggleRegionPicker() {
    setState(() => _regionPickerExpanded = !_regionPickerExpanded);
  }

  /// Collapsed phone trigger copy: prefer the active cuisine (what
  /// actually filters the grid) over the region name alone.
  ({String emoji, String label}) _phoneRegionSummary(
    AppL10n l,
    CuisineRegion? activeRegion,
  ) {
    final cuisine = widget.cuisine;
    if (cuisine != null) {
      return (
        emoji: CuisinePillBar.emojiFor(cuisine),
        label: CuisinePillBar.labelFor(l, cuisineForDisplay(cuisine)),
      );
    }
    if (activeRegion != null) {
      return (
        emoji: _regionEmoji(activeRegion),
        label: _regionLabel(l, activeRegion),
      );
    }
    return (
      emoji: _regionEyebrowIcon,
      label: widget.phonePreferencesTrigger != null
          ? l.filterRegionShort
          : l.chooseRegion,
    );
  }

  bool _regionTriggerActive(CuisineRegion? activeRegion) =>
      activeRegion != null || widget.cuisine != null;

  bool _refineCardActive(CuisineRegion? activeRegion) =>
      _regionTriggerActive(activeRegion) || widget.preferencesActive;

  Widget _buildRegionPillRow(
    AppL10n l,
    List<CuisineRegion> regions,
    CuisineRegion? activeRegion, {
    required bool scrollable,
  }) {
    return _PillRow(
      scrollable: scrollable,
      children: [
        for (final r in regions)
          _RegionPill(
            emoji: _regionEmoji(r),
            label: _regionLabel(l, r),
            selected: r == activeRegion,
            scrollable: scrollable,
            onTap: () => _selectRegion(r),
          ),
      ],
    );
  }

  Widget _buildPhoneRegionTier(
    AppL10n l,
    List<CuisineRegion> regions,
    CuisineRegion? activeRegion,
  ) {
    final combined = widget.phonePreferencesTrigger != null;
    final summary = _phoneRegionSummary(l, activeRegion);
    final summaryLabel = summary.label;
    final summaryEmoji = summary.emoji;
    final regionActive = _regionTriggerActive(activeRegion);
    final refineActive = _refineCardActive(activeRegion);

    Widget regionTrigger;
    if (combined) {
      regionTrigger = MobileFilterTriggerHalf(
        emoji: summaryEmoji,
        label: summaryLabel,
        expanded: _regionPickerExpanded,
        isActive: regionActive,
        semanticsExpanded: _regionPickerExpanded,
        onTap: _toggleRegionPicker,
      );
    } else {
      regionTrigger = MobileFilterTriggerPill(
        emoji: summaryEmoji,
        label: summaryLabel,
        expanded: _regionPickerExpanded,
        isActive: regionActive,
        embedded: regionActive,
        semanticsExpanded: _regionPickerExpanded,
        onTap: _toggleRegionPicker,
      );
    }

    final regionHeader = combined
        ? MobileRefineCombinedCard(
            isActive: refineActive,
            left: regionTrigger,
            right: widget.phonePreferencesTrigger!,
          )
        : regionTrigger;

    final expandedPills = AnimatedSize(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: _regionPickerExpanded
          ? Padding(
              padding: EdgeInsets.fromLTRB(
                combined || activeRegion == null ? 0 : 14,
                10,
                combined || activeRegion == null ? 0 : 14,
                combined || activeRegion == null ? 0 : 4,
              ),
              child: _buildRegionPillRow(
                l,
                regions,
                activeRegion,
                scrollable: true,
              ),
            )
          : const SizedBox.shrink(),
    );

    final eyebrowText = combined ? l.exploreRefine : l.exploreByRegion;

    if (activeRegion == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Eyebrow(icon: _regionEyebrowIcon, text: eyebrowText),
          const SizedBox(height: 10),
          regionHeader,
          expandedPills,
        ],
      );
    }

    if (combined) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Eyebrow(icon: _regionEyebrowIcon, text: eyebrowText),
          const SizedBox(height: 10),
          regionHeader,
          expandedPills,
          const SizedBox(height: 10),
          _CuisineTraditionCard(
            eyebrow: l.selectCuisineTradition,
            scrollable: true,
            children: [
              for (final c in selectableCuisinesInRegion(activeRegion))
                _CuisinePill(
                  emoji: CuisinePillBar.emojiFor(c),
                  label: CuisinePillBar.labelFor(l, c),
                  selected: cuisinePillSelected(
                    pill: c,
                    active: widget.cuisine,
                  ),
                  scrollable: true,
                  onTap: () => _selectCuisine(c),
                ),
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Eyebrow(icon: _regionEyebrowIcon, text: l.exploreByRegion),
        const SizedBox(height: 10),
        _PhoneUnifiedRegionCard(
          regionHeader: regionHeader,
          expandedPills: expandedPills,
          cuisineSection: _CuisineTraditionSection(
            eyebrow: l.selectCuisineTradition,
            scrollable: true,
            children: [
              for (final c in selectableCuisinesInRegion(activeRegion))
                _CuisinePill(
                  emoji: CuisinePillBar.emojiFor(c),
                  label: CuisinePillBar.labelFor(l, c),
                  selected: cuisinePillSelected(
                    pill: c,
                    active: widget.cuisine,
                  ),
                  scrollable: true,
                  onTap: () => _selectCuisine(c),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final regions = populatedRegions();
    // Defensive: if the catalog is somehow empty (shouldn't happen
    // since `Cuisine.values` is non-empty by definition) render
    // nothing rather than running the layout below with zero pills.
    if (regions.isEmpty) return const SizedBox.shrink();

    final activeRegion = _activeRegion;
    final isPhone = deviceClassOf(context).isPhone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -----------------------------------------------------------
        // Top tier: region eyebrow + region pills.
        // -----------------------------------------------------------
        if (isPhone)
          _buildPhoneRegionTier(l, regions, activeRegion)
        else ...[
          _Eyebrow(icon: _regionEyebrowIcon, text: l.exploreByRegion),
          const SizedBox(height: 14),
          _buildRegionPillRow(l, regions, activeRegion, scrollable: false),
        ],
        // Phone folds cuisine into the unified region card above.
        if (!isPhone)
          AnimatedSize(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            // Default layoutBuilder centers children in a Stack — fine
            // for icons but bad for left-aligned cards because the
            // shorter card's left edge drifts during the crossfade.
            // Pin top-left so both cards line up exactly with the page
            // edge while transitioning.
            layoutBuilder: (currentChild, previousChildren) {
              return ClipRect(
                child: Stack(
                  alignment: Alignment.topLeft,
                  clipBehavior: Clip.hardEdge,
                  children: [...previousChildren, ?currentChild],
                ),
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
            child: activeRegion == null
                // Sentinel for the blank-slate state. AnimatedSwitcher
                // distinguishes children by key — a SizedBox.shrink
                // with a stable 'region:none' key transitions to/from
                // the populated card via the same crossfade logic.
                ? const SizedBox.shrink(key: ValueKey('region:none'))
                : Padding(
                    // Top gap collapses naturally when the card
                    // animates out (vs a sibling SizedBox that would
                    // linger).
                    key: ValueKey(activeRegion),
                    padding: const EdgeInsets.only(top: 18),
                    child: _CuisineTraditionCard(
                      eyebrow: l.selectCuisineTradition,
                      scrollable: false,
                      children: [
                        for (final c in selectableCuisinesInRegion(
                          activeRegion,
                        ))
                          _CuisinePill(
                            emoji: CuisinePillBar.emojiFor(c),
                            label: CuisinePillBar.labelFor(l, c),
                            selected: cuisinePillSelected(
                              pill: c,
                              active: widget.cuisine,
                            ),
                            onTap: () => _selectCuisine(c),
                          ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

/// Phone-only: one card for the active region header, optional region
/// picker, and cuisine pills — reads as a single filter block instead
/// of two stacked cards.
class _PhoneUnifiedRegionCard extends StatelessWidget {
  const _PhoneUnifiedRegionCard({
    required this.regionHeader,
    required this.expandedPills,
    required this.cuisineSection,
  });

  final Widget regionHeader;
  final Widget expandedPills;
  final Widget cuisineSection;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: SpiceRoutePalette.naturalCharcoal.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          regionHeader,
          expandedPills,
          Divider(height: 1, color: cs.outlineVariant.withValues(alpha: 0.7)),
          cuisineSection,
        ],
      ),
    );
  }
}

/// Cuisine eyebrow + pills without an outer card — parent supplies chrome.
class _CuisineTraditionSection extends StatelessWidget {
  const _CuisineTraditionSection({
    required this.eyebrow,
    required this.children,
    this.scrollable = false,
  });

  final String eyebrow;
  final List<Widget> children;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Eyebrow(icon: _cuisineEyebrowIcon, text: eyebrow),
          const SizedBox(height: 14),
          _PillRow(scrollable: scrollable, children: children),
        ],
      ),
    );
  }
}

/// Card that frames the cuisine row. The parent's `Padding` wrapper
/// owns the `ValueKey(region)` that drives AnimatedSwitcher crossfades,
/// so this widget itself doesn't take a key.
///
/// `compact` shrinks horizontal padding from 20 → 14 on phone-class
/// viewports. The 6px difference per side is invisible on desktop but
/// frees 12px of horizontal pill space on a 343px-wide phone — enough
/// to fit one more pill per row in most locales.
class _CuisineTraditionCard extends StatelessWidget {
  const _CuisineTraditionCard({
    required this.eyebrow,
    required this.children,
    this.scrollable = false,
  });

  final String eyebrow;
  final List<Widget> children;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
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
          _PillRow(scrollable: scrollable, children: children),
        ],
      ),
    );
  }
}

/// Region / cuisine pill layout. Phone uses one horizontal scroll row to
/// save vertical space; tablet+ keeps the wrapping chip grid.
class _PillRow extends StatelessWidget {
  const _PillRow({required this.children, required this.scrollable});

  final List<Widget> children;
  final bool scrollable;

  static const double _spacing = 10;

  @override
  Widget build(BuildContext context) {
    if (!scrollable) {
      return Wrap(spacing: _spacing, runSpacing: _spacing, children: children);
    }
    return SizedBox(
      height: _kScrollablePillRowHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemCount: children.length,
        separatorBuilder: (_, _) => const SizedBox(width: _spacing),
        itemBuilder: (_, index) => Align(
          alignment: Alignment.center,
          child: children[index],
        ),
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
    this.scrollable = false,
  });

  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool scrollable;

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
          if (scrollable)
            _PillLabel(text: label, selected: selected, maxLines: 1)
          else
            Flexible(
              child: _PillLabel(text: label, selected: selected),
            ),
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
    this.scrollable = false,
  });

  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool scrollable;

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
          if (scrollable)
            _PillLabel(text: label, selected: selected, maxLines: 1)
          else
            Flexible(
              child: _PillLabel(text: label, selected: selected),
            ),
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
        duration: const Duration(milliseconds: 100),
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
                child: Center(widthFactor: 1, heightFactor: 1, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PillLabel extends StatelessWidget {
  const _PillLabel({
    required this.text,
    required this.selected,
    this.maxLines = 2,
  });

  final String text;
  final bool selected;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Text(
      text,
      // Long regional labels (e.g. "Maritime Southeast Asia" in some
      // locales) can wrap inside a narrow Wrap row; we cap at two
      // lines so a pill never silently grows past its neighbours and
      // breaks the row's visual rhythm. The `_PillButton`'s
      // ConstrainedBox(minHeight: 44) still keeps the chip tappable
      // when the label wraps to two lines.
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: theme.textTheme.labelMedium?.copyWith(
        color: selected ? cs.surface : cs.onSurface,
        fontWeight: FontWeight.w600,
        height: 1.15,
      ),
    );
  }
}

/// Height of the horizontal pill scroller on phone. Must fit a
/// `_PillButton` (min 44 + vertical padding) plus flag emojis that
/// paint below their line box. The old 48 px slot with [Clip.none]
/// let chips bleed past the cuisine card border.
const double _kScrollablePillRowHeight = 52;

/// Eyebrow glyphs picked to read at 14px and mirror the reference
/// design's category icons. Kept inline (not constants on a class)
/// because they're never read from outside this file.
/// Globe for the section eyebrow — distinct from the East Asia pill (🏯).
const String _regionEyebrowIcon = '🌍';
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
