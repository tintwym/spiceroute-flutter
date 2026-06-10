import 'dart:ui';

import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/spice_route.dart';
import '../shared/cuisine_pill_bar.dart';
import '../shared/theme.dart';

/// Three-column filter bar shown above the Explore grid:
///   [ SELECT CUISINE ]   [ SELECT COURSE ]   [ DIETARY, LIFESTYLE & FORMAT ]
///
/// Each option uses an emoji glyph as its icon (flag emojis for cuisines,
/// food/lifestyle emojis for courses + dietary) to match the design
/// reference exactly. Emojis ship for free with the OS — no asset
/// bundling or icon-font wrangling required.
///
/// The dropdown menus are rendered as glassmorphic overlays (translucent
/// frosted-glass surface, vibrant blue selected state, soft drop shadow).
/// On screens narrower than ~720px the columns stack vertically so each
/// dropdown gets full width.
class FilterBar extends StatelessWidget {
  const FilterBar({
    super.key,
    required this.cuisine,
    required this.course,
    required this.dietary,
    required this.onCuisineChanged,
    required this.onCourseChanged,
    required this.onDietaryChanged,
  });

  final Cuisine? cuisine;
  final Course? course;
  final Dietary? dietary;
  final ValueChanged<Cuisine?> onCuisineChanged;
  final ValueChanged<Course?> onCourseChanged;
  final ValueChanged<Dietary?> onDietaryChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);

    final cuisineCol = _FilterColumn<Cuisine?>(
      label: l.filterCuisineLabel,
      labelIcon: Icons.public_outlined,
      value: cuisine,
      hintEmoji: _allCuisinesEmoji,
      hintText: l.filterAllCuisines,
      items: [
        _FilterItem(
          value: null,
          label: l.filterAllCuisines,
          emoji: _allCuisinesEmoji,
        ),
        for (final c in Cuisine.values)
          _FilterItem(
            value: c,
            label: CuisinePillBar.labelFor(l, c),
            emoji: _cuisineEmoji(c),
          ),
      ],
      onChanged: onCuisineChanged,
    );

    final courseCol = _FilterColumn<Course?>(
      label: l.filterCourseLabel,
      labelIcon: Icons.schedule,
      value: course,
      hintEmoji: _allCoursesEmoji,
      hintText: l.filterAllCourses,
      items: _buildCourseItems(l),
      onChanged: onCourseChanged,
    );

    final dietaryCol = _FilterColumn<Dietary?>(
      label: l.filterDietaryLabel,
      labelIcon: Icons.eco_outlined,
      value: dietary,
      hintEmoji: _allDietaryEmoji,
      hintText: l.filterAllDietary,
      items: [
        _FilterItem(
          value: null,
          label: l.filterAllDietary,
          emoji: _allDietaryEmoji,
        ),
        for (final d in Dietary.values)
          _FilterItem(
            value: d,
            label: _dietaryLabel(l, d),
            emoji: _dietaryEmoji(d),
          ),
      ],
      onChanged: onDietaryChanged,
    );

    return LayoutBuilder(builder: (context, constraints) {
      // Below ~720px the three pills next to each other get too cramped
      // (especially the third label "DIETARY, LIFESTYLE & FORMAT
      // RESTRICTIONS" which is long). Stack vertically on narrow screens
      // so each column gets the full width.
      final stacked = constraints.maxWidth < 720;
      if (stacked) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            cuisineCol,
            const SizedBox(height: 12),
            courseCol,
            const SizedBox(height: 12),
            dietaryCol,
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: cuisineCol),
          const SizedBox(width: 16),
          Expanded(child: courseCol),
          const SizedBox(width: 16),
          Expanded(child: dietaryCol),
        ],
      );
    });
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
  });

  final String label;
  final IconData labelIcon;
  final T value;
  final String hintEmoji;
  final String hintText;
  final List<_FilterItem<T>> items;
  final ValueChanged<T> onChanged;

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
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
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
class _FilterItem<T> {
  const _FilterItem({
    required this.value,
    required this.label,
    required this.emoji,
    this.isHeader = false,
  });

  /// Convenience constructor for a non-selectable section header. The
  /// header inherits the dropdown's value type but never matches the
  /// active selection, so it always renders in its inactive style.
  const _FilterItem.header({
    required T sentinel,
    required this.label,
  })  : value = sentinel,
        emoji = '',
        isHeader = true;

