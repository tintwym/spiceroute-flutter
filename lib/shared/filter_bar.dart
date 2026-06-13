import 'dart:ui';

import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/spice_route.dart';
import '../shared/theme.dart';

/// Two-column filter bar shown above the Explore grid:
///   [ SELECT COURSE ]   [ DIETARY, LIFESTYLE & FORMAT ]
///
/// The cuisine selector used to live here as a third column but moved
/// to the dedicated [RegionFilterBar] above this widget — the
/// region-grouped pill UI is more discoverable than a flat dropdown
/// of 16 country flags.
///
/// Each option uses an emoji glyph as its icon (food/lifestyle
/// emojis) to match the design reference exactly. Emojis ship for
/// free with the OS — no asset bundling or icon-font wrangling
/// required.
///
/// The dropdown menus are rendered as glassmorphic overlays
/// (translucent frosted-glass surface, vibrant blue selected state,
/// soft drop shadow). On screens narrower than ~560px the columns
/// stack vertically so each dropdown gets full width. (Was 720px
/// when this had three columns; the cuisine column moving to
/// [RegionFilterBar] freed the horizontal budget.)
class FilterBar extends StatelessWidget {
  const FilterBar({
    super.key,
    required this.course,
    required this.dietary,
    required this.onCourseChanged,
    required this.onDietaryChanged,
  });

  final Course? course;
  final Dietary? dietary;
  final ValueChanged<Course?> onCourseChanged;
  final ValueChanged<Dietary?> onDietaryChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);

    final courseCol = _FilterColumn<Course?>(
      label: l.filterCourseLabel,
      labelIcon: Icons.schedule,
      value: course,
      hintEmoji: _allCoursesEmoji,
      hintText: l.filterAllCourses,
      // Same accordion treatment as Dietary: search field, collapsible
      // CourseGroup sections (Early Day, Daytime / Casual, …), and an
      // EXPAND ALL / COLLAPSE ALL toggle. `items` only carries the
      // "All Courses" sentinel — the accordion reads its real options
      // from `groups` and the trigger pill resolves the active value
      // against the flattened group items.
      items: [
        _FilterItem<Course?>(
          value: null,
          label: l.filterAllCourses,
          emoji: _allCoursesEmoji,
        ),
      ],
      groups: _buildCourseGroups(l),
      searchHint: l.filterSearchCourses,
      onChanged: onCourseChanged,
    );

    final dietaryCol = _FilterColumn<Dietary?>(
      label: l.filterDietaryLabel,
      labelIcon: Icons.eco_outlined,
      value: dietary,
      hintEmoji: _allDietaryEmoji,
      hintText: l.filterAllDietary,
      // Flat `items` only carries the "All Requests" sentinel — the
      // accordion menu reads its real options from `groups`. The
      // sentinel still appears in `items` so the trigger pill knows
      // how to render the cleared state (hint emoji + hint text).
      items: [
        _FilterItem(
          value: null,
          label: l.filterAllDietary,
          emoji: _allDietaryEmoji,
        ),
      ],
      groups: _buildDietaryGroups(l),
      searchHint: l.filterSearchDietary,
      onChanged: onDietaryChanged,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Below ~560px the two pills next to each other get cramped
        // (especially the second label "DIETARY, LIFESTYLE & FORMAT
        // RESTRICTIONS" which is long). Stack vertically on narrow
        // screens so each column gets the full width.
        final stacked = constraints.maxWidth < 560;
        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [courseCol, const SizedBox(height: 12), dietaryCol],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: courseCol),
            const SizedBox(width: 16),
            Expanded(child: dietaryCol),
          ],
        );
      },
    );
  }
}

/// One labeled dropdown column. `T` is the option value type (nullable so
/// that "All" can be represented as `null`).
class _FilterColumn<T> extends StatelessWidget {
  const _FilterColumn({
    super.key,
    required this.label,
    required this.labelIcon,
    required this.value,
    required this.hintEmoji,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.groups,
    this.searchHint,
  });

  final String label;
  final IconData labelIcon;
  final T value;
  final String hintEmoji;
  final String hintText;
  final List<_FilterItem<T>> items;
  final ValueChanged<T> onChanged;

  /// When non-null the dropdown opens the *accordion* menu variant
  /// (search input + collapsible subcategory cards + expand-all
  /// toggle) instead of the flat scrolling list. Used by the dietary
  /// column to organise 8 items into 3 user-meaningful buckets.
  ///
  /// `items` still drives the trigger pill's "selected" lookup —
  /// flatten every group's items into `items` if you want them
  /// resolvable from the closed state.
  final List<_FilterGroup<T>>? groups;

