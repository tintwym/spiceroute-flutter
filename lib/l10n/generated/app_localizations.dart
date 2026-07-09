import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SpiceRoute'**
  String get appTitle;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navAiCreator.
  ///
  /// In en, this message translates to:
  /// **'Creator'**
  String get navAiCreator;

  /// No description provided for @navAiCompanion.
  ///
  /// In en, this message translates to:
  /// **'Companion'**
  String get navAiCompanion;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get navSaved;

  /// No description provided for @navMe.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get navMe;

  /// No description provided for @createSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createSheetTitle;

  /// No description provided for @createSheetAiTitle.
  ///
  /// In en, this message translates to:
  /// **'Generate with AI'**
  String get createSheetAiTitle;

  /// No description provided for @createSheetAiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build a heritage recipe with AI Creator'**
  String get createSheetAiSubtitle;

  /// No description provided for @createSheetMyRecipesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Recipes'**
  String get createSheetMyRecipesTitle;

  /// No description provided for @createSheetMyRecipesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recipes you\'ve published or saved'**
  String get createSheetMyRecipesSubtitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get profileTitle;

  /// No description provided for @profileWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SpiceRoute'**
  String get profileWelcome;

  /// No description provided for @profileWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to save recipes and publish your own.'**
  String get profileWelcomeSubtitle;

  /// No description provided for @profileYourKitchen.
  ///
  /// In en, this message translates to:
  /// **'Your kitchen'**
  String get profileYourKitchen;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get languageChinese;

  /// No description provided for @languageJapanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get languageJapanese;

  /// No description provided for @languageKorean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get languageKorean;

  /// No description provided for @languageVietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get languageVietnamese;

  /// No description provided for @cuisineAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get cuisineAll;

  /// No description provided for @cuisineKorean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get cuisineKorean;

  /// No description provided for @cuisineJapanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get cuisineJapanese;

  /// No description provided for @cuisineChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get cuisineChinese;

  /// No description provided for @cuisineBurmese.
  ///
  /// In en, this message translates to:
  /// **'Burmese'**
  String get cuisineBurmese;

  /// No description provided for @cuisineThai.
  ///
  /// In en, this message translates to:
  /// **'Thai'**
  String get cuisineThai;

  /// No description provided for @cuisineVietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get cuisineVietnamese;

  /// No description provided for @cuisineIndian.
  ///
  /// In en, this message translates to:
  /// **'Indian'**
  String get cuisineIndian;

  /// No description provided for @cuisineItalian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get cuisineItalian;

  /// No description provided for @cuisineAmericanWestern.
  ///
  /// In en, this message translates to:
  /// **'American / Western'**
  String get cuisineAmericanWestern;

  /// No description provided for @cuisineMexican.
  ///
  /// In en, this message translates to:
  /// **'Mexican'**
  String get cuisineMexican;

  /// No description provided for @cuisineFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get cuisineFrench;

  /// No description provided for @cuisineGreek.
  ///
  /// In en, this message translates to:
  /// **'Greek'**
  String get cuisineGreek;

  /// No description provided for @cuisineSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get cuisineSpanish;

  /// No description provided for @cuisineMalaysian.
  ///
  /// In en, this message translates to:
  /// **'Malaysian'**
  String get cuisineMalaysian;

  /// No description provided for @cuisineGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get cuisineGerman;

  /// No description provided for @cuisineIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get cuisineIndonesian;

  /// No description provided for @cuisineLebanese.
  ///
  /// In en, this message translates to:
  /// **'Lebanese'**
  String get cuisineLebanese;

  /// No description provided for @cuisineTurkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get cuisineTurkish;

  /// No description provided for @cuisineMoroccan.
  ///
  /// In en, this message translates to:
  /// **'Moroccan'**
  String get cuisineMoroccan;

  /// No description provided for @cuisineEthiopian.
  ///
  /// In en, this message translates to:
  /// **'Ethiopian'**
  String get cuisineEthiopian;

  /// No description provided for @cuisineFilipino.
  ///
  /// In en, this message translates to:
  /// **'Filipino'**
  String get cuisineFilipino;

  /// No description provided for @cuisinePakistani.
  ///
  /// In en, this message translates to:
  /// **'Pakistani'**
  String get cuisinePakistani;

  /// No description provided for @cuisineSriLankan.
  ///
  /// In en, this message translates to:
  /// **'Sri Lankan'**
  String get cuisineSriLankan;

  /// No description provided for @cuisineCambodian.
  ///
  /// In en, this message translates to:
  /// **'Cambodian'**
  String get cuisineCambodian;

  /// No description provided for @cuisineBrazilian.
  ///
  /// In en, this message translates to:
  /// **'Brazilian'**
  String get cuisineBrazilian;

  /// No description provided for @cuisinePeruvian.
  ///
  /// In en, this message translates to:
  /// **'Peruvian'**
  String get cuisinePeruvian;

  /// No description provided for @cuisineCaribbean.
  ///
  /// In en, this message translates to:
  /// **'Caribbean'**
  String get cuisineCaribbean;

  /// No description provided for @cuisineTaiwanese.
  ///
  /// In en, this message translates to:
  /// **'Taiwanese'**
  String get cuisineTaiwanese;

  /// No description provided for @cuisinePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get cuisinePortuguese;

  /// No description provided for @cuisineBritish.
  ///
  /// In en, this message translates to:
  /// **'British'**
  String get cuisineBritish;

  /// No description provided for @cuisineMongolian.
  ///
  /// In en, this message translates to:
  /// **'Mongolian'**
  String get cuisineMongolian;

  /// No description provided for @cuisineTibetan.
  ///
  /// In en, this message translates to:
  /// **'Tibetan'**
  String get cuisineTibetan;

  /// No description provided for @cuisineHongKong.
  ///
  /// In en, this message translates to:
  /// **'Hong Kong'**
  String get cuisineHongKong;

  /// No description provided for @cuisineMacanese.
  ///
  /// In en, this message translates to:
  /// **'Macanese'**
  String get cuisineMacanese;

  /// No description provided for @cuisineSichuan.
  ///
  /// In en, this message translates to:
  /// **'Sichuan'**
  String get cuisineSichuan;

  /// No description provided for @cuisineCantonese.
  ///
  /// In en, this message translates to:
  /// **'Cantonese'**
  String get cuisineCantonese;

  /// No description provided for @cuisineShanghainese.
  ///
  /// In en, this message translates to:
  /// **'Shanghainese'**
  String get cuisineShanghainese;

  /// No description provided for @cuisineFujian.
  ///
  /// In en, this message translates to:
  /// **'Fujian'**
  String get cuisineFujian;

  /// No description provided for @cuisineHunan.
  ///
  /// In en, this message translates to:
  /// **'Hunan'**
  String get cuisineHunan;

  /// No description provided for @cuisineYunnan.
  ///
  /// In en, this message translates to:
  /// **'Yunnan'**
  String get cuisineYunnan;

  /// No description provided for @cuisineBeijing.
  ///
  /// In en, this message translates to:
  /// **'Beijing'**
  String get cuisineBeijing;

  /// No description provided for @cuisineDongbei.
  ///
  /// In en, this message translates to:
  /// **'Northeast Chinese'**
  String get cuisineDongbei;

  /// No description provided for @cuisineHakka.
  ///
  /// In en, this message translates to:
  /// **'Hakka'**
  String get cuisineHakka;

  /// No description provided for @cuisineUyghur.
  ///
  /// In en, this message translates to:
  /// **'Uyghur'**
  String get cuisineUyghur;

  /// No description provided for @cuisineOkinawan.
  ///
  /// In en, this message translates to:
  /// **'Okinawan'**
  String get cuisineOkinawan;

  /// No description provided for @cuisineShandong.
  ///
  /// In en, this message translates to:
  /// **'Shandong'**
  String get cuisineShandong;

  /// No description provided for @cuisineGuangxi.
  ///
  /// In en, this message translates to:
  /// **'Guangxi'**
  String get cuisineGuangxi;

  /// No description provided for @cuisineTeochew.
  ///
  /// In en, this message translates to:
  /// **'Teochew'**
  String get cuisineTeochew;

  /// No description provided for @cuisineHainanese.
  ///
  /// In en, this message translates to:
  /// **'Hainanese'**
  String get cuisineHainanese;

  /// No description provided for @cuisineJiangsu.
  ///
  /// In en, this message translates to:
  /// **'Jiangsu'**
  String get cuisineJiangsu;

  /// No description provided for @cuisineZhejiang.
  ///
  /// In en, this message translates to:
  /// **'Zhejiang'**
  String get cuisineZhejiang;

  /// No description provided for @cuisineAnhui.
  ///
  /// In en, this message translates to:
  /// **'Anhui'**
  String get cuisineAnhui;

  /// No description provided for @cuisineJiangxi.
  ///
  /// In en, this message translates to:
  /// **'Jiangxi'**
  String get cuisineJiangxi;

  /// No description provided for @cuisineGuizhou.
  ///
  /// In en, this message translates to:
  /// **'Guizhou'**
  String get cuisineGuizhou;

  /// No description provided for @cuisineManchurian.
  ///
  /// In en, this message translates to:
  /// **'Manchurian'**
  String get cuisineManchurian;

  /// No description provided for @cuisineShaanxi.
  ///
  /// In en, this message translates to:
  /// **'Shaanxi'**
  String get cuisineShaanxi;

  /// No description provided for @cuisineShan.
  ///
  /// In en, this message translates to:
  /// **'Shan'**
  String get cuisineShan;

  /// No description provided for @cuisineRakhine.
  ///
  /// In en, this message translates to:
  /// **'Rakhine'**
  String get cuisineRakhine;

  /// No description provided for @cuisineMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get cuisineMon;

  /// No description provided for @cuisineKachin.
  ///
  /// In en, this message translates to:
  /// **'Kachin'**
  String get cuisineKachin;

  /// No description provided for @cuisineKayin.
  ///
  /// In en, this message translates to:
  /// **'Kayin'**
  String get cuisineKayin;

  /// No description provided for @cuisineChin.
  ///
  /// In en, this message translates to:
  /// **'Chin'**
  String get cuisineChin;

  /// No description provided for @cuisineKayah.
  ///
  /// In en, this message translates to:
  /// **'Kayah'**
  String get cuisineKayah;

  /// No description provided for @cuisineMandalay.
  ///
  /// In en, this message translates to:
  /// **'Mandalay'**
  String get cuisineMandalay;

  /// No description provided for @cuisineYangon.
  ///
  /// In en, this message translates to:
  /// **'Yangon'**
  String get cuisineYangon;

  /// No description provided for @cuisineAyeyarwady.
  ///
  /// In en, this message translates to:
  /// **'Ayeyarwady'**
  String get cuisineAyeyarwady;

  /// No description provided for @cuisineTanintharyi.
  ///
  /// In en, this message translates to:
  /// **'Tanintharyi'**
  String get cuisineTanintharyi;

  /// No description provided for @cuisineIntha.
  ///
  /// In en, this message translates to:
  /// **'Intha'**
  String get cuisineIntha;

  /// No description provided for @cuisineNaga.
  ///
  /// In en, this message translates to:
  /// **'Naga'**
  String get cuisineNaga;

  /// No description provided for @cuisinePaO.
  ///
  /// In en, this message translates to:
  /// **'Pa\'O'**
  String get cuisinePaO;

  /// No description provided for @cuisineDanu.
  ///
  /// In en, this message translates to:
  /// **'Danu'**
  String get cuisineDanu;

  /// No description provided for @cuisineWa.
  ///
  /// In en, this message translates to:
  /// **'Wa'**
  String get cuisineWa;

  /// No description provided for @cuisineMagway.
  ///
  /// In en, this message translates to:
  /// **'Magway'**
  String get cuisineMagway;

  /// No description provided for @cuisineBago.
  ///
  /// In en, this message translates to:
  /// **'Bago'**
  String get cuisineBago;

  /// No description provided for @cuisineSagaing.
  ///
  /// In en, this message translates to:
  /// **'Sagaing'**
  String get cuisineSagaing;

  /// No description provided for @cuisineTaunggyi.
  ///
  /// In en, this message translates to:
  /// **'Taunggyi'**
  String get cuisineTaunggyi;

  /// No description provided for @exploreSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search recipes, ingredients, tags'**
  String get exploreSearchHint;

  /// No description provided for @exploreSearchHintLong.
  ///
  /// In en, this message translates to:
  /// **'Search recipes, ingredients, or cuisines...'**
  String get exploreSearchHintLong;

  /// No description provided for @heroBadge.
  ///
  /// In en, this message translates to:
  /// **'CULINARY STUDIO'**
  String get heroBadge;

  /// No description provided for @heroTitle.
  ///
  /// In en, this message translates to:
  /// **'SpiceRoute'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A culinary journey across the world\'s kitchens. Discover recipes by country, get inspired with AI Creator, and cook along with AI Companion in your language.'**
  String get heroSubtitle;

  /// No description provided for @brandTagline.
  ///
  /// In en, this message translates to:
  /// **'{cuisines} cuisines · {languages} languages'**
  String brandTagline(int cuisines, int languages);

  /// No description provided for @exploreResultCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No recipes in {scope}} =1{Showing 1 recipe in {scope}} other{Showing {count} recipes in {scope}}}'**
  String exploreResultCount(int count, String scope);

  /// No description provided for @communityBadge.
  ///
  /// In en, this message translates to:
  /// **'REAL-TIME SYNC'**
  String get communityBadge;

  /// No description provided for @communityTitle.
  ///
  /// In en, this message translates to:
  /// **'Community Culinary Board'**
  String get communityTitle;

  /// No description provided for @communitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'See what other food lovers are cooking, or upload your own creations for any international cuisine!'**
  String get communitySubtitle;

  /// No description provided for @communityShowcaseTitle.
  ///
  /// In en, this message translates to:
  /// **'SHOWCASE YOUR DISH'**
  String get communityShowcaseTitle;

  /// No description provided for @communityUploadCta.
  ///
  /// In en, this message translates to:
  /// **'Click to upload culinary creation'**
  String get communityUploadCta;

  /// No description provided for @communityUploadHint.
  ///
  /// In en, this message translates to:
  /// **'JPEG / PNG (automatically compressed)'**
  String get communityUploadHint;

  /// No description provided for @communityChefLabel.
  ///
  /// In en, this message translates to:
  /// **'CHEF / COOK NAME'**
  String get communityChefLabel;

  /// No description provided for @communityChefHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Nonna Sophia, Alex'**
  String get communityChefHint;

  /// No description provided for @communityCaptionLabel.
  ///
  /// In en, this message translates to:
  /// **'CAPTION / STORY'**
  String get communityCaptionLabel;

  /// No description provided for @communityCaptionHint.
  ///
  /// In en, this message translates to:
  /// **'Made this for Sunday dinner! Replaced with fresh herbs.'**
  String get communityCaptionHint;

  /// No description provided for @communityShareBtn.
  ///
  /// In en, this message translates to:
  /// **'SHARE TO LIVE BOARD'**
  String get communityShareBtn;

  /// No description provided for @communityFeedTitle.
  ///
  /// In en, this message translates to:
  /// **'LIVE FEED ({count} PHOTOS)'**
  String communityFeedTitle(int count);

  /// No description provided for @communityEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No community photos yet'**
  String get communityEmptyTitle;

  /// No description provided for @communityEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Be the first to upload a photo of your cooked masterwork here for this cuisine!'**
  String get communityEmptySubtitle;

  /// No description provided for @communitySharedToast.
  ///
  /// In en, this message translates to:
  /// **'Shared to the live board!'**
  String get communitySharedToast;

  /// No description provided for @communityViewFeed.
  ///
  /// In en, this message translates to:
  /// **'View feed'**
  String get communityViewFeed;

  /// No description provided for @communityByLine.
  ///
  /// In en, this message translates to:
  /// **'by {name}'**
  String communityByLine(String name);

  /// No description provided for @communityRemovePhoto.
  ///
  /// In en, this message translates to:
  /// **'REMOVE PHOTO'**
  String get communityRemovePhoto;

  /// No description provided for @communityUploading.
  ///
  /// In en, this message translates to:
  /// **'Compressing & sharing…'**
  String get communityUploading;

  /// No description provided for @communityUploaded.
  ///
  /// In en, this message translates to:
  /// **'Successfully published to live community feed'**
  String get communityUploaded;

  /// Inline error banner shown on the community-board upload card when the chosen photo (after compression) is over the per-document storage cap.
  ///
  /// In en, this message translates to:
  /// **'Photo is too large, try a smaller image.'**
  String get communityUploadErrorPhotoTooLarge;

  /// Snackbar shown when image_picker.pickImage() throws (typically denied gallery permission, OS-level cancel, or web error).
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the photo picker. Check the app\'s photo permission and try again.'**
  String get communityUploadErrorPickFailed;

  /// Fallback inline error for the community upload card covering Firestore failures, network drops, and other non-user-recoverable upload errors.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t share photo. Try again in a moment.'**
  String get communityUploadErrorGeneric;

  /// No description provided for @communityFilteredTo.
  ///
  /// In en, this message translates to:
  /// **'Filtered: {cuisine}'**
  String communityFilteredTo(String cuisine);

  /// No description provided for @storiesHeading.
  ///
  /// In en, this message translates to:
  /// **'{cuisine} Culinary Heritage & Connections'**
  String storiesHeading(String cuisine);

  /// No description provided for @storiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore traditional course approaches and heritage stories — tap a card to filter the recipes.'**
  String get storiesSubtitle;

  /// No description provided for @storiesActiveBadge.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get storiesActiveBadge;

  /// No description provided for @footerBlurb.
  ///
  /// In en, this message translates to:
  /// **'An elegant culinary gateway offering curated recipes across many distinct culinary traditions. Elevate your home cooking with international flavors and real-time AI assistance.'**
  String get footerBlurb;

  /// No description provided for @footerQuickNav.
  ///
  /// In en, this message translates to:
  /// **'QUICK NAVIGATION'**
  String get footerQuickNav;

  /// No description provided for @footerLinkExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore Recipes'**
  String get footerLinkExplore;

  /// No description provided for @footerLinkCreator.
  ///
  /// In en, this message translates to:
  /// **'AI Recipe Creator'**
  String get footerLinkCreator;

  /// No description provided for @footerLinkCompanion.
  ///
  /// In en, this message translates to:
  /// **'AI Chef Companion'**
  String get footerLinkCompanion;

  /// No description provided for @footerLinkSaved.
  ///
  /// In en, this message translates to:
  /// **'My Saved Cookbook'**
  String get footerLinkSaved;

  /// No description provided for @footerConnect.
  ///
  /// In en, this message translates to:
  /// **'CONNECT WITH US'**
  String get footerConnect;

  /// No description provided for @footerEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Your email address'**
  String get footerEmailHint;

  /// No description provided for @footerJoin.
  ///
  /// In en, this message translates to:
  /// **'Join Hub'**
  String get footerJoin;

  /// No description provided for @footerJoinedToast.
  ///
  /// In en, this message translates to:
  /// **'Thanks for joining the hub!'**
  String get footerJoinedToast;

  /// No description provided for @footerCopyright.
  ///
  /// In en, this message translates to:
  /// **'© {year} {brand}. All rights reserved.'**
  String footerCopyright(int year, String brand);

  /// No description provided for @footerLicense.
  ///
  /// In en, this message translates to:
  /// **'Released under the MIT License.'**
  String get footerLicense;

  /// No description provided for @exploreEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No recipes match yet'**
  String get exploreEmptyTitle;

  /// No description provided for @exploreEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try a different cuisine or clear the search.'**
  String get exploreEmptySubtitle;

  /// No description provided for @exploreErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load recipes'**
  String get exploreErrorTitle;

  /// No description provided for @exploreErrorRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get exploreErrorRetry;

  /// No description provided for @filterCuisineLabel.
  ///
  /// In en, this message translates to:
  /// **'SELECT CUISINE'**
  String get filterCuisineLabel;

  /// No description provided for @filterCourseLabel.
  ///
  /// In en, this message translates to:
  /// **'SELECT COURSE'**
  String get filterCourseLabel;

  /// No description provided for @filterDietaryLabel.
  ///
  /// In en, this message translates to:
  /// **'DIETARY, LIFESTYLE & FORMAT RESTRICTIONS'**
  String get filterDietaryLabel;

  /// No description provided for @filterAllCuisines.
  ///
  /// In en, this message translates to:
  /// **'All Cuisines'**
  String get filterAllCuisines;

  /// No description provided for @filterAllCourses.
  ///
  /// In en, this message translates to:
  /// **'All Courses'**
  String get filterAllCourses;

  /// No description provided for @filterAllDietary.
  ///
  /// In en, this message translates to:
  /// **'All Preferences'**
  String get filterAllDietary;

  /// No description provided for @exploreRefine.
  ///
  /// In en, this message translates to:
  /// **'REFINE'**
  String get exploreRefine;

  /// No description provided for @exploreByRegion.
  ///
  /// In en, this message translates to:
  /// **'EXPLORE BY GEOGRAPHIC REGION'**
  String get exploreByRegion;

  /// No description provided for @chooseRegion.
  ///
  /// In en, this message translates to:
  /// **'Choose a region'**
  String get chooseRegion;

  /// No description provided for @changeRegion.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeRegion;

  /// No description provided for @selectCuisineTradition.
  ///
  /// In en, this message translates to:
  /// **'SELECT CUISINE TRADITION'**
  String get selectCuisineTradition;

  /// No description provided for @regionEastAsia.
  ///
  /// In en, this message translates to:
  /// **'East Asia'**
  String get regionEastAsia;

  /// No description provided for @regionMyanmar.
  ///
  /// In en, this message translates to:
  /// **'Myanmar'**
  String get regionMyanmar;

  /// No description provided for @regionMainlandSoutheastAsia.
  ///
  /// In en, this message translates to:
  /// **'Mainland Southeast Asia'**
  String get regionMainlandSoutheastAsia;

  /// No description provided for @regionMaritimeSoutheastAsia.
  ///
  /// In en, this message translates to:
  /// **'Maritime Southeast Asia'**
  String get regionMaritimeSoutheastAsia;

  /// No description provided for @regionSouthAsia.
  ///
  /// In en, this message translates to:
  /// **'South Asia'**
  String get regionSouthAsia;

  /// No description provided for @regionEurope.
  ///
  /// In en, this message translates to:
  /// **'Europe'**
  String get regionEurope;

  /// No description provided for @regionAmericas.
  ///
  /// In en, this message translates to:
  /// **'Americas'**
  String get regionAmericas;

  /// No description provided for @regionMiddleEastAfrica.
  ///
  /// In en, this message translates to:
  /// **'Middle East & Africa'**
  String get regionMiddleEastAfrica;

  /// No description provided for @courseGroupEarlyDay.
  ///
  /// In en, this message translates to:
  /// **'Early Day'**
  String get courseGroupEarlyDay;

  /// No description provided for @courseGroupDaytimeCasual.
  ///
  /// In en, this message translates to:
  /// **'Daytime / Casual'**
  String get courseGroupDaytimeCasual;

  /// No description provided for @courseGroupBeforeMain.
  ///
  /// In en, this message translates to:
  /// **'Before the Main'**
  String get courseGroupBeforeMain;

  /// No description provided for @courseGroupMainEvent.
  ///
  /// In en, this message translates to:
  /// **'The Main Event'**
  String get courseGroupMainEvent;

  /// No description provided for @courseGroupSweetEnding.
  ///
  /// In en, this message translates to:
  /// **'Sweet Ending'**
  String get courseGroupSweetEnding;

  /// No description provided for @courseGroupAfterHours.
  ///
  /// In en, this message translates to:
  /// **'After Hours'**
  String get courseGroupAfterHours;

  /// No description provided for @courseGroupLiquids.
  ///
  /// In en, this message translates to:
  /// **'Liquids'**
  String get courseGroupLiquids;

  /// No description provided for @courseBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast & Brunch'**
  String get courseBreakfast;

  /// No description provided for @courseHighTea.
  ///
  /// In en, this message translates to:
  /// **'High Tea & Afternoon Tea'**
  String get courseHighTea;

  /// No description provided for @courseLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch & Box Lunch'**
  String get courseLunch;

  /// No description provided for @courseSoupsSaladsBowls.
  ///
  /// In en, this message translates to:
  /// **'Soups, Broths & Salads'**
  String get courseSoupsSaladsBowls;

  /// No description provided for @courseAppetizer.
  ///
  /// In en, this message translates to:
  /// **'Appetizers, Starters & Finger Foods'**
  String get courseAppetizer;

  /// No description provided for @courseSharingBoards.
  ///
  /// In en, this message translates to:
  /// **'Sharing Platters, Boards & Charcuterie'**
  String get courseSharingBoards;

  /// No description provided for @courseMainCourse.
  ///
  /// In en, this message translates to:
  /// **'High-Protein Main Courses'**
  String get courseMainCourse;

  /// No description provided for @courseSideDish.
  ///
  /// In en, this message translates to:
  /// **'Side Dishes'**
  String get courseSideDish;

  /// No description provided for @courseDessert.
  ///
  /// In en, this message translates to:
  /// **'Desserts & Sweets'**
  String get courseDessert;

  /// No description provided for @courseSnack.
  ///
  /// In en, this message translates to:
  /// **'Snacks & Late-Night Bites'**
  String get courseSnack;

  /// No description provided for @courseAlcoholicDrinks.
  ///
  /// In en, this message translates to:
  /// **'Alcoholic Drinks & Cocktails'**
  String get courseAlcoholicDrinks;

  /// No description provided for @courseZeroProofDrinks.
  ///
  /// In en, this message translates to:
  /// **'Non-Alcoholic Beverages'**
  String get courseZeroProofDrinks;

  /// No description provided for @dietaryVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get dietaryVegan;

  /// No description provided for @dietaryVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get dietaryVegetarian;

  /// No description provided for @dietaryMealPrep.
  ///
  /// In en, this message translates to:
  /// **'Meal Prep'**
  String get dietaryMealPrep;

  /// No description provided for @dietaryQuickEasy.
  ///
  /// In en, this message translates to:
  /// **'Quick & Easy'**
  String get dietaryQuickEasy;

  /// No description provided for @dietaryPastaSoup.
  ///
  /// In en, this message translates to:
  /// **'Pasta & Soup'**
  String get dietaryPastaSoup;

  /// No description provided for @dietaryBloodSugarBalanced.
  ///
  /// In en, this message translates to:
  /// **'Blood Sugar Balanced'**
  String get dietaryBloodSugarBalanced;

  /// No description provided for @dietarySwicy.
  ///
  /// In en, this message translates to:
  /// **'\"Swicy\" (Sweet & Spicy)'**
  String get dietarySwicy;

  /// No description provided for @dietaryAntiInflammatory.
  ///
  /// In en, this message translates to:
  /// **'Anti-Inflammatory & Longevity'**
  String get dietaryAntiInflammatory;

  /// No description provided for @dietaryGlutenFree.
  ///
  /// In en, this message translates to:
  /// **'Gluten-Free'**
  String get dietaryGlutenFree;

  /// No description provided for @dietaryDairyFree.
  ///
  /// In en, this message translates to:
  /// **'Dairy-Free'**
  String get dietaryDairyFree;

  /// No description provided for @dietaryNutFree.
  ///
  /// In en, this message translates to:
  /// **'Nut-Free'**
  String get dietaryNutFree;

  /// No description provided for @dietaryEggFree.
  ///
  /// In en, this message translates to:
  /// **'Egg-Free'**
  String get dietaryEggFree;

  /// No description provided for @dietaryGroupRestrictions.
  ///
  /// In en, this message translates to:
  /// **'Dietary Restrictions'**
  String get dietaryGroupRestrictions;

  /// No description provided for @dietaryGroupAllergenFree.
  ///
  /// In en, this message translates to:
  /// **'Allergen-Free'**
  String get dietaryGroupAllergenFree;

  /// No description provided for @dietaryGroupWellness.
  ///
  /// In en, this message translates to:
  /// **'Wellness & Lifestyles'**
  String get dietaryGroupWellness;

  /// No description provided for @dietaryGroupCookingFormats.
  ///
  /// In en, this message translates to:
  /// **'Cooking Formats'**
  String get dietaryGroupCookingFormats;

  /// No description provided for @filterSearchCourses.
  ///
  /// In en, this message translates to:
  /// **'Search courses…'**
  String get filterSearchCourses;

  /// No description provided for @filterSearchDietary.
  ///
  /// In en, this message translates to:
  /// **'Search dietary preferences…'**
  String get filterSearchDietary;

  /// No description provided for @filterPreferencesHint.
  ///
  /// In en, this message translates to:
  /// **'Course & diet'**
  String get filterPreferencesHint;

  /// No description provided for @filterTabCourse.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get filterTabCourse;

  /// No description provided for @filterTabDiet.
  ///
  /// In en, this message translates to:
  /// **'Diet & lifestyle'**
  String get filterTabDiet;

  /// No description provided for @filterCourseHeading.
  ///
  /// In en, this message translates to:
  /// **'COURSE SELECTION FILTERS'**
  String get filterCourseHeading;

  /// No description provided for @filterDietHeading.
  ///
  /// In en, this message translates to:
  /// **'DIETARY & LIFESTYLE RESTRICTIONS'**
  String get filterDietHeading;

  /// No description provided for @filterMobilePillHint.
  ///
  /// In en, this message translates to:
  /// **'Filter recipes'**
  String get filterMobilePillHint;

  /// No description provided for @filterChoicesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 choice} other{{count} choices}}'**
  String filterChoicesCount(int count);

  /// No description provided for @filterExpandAll.
  ///
  /// In en, this message translates to:
  /// **'EXPAND ALL'**
  String get filterExpandAll;

  /// No description provided for @filterCollapseAll.
  ///
  /// In en, this message translates to:
  /// **'COLLAPSE ALL'**
  String get filterCollapseAll;

  /// No description provided for @filterNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get filterNoMatches;

  /// No description provided for @filterClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get filterClearSearch;

  /// No description provided for @filterDismissMenu.
  ///
  /// In en, this message translates to:
  /// **'Dismiss menu'**
  String get filterDismissMenu;

  /// No description provided for @recipeMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String recipeMinutesShort(int minutes);

  /// No description provided for @recipeHoursShort.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String recipeHoursShort(int hours);

  /// No description provided for @recipeHoursMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String recipeHoursMinutesShort(int hours, int minutes);

  /// No description provided for @recipeServings.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 serving} other{{count} servings}}'**
  String recipeServings(int count);

  /// No description provided for @recipeKcal.
  ///
  /// In en, this message translates to:
  /// **'{kcal} kcal'**
  String recipeKcal(int kcal);

  /// No description provided for @recipePremiumBadge.
  ///
  /// In en, this message translates to:
  /// **'Curated'**
  String get recipePremiumBadge;

  /// No description provided for @recipeAiBadge.
  ///
  /// In en, this message translates to:
  /// **'AI created'**
  String get recipeAiBadge;

  /// No description provided for @recipeSpiceLevel0.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get recipeSpiceLevel0;

  /// No description provided for @recipeSpiceLevel1.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get recipeSpiceLevel1;

  /// No description provided for @recipeSpiceLevel2.
  ///
  /// In en, this message translates to:
  /// **'Spicy'**
  String get recipeSpiceLevel2;

  /// No description provided for @recipeSpiceLevel3.
  ///
  /// In en, this message translates to:
  /// **'Fiery'**
  String get recipeSpiceLevel3;

  /// No description provided for @detailIngredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get detailIngredients;

  /// No description provided for @detailCookingInstructions.
  ///
  /// In en, this message translates to:
  /// **'Cooking Instructions'**
  String get detailCookingInstructions;

  /// No description provided for @detailPrepTime.
  ///
  /// In en, this message translates to:
  /// **'Prep Time'**
  String get detailPrepTime;

  /// No description provided for @detailCookTime.
  ///
  /// In en, this message translates to:
  /// **'Cook Time'**
  String get detailCookTime;

  /// No description provided for @detailServingsShort.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get detailServingsShort;

  /// No description provided for @detailDifficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get detailDifficultyEasy;

  /// No description provided for @detailDifficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get detailDifficultyMedium;

  /// No description provided for @detailDifficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get detailDifficultyHard;

  /// No description provided for @detailClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get detailClose;

  /// No description provided for @detailSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get detailSteps;

  /// No description provided for @detailStepNumber.
  ///
  /// In en, this message translates to:
  /// **'Step {number}'**
  String detailStepNumber(int number);

  /// No description provided for @detailNoDescription.
  ///
  /// In en, this message translates to:
  /// **'No description provided.'**
  String get detailNoDescription;

  /// No description provided for @detailSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get detailSave;

  /// No description provided for @detailSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get detailSaved;

  /// No description provided for @detailUnsave.
  ///
  /// In en, this message translates to:
  /// **'Remove from saved'**
  String get detailUnsave;

  /// No description provided for @detailShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get detailShare;

  /// No description provided for @detailBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get detailBack;

  /// No description provided for @savedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedTitle;

  /// No description provided for @savedHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your personal cookbook. Bookmark dishes from any cuisine and they\'ll land here so you can revisit them anytime.'**
  String get savedHeroSubtitle;

  /// No description provided for @savedCountHeading.
  ///
  /// In en, this message translates to:
  /// **'Saved ({count})'**
  String savedCountHeading(int count);

  /// No description provided for @savedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get savedEmptyTitle;

  /// No description provided for @savedEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t saved any recipes yet. Tap the bookmark icon on any recipe card to start building your personal cookbook!'**
  String get savedEmptySubtitle;

  /// No description provided for @savedEmptyCta.
  ///
  /// In en, this message translates to:
  /// **'Explore Recipes now'**
  String get savedEmptyCta;

  /// No description provided for @savedCloudSyncedBadge.
  ///
  /// In en, this message translates to:
  /// **'CLOUD SYNCED'**
  String get savedCloudSyncedBadge;

  /// No description provided for @savedClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get savedClearAll;

  /// No description provided for @savedClearConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear all saved recipes?'**
  String get savedClearConfirm;

  /// No description provided for @savedClearConfirmYes.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get savedClearConfirmYes;

  /// No description provided for @savedClearConfirmNo.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get savedClearConfirmNo;

  /// No description provided for @aiCreatorTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Recipe Creator'**
  String get aiCreatorTitle;

  /// No description provided for @aiCreatorCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Generate Custom AI Recipe'**
  String get aiCreatorCardTitle;

  /// No description provided for @aiCreatorCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter ingredients you have or a craving, and watch our AI Chef instantly cook up a custom step-by-step culinary masterpiece in your preferred language.'**
  String get aiCreatorCardSubtitle;

  /// No description provided for @aiCreatorIngredientsLabel.
  ///
  /// In en, this message translates to:
  /// **'Ingredients / Food Idea'**
  String get aiCreatorIngredientsLabel;

  /// No description provided for @aiCreatorIdeaHintLong.
  ///
  /// In en, this message translates to:
  /// **'e.g. Tomato, eggs, scallions or \'A light healthy tofu dinner\''**
  String get aiCreatorIdeaHintLong;

  /// No description provided for @aiCreatorCreateBtn.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get aiCreatorCreateBtn;

  /// No description provided for @aiCreatorIdeaLabel.
  ///
  /// In en, this message translates to:
  /// **'What do you feel like cooking?'**
  String get aiCreatorIdeaLabel;

  /// No description provided for @aiCreatorIdeaHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cozy mushroom pasta with leftover wine'**
  String get aiCreatorIdeaHint;

  /// No description provided for @aiCreatorCuisineLabel.
  ///
  /// In en, this message translates to:
  /// **'Cuisine'**
  String get aiCreatorCuisineLabel;

  /// No description provided for @aiCreatorCuisineAuto.
  ///
  /// In en, this message translates to:
  /// **'Let the AI choose'**
  String get aiCreatorCuisineAuto;

  /// No description provided for @aiCreatorLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language for the recipe'**
  String get aiCreatorLanguageLabel;

  /// No description provided for @aiCreatorGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate recipe'**
  String get aiCreatorGenerate;

  /// No description provided for @aiCreatorRegenerate.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get aiCreatorRegenerate;

  /// No description provided for @aiCreatorSaveBtn.
  ///
  /// In en, this message translates to:
  /// **'Save to my recipes'**
  String get aiCreatorSaveBtn;

  /// No description provided for @aiCreatorSavedToast.
  ///
  /// In en, this message translates to:
  /// **'Saved! You can find it in My Saved.'**
  String get aiCreatorSavedToast;

  /// No description provided for @aiCreatorErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t generate that recipe'**
  String get aiCreatorErrorTitle;

  /// No description provided for @aiCreatorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'You\'ve hit today\'s free generation limit. Try again tomorrow.'**
  String get aiCreatorRateLimited;

  /// No description provided for @aiCreatorQuote1.
  ///
  /// In en, this message translates to:
  /// **'Sharpening the knives and chopping scallions…'**
  String get aiCreatorQuote1;

  /// No description provided for @aiCreatorQuote2.
  ///
  /// In en, this message translates to:
  /// **'Roasting raw spices to unlock golden aromas…'**
  String get aiCreatorQuote2;

  /// No description provided for @aiCreatorQuote3.
  ///
  /// In en, this message translates to:
  /// **'Simmering authentic stock and checking seasonings…'**
  String get aiCreatorQuote3;

  /// No description provided for @aiCreatorQuote4.
  ///
  /// In en, this message translates to:
  /// **'Curating high-quality ingredients for your custom palate…'**
  String get aiCreatorQuote4;

  /// No description provided for @aiCreatorQuote5.
  ///
  /// In en, this message translates to:
  /// **'Assembling delicate step-by-step instructions for perfect execution…'**
  String get aiCreatorQuote5;

  /// No description provided for @aiCompanionTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Kitchen Companion'**
  String get aiCompanionTitle;

  /// No description provided for @aiCompanionActiveFocus.
  ///
  /// In en, this message translates to:
  /// **'Active Focus: Global'**
  String get aiCompanionActiveFocus;

  /// No description provided for @aiCompanionGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi! I am your Global Gastronomy AI Chef. Ask me anything about ingredient substitutes, cooking tricks, or request a completely new custom recipe!'**
  String get aiCompanionGreeting;

  /// No description provided for @aiCompanionSuggestionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Gourmet Suggestions'**
  String get aiCompanionSuggestionsLabel;

  /// No description provided for @aiCompanionEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about cooking'**
  String get aiCompanionEmptyTitle;

  /// No description provided for @aiCompanionEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Substitutes, techniques, dietary swaps - I\'ve got you.'**
  String get aiCompanionEmptySubtitle;

  /// No description provided for @aiCompanionInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask AI how to make a dish, ask for keto/vegan options...'**
  String get aiCompanionInputHint;

  /// No description provided for @aiCompanionSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get aiCompanionSend;

  /// No description provided for @aiCompanionStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get aiCompanionStop;

  /// No description provided for @aiCompanionClear.
  ///
  /// In en, this message translates to:
  /// **'Clear chat'**
  String get aiCompanionClear;

  /// No description provided for @aiCompanionTyping.
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get aiCompanionTyping;

  /// No description provided for @aiCompanionRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many messages this hour. Try again later.'**
  String get aiCompanionRateLimited;

  /// No description provided for @aiCompanionActiveFocusCuisine.
  ///
  /// In en, this message translates to:
  /// **'Active Focus: {cuisine}'**
  String aiCompanionActiveFocusCuisine(String cuisine);

  /// No description provided for @aiCompanionSuggestion1.
  ///
  /// In en, this message translates to:
  /// **'What is a good vegetarian substitute for fish sauce?'**
  String get aiCompanionSuggestion1;

  /// No description provided for @aiCompanionSuggestion2.
  ///
  /// In en, this message translates to:
  /// **'Suggest an authentic side dish for Korean Kimchi Jjigae.'**
  String get aiCompanionSuggestion2;

  /// No description provided for @aiCompanionSuggestion3.
  ///
  /// In en, this message translates to:
  /// **'Can you explain Szechuan peppercorn numbing effect?'**
  String get aiCompanionSuggestion3;

  /// No description provided for @aiCompanionSuggestion4.
  ///
  /// In en, this message translates to:
  /// **'How do I control the heat level in Burmese Mohinga?'**
  String get aiCompanionSuggestion4;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsAccountSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {name}'**
  String settingsAccountSignedInAs(String name);

  /// No description provided for @settingsAccountGuest.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get settingsAccountGuest;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About SpiceRoute'**
  String get settingsAbout;

  /// No description provided for @settingsAboutBody.
  ///
  /// In en, this message translates to:
  /// **'SpiceRoute brings together the foods of the world into one calm, beautiful library, plus AI tools to remix them for your kitchen.'**
  String get settingsAboutBody;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @settingsClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get settingsClose;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonError;

  /// Shown when an API call fails before the server responds — timeout, DNS failure, TLS handshake failure, browser blocked the request, no internet. Surfaced by api_client.kApiErrorNetworkSentinel.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the server. Check your connection and try again.'**
  String get errorNetwork;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get commonNotFound;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get commonHome;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get authSignOut;

  /// No description provided for @authSignOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get authSignOutConfirmTitle;

  /// No description provided for @authSignOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to sign in again to access your saved recipes and AI features.'**
  String get authSignOutConfirmBody;

  /// No description provided for @authRegister.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authRegister;

  /// No description provided for @authAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get authAccount;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get authDisplayName;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authOrDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get authOrDivider;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get authForgotPassword;

  /// No description provided for @authResetSent.
  ///
  /// In en, this message translates to:
  /// **'If that email is registered, a reset link is on its way.'**
  String get authResetSent;

  /// No description provided for @authNoAccountYet.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authNoAccountYet;

  /// No description provided for @authHasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authHasAccount;

  /// No description provided for @authSignUpHere.
  ///
  /// In en, this message translates to:
  /// **'Create one'**
  String get authSignUpHere;

  /// No description provided for @authSignInHere.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get authSignInHere;

  /// No description provided for @authProtectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in required'**
  String get authProtectedTitle;

  /// No description provided for @authProtectedBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in to publish your recipe so it stays attributed to you and you can edit or remove it later.'**
  String get authProtectedBody;

  /// No description provided for @authNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Sign-in is not configured yet. Add Firebase config to enable it.'**
  String get authNotConfigured;

  /// No description provided for @authDevModeBanner.
  ///
  /// In en, this message translates to:
  /// **'Dev mode - Firebase isn\'t configured. Any email + password creates a local test account on this device.'**
  String get authDevModeBanner;

  /// No description provided for @authWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get authWelcomeTitle;

  /// No description provided for @authWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Login to retrieve your customized recipes and culinary logs'**
  String get authWelcomeSubtitle;

  /// No description provided for @authRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Culinary Account'**
  String get authRegisterTitle;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join us to synchronize and manage your bespoke recipes'**
  String get authRegisterSubtitle;

  /// No description provided for @authNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your culinary name'**
  String get authNameLabel;

  /// No description provided for @authNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Chef Oliver'**
  String get authNameHint;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'chef@example.com'**
  String get authEmailHint;

  /// No description provided for @authPrimarySignIn.
  ///
  /// In en, this message translates to:
  /// **'Access Studio'**
  String get authPrimarySignIn;

  /// No description provided for @authPrimaryRegister.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authPrimaryRegister;

  /// No description provided for @authErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Email or password isn\'t right.'**
  String get authErrorInvalid;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'That email is already registered.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Pick a stronger password (at least 6 characters).'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Try again.'**
  String get authErrorNetwork;

  /// No description provided for @authErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong with sign-in.'**
  String get authErrorGeneric;

  /// No description provided for @authErrorProviderDisabled.
  ///
  /// In en, this message translates to:
  /// **'This sign-in method isn\'t enabled for this app yet. Ask the operator to enable it in Firebase Console → Authentication → Sign-in method.'**
  String get authErrorProviderDisabled;

  /// No description provided for @authErrorUnauthorizedDomain.
  ///
  /// In en, this message translates to:
  /// **'This domain isn\'t authorized for Google sign-in. Add it in Firebase Console → Authentication → Settings → Authorized domains.'**
  String get authErrorUnauthorizedDomain;

  /// No description provided for @authErrorPopupBlocked.
  ///
  /// In en, this message translates to:
  /// **'Your browser blocked the sign-in popup. Allow popups for this site and try again.'**
  String get authErrorPopupBlocked;

  /// No description provided for @authErrorAccountExists.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists using a different sign-in method. Try signing in with email + password instead.'**
  String get authErrorAccountExists;

  /// No description provided for @authSuccessSignIn.
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully. Happy cooking!'**
  String get authSuccessSignIn;

  /// No description provided for @authSuccessRegister.
  ///
  /// In en, this message translates to:
  /// **'Account registered successfully! Welcome!'**
  String get authSuccessRegister;

  /// No description provided for @authSuccessGoogle.
  ///
  /// In en, this message translates to:
  /// **'Logged in with Google successfully!'**
  String get authSuccessGoogle;

  /// No description provided for @recipeOwnerYou.
  ///
  /// In en, this message translates to:
  /// **'By you'**
  String get recipeOwnerYou;

  /// No description provided for @recipeOwnerBy.
  ///
  /// In en, this message translates to:
  /// **'By {name}'**
  String recipeOwnerBy(String name);

  /// No description provided for @myRecipesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Recipes'**
  String get myRecipesTitle;

  /// No description provided for @myRecipesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get myRecipesEmptyTitle;

  /// No description provided for @myRecipesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recipes you publish or save with AI Creator will appear here.'**
  String get myRecipesEmptySubtitle;

  /// No description provided for @myRecipesSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your recipes'**
  String get myRecipesSignInTitle;

  /// No description provided for @myRecipesSignInBody.
  ///
  /// In en, this message translates to:
  /// **'Recipes you publish or save with AI Creator appear here. Sign in to view and manage them.'**
  String get myRecipesSignInBody;

  /// No description provided for @navMyRecipes.
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get navMyRecipes;

  /// No description provided for @detailEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get detailEdit;

  /// No description provided for @detailDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get detailDelete;

  /// No description provided for @detailDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this recipe? This can\'t be undone.'**
  String get detailDeleteConfirm;

  /// No description provided for @detailDeleteOk.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get detailDeleteOk;

  /// No description provided for @detailDeletedToast.
  ///
  /// In en, this message translates to:
  /// **'Recipe deleted.'**
  String get detailDeletedToast;

  /// No description provided for @detailStartCooking.
  ///
  /// In en, this message translates to:
  /// **'Start cooking'**
  String get detailStartCooking;

  /// No description provided for @cookExit.
  ///
  /// In en, this message translates to:
  /// **'Exit cooking'**
  String get cookExit;

  /// No description provided for @cookStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String cookStepOf(int current, int total);

  /// No description provided for @cookPrev.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get cookPrev;

  /// No description provided for @cookNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get cookNext;

  /// No description provided for @cookFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish cooking'**
  String get cookFinish;

  /// No description provided for @cookFinishShort.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get cookFinishShort;

  /// No description provided for @cookStepDone.
  ///
  /// In en, this message translates to:
  /// **'Mark step done'**
  String get cookStepDone;

  /// No description provided for @cookStepUndo.
  ///
  /// In en, this message translates to:
  /// **'Mark as not done'**
  String get cookStepUndo;

  /// No description provided for @cookIngredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get cookIngredients;

  /// No description provided for @cookIngredientsCount.
  ///
  /// In en, this message translates to:
  /// **'Ingredients ({count})'**
  String cookIngredientsCount(int count);

  /// No description provided for @cookServingsLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 serving} other{{count} servings}}'**
  String cookServingsLabel(int count);

  /// No description provided for @cookServingsIncrease.
  ///
  /// In en, this message translates to:
  /// **'More servings'**
  String get cookServingsIncrease;

  /// No description provided for @cookServingsDecrease.
  ///
  /// In en, this message translates to:
  /// **'Fewer servings'**
  String get cookServingsDecrease;

  /// No description provided for @cookUnitsOriginal.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get cookUnitsOriginal;

  /// No description provided for @cookUnitsMetric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get cookUnitsMetric;

  /// No description provided for @cookUnitsImperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get cookUnitsImperial;

  /// No description provided for @cookFinishedTitle.
  ///
  /// In en, this message translates to:
  /// **'All done!'**
  String get cookFinishedTitle;

  /// No description provided for @cookFinishedBody.
  ///
  /// In en, this message translates to:
  /// **'You finished every step. Bon appétit!'**
  String get cookFinishedBody;

  /// No description provided for @cookFinishedStay.
  ///
  /// In en, this message translates to:
  /// **'Keep recipe open'**
  String get cookFinishedStay;

  /// No description provided for @cookFinishedExit.
  ///
  /// In en, this message translates to:
  /// **'Exit cooking'**
  String get cookFinishedExit;

  /// No description provided for @cookNoStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'No steps yet'**
  String get cookNoStepsTitle;

  /// No description provided for @cookNoStepsBody.
  ///
  /// In en, this message translates to:
  /// **'This recipe doesn\'t have step-by-step instructions to cook through.'**
  String get cookNoStepsBody;

  /// No description provided for @cookBackToRecipe.
  ///
  /// In en, this message translates to:
  /// **'Back to recipe'**
  String get cookBackToRecipe;

  /// No description provided for @reviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Community Gallery & Reviews'**
  String get reviewsTitle;

  /// No description provided for @reviewsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See creations from fellow home chefs, or upload a photo of your own cooking masterwork!'**
  String get reviewsSubtitle;

  /// No description provided for @reviewsAverage.
  ///
  /// In en, this message translates to:
  /// **'AVERAGE RATING'**
  String get reviewsAverage;

  /// No description provided for @reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No reviews yet} =1{1 review} other{{count} reviews}}'**
  String reviewsCount(int count);

  /// No description provided for @reviewsUploadedCooks.
  ///
  /// In en, this message translates to:
  /// **'Uploaded: {count}'**
  String reviewsUploadedCooks(int count);

  /// No description provided for @reviewsEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No community photos shared yet. Be the first to cook and review this dish!'**
  String get reviewsEmptyState;

  /// No description provided for @reviewsLoginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to share your cooking and rate this recipe.'**
  String get reviewsLoginPrompt;

  /// No description provided for @reviewsLoginCta.
  ///
  /// In en, this message translates to:
  /// **'Sign in to review'**
  String get reviewsLoginCta;

  /// No description provided for @reviewsFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Did you make this?'**
  String get reviewsFormTitle;

  /// No description provided for @reviewsFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a photo, rate it, leave notes — a photo or a note plus a rating is enough to share.'**
  String get reviewsFormSubtitle;

  /// No description provided for @reviewsRatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get reviewsRatingLabel;

  /// No description provided for @reviewsAuthorLabel.
  ///
  /// In en, this message translates to:
  /// **'Chef name'**
  String get reviewsAuthorLabel;

  /// No description provided for @reviewsAuthorHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your nickname...'**
  String get reviewsAuthorHint;

  /// No description provided for @reviewsCommentLabel.
  ///
  /// In en, this message translates to:
  /// **'Kitchen notes (optional)'**
  String get reviewsCommentLabel;

  /// No description provided for @reviewsCommentHint.
  ///
  /// In en, this message translates to:
  /// **'How did it taste? Any substitutions or tips? (e.g. added extra garlic!)'**
  String get reviewsCommentHint;

  /// No description provided for @reviewsPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to attach a photo of your cooked dish'**
  String get reviewsPhotoHint;

  /// No description provided for @reviewsPublishBtn.
  ///
  /// In en, this message translates to:
  /// **'Share with community'**
  String get reviewsPublishBtn;

  /// No description provided for @reviewsPublishing.
  ///
  /// In en, this message translates to:
  /// **'Sharing…'**
  String get reviewsPublishing;

  /// No description provided for @reviewsSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Shared with the community!'**
  String get reviewsSubmitted;

  /// No description provided for @reviewsPostAnother.
  ///
  /// In en, this message translates to:
  /// **'Share another'**
  String get reviewsPostAnother;

  /// No description provided for @reviewsPhotoTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Photo is too large, try a smaller image.'**
  String get reviewsPhotoTooLarge;

  /// No description provided for @reviewsErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t share. Try again.'**
  String get reviewsErrorGeneric;

  /// No description provided for @reviewsErrorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'You\'re sharing a lot — give it a minute, then try again.'**
  String get reviewsErrorRateLimited;

  /// No description provided for @reviewsErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network\'s slow right now. Check your connection and try again.'**
  String get reviewsErrorNetwork;

  /// No description provided for @reviewsNotesHeading.
  ///
  /// In en, this message translates to:
  /// **'Notes from the kitchen'**
  String get reviewsNotesHeading;

  /// No description provided for @reviewsDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete review'**
  String get reviewsDeleteTooltip;

  /// No description provided for @reviewsDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete your review?'**
  String get reviewsDeleteConfirm;

  /// No description provided for @reviewsAnonymousChef.
  ///
  /// In en, this message translates to:
  /// **'Home Chef'**
  String get reviewsAnonymousChef;

  /// No description provided for @reviewsLightboxCloseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close photo'**
  String get reviewsLightboxCloseTooltip;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppL10nEn();
    case 'ja':
      return AppL10nJa();
    case 'ko':
      return AppL10nKo();
    case 'vi':
      return AppL10nVi();
    case 'zh':
      return AppL10nZh();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
