import '../l10n/generated/app_localizations.dart';
import '../models/cuisine_region.dart';
import '../models/spice_route.dart';

/// Shared display helpers for the `Cuisine` enum.
///
/// Previously inlined as private helpers inside `community_board.dart` and
/// `cross_cultural_stories.dart`. Extracting keeps the two switch statements
/// from drifting out of sync as we add cuisines — every place that needs to
/// label or flag a cuisine now reads from this single file.
String cuisineLabel(AppL10n l, Cuisine c) {
  switch (c) {
    case Cuisine.korean:
      return l.cuisineKorean;
    case Cuisine.japanese:
      return l.cuisineJapanese;
    case Cuisine.chinese:
      return l.cuisineChinese;
    case Cuisine.burmese:
      return l.cuisineBurmese;
    case Cuisine.thai:
      return l.cuisineThai;
    case Cuisine.vietnamese:
      return l.cuisineVietnamese;
    case Cuisine.indian:
      return l.cuisineIndian;
    case Cuisine.italian:
      return l.cuisineItalian;
    case Cuisine.americanWestern:
      return l.cuisineAmericanWestern;
    case Cuisine.mexican:
      return l.cuisineMexican;
    case Cuisine.french:
      return l.cuisineFrench;
    case Cuisine.greek:
      return l.cuisineGreek;
    case Cuisine.spanish:
      return l.cuisineSpanish;
    case Cuisine.malaysian:
      return l.cuisineMalaysian;
    case Cuisine.german:
      return l.cuisineGerman;
    case Cuisine.indonesian:
      return l.cuisineIndonesian;
    case Cuisine.lebanese:
      return l.cuisineLebanese;
    case Cuisine.turkish:
      return l.cuisineTurkish;
    case Cuisine.moroccan:
      return l.cuisineMoroccan;
    case Cuisine.ethiopian:
      return l.cuisineEthiopian;
    case Cuisine.filipino:
      return l.cuisineFilipino;
    case Cuisine.pakistani:
      return l.cuisinePakistani;
    case Cuisine.sriLankan:
      return l.cuisineSriLankan;
    case Cuisine.cambodian:
      return l.cuisineCambodian;
    case Cuisine.brazilian:
      return l.cuisineBrazilian;
    case Cuisine.peruvian:
      return l.cuisinePeruvian;
    case Cuisine.caribbean:
      return l.cuisineCaribbean;
    case Cuisine.taiwanese:
      return l.cuisineTaiwanese;
    case Cuisine.portuguese:
      return l.cuisinePortuguese;
    case Cuisine.british:
      return l.cuisineBritish;
    case Cuisine.mongolian:
      return l.cuisineMongolian;
    case Cuisine.tibetan:
      return l.cuisineTibetan;
    case Cuisine.hongKong:
      return l.cuisineHongKong;
    case Cuisine.macanese:
      return l.cuisineMacanese;
    case Cuisine.sichuan:
      return l.cuisineSichuan;
    case Cuisine.cantonese:
      return l.cuisineCantonese;
    case Cuisine.shanghainese:
      return l.cuisineShanghainese;
    case Cuisine.fujian:
      return l.cuisineFujian;
    case Cuisine.hunan:
      return l.cuisineHunan;
    case Cuisine.yunnan:
      return l.cuisineYunnan;
    case Cuisine.beijing:
      return l.cuisineBeijing;
    case Cuisine.dongbei:
      return l.cuisineDongbei;
    case Cuisine.hakka:
      return l.cuisineHakka;
    case Cuisine.uyghur:
      return l.cuisineUyghur;
    case Cuisine.okinawan:
      return l.cuisineOkinawan;
    case Cuisine.shandong:
      return l.cuisineShandong;
    case Cuisine.guangxi:
      return l.cuisineGuangxi;
    case Cuisine.teochew:
      return l.cuisineTeochew;
    case Cuisine.hainanese:
      return l.cuisineHainanese;
    case Cuisine.jiangsu:
      return l.cuisineJiangsu;
    case Cuisine.zhejiang:
      return l.cuisineZhejiang;
    case Cuisine.anhui:
      return l.cuisineAnhui;
    case Cuisine.jiangxi:
      return l.cuisineJiangxi;
    case Cuisine.guizhou:
      return l.cuisineGuizhou;
    case Cuisine.manchurian:
      return l.cuisineManchurian;
    case Cuisine.shaanxi:
      return l.cuisineShaanxi;
    case Cuisine.shan:
      return l.cuisineShan;
    case Cuisine.rakhine:
      return l.cuisineRakhine;
    case Cuisine.mon:
      return l.cuisineMon;
    case Cuisine.kachin:
      return l.cuisineKachin;
    case Cuisine.kayin:
      return l.cuisineKayin;
    case Cuisine.chin:
      return l.cuisineChin;
    case Cuisine.kayah:
      return l.cuisineKayah;
    case Cuisine.mandalay:
      return l.cuisineMandalay;
    case Cuisine.yangon:
      return l.cuisineYangon;
    case Cuisine.ayeyarwady:
      return l.cuisineAyeyarwady;
    case Cuisine.tanintharyi:
      return l.cuisineTanintharyi;
    case Cuisine.intha:
      return l.cuisineIntha;
    case Cuisine.naga:
      return l.cuisineNaga;
    case Cuisine.paO:
      return l.cuisinePaO;
    case Cuisine.danu:
      return l.cuisineDanu;
    case Cuisine.wa:
      return l.cuisineWa;
    case Cuisine.magway:
      return l.cuisineMagway;
    case Cuisine.bago:
      return l.cuisineBago;
    case Cuisine.sagaing:
      return l.cuisineSagaing;
    case Cuisine.taunggyi:
      return l.cuisineTaunggyi;
  }
}

