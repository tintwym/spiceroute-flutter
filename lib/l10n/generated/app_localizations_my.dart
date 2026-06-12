// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Burmese (`my`).
class AppL10nMy extends AppL10n {
  AppL10nMy([String locale = 'my']) : super(locale);

  @override
  String get appTitle => 'SpiceRoute';

  @override
  String get navExplore => 'ရှာဖွေပါ';

  @override
  String get navAiCreator => 'ဖန်တီးသူ';

  @override
  String get navAiCompanion => 'လက်ထောက်';

  @override
  String get navSaved => 'သိမ်းထား';

  @override
  String get languageEnglish => 'အင်္ဂလိပ်';

  @override
  String get languageChinese => 'တရုတ်';

  @override
  String get languageBurmese => 'မြန်မာ';

  @override
  String get languageJapanese => 'ဂျပန်';

  @override
  String get languageKorean => 'ကိုရီးယား';

  @override
  String get languageVietnamese => 'ဗီယက်နမ်';

  @override
  String get cuisineAll => 'အားလုံး';

  @override
  String get cuisineKorean => 'ကိုရီးယားအစားအစာ';

  @override
  String get cuisineJapanese => 'ဂျပန်အစားအစာ';

  @override
  String get cuisineChinese => 'တရုတ်အစားအစာ';

  @override
  String get cuisineBurmese => 'မြန်မာအစားအစာ';

  @override
  String get cuisineThai => 'ထိုင်းအစားအစာ';

  @override
  String get cuisineVietnamese => 'ဗီယက်နမ်အစားအစာ';

  @override
  String get cuisineIndian => 'အိန္ဒိယအစားအစာ';

  @override
  String get cuisineItalian => 'အီတလီအစားအစာ';

  @override
  String get cuisineAmericanWestern => 'အမေရိကန် / အနောက်တိုင်း';

  @override
  String get cuisineMexican => 'မက္ကဆီကို';

  @override
  String get cuisineFrench => 'ပြင်သစ်';

  @override
  String get cuisineGreek => 'ဂရိ';

  @override
  String get cuisineSpanish => 'စပိန်';

  @override
  String get cuisineMalaysian => 'မလေးရှား';

  @override
  String get cuisineGerman => 'ဂျာမနီ';

  @override
  String get cuisineIndonesian => 'အင်ဒိုနီးရှား';

  @override
  String get exploreSearchHint =>
      'ချက်ပြုတ်နည်း၊ ပါဝင်ပစ္စည်း သို့မဟုတ် တဂ်များကို ရှာပါ';

  @override
  String get exploreSearchHintLong =>
      'ချက်ပြုတ်နည်း၊ ပါဝင်ပစ္စည်း သို့မဟုတ် အစားအစာအမျိုးအစားများကို ရှာပါ...';

  @override
  String get heroBadge => 'CULINARY STUDIO';

  @override
  String get heroTitle => 'SpiceRoute';

  @override
  String heroSubtitle(int cuisines) {
    return 'ယဉ်ကျေးမှု $cuisines မျိုးကို ဖြတ်ကျော်သော အစားအစာခရီးကို စတင်လိုက်ပါ။ စစ်မှန်သော ချက်ပြုတ်နည်းများကို စစ်ထုတ်ပါ၊ AI ချက်ပြုတ်ဆရာနှင့် စကားပြောပါ၊ သို့မဟုတ် စိတ်ကြိုက် ဘာသာပြန်များ ဖန်တီးပါ။';
  }

  @override
  String brandTagline(int cuisines, int languages) {
    return 'အစားအစာ $cuisines မျိုး · ဘာသာစကား $languages မျိုး';
  }

