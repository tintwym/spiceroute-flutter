import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/spice_route.dart';
import '../shared/breakpoints.dart';
import '../shared/mobile_filter_trigger.dart';
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
    final courseGroups = _buildCourseGroups(l);
    final dietaryGroups = _buildDietaryGroups(l);
    final courseClearItem = _FilterItem<Course?>(
      value: null,
      label: l.filterAllCourses,
      emoji: _allCoursesEmoji,
    );
    final dietaryClearItem = _FilterItem<Dietary?>(
      value: null,
      label: l.filterAllDietary,
      emoji: _allDietaryEmoji,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Course + dietary dropdowns belong on tablet+ — the mobile
        // bottom sheet is a phone affordance (thumb reach + narrow
        // columns). On a 600–719 dp iPad portrait the framed column
        // can be ~536 dp, which is < 560 and used to incorrectly
        // route tablet users through the phone sheet.
        final stacked = deviceClassOf(context).isPhone;

        if (stacked) {
          return _MobileCombinedFilterPill(
            course: course,
            dietary: dietary,
            openSheet: (ctx) {
              // Initial tab: prefer Course, but if the user has only
              // a dietary filter active land them on the Diet tab so
              // they see their current selection without an extra tap.
              final initialTab = (dietary != null && course == null) ? 1 : 0;
              _showFilterBottomSheet(
                context: ctx,
                initialTab: initialTab,
                courseValue: course,
                dietaryValue: dietary,
                courseGroups: courseGroups,
                dietaryGroups: dietaryGroups,
                courseClearItem: courseClearItem,
                dietaryClearItem: dietaryClearItem,
                onCourseSelected: onCourseChanged,
                onDietarySelected: onDietaryChanged,
              );
            },
          );
        }

        final courseCol = _FilterColumn<Course?>(
          label: l.filterCourseLabel,
          labelIcon: Icons.schedule,
          value: course,
          hintEmoji: _allCoursesEmoji,
          hintText: l.filterAllCourses,
          items: [courseClearItem],
          groups: courseGroups,
          searchHint: l.filterSearchCourses,
          onChanged: onCourseChanged,
        );

        final dietaryCol = _FilterColumn<Dietary?>(
          label: l.filterDietaryLabel,
          labelIcon: Icons.eco_outlined,
          value: dietary,
          hintEmoji: _allDietaryEmoji,
          hintText: l.filterAllDietary,
          items: [dietaryClearItem],
          groups: dietaryGroups,
          searchHint: l.filterSearchDietary,
          onChanged: onDietaryChanged,
        );

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
    this.customOpen,
  });

  final String label;
  final IconData labelIcon;
  final T value;
  final String hintEmoji;
  final String hintText;
  final List<_FilterItem<T>> items;
  final ValueChanged<T> onChanged;

  /// See [_GlassDropdown.customOpen]. Forwarded so the parent
  /// [FilterBar] can override per-pill open behaviour on mobile
  /// (both pills open the shared tabbed sheet there).
  final void Function(BuildContext, Offset triggerOrigin, Size triggerSize)?
  customOpen;

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
          customOpen: customOpen,
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
    this.customOpen,
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

  /// When non-null, tapping the trigger calls this *instead* of pushing
  /// the default accordion / flat-menu route. The callback receives the
  /// trigger's screen origin + size (so the parent can anchor its own
  /// route flush beneath the pill) and is responsible for handling the
  /// resulting selection itself — [onChanged] is **not** invoked along
  /// this path.
  ///
  /// Used by the mobile [FilterBar] so both the Course pill and the
  /// Dietary pill open a single shared [_TabbedAccordionMenuRoute]
  /// containing both accordions, rather than each pill opening its
  /// own single-dimension route.
  final void Function(BuildContext, Offset triggerOrigin, Size triggerSize)?
  customOpen;

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

    // Mobile (or any caller) can hand us a custom opener that pushes
    // its own route. We just provide the anchor info and step out;
    // the parent is responsible for handling the selection.
    if (widget.customOpen != null) {
      widget.customOpen!(context, origin, triggerSize);
      return;
    }

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
    // existing "All Preferences" presentation.
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
        child: buildFrostedSurface(
          fillColor: glassFill,
          borderColor: borderColor,
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
    this.brandSelection = false,
  });

  final _FilterItem<T> item;
  final bool selected;
  final VoidCallback onTap;
  final Color textColor;

  /// When true, uses the app theme primary (sage/olive) instead of the
  /// legacy vibrant-blue active row — matches the editorial refine card.
  final bool brandSelection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final activeBg = brandSelection ? cs.primary : const Color(0xFF3D8BFD);
    final activeFg = brandSelection ? cs.onPrimary : Colors.white;

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
                      ? Icon(Icons.check, size: 18, color: activeFg)
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
    super.key,
    required this.groups,
    required this.selectedValue,
    required this.searchHint,
    required this.onSelected,
    this.clearItem,
    this.heading,
    this.dropFrostedSurface = false,
    this.flatMobileList = false,
  });

  final List<_FilterGroup<T>> groups;
  final T selectedValue;
  final String searchHint;
  final ValueChanged<T> onSelected;

  /// Optional "All …" row pinned above the accordion sections. See
  /// [_AccordionMenuRoute.clearItem].
  final _FilterItem<T>? clearItem;

  /// Optional uppercase heading rendered to the left of the
  /// EXPAND ALL toggle. Used by the mobile tabbed sheet so each
  /// tab can display its own context label
  /// ("COURSE SELECTION FILTERS", "DIETARY & LIFESTYLE
  /// RESTRICTIONS"). Desktop callers leave it null — they already
  /// render the heading above the trigger pill via [_FilterColumn].
  final String? heading;

  /// When true, drops the outer frosted-glass surface (shadow,
  /// rounded clip, BackdropFilter, fill colour, padding) so the
  /// menu can be embedded inside another container that already
  /// owns those visuals — like the mobile tabbed sheet, which
  /// wraps two accordions in a single shared frosted-glass card
  /// instead of giving each its own.
  final bool dropFrostedSurface;

  /// Phone bottom sheet: flat scroll list with soft group subheaders —
  /// no search, no EXPAND ALL, no collapsible accordion cards.
  final bool flatMobileList;

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
    if (widget.flatMobileList) {
      _expanded.addAll(Iterable<int>.generate(widget.groups.length));
      return;
    }
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

    if (widget.flatMobileList) {
      return Material(
        type: MaterialType.transparency,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.clearItem != null) ...[
              _GlassMenuItem<T>(
                item: widget.clearItem!,
                selected: widget.clearItem!.value == widget.selectedValue,
                onTap: () => widget.onSelected(widget.clearItem!.value),
                textColor: cs.onSurface,
                brandSelection: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1, color: cs.outlineVariant),
              ),
            ],
            Expanded(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  for (final g in widget.groups) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 10, 4, 6),
                      child: Text(
                        g.label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    for (final it in g.items)
                      _GlassMenuItem<T>(
                        item: it,
                        selected: it.value == widget.selectedValue,
                        onTap: () => widget.onSelected(it.value),
                        textColor: cs.onSurface,
                        brandSelection: true,
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    }

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

    // -------------------------------------------------------------
    // Top-of-menu chrome: the EXPAND ALL toggle (always present)
    // and an optional uppercase heading on the left.
    //
    // The heading is wrapped in `Flexible` so a long localized
    // string (Burmese "ဟင်းပွဲ ရွေးချယ်မှု စစ်ထုတ်ချက်" runs
    // ~28 chars) can wrap to a second line instead of pushing
    // the toggle off the right edge of the row.
    // -------------------------------------------------------------
    final topRow = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.heading != null)
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                widget.heading!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        else
          const Spacer(),
        _ExpandAllToggle(expanded: _allExpanded, onTap: _toggleAll),
      ],
    );

    final body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        topRow,
        const SizedBox(height: 6),
        // ---------------------------------------------------------
        // Search input. autofocus: false so the on-screen keyboard
        // doesn't pop the moment the menu opens — many users open
        // the menu just to browse.
        // ---------------------------------------------------------
        _AccordionSearchField(
          controller: _searchCtl,
          hint: widget.searchHint,
          onChanged: _onSearchChanged,
        ),
        const SizedBox(height: 10),
        // ---------------------------------------------------------
        // Clear-filter row pinned ABOVE the scroll area so it's
        // always reachable. Used to live inside the scroll view but
        // on phones with lots of accordion sections it could scroll
        // off-screen, leaving "clear" hidden behind whichever
        // section the user had expanded last. Pinning it solves that
        // and gives the search/no-matches body its own predictable
        // scroll surface below.
        // ---------------------------------------------------------
        if (widget.clearItem != null) ...[
          _GlassMenuItem<T>(
            item: widget.clearItem!,
            selected: widget.clearItem!.value == widget.selectedValue,
            onTap: () => widget.onSelected(widget.clearItem!.value),
            textColor: cs.onSurface,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Divider(height: 1, color: cs.outlineVariant),
          ),
        ],
        // ---------------------------------------------------------
        // Scrollable column of accordion sections so the menu
        // height never exceeds the route's maxHeight.
        // ---------------------------------------------------------
        Flexible(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
    );

    if (widget.dropFrostedSurface) {
      // The mobile tabbed sheet owns the outer frosted-glass card
      // (shadow + ClipRRect + BackdropFilter + fill) so multiple
      // accordions can share a single visual surface. Just emit
      // the body — no padding either, the host applies its own.
      return Material(type: MaterialType.transparency, child: body);
    }

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
        child: buildFrostedSurface(
          fillColor: glassFill,
          borderColor: borderColor,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: body,
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
    // `surfaceContainerHighest` (not `surface`) on purpose. In dark
    // mode `cs.surface` == #1B1F15 which is also the page background,
    // so a search bar filled with `cs.surface` looks like a DARKER
    // hole punched through the lighter frosted-glass sheet (the
    // sheet sits on an 8% white overlay over a backdrop blur, which
    // raises its effective tone). That's the wrong direction —
    // inputs should read as a *raised* element, not recessed. The
    // theme's design doc explicitly assigns `surfaceContainerHighest`
    // (#272C1F dark / #F5F2ED light) to "inner surfaces — dropdown
    // items, card details", and Material 3's `inputDecorationTheme`
    // already uses the same token as the canonical filled-input
    // colour. Pinning here keeps the bar consistent with both the
    // outer trigger pill (also `surfaceContainerHighest`) and the
    // M3 input convention.
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
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
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
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

/// "All Courses" sentinel in the desktop course dropdown.
const String _allCoursesEmoji = '🕐';

/// "All Dietary" sentinel in the desktop dietary dropdown.
const String _allDietaryEmoji = '🎯';

/// Chef glyph for the mobile combined filter pill when no filter is
/// active (or both are) — pairs with [filterMobilePillHint].
const String _mobileFilterNeutralEmoji = '🧑‍🍳';

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

// =============================================================================
// Mobile two-tab filter sheet
// =============================================================================
//
// On screens narrower than 560 dp the [FilterBar] swaps each pill's
// per-dimension accordion route for a single shared route that hosts
// BOTH the Course and Dietary accordions in a tab toggle. This matches
// the minimalist iOS-style mockup (`assets/filter-ui-mockup.png`):
//
//     ┌─────────────────────────────────────────────────┐
//     │  [⏱ By Course]   [🌿 By Diet & Lifestyle]      │   tab toggle
//     ├─────────────────────────────────────────────────┤
//     │  COURSE SELECTION FILTERS         ⊕ EXPAND ALL  │   heading + toggle
//     │  ┌───────────────────────────────────────────┐  │
//     │  │ 🔍  Search courses (e.g. Dessert, Mains…) │  │   search field
//     │  └───────────────────────────────────────────┘  │
//     │  ┌───────────────────────────────────────────┐  │
//     │  │ 🗂  EARLY DAY               2 MATCHED  ⌄  │  │   accordion section
//     │  └───────────────────────────────────────────┘  │
//     │  …                                              │
//     └─────────────────────────────────────────────────┘
//
// Architecture:
//   * [_showFilterBottomSheet] opens a Material modal bottom sheet
//     anchored to the bottom edge of the viewport (NOT to the trigger
//     pill). Earlier versions used a [PopupRoute] anchored below the
//     trigger; that broke on small phones because the popup's height
//     was clamped to a 280 dp minimum and rendered partially off-screen
//     when the trigger sat low in the viewport — the inner scroll view
//     couldn't pan the off-screen content into view.
//   * [_FilterBottomSheet] is the sheet body. It owns the active-tab
//     state and wraps two [_AccordionGlassMenu] instances (one per
//     dimension) in an [IndexedStack]. Each accordion runs with
//     `dropFrostedSurface: true` so the sheet's own surface isn't
//     double-rendered.
//   * State (search query, expanded sections) is preserved across tab
//     switches because [IndexedStack] keeps both subtrees alive — a
//     user who types into the Course search box, switches to Diet,
//     then switches back, finds their query intact.

/// Single combined pill rendered on mobile (< 560 dp). Replaces the
/// pair of stacked [_FilterColumn]s — both filter dimensions live
/// inside the tabbed sheet now, so two visually-separate triggers
/// would have been redundant chrome.
///
/// Visual style matches [_GlassDropdown]'s closed trigger so the
/// pill feels native to the rest of the filter UI:
///   - 28-dp rounded surface, surfaceContainerHighest fill
///   - Leading emoji glyph, summary text, trailing chevron
///   - 48-dp min height
///
/// Summary content reflects the current filter state:
///   - Both dimensions cleared → 🧑‍🍳 + [filterMobilePillHint]
///   - Single active dimension → that selection's emoji + label
///   - Both active → 🧑‍🍳 + "{course} · {dietary}", soft-clipped on
///     overflow so a verbose locale doesn't blow the row out
class _MobileCombinedFilterPill extends StatefulWidget {
  const _MobileCombinedFilterPill({
    required this.course,
    required this.dietary,
    required this.openSheet,
  });

  final Course? course;
  final Dietary? dietary;

  /// Invoked when the user taps the trigger pill. The parent opens
  /// the modal bottom sheet — no geometry needed because the sheet
  /// anchors to the bottom edge of the screen, not to this trigger.
  final void Function(BuildContext) openSheet;

  @override
  State<_MobileCombinedFilterPill> createState() =>
      _MobileCombinedFilterPillState();
}

class _MobileCombinedFilterPillState extends State<_MobileCombinedFilterPill> {
  void _open(BuildContext context) {
    widget.openSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);

    final courseActive = widget.course != null;
    final dietActive = widget.dietary != null;

    final String emoji;
    final String summary;
    if (!courseActive && !dietActive) {
      emoji = _mobileFilterNeutralEmoji;
      summary = l.filterMobilePillHint;
    } else if (courseActive && !dietActive) {
      emoji = _courseEmoji(widget.course!);
      summary = _courseLabel(l, widget.course!);
    } else if (!courseActive && dietActive) {
      emoji = _dietaryEmoji(widget.dietary!);
      summary = _dietaryLabel(l, widget.dietary!);
    } else {
      emoji = _mobileFilterNeutralEmoji;
      summary =
          '${_courseLabel(l, widget.course!)} · '
          '${_dietaryLabel(l, widget.dietary!)}';
    }

    return MobileFilterTriggerPill(
      emoji: emoji,
      label: summary,
      isActive: courseActive || dietActive,
      onTap: () => _open(context),
    );
  }
}