  /// Placeholder shown inside the accordion menu's search input.
  /// Required when `groups` is non-null; ignored otherwise.
  final String? searchHint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header — small uppercase line with leading icon, like the
        // screenshot: "SELECT CUISINE", "SELECT COURSE", etc.
        //
        // The third column's label ("DIETARY, LIFESTYLE & FORMAT
        // RESTRICTIONS") is long enough to overflow a ~300px column at
        // 3-up width on a medium viewport. Wrapping the text in Flexible
        // + allowing soft-wrap lets it spill onto a second line instead
        // of throwing RenderFlex overflow exceptions.
        Padding(
          padding: const EdgeInsets.only(left: 14, bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(labelIcon, size: 14, color: cs.onSurfaceVariant),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // The dropdown pill itself.
        _GlassDropdown<T>(
          value: value,
          hintEmoji: hintEmoji,
          hintText: hintText,
          items: _withGroupAwareTriggerLabels(items, groups),
          onChanged: onChanged,
          groups: groups,
          searchHint: searchHint,
        ),
      ],
    );
  }
}

/// Returns `items` augmented so each item knows the [_FilterGroup.label]
/// it belongs to (if any). The trigger pill reads this to render the
/// `Group · Selection` two-tier closed state. We resolve the group
/// lazily here rather than baking the label into every call site
/// because the same `_FilterItem` ought to render in both the flat
/// `items` list and the accordion `groups`.
List<_FilterItem<T>> _withGroupAwareTriggerLabels<T>(
  List<_FilterItem<T>> items,
  List<_FilterGroup<T>>? groups,
) {
  if (groups == null || groups.isEmpty) return items;
  final groupByValue = <T, String>{};
  for (final g in groups) {
    for (final it in g.items) {
      if (it.isHeader) continue;
      groupByValue[it.value] = g.label;
    }
  }
  // Walk the flat trigger-resolution list and overlay group labels.
  // We don't mutate any existing items — _FilterItem is immutable
  // and may be shared across columns / tests.
  return [
    for (final it in items)
      if (it.isHeader || groupByValue[it.value] == null)
        it
      else
        it.copyWith(triggerGroupLabel: groupByValue[it.value]),
    // Plus every group's items, in case `items` only carries the
    // "All" sentinel (the dietary column ships items=[all] for
    // brevity and lets the accordion do the heavy lifting).
    for (final g in groups)
      for (final it in g.items)
        if (!it.isHeader) it.copyWith(triggerGroupLabel: g.label),
  ];
}

/// One option in a filter dropdown. `value == null` represents "All …".
///
/// `emoji` is rendered as text (e.g. "🇰🇷", "🥞", "🌶️"). Using emojis
/// instead of [IconData] lets us match the design reference exactly
/// without bundling a custom icon font.
///
/// Set [isHeader] to render a non-selectable section header instead of a
/// regular row. Headers are used to group [Course] items (Early Day,
/// Daytime / Casual, …) inside an otherwise-flat dropdown.
///
/// [triggerGroupLabel] is the subcategory pill text rendered in the
/// closed dropdown trigger when this item is the active selection.
/// E.g. selecting `Dietary.quickEasy` renders `[Cooking Formats]
/// Quick & Easy` in the trigger. Null → no pill, just the label.
class _FilterItem<T> {
  const _FilterItem({
    required this.value,
    required this.label,
    required this.emoji,
    this.isHeader = false,
    this.triggerGroupLabel,
  });

  // Note: there used to be a `_FilterItem.header` named constructor
  // used by the flat-menu Course builder to emit inline section
  // headers ("EARLY DAY", "DAYTIME / CASUAL", …) between rows.
  // Course now uses the accordion variant — each [CourseGroup] is
  // its own collapsible section — so inline headers are no longer
  // produced. The `isHeader` flag is kept for the still-mounted
  // [_GlassMenu] flat menu in case future filters need it.

  final T value;
  final String label;
  final String emoji;
  final bool isHeader;
  final String? triggerGroupLabel;

  _FilterItem<T> copyWith({String? triggerGroupLabel}) => _FilterItem<T>(
    value: value,
    label: label,
    emoji: emoji,
    isHeader: isHeader,
    triggerGroupLabel: triggerGroupLabel ?? this.triggerGroupLabel,
  );
}

/// One accordion bucket in the searchable dropdown menu (e.g. "Dietary
/// Restrictions", "Wellness & Lifestyles", "Cooking Formats").
///
/// `items` should be the *selectable* options only — section headers
/// aren't supported inside accordion groups since the group itself is
/// the grouping mechanism.
class _FilterGroup<T> {
  const _FilterGroup({required this.label, required this.items});
  final String label;
  final List<_FilterItem<T>> items;
}

// -- Custom glass dropdown ----------------------------------------------------

/// Pill-shaped trigger that, when tapped, opens a glassmorphic overlay
/// menu of options.
///
/// We hand-roll this instead of using [PopupMenuButton] because the
/// standard menu wraps its items in an opaque `Material` we can't slip
/// a [BackdropFilter] behind — and the frosted-glass surface is the
/// whole point of the design.
class _GlassDropdown<T> extends StatefulWidget {
  const _GlassDropdown({
    super.key,
    required this.value,
    required this.hintEmoji,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.groups,
    this.searchHint,
  });

  final T value;
  final String hintEmoji;
  final String hintText;
  final List<_FilterItem<T>> items;
  final ValueChanged<T> onChanged;