  final T value;
  final String label;
  final String emoji;
  final bool isHeader;
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
  });

  final T value;
  final String hintEmoji;
  final String hintText;
  final List<_FilterItem<T>> items;
  final ValueChanged<T> onChanged;

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
    final overlay = Navigator.of(context)
        .overlay!
        .context
        .findRenderObject() as RenderBox;
    final origin = triggerBox.localToGlobal(Offset.zero, ancestor: overlay);
    final triggerSize = triggerBox.size;

    final result = await Navigator.of(context).push<_MenuResult<T>>(
      _GlassMenuRoute<T>(
        origin: origin,
        triggerSize: triggerSize,
        viewportSize: overlay.size,
        items: widget.items,
        selectedValue: widget.value,
      ),
    );
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
                child: Text(
                  displayText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.keyboard_arrow_down,
                  size: 22, color: cs.onSurfaceVariant),
            ],
          ),
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
  });

  final Offset origin;
  final Size triggerSize;
  final Size viewportSize;
  final List<_FilterItem<T>> items;

  /// Currently-selected value. Callers always pass an already-nullable
  /// `T` (e.g. `Cuisine?`), so the extra `?` would only confuse the
  /// type system.
  final T selectedValue;

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Dismiss menu';

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
    final maxMenuHeight = viewportSize.height - origin.dy - triggerSize.height - 24;
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
              onSelected: (v) =>
                  Navigator.of(context).pop(_MenuResult<T>(v)),
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
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
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
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Leading checkmark slot — always present so labels line
                // up vertically whether selected or not. Visible only on
                // the active row.
                SizedBox(
                  width: 20,
                  child: selected
                      ? const Icon(
                          Icons.check,
                          size: 18,
                          color: activeFg,
                        )
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
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
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

// --- emoji + label helpers ----------------------------------------------------

/// "All Cuisines" sentinel: a fried-egg glyph reads as the warm yellow
/// disc shown in the reference design and pairs visually with the
/// flag emojis below it (single-codepoint, brightly colored).
const String _allCuisinesEmoji = '🍳';

/// "All Courses" sentinel: clock matches the time-of-day framing that
/// courses imply ("when do you eat this?"), and visually echoes the
/// yellow circle in the reference design.
const String _allCoursesEmoji = '🕐';

/// "All Requests" sentinel for the dietary column: the dart-and-target
/// icon from the reference design.
const String _allDietaryEmoji = '🎯';

/// Flag-emoji per cuisine. Flag emojis are regional-indicator pairs and
/// render natively on macOS, iOS, Android, ChromeOS, Linux (Twemoji),
/// and Chrome on most desktop OSes. Windows falls back to plain letter
/// pairs (e.g. "KR" instead of 🇰🇷) — by design, Microsoft chose not
/// to ship flag glyphs in Segoe UI Emoji.
String _cuisineEmoji(Cuisine c) {
  switch (c) {
    case Cuisine.korean:
      return '🇰🇷';
    case Cuisine.japanese:
      return '🇯🇵';
    case Cuisine.chinese:
      return '🇨🇳';
    case Cuisine.burmese:
      return '🇲🇲';
    case Cuisine.thai:
      return '🇹🇭';
    case Cuisine.vietnamese:
      return '🇻🇳';
    case Cuisine.indian:
      return '🇮🇳';
    case Cuisine.italian:
      return '🇮🇹';
    case Cuisine.americanWestern:
      return '🇺🇸';
    case Cuisine.mexican:
      return '🇲🇽';
    case Cuisine.french:
      return '🇫🇷';
    case Cuisine.greek:
      return '🇬🇷';
    case Cuisine.spanish:
      return '🇪🇸';
    case Cuisine.malaysian:
      return '🇲🇾';
    case Cuisine.german:
      return '🇩🇪';
    case Cuisine.indonesian:
      return '🇮🇩';
  }
}

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

/// Build the dropdown list for the Course column. Walks [Course.values]
/// in declared order (which is already grouped) and emits a section
/// header every time the group changes.
List<_FilterItem<Course?>> _buildCourseItems(AppL10n l) {
  final out = <_FilterItem<Course?>>[
    _FilterItem<Course?>(
      value: null,
      label: l.filterAllCourses,
      emoji: _allCoursesEmoji,
    ),
  ];
  CourseGroup? lastGroup;
  for (final c in Course.values) {
    if (c.group != lastGroup) {
      out.add(_FilterItem<Course?>.header(
        sentinel: null,
        label: _courseGroupLabel(l, c.group),
      ));
      lastGroup = c.group;
    }
    out.add(_FilterItem<Course?>(
      value: c,
      label: _courseLabel(l, c),
      emoji: _courseEmoji(c),
    ));
  }
  return out;
}

String _dietaryLabel(AppL10n l, Dietary d) {
  switch (d) {
    case Dietary.vegan:
      return l.dietaryVegan;
    case Dietary.vegetarian:
      return l.dietaryVegetarian;
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
