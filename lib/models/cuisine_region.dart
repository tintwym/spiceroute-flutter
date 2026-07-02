import 'spice_route.dart';

/// Geographic region a [Cuisine] belongs to.
///
/// Regions are a *presentation grouping* on the Explore screen — they
/// don't change how recipes are stored or queried (the API still
/// filters by `Cuisine`). They exist purely to make a long pill bar
/// navigable: rather than scrolling past 30+ flags to find Japanese,
/// the user picks "East Asia" and sees only the cuisines that fit.
///
/// Display order is fixed and matches the reference design:
///   1. East Asia
///   2. Mainland Southeast Asia (Thai, Vietnamese, Cambodian, Burmese + …)
///   3. Maritime Southeast Asia
///   4. South Asia
///   5. Europe
///   6. Americas
///   7. Middle East & Africa
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
  CuisineRegion get region => switch (this) {
    Cuisine.chinese ||
    Cuisine.japanese ||
    Cuisine.korean ||
    Cuisine.taiwanese ||
    Cuisine.mongolian ||
    Cuisine.tibetan ||
    Cuisine.hongKong ||
    Cuisine.macanese ||
    Cuisine.sichuan ||
    Cuisine.cantonese ||
    Cuisine.shanghainese ||
    Cuisine.fujian ||
    Cuisine.hunan ||
    Cuisine.yunnan ||
    Cuisine.beijing ||
    Cuisine.dongbei ||
    Cuisine.hakka ||
    Cuisine.uyghur ||
    Cuisine.okinawan ||
    Cuisine.shandong ||
    Cuisine.guangxi ||
    Cuisine.teochew ||
    Cuisine.hainanese ||
    Cuisine.jiangsu ||
    Cuisine.zhejiang ||
    Cuisine.anhui ||
    Cuisine.jiangxi ||
    Cuisine.guizhou ||
    Cuisine.manchurian ||
    Cuisine.shaanxi => CuisineRegion.eastAsia,
    Cuisine.burmese ||
    Cuisine.shan ||
    Cuisine.rakhine ||
    Cuisine.mon ||
    Cuisine.kachin ||
    Cuisine.kayin ||
    Cuisine.chin ||
    Cuisine.kayah ||
    Cuisine.mandalay ||
    Cuisine.yangon ||
    Cuisine.ayeyarwady ||
    Cuisine.tanintharyi ||
    Cuisine.intha ||
    Cuisine.naga ||
    Cuisine.paO ||
    Cuisine.danu ||
    Cuisine.wa ||
    Cuisine.magway ||
    Cuisine.bago ||
    Cuisine.sagaing ||
    Cuisine.taunggyi ||
    Cuisine.cambodian ||
    Cuisine.thai ||
    Cuisine.vietnamese => CuisineRegion.mainlandSoutheastAsia,
    Cuisine.filipino ||
    Cuisine.indonesian ||
    Cuisine.malaysian => CuisineRegion.maritimeSoutheastAsia,
    Cuisine.indian ||
    Cuisine.pakistani ||
    Cuisine.sriLankan => CuisineRegion.southAsia,
    Cuisine.british ||
    Cuisine.french ||
    Cuisine.german ||
    Cuisine.greek ||
    Cuisine.italian ||
    Cuisine.portuguese ||
    Cuisine.spanish => CuisineRegion.europe,
    Cuisine.americanWestern ||
    Cuisine.brazilian ||
    Cuisine.caribbean ||
    Cuisine.mexican ||
    Cuisine.peruvian => CuisineRegion.americas,
    Cuisine.ethiopian ||
    Cuisine.lebanese ||
    Cuisine.moroccan ||
    Cuisine.turkish => CuisineRegion.middleEastAfrica,
  };
}

extension CuisineRegionMembers on CuisineRegion {
  List<Cuisine> get cuisines {
    return [
      for (final c in Cuisine.values)
        if (c.region == this) c,
    ];
  }
}

const List<CuisineRegion> _regionDisplayOrder = [
  CuisineRegion.eastAsia,
  CuisineRegion.mainlandSoutheastAsia,
  CuisineRegion.maritimeSoutheastAsia,
  CuisineRegion.southAsia,
  CuisineRegion.europe,
  CuisineRegion.americas,
  CuisineRegion.middleEastAfrica,
];

List<CuisineRegion> populatedRegions() {
  return [
    for (final r in _regionDisplayOrder)
      if (r.cuisines.isNotEmpty) r,
  ];
}