  /// See [_FilterColumn.groups]. When non-null the trigger opens the
  /// accordion menu variant instead of the flat list.
  final List<_FilterGroup<T>>? groups;
  final String? searchHint;

  @override
  State<_GlassDropdown<T>> createState() => _GlassDropdownState<T>();
}

class _GlassDropdownState<T> extends State<_GlassDropdown<T>> {
  final GlobalKey _triggerKey = GlobalKey();

  Future<void> _open(BuildContext context) async {
    // Resolve the trigger pill's screen position so the overlay menu can
    // anchor flush beneath it, matching the trigger's width exactly.
    final triggerBox =
        _triggerKey.currentContext!.findRenderObject() as RenderBox;
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final origin = triggerBox.localToGlobal(Offset.zero, ancestor: overlay);
    final triggerSize = triggerBox.size;

    // Resolve localization HERE — `_open` runs with a live BuildContext
    // but the route's `barrierLabel` getter is called later by the
    // Navigator without one, so we have to snapshot the string at
    // construction time and let the route hold it. Otherwise the
    // tap-outside-to-dismiss action would be announced in English to
    // VoiceOver / TalkBack on every non-English locale.
    final dismissLabel = AppL10n.of(context).filterDismissMenu;

    final groups = widget.groups;
    final route = groups == null
        ? _GlassMenuRoute<T>(
            origin: origin,
            triggerSize: triggerSize,
            viewportSize: overlay.size,
            items: widget.items,
            selectedValue: widget.value,
            barrierLabelText: dismissLabel,
          )
        : _AccordionMenuRoute<T>(
            origin: origin,
            triggerSize: triggerSize,
            viewportSize: overlay.size,
            groups: groups,
            selectedValue: widget.value,
            searchHint: widget.searchHint ?? '',
            barrierLabelText: dismissLabel,
            // The accordion menu doesn't render any group "all"
            // sentinel by default — we surface the items[0] entry
            // (e.g. "All Courses") as a pinned reset row at the top
            // so users have a discoverable way to clear the filter.
            // If `items` is empty or its head doesn't represent the
            // cleared state we just skip the row.
            clearItem: widget.items.isEmpty ? null : widget.items.first,
          );
    final result = await Navigator.of(context).push<_MenuResult<T>>(route);
    if (result != null) {
      widget.onChanged(result.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    _FilterItem<T>? selected;
    for (final item in widget.items) {
      if (item.isHeader) continue;
      if (item.value == widget.value) {
        selected = item;
        break;
      }
    }
    final displayEmoji = selected?.emoji ?? widget.hintEmoji;
    final displayText = selected?.label ?? widget.hintText;
    // Only show the subcategory pill when we have an active selection
    // *and* it knows its group. Hint state (selected==null) keeps the
    // existing "All Requests" presentation.
    final groupPill = selected?.triggerGroupLabel;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: _triggerKey,
        borderRadius: BorderRadius.circular(28),
        onTap: () => _open(context),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: cs.outlineVariant, width: 1),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 22,
                child: Text(
                  displayEmoji,
                  // Emoji-safe TextStyle — see kEmojiFontFallback
                  // docstring. A bare TextStyle(fontSize: 16) here
                  // would render as a missing-glyph box on web.
                  style: emojiTextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  children: [
                    if (groupPill != null) ...[
                      // Stadium-shaped subcategory chip — cream fill
                      // so it reads as secondary to the selection
                      // label that follows. Capped at ~50% of the
                      // expanded Row's allocation so a verbose
                      // localized label (e.g. Burmese "အစားအသောက်
                      // ကန့်သတ်ချက်များ") can't eat the entire row
                      // and push the selection text into overflow.
                      // Inside the chip the text already ellipsizes,
                      // so the cap is purely a width gate.
                      Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 160),
                          child: _TriggerGroupChip(label: groupPill),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    // 2:1 flex ratio with the chip keeps the actual
                    // selection (the more important label) winning
                    // the space contest whenever both compete.
                    Flexible(
                      flex: 2,
                      child: Text(
                        displayText,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 22,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small stadium-shaped chip used in the dropdown trigger to display
/// the subcategory ("Cooking Formats", "Sweet Ending", …) the active
/// selection belongs to. Visually subordinate to the actual selection
/// label that follows it — fontSize 11, cream fill, no border.
class _TriggerGroupChip extends StatelessWidget {
  const _TriggerGroupChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        // Subtle cream/stone pill that recedes against the trigger's
        // own surfaceContainerHighest fill. Border (not just a darker
        // fill) keeps it visible when the trigger is on a busy page
        // background.
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant, width: 0.5),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelSmall?.copyWith(
          color: cs.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          fontSize: 11,
          height: 1.1,
        ),
      ),
    );
  }
}

/// Pop value type for [_GlassMenuRoute]. Wrapping in a holder lets `null`
/// (the "All" option) distinguish from "user dismissed without choosing".
class _MenuResult<T> {
  const _MenuResult(this.value);
  final T value;
}

/// Modal route that renders the glass menu floating beneath the trigger
/// pill. Uses a fully transparent barrier so the user can tap anywhere
/// outside the menu to dismiss it without seeing a scrim flash.
class _GlassMenuRoute<T> extends PopupRoute<_MenuResult<T>> {
  _GlassMenuRoute({
    required this.origin,
    required this.triggerSize,
    required this.viewportSize,
    required this.items,
    required this.selectedValue,
    required this.barrierLabelText,
  });

  final Offset origin;
  final Size triggerSize;
  final Size viewportSize;
  final List<_FilterItem<T>> items;

  /// Currently-selected value. Callers always pass an already-nullable
  /// `T` (e.g. `Cuisine?`), so the extra `?` would only confuse the
  /// type system.
  final T selectedValue;

  /// Localized "Dismiss menu" string the parent resolved against the
  /// active locale. We snapshot it on the route because [barrierLabel]
  /// is called by the Navigator without a [BuildContext].
  final String barrierLabelText;

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => barrierLabelText;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 180);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // Cap the menu height so the longest list (the grouped Course
    // column has 1 "All" row + 7 headers + 12 courses ≈ 20 rows; the
    // Cuisine column has 17 rows) still leaves breathing room top
    // and bottom. Anything longer scrolls inside the menu.
    final maxMenuHeight =
        viewportSize.height - origin.dy - triggerSize.height - 24;
    return Stack(
      children: [
        Positioned(
          left: origin.dx,
          top: origin.dy + triggerSize.height + 8,
          width: triggerSize.width,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxMenuHeight.clamp(160.0, 540.0),
            ),
            child: _GlassMenu<T>(
              items: items,
              selectedValue: selectedValue,
              onSelected: (v) => Navigator.of(context).pop(_MenuResult<T>(v)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Soft fade + tiny upward slide so the menu feels like it's settling
    // into place rather than appearing out of nothing.
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.04),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

/// Frosted-glass menu surface with rounded corners, soft shadow, and a
/// vertically-scrollable list of items.
class _GlassMenu<T> extends StatelessWidget {
  const _GlassMenu({
    required this.items,
    required this.selectedValue,
    required this.onSelected,
  });

  final List<_FilterItem<T>> items;
  final T selectedValue;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Surface tint behind the blur. The blur picks up whatever is behind
    // the menu (recipe images, the search bar, etc.) and a thin
    // translucent fill on top tames the contrast so the text stays
    // readable without losing the frosted-glass quality.
    final glassFill = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.62);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.6);

    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          // Soft, generous shadow — sits a card-height above the page.
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.55 : 0.18),
              blurRadius: 28,
              spreadRadius: 0,
              offset: const Offset(0, 14),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
              blurRadius: 6,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                color: glassFill,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: borderColor, width: 1),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final item in items)
                      if (item.isHeader)
                        _GlassMenuHeader(label: item.label)
                      else
                        _GlassMenuItem<T>(
                          item: item,
                          selected: item.value == selectedValue,
                          onTap: () => onSelected(item.value),
                          textColor: cs.onSurface,
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Non-interactive section header rendered between groups of items in
/// the glass menu (e.g. "EARLY DAY", "DAYTIME / CASUAL", "LIQUIDS"
/// above the course dropdown items).
///
/// Visually distinct from a regular row: small uppercase label, muted
/// color, no leading emoji or check slot. Skipped by the trigger pill's
/// "find selected" lookup and by the tap handler in `_GlassMenu`.
class _GlassMenuHeader extends StatelessWidget {
  const _GlassMenuHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 14, 6),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: cs.onSurfaceVariant,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
          height: 1.2,
        ),
      ),
    );
  }
}