/// Opens the mobile filter sheet as a Material modal bottom sheet.
///
/// The sheet anchors to the bottom edge of the screen (not to the
/// trigger pill), takes up to ~85% of the viewport, and supports
/// drag-to-dismiss + scroll-to-reveal. This replaced an earlier
/// PopupRoute-anchored-below-trigger design that broke on small
/// phones: the popup's height was clamped to a 280 dp minimum so on
/// devices where the trigger sat low in the viewport the sheet
/// rendered partially below the visible area and the inner
/// SingleChildScrollView couldn't pan the off-screen content into
/// view (it only scrolls within its own logical bounds, not the
/// visible viewport).
///
/// `isScrollControlled: true` is required so the sheet can grow
/// beyond Flutter's default ~50% cap; the [_FilterBottomSheet] then
/// constrains itself to 85% of MediaQuery height.
void _showFilterBottomSheet({
  required BuildContext context,
  required int initialTab,
  required Course? courseValue,
  required Dietary? dietaryValue,
  required List<_FilterGroup<Course?>> courseGroups,
  required List<_FilterGroup<Dietary?>> dietaryGroups,
  required _FilterItem<Course?> courseClearItem,
  required _FilterItem<Dietary?> dietaryClearItem,
  required ValueChanged<Course?> onCourseSelected,
  required ValueChanged<Dietary?> onDietarySelected,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    // We render our own SafeArea inside so the rounded top corners
    // can extend up to the status bar on tall content; only the
    // bottom edge needs OS-inset padding (home indicator).
    useSafeArea: false,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: isDark ? 0.6 : 0.45),
    builder: (sheetCtx) {
      return _FilterBottomSheet(
        initialTab: initialTab,
        courseValue: courseValue,
        dietaryValue: dietaryValue,
        courseGroups: courseGroups,
        dietaryGroups: dietaryGroups,
        courseClearItem: courseClearItem,
        dietaryClearItem: dietaryClearItem,
        onCourseSelected: (v) {
          onCourseSelected(v);
          Navigator.of(sheetCtx).pop();
        },
        onDietarySelected: (v) {
          onDietarySelected(v);
          Navigator.of(sheetCtx).pop();
        },
      );
    },
  );
}

