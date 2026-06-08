import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_th.dart';
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
    Locale('th'),
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
  /// **'AI Creator'**
  String get navAiCreator;

  /// No description provided for @navAiCompanion.
  ///
  /// In en, this message translates to:
  /// **'AI Companion'**
  String get navAiCompanion;

  /// No description provided for @navSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get navSaved;

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

  /// No description provided for @languageThai.
  ///
  /// In en, this message translates to:
  /// **'Thai'**
  String get languageThai;

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
  /// **'American/Western'**
  String get cuisineAmericanWestern;

  /// No description provided for @cuisineMexican.
  ///
  /// In en, this message translates to:
  /// **'Mexican'**
  String get cuisineMexican;

  /// No description provided for @exploreSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search recipes, ingredients, tags'**
  String get exploreSearchHint;

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

  /// No description provided for @recipeMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String recipeMinutesShort(int minutes);

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
  /// **'My Saved Recipes'**
  String get savedTitle;

  /// No description provided for @savedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get savedEmptyTitle;

  /// No description provided for @savedEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on any recipe to keep it here.'**
  String get savedEmptySubtitle;

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

  /// No description provided for @aiCompanionTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Kitchen Companion'**
  String get aiCompanionTitle;

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
  /// **'Type your question...'**
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

  /// No description provided for @aiCompanionSuggestion1.
  ///
  /// In en, this message translates to:
  /// **'Vegan substitute for fish sauce?'**
  String get aiCompanionSuggestion1;

  /// No description provided for @aiCompanionSuggestion2.
  ///
  /// In en, this message translates to:
  /// **'Quick gluten-free dinner ideas?'**
  String get aiCompanionSuggestion2;

  /// No description provided for @aiCompanionSuggestion3.
  ///
  /// In en, this message translates to:
  /// **'How do I temper Indian spices?'**
  String get aiCompanionSuggestion3;

  /// No description provided for @aiCompanionSuggestion4.
  ///
  /// In en, this message translates to:
  /// **'What goes well with kimchi?'**
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
  /// **'Email'**
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
  /// **'Sign in'**
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

  /// No description provided for @authFirebaseNote.
  ///
  /// In en, this message translates to:
  /// **'Note: ensure email/password sign-in is enabled in your Firebase console.'**
  String get authFirebaseNote;

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
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'ja',
    'ko',
    'th',
    'vi',
    'zh',
  ].contains(locale.languageCode);

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
    case 'th':
      return AppL10nTh();
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