/// Flag glyph for a cuisine. Used in pills, badges, and the community
/// feed's per-post chip.
String cuisineFlag(Cuisine c) {
  switch (c) {
    case Cuisine.korean:
      return '🇰🇷';
    case Cuisine.japanese:
      return '🇯🇵';
    case Cuisine.chinese:
      return '🇨🇳';
    case Cuisine.burmese:
    case Cuisine.shan:
    case Cuisine.rakhine:
    case Cuisine.mon:
    case Cuisine.kachin:
    case Cuisine.kayin:
    case Cuisine.chin:
    case Cuisine.kayah:
    case Cuisine.mandalay:
    case Cuisine.yangon:
    case Cuisine.ayeyarwady:
    case Cuisine.tanintharyi:
    case Cuisine.intha:
    case Cuisine.naga:
    case Cuisine.paO:
    case Cuisine.danu:
    case Cuisine.wa:
    case Cuisine.magway:
    case Cuisine.bago:
    case Cuisine.sagaing:
    case Cuisine.taunggyi:
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
    case Cuisine.lebanese:
      return '🇱🇧';
    case Cuisine.turkish:
      return '🇹🇷';
    case Cuisine.moroccan:
      return '🇲🇦';
    case Cuisine.ethiopian:
      return '🇪🇹';
    case Cuisine.filipino:
      return '🇵🇭';
    case Cuisine.pakistani:
      return '🇵🇰';
    case Cuisine.sriLankan:
      return '🇱🇰';
    case Cuisine.cambodian:
      return '🇰🇭';
    case Cuisine.brazilian:
      return '🇧🇷';
    case Cuisine.peruvian:
      return '🇵🇪';
    // Caribbean is an umbrella; tropical-island glyph stands in for
    // the cluster (no single national flag covers it).
    case Cuisine.caribbean:
      return '🏝️';
    case Cuisine.taiwanese:
      return '🇹🇼';
    case Cuisine.portuguese:
      return '🇵🇹';
    case Cuisine.british:
      return '🇬🇧';
    case Cuisine.mongolian:
      return '🇲🇳';
    case Cuisine.tibetan:
      return '🏔️';
    case Cuisine.hongKong:
      return '🇭🇰';
    case Cuisine.macanese:
      return '🇲🇴';
    case Cuisine.sichuan:
    case Cuisine.cantonese:
    case Cuisine.shanghainese:
    case Cuisine.fujian:
    case Cuisine.hunan:
    case Cuisine.yunnan:
    case Cuisine.beijing:
    case Cuisine.dongbei:
    case Cuisine.hakka:
    case Cuisine.shandong:
    case Cuisine.guangxi:
    case Cuisine.teochew:
    case Cuisine.hainanese:
    case Cuisine.jiangsu:
    case Cuisine.zhejiang:
    case Cuisine.anhui:
    case Cuisine.jiangxi:
    case Cuisine.guizhou:
    case Cuisine.manchurian:
    case Cuisine.shaanxi:
      return '🇨🇳';
    case Cuisine.uyghur:
      return '🌙';
    case Cuisine.okinawan:
      return '🏝️';
  }
}

String regionLabel(AppL10n l, CuisineRegion r) {
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

/// Fallback label when the API sends a cuisine wire the client enum
/// doesn't know yet (e.g. user on an older build hitting a newer catalog).
String humanizeCuisineWire(String wire) {
  return wire
      .split('_')
      .map(
        (part) => part.isEmpty
            ? part
            : '${part[0].toUpperCase()}${part.substring(1)}',
      )
      .join(' ');
}