/// Bottom-sheet body containing the tab toggle on top and the
/// active dimension's accordion below.
///
/// Stateful only so the active-tab index can be flipped in-place by
/// the toggle without round-tripping through the parent. State for
/// search query / expanded sections lives inside each
/// [_AccordionGlassMenu]; an [IndexedStack] keeps both alive across
/// tab switches so neither resets when the user ping-pongs.
class _FilterBottomSheet extends StatefulWidget {
  const _FilterBottomSheet({
    required this.initialTab,
    required this.courseValue,
    required this.dietaryValue,
    required this.courseGroups,
    required this.dietaryGroups,
    required this.courseClearItem,
    required this.dietaryClearItem,
    required this.onCourseSelected,
    required this.onDietarySelected,
  });

  final int initialTab;
  final Course? courseValue;
  final Dietary? dietaryValue;
  final List<_FilterGroup<Course?>> courseGroups;
  final List<_FilterGroup<Dietary?>> dietaryGroups;
  final _FilterItem<Course?> courseClearItem;
  final _FilterItem<Dietary?> dietaryClearItem;
  final ValueChanged<Course?> onCourseSelected;
  final ValueChanged<Dietary?> onDietarySelected;

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late int _activeTab;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l = AppL10n.of(context);
    final mq = MediaQuery.of(context);

