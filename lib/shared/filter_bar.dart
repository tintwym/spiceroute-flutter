import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/spice_route.dart';
import '../shared/cuisine_pill_bar.dart';

/// Three-column filter bar shown above the Explore grid:
///   [ SELECT CUISINE ]   [ SELECT COURSE ]   [ DIETARY, LIFESTYLE & FORMAT ]
///
/// Each column has a small uppercase label with a leading icon and a pill
/// dropdown that surfaces the available options. On screens narrower than
/// ~720px the columns stack vertically so each dropdown gets full width.
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
      labelIcon: Icons.layers_outlined,
      value: cuisine,
      hintIcon: Icons.layers_outlined,
      hintText: l.filterAllCuisines,
      items: [
        _FilterItem(value: null, label: l.filterAllCuisines,
            icon: Icons.layers_outlined),
        for (final c in Cuisine.values)
          _FilterItem(value: c, label: CuisinePillBar.labelFor(l, c),
              icon: _cuisineIcon(c)),
      ],
      onChanged: onCuisineChanged,
    );

    final courseCol = _FilterColumn<Course?>(
      label: l.filterCourseLabel,
      labelIcon: Icons.schedule,
      value: course,
      hintIcon: Icons.schedule,
      hintText: l.filterAllCourses,
      items: [
        _FilterItem(value: null, label: l.filterAllCourses,
            icon: Icons.schedule),
        for (final c in Course.values)
          _FilterItem(value: c, label: _courseLabel(l, c),
              icon: _courseIcon(c)),
      ],
      onChanged: onCourseChanged,
    );

    final dietaryCol = _FilterColumn<Dietary?>(
      label: l.filterDietaryLabel,
      labelIcon: Icons.eco_outlined,
      value: dietary,
      hintIcon: Icons.eco_outlined,
      hintText: l.filterAllDietary,
      items: [
        _FilterItem(value: null, label: l.filterAllDietary,
            icon: Icons.eco_outlined),
        for (final d in Dietary.values)
          _FilterItem(value: d, label: _dietaryLabel(l, d),
              icon: _dietaryIcon(d)),
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
    required this.hintIcon,
    required this.hintText,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final IconData labelIcon;
  final T value;
  final IconData hintIcon;
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
        Padding(
          padding: const EdgeInsets.only(left: 14, bottom: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(labelIcon, size: 14, color: cs.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // The dropdown pill itself.
        _DropdownPill<T>(
          value: value,
          hintIcon: hintIcon,
          hintText: hintText,
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// One option in a filter dropdown. `value == null` represents "All …".
class _FilterItem<T> {
  const _FilterItem({
    required this.value,
    required this.label,
    required this.icon,
  });
  final T value;
  final String label;
  final IconData icon;
}

/// Pill-shaped dropdown trigger that, when tapped, opens a menu of options.
/// Implemented as a [PopupMenuButton] so we can fully control the
/// appearance (the default `DropdownButton` doesn't let us style the
/// closed-state pill the way the design wants).
class _DropdownPill<T> extends StatelessWidget {
  const _DropdownPill({
    super.key,
    required this.value,
    required this.hintIcon,
    required this.hintText,
    required this.items,
    required this.onChanged,
  });

  final T value;
  final IconData hintIcon;
  final String hintText;
  final List<_FilterItem<T>> items;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Find the currently-selected item so we render its icon + label in
    // the closed pill state. Falls back to the hint values if the
    // current value isn't in the option list (shouldn't happen in
    // practice but keeps things robust).
    _FilterItem<T>? selected;
    for (final item in items) {
      if (item.value == value) {
        selected = item;
        break;
      }
    }
    final displayIcon = selected?.icon ?? hintIcon;
    final displayText = selected?.label ?? hintText;

    return PopupMenuButton<T>(
      tooltip: '',
      onSelected: onChanged,
      offset: const Offset(0, 56),
      position: PopupMenuPosition.under,
      constraints: const BoxConstraints(minWidth: 220, maxHeight: 360),
      itemBuilder: (_) => [
        for (final item in items)
          PopupMenuItem<T>(
            value: item.value,
            height: 40,
            child: Row(
              children: [
                Icon(item.icon, size: 18, color: cs.onSurfaceVariant),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.label,
                    style: theme.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.value == value)
                  Icon(Icons.check, size: 16, color: cs.primary),
              ],
            ),
          ),
      ],
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: cs.outlineVariant, width: 1),
        ),
        child: Row(
          children: [
            Icon(displayIcon, size: 18, color: cs.onSurfaceVariant),
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
    );
  }
}

// --- icon + label helpers ----------------------------------------------------

IconData _cuisineIcon(Cuisine c) {
  switch (c) {
    case Cuisine.korean:
      return Icons.ramen_dining;
    case Cuisine.japanese:
      return Icons.rice_bowl;
    case Cuisine.chinese:
      return Icons.dinner_dining;
    case Cuisine.burmese:
      return Icons.soup_kitchen;
    case Cuisine.thai:
      return Icons.local_fire_department;
    case Cuisine.vietnamese:
      return Icons.rice_bowl;
    case Cuisine.indian:
      return Icons.spa;
    case Cuisine.italian:
      return Icons.local_pizza;
    case Cuisine.americanWestern:
      return Icons.lunch_dining;
    case Cuisine.mexican:
      return Icons.takeout_dining;
  }
}

String _courseLabel(AppL10n l, Course c) {
  switch (c) {
    case Course.breakfast:
      return l.courseBreakfast;
    case Course.lunch:
      return l.courseLunch;
    case Course.dinner:
      return l.courseDinner;
    case Course.appetizer:
      return l.courseAppetizer;
    case Course.mainCourse:
      return l.courseMainCourse;
    case Course.sideDish:
      return l.courseSideDish;
    case Course.soup:
      return l.courseSoup;
    case Course.salad:
      return l.courseSalad;
    case Course.snack:
      return l.courseSnack;
    case Course.dessert:
      return l.courseDessert;
  }
}

IconData _courseIcon(Course c) {
  switch (c) {
    case Course.breakfast:
      return Icons.breakfast_dining;
    case Course.lunch:
      return Icons.lunch_dining;
    case Course.dinner:
      return Icons.dinner_dining;
    case Course.appetizer:
      return Icons.tapas;
    case Course.mainCourse:
      return Icons.restaurant_menu;
    case Course.sideDish:
      return Icons.rice_bowl;
    case Course.soup:
      return Icons.soup_kitchen;
    case Course.salad:
      return Icons.eco_outlined;
    case Course.snack:
      return Icons.cookie;
    case Course.dessert:
      return Icons.icecream;
  }
}

String _dietaryLabel(AppL10n l, Dietary d) {
  switch (d) {
    case Dietary.vegetarian:
      return l.dietaryVegetarian;
    case Dietary.vegan:
      return l.dietaryVegan;
    case Dietary.glutenFree:
      return l.dietaryGlutenFree;
    case Dietary.dairyFree:
      return l.dietaryDairyFree;
    case Dietary.nutFree:
      return l.dietaryNutFree;
    case Dietary.highProtein:
      return l.dietaryHighProtein;
    case Dietary.lowCarb:
      return l.dietaryLowCarb;
    case Dietary.quick:
      return l.dietaryQuick;
  }
}

IconData _dietaryIcon(Dietary d) {
  switch (d) {
    case Dietary.vegetarian:
      return Icons.eco_outlined;
    case Dietary.vegan:
      return Icons.energy_savings_leaf_outlined;
    case Dietary.glutenFree:
      return Icons.grain;
    case Dietary.dairyFree:
      return Icons.no_drinks;
    case Dietary.nutFree:
      return Icons.no_food;
    case Dietary.highProtein:
      return Icons.fitness_center;
    case Dietary.lowCarb:
      return Icons.donut_small;
    case Dietary.quick:
      return Icons.timer;
  }
}
