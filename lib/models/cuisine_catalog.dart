import 'cuisine_region.dart';
import 'spice_route.dart';

/// Sub-national cuisine enum values collapsed to a single country pill.
/// Enum values remain for legacy API wires and DB compatibility.

const Set<Cuisine> chineseProvincialCuisines = {
  Cuisine.sichuan,
  Cuisine.cantonese,
  Cuisine.shanghainese,
  Cuisine.fujian,
  Cuisine.hunan,
  Cuisine.yunnan,
  Cuisine.beijing,
  Cuisine.dongbei,
  Cuisine.hakka,
  Cuisine.shandong,
  Cuisine.guangxi,
  Cuisine.teochew,
  Cuisine.hainanese,
  Cuisine.jiangsu,
  Cuisine.zhejiang,
  Cuisine.anhui,
  Cuisine.jiangxi,
  Cuisine.guizhou,
  Cuisine.manchurian,
  Cuisine.shaanxi,
};

const Set<Cuisine> chineseSubnationalCuisines = {
  ...chineseProvincialCuisines,
  Cuisine.hongKong,
  Cuisine.macanese,
  Cuisine.tibetan,
  Cuisine.uyghur,
};

const Set<Cuisine> myanmarRegionalCuisines = {
  Cuisine.shan,
  Cuisine.rakhine,
  Cuisine.mon,
  Cuisine.kachin,
  Cuisine.kayin,
  Cuisine.chin,
  Cuisine.kayah,
  Cuisine.mandalay,
  Cuisine.yangon,
  Cuisine.ayeyarwady,
  Cuisine.tanintharyi,
  Cuisine.intha,
  Cuisine.naga,
  Cuisine.paO,
  Cuisine.danu,
  Cuisine.wa,
  Cuisine.magway,
  Cuisine.bago,
  Cuisine.sagaing,
  Cuisine.taunggyi,
};

const Set<Cuisine> japaneseSubnationalCuisines = {Cuisine.okinawan};

/// Country-level cuisine for pickers, card labels, and filters.
/// Myanmar regional wires (Shan, Yangon, …) collapse to [Cuisine.burmese].
Cuisine cuisineForDisplay(Cuisine c) {
  if (chineseSubnationalCuisines.contains(c)) return Cuisine.chinese;
  if (myanmarRegionalCuisines.contains(c)) return Cuisine.burmese;
  if (japaneseSubnationalCuisines.contains(c)) return Cuisine.japanese;
  return c;
}

bool isSubnationalCuisine(Cuisine c) =>
    chineseSubnationalCuisines.contains(c) ||
    myanmarRegionalCuisines.contains(c) ||
    japaneseSubnationalCuisines.contains(c);

bool isChineseProvincial(Cuisine c) => chineseProvincialCuisines.contains(c);

Cuisine? normalizeCuisineFilter(Cuisine? c) =>
    c == null ? null : cuisineForDisplay(c);

bool cuisinePillSelected({required Cuisine pill, required Cuisine? active}) {
  if (active == null) return false;
  return cuisineForDisplay(active) == pill;
}

List<Cuisine> selectableCuisines(Iterable<Cuisine> source) {
  final seen = <Cuisine>{};
  final out = <Cuisine>[];
  for (final c in source) {
    final pick = cuisineForDisplay(c);
    if (seen.add(pick)) out.add(pick);
  }
  return out;
}

List<Cuisine> selectableCuisinesInRegion(CuisineRegion region) =>
    selectableCuisines(region.cuisines);
