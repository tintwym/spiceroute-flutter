// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SpiceRoute';

  @override
  String get navExplore => 'Explore';

  @override
  String get navAiCreator => 'AI Creator';

  @override
  String get navAiCompanion => 'AI Companion';

  @override
  String get navSaved => 'Saved';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => 'Chinese';

  @override
  String get languageThai => 'Thai';

  @override
  String get languageJapanese => 'Japanese';

  @override
  String get languageKorean => 'Korean';

  @override
  String get languageVietnamese => 'Vietnamese';

  @override
  String get cuisineAll => 'All';

  @override
  String get cuisineKorean => 'Korean';

  @override
  String get cuisineJapanese => 'Japanese';

  @override
  String get cuisineChinese => 'Chinese';

  @override
  String get cuisineBurmese => 'Burmese';

  @override
  String get cuisineThai => 'Thai';

  @override
  String get cuisineIndian => 'Indian';

  @override
  String get cuisineItalian => 'Italian';

  @override
  String get cuisineAmericanWestern => 'American/Western';

  @override
  String get cuisineMexican => 'Mexican';

  @override
  String get exploreSearchHint => 'Search recipes, ingredients, tags';

  @override
  String get exploreEmptyTitle => 'No recipes match yet';

  @override
  String get exploreEmptySubtitle =>
      'Try a different cuisine or clear the search.';

  @override
  String get exploreErrorTitle => 'Couldn\'t load recipes';

  @override
  String get exploreErrorRetry => 'Retry';

  @override
  String get filterCuisineLabel => 'SELECT CUISINE';

  @override
  String get filterCourseLabel => 'SELECT COURSE';

  @override
  String get filterDietaryLabel => 'DIETARY, LIFESTYLE & FORMAT RESTRICTIONS';

  @override
  String get filterAllCuisines => 'All Cuisines';

  @override
  String get filterAllCourses => 'All Courses';

  @override
  String get filterAllDietary => 'All Requests';

  @override
  String get courseBreakfast => 'Breakfast';

  @override
  String get courseLunch => 'Lunch';

  @override
  String get courseDinner => 'Dinner';

  @override
  String get courseAppetizer => 'Appetizer';

  @override
  String get courseMainCourse => 'Main course';

  @override
  String get courseSideDish => 'Side dish';

  @override
  String get courseSoup => 'Soup';

  @override
  String get courseSalad => 'Salad';

  @override
  String get courseSnack => 'Snack';

  @override
  String get courseDessert => 'Dessert';

  @override
  String get dietaryVegetarian => 'Vegetarian';

  @override
  String get dietaryVegan => 'Vegan';

  @override
  String get dietaryGlutenFree => 'Gluten-free';

  @override
  String get dietaryDairyFree => 'Dairy-free';

  @override
  String get dietaryNutFree => 'Nut-free';

  @override
  String get dietaryHighProtein => 'High-protein';

  @override
  String get dietaryLowCarb => 'Low-carb';

  @override
  String get dietaryQuick => 'Quick (under 30 min)';

  @override
  String recipeMinutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String recipeServings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servings',
      one: '1 serving',
    );
    return '$_temp0';
  }

  @override
  String recipeKcal(int kcal) {
    return '$kcal kcal';
  }

  @override
  String get recipePremiumBadge => 'Curated';

  @override
  String get recipeAiBadge => 'AI created';

  @override
  String get recipeSpiceLevel0 => 'Mild';

  @override
  String get recipeSpiceLevel1 => 'Light';

  @override
  String get recipeSpiceLevel2 => 'Spicy';

  @override
  String get recipeSpiceLevel3 => 'Fiery';

  @override
  String get detailIngredients => 'Ingredients';

  @override
  String get detailSteps => 'Steps';

  @override
  String detailStepNumber(int number) {
    return 'Step $number';
  }

  @override
  String get detailNoDescription => 'No description provided.';

  @override
  String get detailSave => 'Save';

  @override
  String get detailSaved => 'Saved';

  @override
  String get detailUnsave => 'Remove from saved';

  @override
  String get detailShare => 'Share';

  @override
  String get detailBack => 'Back';

  @override
  String get savedTitle => 'My Saved Recipes';

  @override
  String get savedEmptyTitle => 'Nothing saved yet';

  @override
  String get savedEmptySubtitle =>
      'Tap the heart on any recipe to keep it here.';

  @override
  String get savedClearAll => 'Clear all';

  @override
  String get savedClearConfirm => 'Clear all saved recipes?';

  @override
  String get savedClearConfirmYes => 'Clear';

  @override
  String get savedClearConfirmNo => 'Cancel';

  @override
  String get aiCreatorTitle => 'AI Recipe Creator';

  @override
  String get aiCreatorIdeaLabel => 'What do you feel like cooking?';

  @override
  String get aiCreatorIdeaHint => 'e.g. Cozy mushroom pasta with leftover wine';

  @override
  String get aiCreatorCuisineLabel => 'Cuisine';

  @override
  String get aiCreatorCuisineAuto => 'Let the AI choose';

  @override
  String get aiCreatorLanguageLabel => 'Language for the recipe';

  @override
  String get aiCreatorGenerate => 'Generate recipe';

  @override
  String get aiCreatorRegenerate => 'Try again';

  @override
  String get aiCreatorSaveBtn => 'Save to my recipes';

  @override
  String get aiCreatorSavedToast => 'Saved! You can find it in My Saved.';

  @override
  String get aiCreatorErrorTitle => 'Couldn\'t generate that recipe';

  @override
  String get aiCreatorRateLimited =>
      'You\'ve hit today\'s free generation limit. Try again tomorrow.';

  @override
  String get aiCompanionTitle => 'AI Kitchen Companion';

  @override
  String get aiCompanionEmptyTitle => 'Ask me anything about cooking';

  @override
  String get aiCompanionEmptySubtitle =>
      'Substitutes, techniques, dietary swaps - I\'ve got you.';

  @override
  String get aiCompanionInputHint => 'Type your question...';

  @override
  String get aiCompanionSend => 'Send';

  @override
  String get aiCompanionStop => 'Stop';

  @override
  String get aiCompanionClear => 'Clear chat';

  @override
  String get aiCompanionTyping => 'Thinking...';

  @override
  String get aiCompanionRateLimited =>
      'Too many messages this hour. Try again later.';

  @override
  String get aiCompanionSuggestion1 => 'Vegan substitute for fish sauce?';

  @override
  String get aiCompanionSuggestion2 => 'Quick gluten-free dinner ideas?';

  @override
  String get aiCompanionSuggestion3 => 'How do I temper Indian spices?';

  @override
  String get aiCompanionSuggestion4 => 'What goes well with kimchi?';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAccount => 'Account';

  @override
  String settingsAccountSignedInAs(String name) {
    return 'Signed in as $name';
  }

  @override
  String get settingsAccountGuest => 'Not signed in';

  @override
  String get settingsAbout => 'About SpiceRoute';

  @override
  String get settingsAboutBody =>
      'SpiceRoute brings together the foods of the world into one calm, beautiful library, plus AI tools to remix them for your kitchen.';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsClose => 'Close';

  @override
  String get navSettings => 'Settings';

  @override
  String get commonClose => 'Close';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonNotFound => 'Not found';

  @override
  String get commonOk => 'OK';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonHome => 'Back to home';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authSignOut => 'Sign out';

  @override
  String get authRegister => 'Create account';

  @override
  String get authAccount => 'Account';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authDisplayName => 'Display name';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authOrDivider => 'or';

  @override
  String get authForgotPassword => 'Forgot your password?';

  @override
  String get authResetSent =>
      'If that email is registered, a reset link is on its way.';

  @override
  String get authNoAccountYet => 'Don\'t have an account?';

  @override
  String get authHasAccount => 'Already have an account?';

  @override
  String get authSignUpHere => 'Create one';

  @override
  String get authSignInHere => 'Sign in';

  @override
  String get authProtectedTitle => 'Sign in required';

  @override
  String get authProtectedBody =>
      'Sign in to publish your recipe so it stays attributed to you and you can edit or remove it later.';

  @override
  String get authNotConfigured =>
      'Sign-in is not configured yet. Add Firebase config to enable it.';

  @override
  String get authDevModeBanner =>
      'Dev mode - Firebase isn\'t configured. Any email + password creates a local test account on this device.';

  @override
  String get authWelcomeTitle => 'Welcome Back';

  @override
  String get authWelcomeSubtitle =>
      'Login to retrieve your customized recipes and culinary logs';

  @override
  String get authRegisterTitle => 'Create Culinary Account';

  @override
  String get authRegisterSubtitle =>
      'Join us to synchronize and manage your bespoke recipes';

  @override
  String get authNameLabel => 'Your culinary name';

  @override
  String get authNameHint => 'e.g. Chef Oliver';

  @override
  String get authEmailHint => 'chef@example.com';

  @override
  String get authPrimarySignIn => 'Access Studio';

  @override
  String get authPrimaryRegister => 'Create Account';

  @override
  String get authFirebaseNote =>
      'Note: ensure email/password sign-in is enabled in your Firebase console.';

  @override
  String get authErrorInvalid => 'Email or password isn\'t right.';

  @override
  String get authErrorEmailInUse => 'That email is already registered.';

  @override
  String get authErrorWeakPassword =>
      'Pick a stronger password (at least 6 characters).';

  @override
  String get authErrorNetwork => 'Network error. Try again.';

  @override
  String get authErrorGeneric => 'Something went wrong with sign-in.';

  @override
  String get recipeOwnerYou => 'By you';

  @override
  String recipeOwnerBy(String name) {
    return 'By $name';
  }

  @override
  String get myRecipesTitle => 'My Recipes';

  @override
  String get myRecipesEmptyTitle => 'Nothing here yet';

  @override
  String get myRecipesEmptySubtitle =>
      'Recipes you publish or save with AI Creator will appear here.';

  @override
  String get navMyRecipes => 'Mine';

  @override
  String get detailEdit => 'Edit';

  @override
  String get detailDelete => 'Delete';

  @override
  String get detailDeleteConfirm =>
      'Delete this recipe? This can\'t be undone.';

  @override
  String get detailDeleteOk => 'Delete';

  @override
  String get detailDeletedToast => 'Recipe deleted.';
}
