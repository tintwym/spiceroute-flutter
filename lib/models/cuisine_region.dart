import 'spice_route.dart';

/// Geographic region a [Cuisine] belongs to.
///
/// Regions are a *presentation grouping* on the Explore screen — they
/// don't change how recipes are stored or queried (the API still
/// filters by `Cuisine`). They exist purely to make a long pill bar
/// navigable: rather than scrolling past 16+ flags to find Japanese,
/// the user picks "East Asian Countries" and sees only the 3 that fit.
///
/// Display order is fixed and matches the reference design:
///   1. East Asia
///   2. Mainland Southeast Asia
///   3. Maritime Southeast Asia
///   4. South Asia
///   5. Europe
///   6. Americas
///   7. Middle East & Africa
///
/// A region with zero cuisines is hidden from the UI (see
/// [populatedRegions]) — when the catalog grows to include e.g.
/// Lebanese / Turkish / Moroccan, Middle East & Africa auto-appears
/// with no code change to the widget.
enum CuisineRegion {
  eastAsia,
  mainlandSoutheastAsia,
  maritimeSoutheastAsia,
  southAsia,
  europe,
  americas,
  middleEastAfrica,
}

extension CuisineRegionLookup on Cuisine {
  /// Which region a cuisine belongs to.
  ///
  /// Switch is exhaustive over [Cuisine] so adding a new cuisine
  /// becomes a compile error here — forcing the contributor to pick
  /// a region rather than silently dropping the cuisine into "no
  /// region" limbo.
  CuisineRegion get region => switch (this) {
        Cuisine.chinese ||
        Cuisine.japanese ||
        Cuisine.korean =>
          CuisineRegion.eastAsia,
        Cuisine.burmese ||
        Cuisine.thai ||
        Cuisine.vietnamese =>
          CuisineRegion.mainlandSoutheastAsia,
        Cuisine.indonesian ||
        Cuisine.malaysian =>
          CuisineRegion.maritimeSoutheastAsia,
        Cuisine.indian => CuisineRegion.southAsia,
        Cuisine.french ||
        Cuisine.german ||
        Cuisine.greek ||
        Cuisine.italian ||
        Cuisine.spanish =>
          CuisineRegion.europe,
        Cuisine.americanWestern ||
        Cuisine.mexican =>
          CuisineRegion.americas,
      };
}

extension CuisineRegionMembers on CuisineRegion {
  /// Cuisines that belong to this region, in declared `Cuisine.values`
  /// order. Computed lazily; the catalog is 16 items so the filter
  /// pass is cheap (no need to cache).
  List<Cuisine> get cuisines {
    return [
      for (final c in Cuisine.values)
        if (c.region == this) c,
    ];
  }
}

/// Display order of every region the app might surface, even ones
/// that currently have zero cuisines. Use [populatedRegions] for the
/// UI-ready list.
const List<CuisineRegion> _regionDisplayOrder = [
  CuisineRegion.eastAsia,
  CuisineRegion.mainlandSoutheastAsia,
  CuisineRegion.maritimeSoutheastAsia,
  CuisineRegion.southAsia,
  CuisineRegion.europe,
  CuisineRegion.americas,
  CuisineRegion.middleEastAfrica,
];

/// Regions that have at least one cuisine assigned. The Explore UI
/// renders only these — empty regions would create dead navigation
/// targets ("clicked European Countries, saw nothing"). When the
/// catalog grows (adding Lebanese, Turkish, etc.) the affected
/// region auto-appears.
List<CuisineRegion> populatedRegions() {
  return [
    for (final r in _regionDisplayOrder)
      if (r.cuisines.isNotEmpty) r,
  ];
}