    // Cap at ~60% of the viewport — enough for the flat list to
    // scroll without feeling like a full-screen takeover.
    final maxHeight = mq.size.height * 0.6;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      // When the on-screen keyboard appears (search field focused),
      // viewInsets.bottom > 0 — pad ourselves up so the sheet body
      // remains fully visible above the keyboard.
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Material(
          color: cs.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          clipBehavior: Clip.antiAlias,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag-handle indicator. iOS users instinctively
                  // grab this to dismiss; Material's `enableDrag`
                  // gesture covers the whole sheet so the visual is
                  // mostly affordance-signaling.
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: cs.onSurface.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  _FilterTabBar(
                    activeIndex: _activeTab,
                    onChanged: (i) => setState(() => _activeTab = i),
                    courseLabel: l.filterTabCourse,
                    dietaryLabel: l.filterTabDiet,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: IndexedStack(
                      index: _activeTab,
                      sizing: StackFit.passthrough,
                      children: [
                        _AccordionGlassMenu<Course?>(
                          key: const ValueKey('tabbed-course-accordion'),
                          groups: widget.courseGroups,
                          selectedValue: widget.courseValue,
                          searchHint: l.filterSearchCourses,
                          dropFrostedSurface: true,
                          flatMobileList: true,
                          clearItem: widget.courseClearItem,
                          onSelected: widget.onCourseSelected,
                        ),
                        _AccordionGlassMenu<Dietary?>(
                          key: const ValueKey('tabbed-diet-accordion'),
                          groups: widget.dietaryGroups,
                          selectedValue: widget.dietaryValue,
                          searchHint: l.filterSearchDietary,
                          dropFrostedSurface: true,
                          flatMobileList: true,
                          clearItem: widget.dietaryClearItem,
                          onSelected: widget.onDietarySelected,
                        ),
                      ],
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

/// Two-pill segmented toggle that switches the body between the
/// Course accordion and the Dietary accordion. Mirrors the screenshot
/// reference: rounded outer container, white selected pill with a
/// thin coloured outline, leaf glyph rendered in green to set off the
/// "Diet & Lifestyle" tab.
class _FilterTabBar extends StatelessWidget {
  const _FilterTabBar({
    required this.activeIndex,
    required this.onChanged,
    required this.courseLabel,
    required this.dietaryLabel,
  });

  final int activeIndex;
  final ValueChanged<int> onChanged;
  final String courseLabel;
  final String dietaryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant, width: 1),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _FilterTab(
              icon: Icons.timer_outlined,
              label: courseLabel,
              active: activeIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _FilterTab(
              icon: Icons.eco_outlined,
              label: dietaryLabel,
              active: activeIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: active ? cs.surface : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              // Thin border on the active pill to lift it off the
              // toggle's surfaceContainerHighest fill — without it
              // the active state reads as faintly tinted air.
              border: active
                  ? Border.all(
                      color: cs.primary.withValues(alpha: 0.22),
                      width: 1,
                    )
                  : null,
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: cs.primary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    ),
                    maxLines: 1,
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

/// Half-width course + dietary trigger for the combined refine row on
/// phone Explore. Opens the same tabbed bottom sheet as
/// [_MobileCombinedFilterPill].
class MobileCourseDietaryFilterTrigger extends StatelessWidget {
  const MobileCourseDietaryFilterTrigger({
    super.key,
    required this.course,
    required this.dietary,
    required this.onCourseChanged,
    required this.onDietaryChanged,
    this.compactHint = true,
  });

  final Course? course;
  final Dietary? dietary;
  final ValueChanged<Course?> onCourseChanged;
  final ValueChanged<Dietary?> onDietaryChanged;

  /// When true (default), idle label uses the shorter
  /// [AppL10n.filterPreferencesHint] for the narrow column.
  final bool compactHint;

  void _open(BuildContext context) {
    final l = AppL10n.of(context);
    final courseGroups = _buildCourseGroups(l);
    final dietaryGroups = _buildDietaryGroups(l);
    final courseClearItem = _FilterItem<Course?>(
      value: null,
      label: l.filterAllCourses,
      emoji: _allCoursesEmoji,
    );
    final dietaryClearItem = _FilterItem<Dietary?>(
      value: null,
      label: l.filterAllDietary,
      emoji: _allDietaryEmoji,
    );
    final initialTab = (dietary != null && course == null) ? 1 : 0;
    _showFilterBottomSheet(
      context: context,
      initialTab: initialTab,
      courseValue: course,
      dietaryValue: dietary,
      courseGroups: courseGroups,
      dietaryGroups: dietaryGroups,
      courseClearItem: courseClearItem,
      dietaryClearItem: dietaryClearItem,
      onCourseSelected: onCourseChanged,
      onDietarySelected: onDietaryChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);

    final courseActive = course != null;
    final dietActive = dietary != null;

    final String emoji;
    final String summary;
    if (!courseActive && !dietActive) {
      emoji = _mobileFilterNeutralEmoji;
      summary = compactHint ? l.filterPreferencesHint : l.filterMobilePillHint;
    } else if (courseActive && !dietActive) {
      emoji = _courseEmoji(course!);
      summary = _courseLabel(l, course!);
    } else if (!courseActive && dietActive) {
      emoji = _dietaryEmoji(dietary!);
      summary = _dietaryLabel(l, dietary!);
    } else {
      emoji = _courseEmoji(course!);
      summary =
          '${_courseLabel(l, course!)} · '
          '${_dietaryLabel(l, dietary!)}';
    }

    return MobileFilterTriggerHalf(
      emoji: emoji,
      secondaryEmoji: courseActive && dietActive
          ? _dietaryEmoji(dietary!)
          : null,
      label: summary,
      isActive: courseActive || dietActive,
      onTap: () => _open(context),
    );
  }
}