/// One row inside the glass menu.
///
/// Inactive rows: transparent background, emoji on the left, label in the
/// app's normal text color.
///
/// Active row: vibrant blue pill background, white text, leading
/// checkmark — emoji slides right behind the check.
class _GlassMenuItem<T> extends StatelessWidget {
  const _GlassMenuItem({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.textColor,
  });

  final _FilterItem<T> item;
  final bool selected;
  final VoidCallback onTap;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Material 3 primary is the natural "vibrant blue" choice in our
    // theme. Solid (not translucent) so the white text stays legible
    // against any background showing through the glass.
    const Color activeBg = Color(0xFF3D8BFD);
    const Color activeFg = Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: selected ? activeBg : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Leading checkmark slot — always present so labels line
                // up vertically whether selected or not. Visible only on
                // the active row.
                SizedBox(
                  width: 20,
                  child: selected
                      ? const Icon(Icons.check, size: 18, color: activeFg)
                      : null,
                ),
                const SizedBox(width: 10),
                // Emoji glyph.
                SizedBox(
                  width: 24,
                  child: Text(
                    item.emoji,
                    // Emoji-safe TextStyle — see kEmojiFontFallback.
                    style: emojiTextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: selected ? activeFg : textColor,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      height: 1.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -- Accordion menu (searchable, expand-all, collapsible groups) -------------

/// Modal route hosting the [_AccordionGlassMenu]. Shares the same
/// anchor / sizing / fade-in conventions as [_GlassMenuRoute] so the
/// trigger pill animates open identically regardless of which variant
/// is mounted underneath.
class _AccordionMenuRoute<T> extends PopupRoute<_MenuResult<T>> {
  _AccordionMenuRoute({
    required this.origin,
    required this.triggerSize,
    required this.viewportSize,
    required this.groups,
    required this.selectedValue,
    required this.searchHint,
    required this.barrierLabelText,
    this.clearItem,
  });

  final Offset origin;
  final Size triggerSize;
  final Size viewportSize;
  final List<_FilterGroup<T>> groups;
  final T selectedValue;
  final String searchHint;

  /// Localized "Dismiss menu" string. See [_GlassMenuRoute.barrierLabelText].
  final String barrierLabelText;

  /// Optional "All …" row pinned above the accordion sections. When
  /// non-null, tapping it pops the menu with its [_FilterItem.value]
  /// (usually `null`), which restores the dropdown's hint state.
  final _FilterItem<T>? clearItem;

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => barrierLabelText;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 180);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // Cap the menu height so the longest accordion (all groups
    // expanded, all items visible) still leaves breathing room above
    // and below. Anything taller scrolls inside the menu.
    final maxMenuHeight =
        viewportSize.height - origin.dy - triggerSize.height - 24;
    return Stack(
      children: [
        Positioned(
          left: origin.dx,
          top: origin.dy + triggerSize.height + 8,
          width: triggerSize.width,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxMenuHeight.clamp(220.0, 560.0),
            ),
            child: _AccordionGlassMenu<T>(
              groups: groups,
              selectedValue: selectedValue,
              searchHint: searchHint,
              clearItem: clearItem,
              onSelected: (v) => Navigator.of(context).pop(_MenuResult<T>(v)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.04),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

/// Frosted-glass surface containing a search field, an expand-all
/// toggle, and one collapsible section per [_FilterGroup].
///
/// Stateful because the open/closed state of each group, the current
/// search query, and the implicit "all expanded?" flag all live
/// locally and don't need to round-trip through the parent — the only
/// thing the parent cares about is which value was tapped, which is
/// reported via [onSelected].
class _AccordionGlassMenu<T> extends StatefulWidget {
  const _AccordionGlassMenu({
    required this.groups,
    required this.selectedValue,
    required this.searchHint,
    required this.onSelected,
    this.clearItem,
  });

  final List<_FilterGroup<T>> groups;
  final T selectedValue;
  final String searchHint;
  final ValueChanged<T> onSelected;

  /// Optional "All …" row pinned above the accordion sections. See
  /// [_AccordionMenuRoute.clearItem].
  final _FilterItem<T>? clearItem;

  @override
  State<_AccordionGlassMenu<T>> createState() => _AccordionGlassMenuState<T>();
}

class _AccordionGlassMenuState<T> extends State<_AccordionGlassMenu<T>> {
  late final TextEditingController _searchCtl;
  String _query = '';

  /// Indexes of expanded groups. We persist by index (not label) so
  /// renaming a group's localized string doesn't desync the state.
  final Set<int> _expanded = <int>{};

  @override
  void initState() {
    super.initState();
    _searchCtl = TextEditingController();
    // On open, auto-expand the group containing the active selection
    // so the user can see / re-tap it without having to hunt for it.
    // If nothing is selected (T == null) every group starts collapsed,
    // matching screenshot 2.
    for (var i = 0; i < widget.groups.length; i++) {
      final hasSelected = widget.groups[i].items.any(
        (it) => !it.isHeader && it.value == widget.selectedValue,
      );
      if (hasSelected) _expanded.add(i);
    }
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  bool get _allExpanded => _expanded.length == widget.groups.length;

  void _toggleAll() {
    setState(() {
      if (_allExpanded) {
        _expanded.clear();
      } else {
        _expanded
          ..clear()
          ..addAll(Iterable<int>.generate(widget.groups.length));
      }
    });
  }

  void _toggleGroup(int idx) {
    setState(() {
      if (_expanded.contains(idx)) {
        _expanded.remove(idx);
      } else {
        _expanded.add(idx);
      }
    });
  }

  void _onSearchChanged(String q) {
    setState(() {
      _query = q;
      final trimmed = q.trim();
      if (trimmed.isEmpty) return;
      // Auto-expand groups containing matches so the user sees them
      // without having to drill into each section manually.
      final lc = trimmed.toLowerCase();
      for (var i = 0; i < widget.groups.length; i++) {
        final hasMatch = widget.groups[i].items.any(
          (it) => !it.isHeader && it.label.toLowerCase().contains(lc),
        );
        if (hasMatch) _expanded.add(i);
      }
    });
  }

  List<_FilterItem<T>> _visibleItems(_FilterGroup<T> g) {
    final lc = _query.trim().toLowerCase();
    if (lc.isEmpty) return g.items;
    return g.items
        .where((it) => !it.isHeader && it.label.toLowerCase().contains(lc))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l = AppL10n.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Same frosted-glass surface as [_GlassMenu] — keep both menus
    // visually identical so swapping between flat / accordion never
    // feels like landing in a different app.
    final glassFill = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.62);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.6);

    // Memoize visibility per group. Without this we called
    // `_visibleItems(g)` 2 + groups.length times per build (one for
    // `hasAnyVisible`, one per section header for the count, one per
    // section body for the items). Each call walks every item with a
    // `.toLowerCase().contains()` test — cheap individually but noisy
    // during fast typing in the search field.
    final visibleByIdx = <List<_FilterItem<T>>>[
      for (final g in widget.groups) _visibleItems(g),
    ];
    final hasAnyVisible = visibleByIdx.any((items) => items.isNotEmpty);

    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.55 : 0.18),
              blurRadius: 28,
              spreadRadius: 0,
              offset: const Offset(0, 14),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
              blurRadius: 6,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                color: glassFill,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: borderColor, width: 1),
              ),
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // -------------------------------------------------
                  // Expand-all / Collapse-all toggle. Right-aligned so
                  // the chrome doesn't crowd the search field below.
                  // -------------------------------------------------
                  Align(
                    alignment: Alignment.centerRight,
                    child: _ExpandAllToggle(
                      expanded: _allExpanded,
                      onTap: _toggleAll,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // -------------------------------------------------
                  // Search input. autofocus: false so the on-screen
                  // keyboard doesn't pop the moment the menu opens —
                  // many users open the menu just to browse.
                  // -------------------------------------------------
                  _AccordionSearchField(
                    controller: _searchCtl,
                    hint: widget.searchHint,
                    onChanged: _onSearchChanged,
                  ),
                  const SizedBox(height: 10),
                  // -------------------------------------------------
                  // Scrollable column of accordion sections so the
                  // menu height never exceeds the route's maxHeight.
                  // The clear-row sits OUTSIDE the search/no-matches
                  // filter — we always want it reachable even when
                  // the user's query is "asdf" and nothing matches.
                  // -------------------------------------------------
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Pinned "All …" reset row + thin divider
                          // separating it from the accordion sections
                          // below. Distinct from category rows since
                          // the user explicitly opted into the
                          // "filter-off" presentation.
                          if (widget.clearItem != null) ...[
                            _GlassMenuItem<T>(
                              item: widget.clearItem!,
                              selected:
                                  widget.clearItem!.value ==
                                  widget.selectedValue,
                              onTap: () =>
                                  widget.onSelected(widget.clearItem!.value),
                              textColor: cs.onSurface,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Divider(
                                height: 1,
                                color: cs.outlineVariant,
                              ),
                            ),
                          ],
                          if (!hasAnyVisible)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 4,
                              ),
                              child: Text(
                                l.filterNoMatches,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            )
                          else
                            for (var i = 0; i < widget.groups.length; i++)
                              if (visibleByIdx[i].isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _AccordionSection<T>(
                                    label: widget.groups[i].label,
                                    items: visibleByIdx[i],
                                    selectedValue: widget.selectedValue,
                                    expanded: _expanded.contains(i),
                                    onToggle: () => _toggleGroup(i),
                                    onSelected: widget.onSelected,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Right-aligned "EXPAND ALL ⊕ / COLLAPSE ALL ⊖" toggle button.
/// Stateless — the parent owns the expanded/collapsed truth.
class _ExpandAllToggle extends StatelessWidget {
  const _ExpandAllToggle({required this.expanded, required this.onTap});
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l = AppL10n.of(context);
    final label = expanded ? l.filterCollapseAll : l.filterExpandAll;
    // unfold_more / unfold_less mirrors the screenshot's "⊕ / ⊖"
    // affordance and stays glyph-consistent across platforms.
    final icon = expanded ? Icons.unfold_less : Icons.unfold_more;
    return Semantics(
      button: true,
      // toggled + value together let VoiceOver / TalkBack announce
      // "expand all, button, collapsed" → "expand all, button,
      // expanded" as the user taps. Without `toggled` the AT treats
      // it as a plain push button and the user can't tell the
      // current state without trying it.
      toggled: expanded,
      label: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Icon(icon, size: 16, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

/// The accordion menu's search field. Pill-shaped to match the menu
/// surface's rounded corners. Lazily rebuilds via [onChanged] so the
/// filtered groups update as the user types.
///
/// Stateful only so the trailing "clear" affordance can rebuild on
/// every keystroke (controller doesn't notify Listenable subscribers
/// automatically without a listener).
class _AccordionSearchField extends StatefulWidget {
  const _AccordionSearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  State<_AccordionSearchField> createState() => _AccordionSearchFieldState();
}

class _AccordionSearchFieldState extends State<_AccordionSearchField> {
  @override
  void initState() {
    super.initState();
    // Listen to the controller so we can toggle the trailing clear
    // icon in/out as the user types. We pass the same controller
    // through to the TextField — the field itself rebuilds on
    // changes already; this listener is just for the suffix.
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l = AppL10n.of(context);
    final hasText = widget.controller.text.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(Icons.search, size: 18, color: cs.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              // Hitting return on a hardware keyboard / soft-search
              // closes the IME without dismissing the menu; the
              // filter already reflects the typed query live.
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface),
            ),
          ),
          if (hasText)
            // Compact 28x28 hit target — bigger than the icon glyph
            // so quick taps don't miss but small enough not to
            // distort the pill height.
            Semantics(
              button: true,
              label: l.filterClearSearch,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  widget.controller.clear();
                  widget.onChanged('');
                },
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// One collapsible category card inside the accordion menu.
///
/// Header row: folder icon + label + "X choices" + expand arrow.
/// Body: nested choice rows, revealed via [AnimatedSize] when
/// [expanded] flips true. The body uses the same [_GlassMenuItem]
/// chrome as the flat menu so the active row gets the vibrant
/// blue active treatment.
class _AccordionSection<T> extends StatelessWidget {
  const _AccordionSection({
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.expanded,
    required this.onToggle,
    required this.onSelected,
  });

  final String label;
  final List<_FilterItem<T>> items;
  final T selectedValue;
  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l = AppL10n.of(context);
    final hasActive = items.any(
      (it) => !it.isHeader && it.value == selectedValue,
    );
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // Subtle olive highlight on the group containing the active
          // pick so the user can see at a glance "this category is
          // where my current selection lives" even when collapsed.
          color: hasActive
              ? cs.primary.withValues(alpha: 0.45)
              : cs.outlineVariant,
          width: hasActive ? 1.2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---------------------------------------------------------
          // Header row — the clickable toggle.
          // ---------------------------------------------------------
          Semantics(
            button: true,
            expanded: expanded,
            label: label,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Row(
                  children: [
                    Icon(Icons.folder_outlined, size: 18, color: cs.secondary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        label.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: cs.secondary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    Text(
                      l.filterChoicesCount(items.length),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Animate the arrow rotation rather than swap
                    // icons — gives a smooth visual cue that the
                    // section is opening / closing.
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      turns: expanded ? 0.5 : 0.0,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ---------------------------------------------------------
          // Body — animated reveal. ClipRect prevents the inner
          // shadows / rows from peeking out during the size
          // transition.
          // ---------------------------------------------------------
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: expanded
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final it in items)
                            _GlassMenuItem<T>(
                              item: it,
                              selected: it.value == selectedValue,
                              onTap: () => onSelected(it.value),
                              textColor: cs.onSurface,
                            ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

// --- emoji + label helpers ----------------------------------------------------

/// "All Courses" sentinel: clock matches the time-of-day framing that
/// courses imply ("when do you eat this?"), and visually echoes the
/// yellow circle in the reference design.
const String _allCoursesEmoji = '🕐';

/// "All Requests" sentinel for the dietary column: the dart-and-target
/// icon from the reference design.
const String _allDietaryEmoji = '🎯';

String _courseLabel(AppL10n l, Course c) {
  switch (c) {
    case Course.breakfast:
      return l.courseBreakfast;
    case Course.highTea:
      return l.courseHighTea;
    case Course.lunch:
      return l.courseLunch;
    case Course.soupsSaladsBowls:
      return l.courseSoupsSaladsBowls;
    case Course.appetizer:
      return l.courseAppetizer;
    case Course.sharingBoards:
      return l.courseSharingBoards;
    case Course.mainCourse:
      return l.courseMainCourse;
    case Course.sideDish:
      return l.courseSideDish;
    case Course.dessert:
      return l.courseDessert;
    case Course.snack:
      return l.courseSnack;
    case Course.drinks:
      return l.courseAlcoholicDrinks;
    case Course.zeroProofDrinks:
      return l.courseZeroProofDrinks;
  }
}

String _courseEmoji(Course c) {
  switch (c) {
    case Course.breakfast:
      return '🥞';
    case Course.highTea:
      return '🫖';
    case Course.lunch:
      return '🍱';
    case Course.soupsSaladsBowls:
      return '🥣';
    case Course.appetizer:
      return '🥟';
    case Course.sharingBoards:
      return '🧀';
    case Course.mainCourse:
      return '🍽️';
    case Course.sideDish:
      return '🥗';
    case Course.dessert:
      return '🍰';
    case Course.snack:
      return '🍿';
    case Course.drinks:
      return '🍸';
    case Course.zeroProofDrinks:
      return '🥤';
  }
}

String _courseGroupLabel(AppL10n l, CourseGroup g) {
  switch (g) {
    case CourseGroup.earlyDay:
      return l.courseGroupEarlyDay;
    case CourseGroup.daytimeCasual:
      return l.courseGroupDaytimeCasual;
    case CourseGroup.beforeMain:
      return l.courseGroupBeforeMain;
    case CourseGroup.mainEvent:
      return l.courseGroupMainEvent;
    case CourseGroup.sweetEnding:
      return l.courseGroupSweetEnding;
    case CourseGroup.afterHours:
      return l.courseGroupAfterHours;
    case CourseGroup.liquids:
      return l.courseGroupLiquids;
  }
}

/// Build accordion groups for the Course column. One group per
/// [CourseGroup] value in enum-declaration order (Early Day → … →
/// Liquids — already the order the design lays them out). Mirrors
/// [_buildDietaryGroups] so both columns share the same plumbing.
///
/// Each item carries [triggerGroupLabel] so the closed trigger pill
/// can render the "Sweet Ending · Desserts & Sweets" two-tier
/// presentation when that course is the active selection.
List<_FilterGroup<Course?>> _buildCourseGroups(AppL10n l) {
  final byGroup = <CourseGroup, List<_FilterItem<Course?>>>{};
  for (final g in CourseGroup.values) {
    byGroup[g] = <_FilterItem<Course?>>[];
  }
  for (final c in Course.values) {
    byGroup[c.group]!.add(
      _FilterItem<Course?>(
        value: c,
        label: _courseLabel(l, c),
        emoji: _courseEmoji(c),
        triggerGroupLabel: _courseGroupLabel(l, c.group),
      ),
    );
  }
  return [
    for (final g in CourseGroup.values)
      _FilterGroup<Course?>(label: _courseGroupLabel(l, g), items: byGroup[g]!),
  ];
}

String _dietaryGroupLabel(AppL10n l, DietaryGroup g) {
  switch (g) {
    case DietaryGroup.dietaryRestrictions:
      return l.dietaryGroupRestrictions;
    case DietaryGroup.allergenFree:
      return l.dietaryGroupAllergenFree;
    case DietaryGroup.wellness:
      return l.dietaryGroupWellness;
    case DietaryGroup.cookingFormats:
      return l.dietaryGroupCookingFormats;
  }
}

/// Build the accordion groups for the Dietary column. One group per
/// [DietaryGroup] value, in enum-declaration order (restrictions →
/// wellness → cooking formats). Each item carries its group label as
/// the [_FilterItem.triggerGroupLabel] so the closed dropdown trigger
/// can render the same "Cooking Formats · Quick & Easy" pattern that
/// Course uses.
List<_FilterGroup<Dietary?>> _buildDietaryGroups(AppL10n l) {
  final byGroup = <DietaryGroup, List<_FilterItem<Dietary?>>>{};
  for (final g in DietaryGroup.values) {
    byGroup[g] = <_FilterItem<Dietary?>>[];
  }
  for (final d in Dietary.values) {
    byGroup[d.group]!.add(
      _FilterItem<Dietary?>(
        value: d,
        label: _dietaryLabel(l, d),
        emoji: _dietaryEmoji(d),
        triggerGroupLabel: _dietaryGroupLabel(l, d.group),
      ),
    );
  }
  return [
    for (final g in DietaryGroup.values)
      _FilterGroup<Dietary?>(
        label: _dietaryGroupLabel(l, g),
        items: byGroup[g]!,
      ),
  ];
}

String _dietaryLabel(AppL10n l, Dietary d) {
  switch (d) {
    case Dietary.vegan:
      return l.dietaryVegan;
    case Dietary.vegetarian:
      return l.dietaryVegetarian;
    case Dietary.glutenFree:
      return l.dietaryGlutenFree;
    case Dietary.dairyFree:
      return l.dietaryDairyFree;
    case Dietary.nutFree:
      return l.dietaryNutFree;
    case Dietary.eggFree:
      return l.dietaryEggFree;
    case Dietary.mealPrep:
      return l.dietaryMealPrep;
    case Dietary.quickEasy:
      return l.dietaryQuickEasy;
    case Dietary.pastaSoup:
      return l.dietaryPastaSoup;
    case Dietary.bloodSugarBalanced:
      return l.dietaryBloodSugarBalanced;
    case Dietary.swicy:
      return l.dietarySwicy;
    case Dietary.antiInflammatory:
      return l.dietaryAntiInflammatory;
  }
}

String _dietaryEmoji(Dietary d) {
  switch (d) {
    case Dietary.vegan:
      return '🌱';
    case Dietary.vegetarian:
      return '🥗';
    // Allergen-free entries use the *allergen* glyph rather than a
    // "no" overlay because Unicode doesn't have a clean "no-X" food
    // emoji for any of these. The label disambiguates ("Gluten-Free",
    // not just the wheat icon), and the visual glance still
    // communicates the category — wheat = gluten, milk = dairy,
    // peanut = nuts, egg = egg.
    case Dietary.glutenFree:
      return '🌾';
    case Dietary.dairyFree:
      return '🥛';
    case Dietary.nutFree:
      return '🥜';
    case Dietary.eggFree:
      return '🥚';
    case Dietary.mealPrep:
      return '🍱';
    case Dietary.quickEasy:
      return '⚡';
    case Dietary.pastaSoup:
      return '🍜';
    case Dietary.bloodSugarBalanced:
      return '🩺';
    case Dietary.swicy:
      return '🌶️';
    case Dietary.antiInflammatory:
      return '🥦';
  }
}