  @override
  String exploreResultCount(int count, String scope) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$scope တွင် ချက်ပြုတ်နည်း $count ခု ပြသနေသည်',
      one: '$scope တွင် ချက်ပြုတ်နည်း ၁ ခု ပြသနေသည်',
      zero: '$scope တွင် ချက်ပြုတ်နည်း မရှိပါ',
    );
    return '$_temp0';
  }

  @override
  String get communityBadge => 'REAL-TIME SYNC';

  @override
  String get communityTitle => 'ရပ်ရွာ ချက်ပြုတ်ဘုတ်';

  @override
  String get communitySubtitle =>
      'အခြားအစားအသောက်ချစ်သူများ ဘာချက်နေသလဲကြည့်ပါ၊ သို့မဟုတ် မည်သည့်နိုင်ငံတကာအစားအစာအတွက်မဆို သင်ဖန်တီးထားသော အစားအစာများကို တင်ပါ!';

  @override
  String get communityShowcaseTitle => 'သင်၏ ပန်းကန်ကို ပြသပါ';

  @override
  String get communityUploadCta => 'ချက်ပြုတ်ထားသော ပုံကို တင်ရန် နှိပ်ပါ';

  @override
  String get communityUploadHint => 'JPEG / PNG (အလိုအလျောက် ဖိသိမ်းမည်)';

  @override
  String get communityChefLabel => 'ချက်ပြုတ်သူ၏ အမည်';

  @override
  String get communityChefHint => 'ဥပမာ - နွန်နာ ဆိုဖီးယား၊ အလက်စ်';

  @override
  String get communityCaptionLabel => 'ခေါင်းစဉ် / ပုံပြင်';

  @override
  String get communityCaptionHint =>
      'တနင်္ဂနွေညစာအတွက် လုပ်ထားပါတယ်! လတ်ဆတ်တဲ့ ဆေးဖက်ဝင်ပင်များဖြင့် အစားထိုးထားပါတယ်။';

  @override
  String get communityShareBtn => 'တိုက်ရိုက်ဘုတ်တွင် မျှဝေပါ';

  @override
  String communityFeedTitle(int count) {
    return 'တိုက်ရိုက်ဖိဒ် ($count ပုံ)';
  }

  @override
  String get communityEmptyTitle => 'ရပ်ရွာပုံများ မရှိသေးပါ';

  @override
  String get communityEmptySubtitle =>
      'ဤအစားအစာအတွက် သင်ဖန်တီးထားသော ပန်းကန်ပုံကို ပထမဆုံးတင်သူ ဖြစ်လိုက်ပါ!';

  @override
  String get communitySharedToast => 'တိုက်ရိုက်ဘုတ်တွင် မျှဝေပြီးပါပြီ!';

  @override
  String communityByLine(String name) {
    return '$name ၏';
  }

  @override
  String get communityRemovePhoto => 'ပုံကို ဖျက်ပါ';

  @override
  String get communityUploading => 'ချုံ့ပြီး မျှဝေနေသည်…';

  @override
  String get communityUploaded =>
      'အသိုင်းအဝိုင်းသို့ အောင်မြင်စွာ တင်ပြီးပါပြီ';

  @override
  String communityFilteredTo(String cuisine) {
    return 'စစ်ထုတ်ထား: $cuisine';
  }

  @override
  String storiesHeading(String cuisine) {
    return '$cuisine အစားအသောက် အမွေအနှစ်နှင့် ဆက်နွယ်မှု';
  }

  @override
  String get storiesSubtitle =>
      'ရိုးရာ စားသုံးပုံစံများနှင့် သမိုင်းကြောင်းကို လေ့လာပါ — ဟင်းလျာအမျိုးအစားအလိုက် စစ်ထုတ်ရန် ကတ်ကို နှိပ်ပါ။';

  @override
  String get storiesActiveBadge => 'ACTIVE';

  @override
  String get footerBlurb =>
      'ထူးခြားသော ချက်ပြုတ်အစဉ်အလာများမှ ရွေးချယ်ထားသော ချက်ပြုတ်နည်းများကို ပေးအပ်သည့် ဂုဏ်ယူဖွယ်ကောင်းသော ချက်ပြုတ်တံခါး။ နိုင်ငံတကာ အရသာများနှင့် တိုက်ရိုက် AI အကူအညီဖြင့် သင်၏အိမ်တွင်း ချက်ပြုတ်မှုကို မြှင့်တင်ပါ။';

  @override
  String get footerQuickNav => 'လမ်းညွှန် အမြန်';

  @override
  String get footerLinkExplore => 'ချက်ပြုတ်နည်းများ ရှာဖွေပါ';

  @override
  String get footerLinkCreator => 'AI ချက်ပြုတ်နည်း ဖန်တီးသူ';

  @override
  String get footerLinkCompanion => 'AI ချက်ပြုတ်ဆရာ လက်ထောက်';

  @override
  String get footerLinkSaved => 'ကျွန်ုပ်၏ သိမ်းထားသော ချက်ပြုတ်စာအုပ်';

  @override
  String get footerConnect => 'ကျွန်ုပ်တို့နှင့် ဆက်သွယ်ပါ';

  @override
  String get footerEmailHint => 'သင်၏ အီးမေးလ်';

  @override
  String get footerJoin => 'ပါဝင်ပါ';

  @override
  String get footerJoinedToast => 'ပါဝင်ပေးတဲ့အတွက် ကျေးဇူးတင်ပါတယ်!';

  @override
  String footerCopyright(int year, String brand) {
    return '© $year $brand. မူပိုင်ခွင့်အားလုံး ကြိုတင်ထားသည်။';
  }

  @override
  String get footerLicense => 'MIT လိုင်စင်အောက်တွင် ထုတ်ပြန်ထားသည်။';

  @override
  String get exploreEmptyTitle => 'ကိုက်ညီသော ချက်ပြုတ်နည်း မရှိသေးပါ';

  @override
  String get exploreEmptySubtitle =>
      'မတူသော အစားအစာအမျိုးအစား စမ်းသုံးပါ သို့မဟုတ် ရှာဖွေမှုကို ရှင်းပစ်ပါ။';

  @override
  String get exploreErrorTitle => 'ချက်ပြုတ်နည်းများ ဖွင့်၍ မရပါ';

  @override
  String get exploreErrorRetry => 'ပြန်ကြိုးစားပါ';

  @override
  String get filterCuisineLabel => 'အစားအစာ ရွေးပါ';

  @override
  String get filterCourseLabel => 'မီနူး ရွေးပါ';

  @override
  String get filterDietaryLabel =>
      'အစားအသောက်၊ ဘဝနေထိုင်မှု နှင့် ပုံစံ ကန့်သတ်ချက်များ';

  @override
  String get filterAllCuisines => 'အစားအစာအားလုံး';

  @override
  String get filterAllCourses => 'မီနူးအားလုံး';

  @override
  String get filterAllDietary => 'တောင်းဆိုမှုအားလုံး';

  @override
  String get exploreByRegion => 'ဒေသအလိုက် ရှာဖွေပါ';

  @override
  String get selectCuisineTradition => 'ဟင်းအတိုင်အရှည် ရွေးပါ';

  @override
  String get regionEastAsia => 'အရှေ့အာရှ နိုင်ငံများ';

  @override
  String get regionMainlandSoutheastAsia => 'အရှေ့တောင်အာရှ ကုန်းတွင်း';

  @override
  String get regionMaritimeSoutheastAsia => 'အရှေ့တောင်အာရှ ပင်လယ်ပြင်';

  @override
  String get regionSouthAsia => 'တောင်အာရှ';

  @override
  String get regionEurope => 'ဥရောပ';

  @override
  String get regionAmericas => 'အမေရိကတိုက်';

  @override
  String get regionMiddleEastAfrica => 'အရှေ့အလယ်ပိုင်း နှင့် အာဖရိက';

  @override
  String get courseGroupEarlyDay => 'မနက်စောစော';

  @override
  String get courseGroupDaytimeCasual => 'နေ့လည် / ပေါ့ပါးသော အစားအစာ';

  @override
  String get courseGroupBeforeMain => 'ပင်မဟင်းမတိုင်မီ';

  @override
  String get courseGroupMainEvent => 'ပင်မဟင်း';

  @override
  String get courseGroupSweetEnding => 'အချိုဖြင့် နိဂုံး';

  @override
  String get courseGroupAfterHours => 'ည အချိန်';

  @override
  String get courseGroupLiquids => 'သောက်စရာများ';

  @override
  String get courseBreakfast => 'မနက်စာ နှင့် နံနက်စာ';

  @override
  String get courseHighTea => 'မွန်းလွဲ လက်ဖက်ရည် နှင့် High Tea';

  @override
  String get courseLunch => 'နေ့လည်စာ နှင့် ထမင်းဘူး';

  @override
  String get courseSoupsSaladsBowls => 'ဟင်းရည်၊ ဟင်းချို နှင့် အသုပ်';

  @override
  String get courseAppetizer =>
      'ဟင်းပွဲ၊ နှုတ်ဆက်ပွဲ နှင့် လက်ဖြင့်စားသော အစားအစာများ';

  @override
  String get courseSharingBoards =>
      'မျှဝေဖို့ ပန်းကန်များ၊ ဘုတ်များ နှင့် Charcuterie';

  @override
  String get courseMainCourse => 'ပရိုတင်းမြင့် ပင်မဟင်းများ';

  @override
  String get courseSideDish => 'ဟင်းခွဲများ';

  @override
  String get courseDessert => 'အချိုပွဲ နှင့် အချို';

  @override
  String get courseSnack => 'သရေစာ နှင့် ညညဥ့်စာ';

  @override
  String get courseAlcoholicDrinks => 'အရက်ပါသော သောက်စရာ နှင့် ကော့ထယ်';

  @override
  String get courseZeroProofDrinks => 'အရက်မပါသော သောက်စရာများ';

  @override
  String get dietaryVegan => 'ဗီဂန်';

  @override
  String get dietaryVegetarian => 'သက်သတ်လွတ်';

  @override
  String get dietaryMealPrep => 'ကြိုပြင်ဆင်ထား';

  @override
  String get dietaryQuickEasy => 'လွယ်ကူ နှင့် မြန်ဆန်';

  @override
  String get dietaryPastaSoup => 'ပါစတာ နှင့် ဟင်းချို';

  @override
  String get dietaryBloodSugarBalanced => 'သွေးတွင်းသကြားဓာတ် မျှတမှု';

  @override
  String get dietarySwicy => '\"Swicy\" (ချို နှင့် စပ်)';

  @override
  String get dietaryAntiInflammatory => 'ရောင်ရမ်းမှု ဆန့်ကျင် နှင့် အသက်ရှည်';

  @override
  String get dietaryGroupRestrictions => 'အစားအသောက် ကန့်သတ်ချက်များ';

  @override
  String get dietaryGroupWellness => 'ကျန်းမာရေး နှင့် ဘဝနေထိုင်မှု';

  @override
  String get dietaryGroupCookingFormats => 'ချက်ပြုတ်ပုံ စတိုင်';

  @override
  String get filterSearchCourses =>
      'ဟင်းပွဲများ ရှာဖွေပါ (ဥပမာ အချို၊ ပင်မဟင်း…)';

  @override
  String get filterSearchDietary =>
      'အစားအသောက် ရှာဖွေပါ (ဥပမာ Gluten-Free, Vegan…)';

  @override
  String filterChoicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ခု',
      one: '1 ခု',
    );
    return '$_temp0';
  }

  @override
  String get filterExpandAll => 'အားလုံး ဖွင့်ပါ';

  @override
  String get filterCollapseAll => 'အားလုံး ပိတ်ပါ';

  @override
  String get filterNoMatches => 'ကိုက်ညီသည် မရှိ';

  @override
  String get filterClearSearch => 'ရှာဖွေမှု ဖျက်ပါ';

  @override
  String get filterDismissMenu => 'မီနူး ပိတ်ပါ';

  @override
  String recipeMinutesShort(int minutes) {
    return '$minutes မိနစ်';
  }

  @override
  String recipeHoursShort(int hours) {
    return '$hours နာရီ';
  }

  @override
  String recipeHoursMinutesShort(int hours, int minutes) {
    return '$hours နာရီ $minutes မိနစ်';
  }

  @override
  String recipeServings(int count) {
    return '$count ပန်းကန်';
  }

  @override
  String recipeKcal(int kcal) {
    return '$kcal kcal';
  }

  @override
  String get recipePremiumBadge => 'ရွေးချယ်ထား';

  @override
  String get recipeAiBadge => 'AI ဖန်တီး';

  @override
  String get recipeSpiceLevel0 => 'မစပ်';

  @override
  String get recipeSpiceLevel1 => 'အနည်းငယ်စပ်';

  @override
  String get recipeSpiceLevel2 => 'စပ်';

  @override
  String get recipeSpiceLevel3 => 'အလွန်စပ်';

  @override
  String get detailIngredients => 'ပါဝင်ပစ္စည်းများ';

  @override
  String get detailCookingInstructions => 'ချက်ပြုတ်နည်း';

  @override
  String get detailPrepTime => 'ပြင်ဆင်ချိန်';

  @override
  String get detailCookTime => 'ချက်ပြုတ်ချိန်';

  @override
  String get detailServingsShort => 'လူဦးရေ';

  @override
  String get detailDifficultyEasy => 'လွယ်';

  @override
  String get detailDifficultyMedium => 'အလယ်အလတ်';

  @override
  String get detailDifficultyHard => 'ခက်';

  @override
  String get detailClose => 'ပိတ်';

  @override
  String get detailSteps => 'အဆင့်များ';

  @override
  String detailStepNumber(int number) {
    return 'အဆင့် $number';
  }

  @override
  String get detailNoDescription => 'ဖော်ပြချက် မရှိပါ။';

  @override
  String get detailSave => 'သိမ်း';

  @override
  String get detailSaved => 'သိမ်းပြီး';

  @override
  String get detailUnsave => 'သိမ်းမှု ဖျက်';

  @override
  String get detailShare => 'မျှဝေ';

  @override
  String get detailBack => 'ပြန်';

  @override
  String get savedTitle => 'ကျွန်ုပ်၏ သိမ်းထားသော ချက်ပြုတ်နည်းများ';

  @override
  String get savedHeroSubtitle =>
      'သင်၏ ပုဂ္ဂိုလ်ရေး ချက်ပြုတ်စာအုပ်။ မည်သည့်အစားအစာအမျိုးအစားမှမဆို သင်ကြိုက်နှစ်သက်သော အစားအစာများကို ဘွတ်ခ်မှတ်ထားနိုင်ပြီး ၎င်းတို့သည် ဤနေရာတွင် ပေါ်ပါမည်။';

  @override
  String savedCountHeading(int count) {
    return 'ကျွန်ုပ်၏ သိမ်းထားသော ချက်ပြုတ်နည်းများ ($count)';
  }

  @override
  String get savedEmptyTitle => 'မည်သည့်အရာမှ မသိမ်းရသေးပါ';

  @override
  String get savedEmptySubtitle =>
      'သင်သည် ချက်ပြုတ်နည်းတစ်ခုကိုမှ မသိမ်းရသေးပါ။ မည်သည့်ချက်ပြုတ်နည်းကတ်ပေါ်ရှိ ဘွတ်ခ်မှတ်ပုံကို နှိပ်၍ သင်၏ပုဂ္ဂိုလ်ရေး ချက်ပြုတ်စာအုပ်ကို စတင်တည်ဆောက်ပါ!';

  @override
  String get savedEmptyCta => 'ချက်ပြုတ်နည်းများ ရှာဖွေပါ';

  @override
  String get savedCloudSyncedBadge => 'Cloud Sync';

  @override
  String get savedClearAll => 'အားလုံး ရှင်း';

  @override
  String get savedClearConfirm =>
      'သိမ်းထားသော ချက်ပြုတ်နည်းအားလုံးကို ရှင်းမည်လား?';

  @override
  String get savedClearConfirmYes => 'ရှင်း';

  @override
  String get savedClearConfirmNo => 'ပယ်ဖျက်';

  @override
  String get aiCreatorTitle => 'AI ချက်ပြုတ်နည်း ဖန်တီးသူ';

  @override
  String get aiCreatorCardTitle => 'စိတ်ကြိုက် AI ချက်ပြုတ်နည်း ဖန်တီးပါ';

  @override
  String get aiCreatorCardSubtitle =>
      'သင့်တွင်ရှိသော ပါဝင်ပစ္စည်းများ သို့မဟုတ် စားချင်သောအရာများကို ထည့်လိုက်ပါ၊ AI ချက်ပြုတ်ဆရာသည် သင်ကြိုက်နှစ်သက်ရာ ဘာသာစကားဖြင့် အဆင့်ဆင့်ပြထားသော စိတ်ကြိုက် ချက်ပြုတ်နည်းကို ချက်ချင်း ဖန်တီးပေးပါမည်။';

  @override
  String get aiCreatorIngredientsLabel => 'ပါဝင်ပစ္စည်း / အစားအစာ စိတ်ကူး';

  @override
  String get aiCreatorIdeaHintLong =>
      'ဥပမာ - ခရမ်းချဉ်သီး၊ ဥ၊ ကြက်သွန်မြိတ် သို့မဟုတ် \'ပေါ့ပါးကျန်းမာသော တို့ဟူး ညစာ\'';

  @override
  String get aiCreatorCreateBtn => 'ဖန်တီး';

  @override
  String get aiCreatorIdeaLabel => 'ဘာချက်ချင်ပါသလဲ?';

  @override
  String get aiCreatorIdeaHint => 'ဥပမာ - ကျန်ဝိုင်ဖြင့် နွေးထွေးသော မှိုပါစတာ';

  @override
  String get aiCreatorCuisineLabel => 'အစားအစာအမျိုးအစား';

  @override
  String get aiCreatorCuisineAuto => 'AI ကို ရွေးခိုင်းပါ';

  @override
  String get aiCreatorLanguageLabel => 'ချက်ပြုတ်နည်း ဘာသာစကား';

  @override
  String get aiCreatorGenerate => 'ချက်ပြုတ်နည်း ဖန်တီး';

  @override
  String get aiCreatorRegenerate => 'ပြန်စမ်းကြည့်';

  @override
  String get aiCreatorSaveBtn => 'ကျွန်ုပ်၏ ချက်ပြုတ်နည်းများထဲ သိမ်း';

  @override
  String get aiCreatorSavedToast =>
      'သိမ်းပြီးပါပြီ! \'သိမ်းထား\' တွင် ပြန်ရှာနိုင်ပါသည်။';

  @override
  String get aiCreatorErrorTitle => 'ထို ချက်ပြုတ်နည်းကို ဖန်တီး၍ မရပါ';

  @override
  String get aiCreatorRateLimited =>
      'ယနေ့ အခမဲ့ ဖန်တီးနိုင်သော ကန့်သတ်ချက်သို့ ရောက်ပြီပါပြီ။ မနက်ဖြန် ပြန်စမ်းပါ။';

  @override
  String get aiCreatorQuote1 =>
      'ဓါးများ ထက်အောင်ပြုလုပ်၍ ကြက်သွန်ပင် ဖြတ်နေသည်…';

  @override
  String get aiCreatorQuote2 =>
      'မွှေးထောင်ပြောင်လဲမှု အောက်တွင် ဆေးသွားများ ဖုတ်နေသည်…';

  @override
  String get aiCreatorQuote3 =>
      'မူရင်း စာလုပ်ရည် ကို ပြုတ်ပြီး အရသာ စစ်ဆေးနေသည်…';

  @override
  String get aiCreatorQuote4 =>
      'သင်၏ အရသာအတွက် အရည်အသွေးမြင့်သော အရာများ ရွေးချယ်နေသည်…';

  @override
  String get aiCreatorQuote5 =>
      'ပြီးပြည့်စုံစွာ ပြုလုပ်ရန် တစ်ဆင့်စီ ညွှန်ကြားချက် တည်ဆောက်နေသည်…';

  @override
  String get aiCompanionTitle => 'AI မီးဖိုချောင် လက်ထောက်';

  @override
  String get aiCompanionActiveFocus => 'လက်ရှိ အာရုံစိုက်မှု: ကမ္ဘာလုံးဆိုင်ရာ';

  @override
  String get aiCompanionGreeting =>
      'မင်္ဂလာပါ! ကျွန်တော်က ကမ္ဘာလုံးဆိုင်ရာ အစားအသောက် AI ချက်ပြုတ်ဆရာ ဖြစ်ပါတယ်။ ပါဝင်ပစ္စည်း အစားထိုးခြင်း၊ ချက်ပြုတ်နည်း လှည့်ကွက်များ သို့မဟုတ် လုံးဝအသစ်သော စိတ်ကြိုက် ချက်ပြုတ်နည်း တောင်းခြင်း ဘာမဆို မေးနိုင်ပါတယ်!';

  @override
  String get aiCompanionSuggestionsLabel => 'အရသာရှိ အကြံပြုချက်များ';

  @override
  String get aiCompanionEmptyTitle => 'ချက်ပြုတ်ခြင်းအကြောင်း ဘာမဆို မေးပါ';

  @override
  String get aiCompanionEmptySubtitle =>
      'အစားထိုးမှု၊ နည်းပညာ၊ အစားအသောက် လဲလှယ်မှု - ကျွန်တော် ဖြေပေးနိုင်ပါတယ်။';

  @override
  String get aiCompanionInputHint =>
      'AI ကို အစားအစာချက်ပြုတ်နည်း မေးပါ၊ keto/ဗီဂန် ရွေးချယ်စရာများ တောင်းပါ...';

  @override
  String get aiCompanionSend => 'ပို့';

  @override
  String get aiCompanionStop => 'ရပ်';

  @override
  String get aiCompanionClear => 'ရှင်း';

  @override
  String get aiCompanionTyping => 'စဉ်းစားနေသည်...';

  @override
  String get aiCompanionRateLimited =>
      'ဤနာရီအတွင်း မက်ဆေ့ချ်များ များလွန်းနေပါသည်။ နောက်မှ ပြန်ကြိုးစားပါ။';

  @override
  String aiCompanionActiveFocusCuisine(String cuisine) {
    return 'လက်ရှိ အာရုံ: $cuisine';
  }

  @override
  String get aiCompanionSuggestion1 =>
      'ငါးငံပြာရည်အတွက် သက်သတ်လွတ် အစားထိုးကောင်းကောင်းက ဘာလဲ?';

  @override
  String get aiCompanionSuggestion2 =>
      'ကိုရီးယား ကင်ချီဂျိုဂို အတွက် စစ်မှန်တဲ့ ဟင်းခွဲတစ်ခု အကြံပြုပါ။';

  @override
  String get aiCompanionSuggestion3 =>
      'Szechuan ငရုတ်ကောင်း ထုံကျင်စေတဲ့ အကျိုးကို ရှင်းပြနိုင်လား?';

  @override
  String get aiCompanionSuggestion4 =>
      'မြန်မာ မုန့်ဟင်းခါးထဲက အစပ်အပိုင်းကို ဘယ်လို ထိန်းနိုင်မလဲ?';

  @override
  String get settingsTitle => 'ဆက်တင်များ';

  @override
  String get settingsAppearance => 'အသွင်အပြင်';

  @override
  String get settingsTheme => 'အပြင်အဆင်';

  @override
  String get settingsThemeSystem => 'စနစ်အလိုက်';

  @override
  String get settingsThemeLight => 'အလင်း';

  @override
  String get settingsThemeDark => 'အမှောင်';

  @override
  String get settingsLanguage => 'ဘာသာစကား';

  @override
  String get settingsAccount => 'အကောင့်';

  @override
  String settingsAccountSignedInAs(String name) {
    return '$name အဖြစ် ဝင်ထားသည်';
  }

  @override
  String get settingsAccountGuest => 'ဝင်ထားခြင်း မရှိပါ';

  @override
  String get settingsAbout => 'SpiceRoute အကြောင်း';

  @override
  String get settingsAboutBody =>
      'SpiceRoute သည် ကမ္ဘာ့အစားအစာများကို တည်ငြိမ်လှပသော စာကြည့်တိုက်တစ်ခုထဲ စုစည်းပေးပြီး၊ သင်၏မီးဖိုချောင်အတွက် ပြန်လည်ဖန်တီးနိုင်သော AI ကိရိယာများကို ပေးပါသည်။';

  @override
  String settingsVersion(String version) {
    return 'ဗားရှင်း $version';
  }

  @override
  String get settingsClose => 'ပိတ်';

  @override
  String get navSettings => 'ဆက်တင်များ';

  @override
  String get commonClose => 'ပိတ်';

  @override
  String get commonCancel => 'ပယ်ဖျက်';

  @override
  String get commonRetry => 'ပြန်ကြိုးစား';

  @override
  String get commonError => 'တစ်စုံတစ်ရာ မှားယွင်းသွားသည်';

  @override
  String get errorNetwork =>
      'ဆာဗာသို့ ဆက်သွယ်၍ မရပါ။ သင်၏ အင်တာနက်ချိတ်ဆက်မှုကို စစ်ဆေး၍ ထပ်မံကြိုးစားပါ။';

  @override
  String get commonLoading => 'ဖွင့်နေသည်...';

  @override
  String get commonNotFound => 'ရှာမတွေ့ပါ';

  @override
  String get commonOk => 'OK';

  @override
  String get commonDelete => 'ဖျက်';

  @override
  String get commonHome => 'ပင်မစာမျက်နှာသို့ ပြန်';

  @override
  String get authSignIn => 'ဝင်ရောက်';

  @override
  String get authSignOut => 'ထွက်';

  @override
  String get authRegister => 'အကောင့်ဖန်တီး';

  @override
  String get authAccount => 'အကောင့်';

  @override
  String get authEmail => 'အီးမေးလ်';

  @override
  String get authPassword => 'စကားဝှက်';

  @override
  String get authDisplayName => 'ပြသမည့်အမည်';

  @override
  String get authContinueWithGoogle => 'Google ဖြင့် ဆက်လုပ်';

  @override
  String get authOrDivider => 'သို့မဟုတ်';

  @override
  String get authForgotPassword => 'စကားဝှက် မေ့သွားသလား?';

  @override
  String get authResetSent =>
      'ထို အီးမေးလ်ကို မှတ်ပုံတင်ထားပါက ပြန်လည်သတ်မှတ်ရန် လင့်ခ်ကို ပို့ထားပါသည်။';

  @override
  String get authNoAccountYet => 'အကောင့်မရှိသေးဘူးလား?';

  @override
  String get authHasAccount => 'အကောင့်ရှိပြီးသား ဖြစ်နေပါသလား?';

  @override
  String get authSignUpHere => 'ဖန်တီးပါ';

  @override
  String get authSignInHere => 'ဝင်ရောက်ပါ';

  @override
  String get authProtectedTitle => 'ဝင်ရောက်မှု လိုအပ်သည်';

  @override
  String get authProtectedBody =>
      'သင်၏ ချက်ပြုတ်နည်းကို ထုတ်ဖော်ရန် ဝင်ရောက်ပါ။ သင်၏ နာမည်ဖြင့် ဆက်လက်ဖော်ပြထားမည်ဖြစ်ပြီး နောက်ပိုင်းတွင် တည်းဖြတ်ဖျက်ပစ်နိုင်ပါသည်။';

  @override
  String get authNotConfigured =>
      'ဝင်ရောက်မှု မပြင်ဆင်ရသေးပါ။ ဖွင့်ရန် Firebase ပြင်ဆင်ချက်ကို ထည့်ပါ။';

  @override
  String get authDevModeBanner =>
      'Dev mode - Firebase မပြင်ဆင်ရသေးပါ။ မည်သည့် အီးမေးလ်နှင့် စကားဝှက်မဆို ဤစက်ပစ္စည်းပေါ်တွင် စမ်းသပ်အကောင့်တစ်ခု ဖန်တီးပါမည်။';

  @override
  String get authWelcomeTitle => 'ပြန်လည်ကြိုဆိုပါသည်';

  @override
  String get authWelcomeSubtitle =>
      'သင်၏ စိတ်ကြိုက်ချက်ပြုတ်နည်းများနှင့် ချက်ပြုတ်မှတ်တမ်းများကို ပြန်ရယူရန် ဝင်ရောက်ပါ';

  @override
  String get authRegisterTitle => 'ချက်ပြုတ်ရေး အကောင့်ဖန်တီး';

  @override
  String get authRegisterSubtitle =>
      'သင်၏ စိတ်ကြိုက်ချက်ပြုတ်နည်းများကို တစ်ပြိုင်တည်း ထိန်းသိမ်းရန် ပါဝင်ပါ';

  @override
  String get authNameLabel => 'သင်၏ ချက်ပြုတ်ရေး အမည်';

  @override
  String get authNameHint => 'ဥပမာ - ချက်ပြုတ်ဆရာ Oliver';

  @override
  String get authEmailHint => 'chef@example.com';

  @override
  String get authPrimarySignIn => 'Studio သို့';

  @override
  String get authPrimaryRegister => 'အကောင့်ဖန်တီး';

  @override
  String get authErrorInvalid => 'အီးမေးလ် သို့မဟုတ် စကားဝှက် မှားနေပါသည်။';

  @override
  String get authErrorEmailInUse =>
      'ထို အီးမေးလ်ကို မှတ်ပုံတင်ပြီးသား ဖြစ်နေပါသည်။';

  @override
  String get authErrorWeakPassword =>
      'ပိုခိုင်မာသော စကားဝှက်ကို ရွေးပါ (အနည်းဆုံး ၆ လုံး)။';

  @override
  String get authErrorNetwork => 'ကွန်ရက် အမှား။ ပြန်ကြိုးစားပါ။';

  @override
  String get authErrorGeneric =>
      'ဝင်ရောက်မှုတွင် တစ်စုံတစ်ရာ မှားယွင်းသွားသည်။';

  @override
  String get authErrorProviderDisabled =>
      'ဤဝင်ရောက်မှုနည်းလမ်းကို အက်ပ်တွင် မဖွင့်ထားသေးပါ။ စီမံခန့်ခွဲသူသည် Firebase Console → Authentication → Sign-in method တွင် ဖွင့်ပေးပါ။';

  @override
  String get authErrorUnauthorizedDomain =>
      'ဤဒိုမိန်းသည် Google ဝင်ရောက်ရန် ခွင့်ပြုထားခြင်း မရှိပါ။ Firebase Console → Authentication → Settings → Authorized domains တွင် ထည့်ပါ။';

  @override
  String get authErrorPopupBlocked =>
      'သင်၏ဘရောက်ဇာသည် ဝင်ရောက်ရန် ပေါ်လာသော ဝင်းဒိုးကို ပိတ်ဆို့ထားသည်။ ဤဆိုက်အတွက် ပေါ်လာသော ဝင်းဒိုးများကို ခွင့်ပြုပြီး ထပ်စမ်းကြည့်ပါ။';

  @override
  String get authErrorAccountExists =>
      'ဤအီးမေးလ်ဖြင့် အကောင့်ကို အခြားနည်းလမ်းတစ်ခုဖြင့် မှတ်ပုံတင်ထားပြီးဖြစ်သည်။ အီးမေးလ်နှင့် စကားဝှက်ဖြင့် ဝင်ရောက်ပါ။';

  @override
  String get authSuccessSignIn =>
      'အောင်မြင်စွာ ဝင်ရောက်ပြီးပါပြီ။ ပျော်ရွှင်စွာ ချက်ပြုတ်ပါ!';

  @override
  String get authSuccessRegister =>
      'အကောင့်ကို အောင်မြင်စွာ ဖန်တီးပြီးပါပြီ။ ကြိုဆိုပါသည်!';

  @override
  String get authSuccessGoogle =>
      'Google ဖြင့် အောင်မြင်စွာ ဝင်ရောက်ပြီးပါပြီ!';

  @override
  String get recipeOwnerYou => 'သင်က';

  @override
  String recipeOwnerBy(String name) {
    return '$name က';
  }

  @override
  String get myRecipesTitle => 'ကျွန်ုပ်၏ ချက်ပြုတ်နည်းများ';

  @override
  String get myRecipesEmptyTitle => 'ဤနေရာတွင် ဘာမှ မရှိသေးပါ';

  @override
  String get myRecipesEmptySubtitle =>
      'သင်ထုတ်ဖော်သော သို့မဟုတ် AI Creator ဖြင့် သိမ်းသော ချက်ပြုတ်နည်းများ ဤနေရာတွင် ပေါ်ပါမည်။';

  @override
  String get navMyRecipes => 'ကျွန်ုပ်၏';

  @override
  String get detailEdit => 'တည်းဖြတ်';

  @override
  String get detailDelete => 'ဖျက်';

  @override
  String get detailDeleteConfirm =>
      'ဤချက်ပြုတ်နည်းကို ဖျက်မှာ သေချာလား? ပြန်ပြောင်း၍ မရတော့ပါ။';

  @override
  String get detailDeleteOk => 'ဖျက်';

  @override
  String get detailDeletedToast => 'ချက်ပြုတ်နည်း ဖျက်ပြီးပါပြီ။';

  @override
  String get detailStartCooking => 'ချက်ပြုတ်ရန် စတင်ပါ';

  @override
  String get cookExit => 'ချက်ပြုတ်မှု ထွက်ရန်';

  @override
  String cookStepOf(int current, int total) {
    return 'အဆင့် $current / $total';
  }

  @override
  String get cookPrev => 'နောက်သို့';

  @override
  String get cookNext => 'ရှေ့သို့';

  @override
  String get cookFinish => 'ချက်ပြုတ်မှု ပြီးပြီ';

  @override
  String get cookFinishShort => 'ပြီးပြီ';

  @override
  String get cookStepDone => 'ပြီးပြီဟု မှတ်ပါ';

  @override
  String get cookStepUndo => 'မပြီးသေးပါ';

  @override
  String get cookIngredients => 'ပါဝင်ပစ္စည်းများ';

  @override
  String cookIngredientsCount(int count) {
    return 'ပါဝင်ပစ္စည်းများ ($count)';
  }

  @override
  String cookServingsLabel(int count) {
    return '$count ပန်းကန်';
  }

  @override
  String get cookServingsIncrease => 'ပမာဏ တိုးပါ';

  @override
  String get cookServingsDecrease => 'ပမာဏ လျှော့ပါ';

  @override
  String get cookUnitsOriginal => 'မူရင်း';

  @override
  String get cookUnitsMetric => 'မက်ထရစ်';

  @override
  String get cookUnitsImperial => 'အင်ပါယာ';

  @override
  String get cookFinishedTitle => 'အားလုံး ပြီးပါပြီ!';

  @override
  String get cookFinishedBody => 'အဆင့်အားလုံး ပြီးပါပြီ။ စားသုံးနိုင်ပါပြီ!';

  @override
  String get cookFinishedStay => 'ချက်ပြုတ်နည်း ဆက်ဖွင့်ပါ';

  @override
  String get cookFinishedExit => 'ချက်ပြုတ်မှု ထွက်ရန်';

  @override
  String get cookNoStepsTitle => 'အဆင့်များ မရှိသေးပါ';

  @override
  String get cookNoStepsBody =>
      'ဤချက်ပြုတ်နည်းတွင် အဆင့်ဆင့် ညွှန်ကြားချက်များ မရှိသေးပါ။';

  @override
  String get cookBackToRecipe => 'ချက်ပြုတ်နည်းသို့ ပြန်ပါ';

  @override
  String get reviewsTitle => 'အသိုက်အဝန်း ပုံတင်နှင့် သုံးသပ်ချက်များ';

  @override
  String get reviewsSubtitle =>
      'အခြား စားဖိုမှူးများ ချက်ထားသည်များကို ကြည့်ပါ၊ သို့မဟုတ် သင်ကိုယ်တိုင် ချက်ထားသော ပုံကို တင်ပါ!';

  @override
  String get reviewsAverage => 'ပျမ်းမျှ အဆင့်';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'သုံးသပ်ချက် $count ခု',
      one: 'သုံးသပ်ချက် 1 ခု',
      zero: 'သုံးသပ်ချက် မရှိသေးပါ',
    );
    return '$_temp0';
  }

  @override
  String reviewsUploadedCooks(int count) {
    return 'တင်ထားသော ပုံ: $count';
  }

  @override
  String get reviewsEmptyState =>
      'အသိုက်အဝန်းမှ ပုံများ မရှိသေးပါ။ ပထမဦးဆုံး ချက်၍ သုံးသပ်ပါ!';

  @override
  String get reviewsLoginPrompt =>
      'သင်၏ ချက်ပြုတ်မှုကို ဝေမျှရန် ကျေးဇူးပြု၍ ဝင်ရောက်ပါ။';

  @override
  String get reviewsLoginCta => 'ဝင်ရောက်ပြီး သုံးသပ်ပါ';

  @override
  String get reviewsFormTitle => 'သင်၏ ချက်ပြုတ်မှု အောင်မြင်ခြင်းကို ဝေမျှပါ';

  @override
  String get reviewsRatingLabel => 'အဆင့်';

  @override
  String get reviewsAuthorLabel => 'စားဖိုမှူး အမည်';

  @override
  String get reviewsAuthorHint => 'သင်၏ အမည်ပြောင်ကို ထည့်ပါ…';

  @override
  String get reviewsCommentLabel => 'ချက်ပြုတ်ခန်း မှတ်စု';

  @override
  String get reviewsCommentHint => 'ဘယ်လို အရသာရှိသလဲ? အကြံပြုချက် ရှိပါသလား?';

  @override
  String get reviewsPhotoHint => 'ချက်ပြုတ်ပြီးသော ပုံ ပူးတွဲရန် တို့ပါ';

  @override
  String get reviewsPublishBtn => 'အသိုက်အဝန်းသို့ တင်မည်';

  @override
  String get reviewsPublishing => 'တင်နေသည်…';

  @override
  String get reviewsSubmitted => 'ဂယ်လာရီသို့ အောင်မြင်စွာ ထည့်ပြီးပါပြီ!';

  @override
  String get reviewsPostAnother => 'နောက်တစ်ခု ထပ်တင်မည်';

  @override
  String get reviewsPhotoTooLarge =>
      'ပုံ ကြီးလွန်းသည်၊ ပိုသေးသော ပုံကို ရွေးပါ။';

  @override
  String get reviewsErrorGeneric => 'သုံးသပ်ချက် မတင်နိုင်ပါ၊ ပြန်ကြိုးစားပါ။';

  @override
  String get reviewsDeleteTooltip => 'သုံးသပ်ချက် ဖျက်';

  @override
  String get reviewsDeleteConfirm => 'သင်၏ သုံးသပ်ချက်ကို ဖျက်မှာလား?';

  @override
  String get reviewsAnonymousChef => 'အိမ်စားဖိုမှူး';

  @override
  String get reviewsLightboxCloseTooltip => 'ပုံ ပိတ်ပါ';
}
