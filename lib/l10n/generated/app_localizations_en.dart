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
  String get navAiCreator => 'Creator';

  @override
  String get navAiCompanion => 'Companion';

  @override
  String get navSaved => 'Saved';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => 'Chinese';

  @override
  String get languageBurmese => 'Burmese';

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
  String get cuisineVietnamese => 'Vietnamese';

  @override
  String get cuisineIndian => 'Indian';

  @override
  String get cuisineItalian => 'Italian';

  @override
  String get cuisineAmericanWestern => 'American / Western';

  @override
  String get cuisineMexican => 'Mexican';

  @override
  String get cuisineFrench => 'French';

  @override
  String get cuisineGreek => 'Greek';

  @override
  String get cuisineSpanish => 'Spanish';

  @override
  String get cuisineMalaysian => 'Malaysian';

  @override
  String get cuisineGerman => 'German';

  @override
  String get cuisineIndonesian => 'Indonesian';

  @override
  String get exploreSearchHint => 'Search recipes, ingredients, tags';

  @override
  String get exploreSearchHintLong =>
      'Search recipes, ingredients, or cuisines...';

  @override
  String get heroBadge => 'CULINARY STUDIO';

  @override
  String get heroTitle => 'SpiceRoute';

  @override
  String heroSubtitle(int cuisines) {
    return 'Embark on a culinary journey across $cuisines distinct cultures. Filter authentic recipes, talk to our AI Chef, or generate custom translations.';
  }

  @override
  String brandTagline(int cuisines, int languages) {
    return '$cuisines cuisines · $languages languages';
  }

  @override
  String exploreResultCount(int count, String scope) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Showing $count recipes in $scope',
      one: 'Showing 1 recipe in $scope',
      zero: 'No recipes in $scope',
    );
    return '$_temp0';
  }

  @override
  String get communityBadge => 'REAL-TIME SYNC';

  @override
  String get communityTitle => 'Community Culinary Board';

  @override
  String get communitySubtitle =>
      'See what other food lovers are cooking, or upload your own creations for any international cuisine!';

  @override
  String get communityShowcaseTitle => 'SHOWCASE YOUR DISH';

  @override
  String get communityUploadCta => 'Click to upload culinary creation';

  @override
  String get communityUploadHint => 'JPEG / PNG (automatically compressed)';

  @override
  String get communityChefLabel => 'CHEF / COOK NAME';

  @override
  String get communityChefHint => 'e.g. Nonna Sophia, Alex';

  @override
  String get communityCaptionLabel => 'CAPTION / STORY';

  @override
  String get communityCaptionHint =>
      'Made this for Sunday dinner! Replaced with fresh herbs.';

  @override
  String get communityShareBtn => 'SHARE TO LIVE BOARD';

  @override
  String communityFeedTitle(int count) {
    return 'LIVE FEED ($count PHOTOS)';
  }

  @override
  String get communityEmptyTitle => 'No community photos yet';

  @override
  String get communityEmptySubtitle =>
      'Be the first to upload a photo of your cooked masterwork here for this cuisine!';

  @override
  String get communitySharedToast => 'Shared to the live board!';

  @override
  String communityByLine(String name) {
    return 'by $name';
  }

  @override
  String get communityRemovePhoto => 'REMOVE PHOTO';

  @override
  String get communityUploading => 'Compressing & sharing…';

  @override
  String get communityUploaded =>
      'Successfully published to live community feed';

  @override
  String get communityUploadErrorPhotoTooLarge =>
      'Photo is too large, try a smaller image.';

  @override
  String get communityUploadErrorPickFailed =>
      'Couldn\'t open the photo picker. Check the app\'s photo permission and try again.';

  @override
  String get communityUploadErrorGeneric =>
      'Couldn\'t share photo. Try again in a moment.';

  @override
  String communityFilteredTo(String cuisine) {
    return 'Filtered: $cuisine';
  }

  @override
  String storiesHeading(String cuisine) {
    return '$cuisine Culinary Heritage & Connections';
  }

  @override
  String get storiesSubtitle =>
      'Explore traditional course approaches and heritage stories — tap a card to filter the recipes.';

  @override
  String get storiesActiveBadge => 'ACTIVE';

  @override
  String get footerBlurb =>
      'An elegant culinary gateway offering curated recipes across many distinct culinary traditions. Elevate your home cooking with international flavors and real-time AI assistance.';

  @override
  String get footerQuickNav => 'QUICK NAVIGATION';

  @override
  String get footerLinkExplore => 'Explore Recipes';

  @override
  String get footerLinkCreator => 'AI Recipe Creator';

  @override
  String get footerLinkCompanion => 'AI Chef Companion';

  @override
  String get footerLinkSaved => 'My Saved Cookbook';

  @override
  String get footerConnect => 'CONNECT WITH US';

  @override
  String get footerEmailHint => 'Your email address';

  @override
  String get footerJoin => 'Join Hub';

  @override
  String get footerJoinedToast => 'Thanks for joining the hub!';

  @override
  String footerCopyright(int year, String brand) {
    return '© $year $brand. All rights reserved.';
  }

  @override
  String get footerLicense => 'Released under the MIT License.';

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
  String get exploreByRegion => 'EXPLORE BY GEOGRAPHIC REGION';

  @override
  String get selectCuisineTradition => 'SELECT CUISINE TRADITION';

  @override
  String get regionEastAsia => 'East Asian Countries';

  @override
  String get regionMainlandSoutheastAsia => 'Mainland Southeast Asia';

  @override
  String get regionMaritimeSoutheastAsia => 'Maritime Southeast Asia';

  @override
  String get regionSouthAsia => 'South Asian';

  @override
  String get regionEurope => 'European';

  @override
  String get regionAmericas => 'Americas';

  @override
  String get regionMiddleEastAfrica => 'Middle Eastern & African';

  @override
  String get courseGroupEarlyDay => 'Early Day';

  @override
  String get courseGroupDaytimeCasual => 'Daytime / Casual';

  @override
  String get courseGroupBeforeMain => 'Before the Main';

  @override
  String get courseGroupMainEvent => 'The Main Event';

  @override
  String get courseGroupSweetEnding => 'Sweet Ending';

  @override
  String get courseGroupAfterHours => 'After Hours';

  @override
  String get courseGroupLiquids => 'Liquids';

  @override
  String get courseBreakfast => 'Breakfast & Brunch';

  @override
  String get courseHighTea => 'High Tea & Afternoon Tea';

  @override
  String get courseLunch => 'Lunch & Box Lunch';

  @override
  String get courseSoupsSaladsBowls => 'Soups, Broths & Salads';

  @override
  String get courseAppetizer => 'Appetizers, Starters & Finger Foods';

  @override
  String get courseSharingBoards => 'Sharing Platters, Boards & Charcuterie';

  @override
  String get courseMainCourse => 'High-Protein Main Courses';

  @override
  String get courseSideDish => 'Side Dishes';

  @override
  String get courseDessert => 'Desserts & Sweets';

  @override
  String get courseSnack => 'Snacks & Late-Night Bites';

  @override
  String get courseAlcoholicDrinks => 'Alcoholic Drinks & Cocktails';

  @override
  String get courseZeroProofDrinks => 'Non-Alcoholic Beverages';

  @override
  String get dietaryVegan => 'Vegan';

  @override
  String get dietaryVegetarian => 'Vegetarian';

  @override
  String get dietaryMealPrep => 'Meal Prep';

  @override
  String get dietaryQuickEasy => 'Quick & Easy';

  @override
  String get dietaryPastaSoup => 'Pasta & Soup';

  @override
  String get dietaryBloodSugarBalanced => 'Blood Sugar Balanced';

  @override
  String get dietarySwicy => '\"Swicy\" (Sweet & Spicy)';

  @override
  String get dietaryAntiInflammatory => 'Anti-Inflammatory & Longevity';

  @override
  String get dietaryGlutenFree => 'Gluten-Free';

  @override
  String get dietaryDairyFree => 'Dairy-Free';

  @override
  String get dietaryNutFree => 'Nut-Free';

  @override
  String get dietaryEggFree => 'Egg-Free';

  @override
  String get dietaryGroupRestrictions => 'Dietary Restrictions';

  @override
  String get dietaryGroupAllergenFree => 'Allergen-Free';

  @override
  String get dietaryGroupWellness => 'Wellness & Lifestyles';

  @override
  String get dietaryGroupCookingFormats => 'Cooking Formats';

  @override
  String get filterSearchCourses => 'Search courses (e.g. Dessert, Main…)';

  @override
  String get filterSearchDietary => 'Search diets (e.g. Gluten-Free, Vegan…)';

  @override
  String get filterTabCourse => 'By Course';

  @override
  String get filterTabDiet => 'By Diet & Lifestyle';

  @override
  String get filterCourseHeading => 'COURSE SELECTION FILTERS';

  @override
  String get filterDietHeading => 'DIETARY & LIFESTYLE RESTRICTIONS';

  @override
  String get filterMobilePillHint => 'Filter recipes';

  @override
  String filterChoicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count choices',
      one: '1 choice',
    );
    return '$_temp0';
  }

  @override
  String get filterExpandAll => 'EXPAND ALL';

  @override
  String get filterCollapseAll => 'COLLAPSE ALL';

  @override
  String get filterNoMatches => 'No matches';

  @override
  String get filterClearSearch => 'Clear search';

  @override
  String get filterDismissMenu => 'Dismiss menu';

  @override
  String recipeMinutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String recipeHoursShort(int hours) {
    return '$hours h';
  }

  @override
  String recipeHoursMinutesShort(int hours, int minutes) {
    return '$hours h $minutes min';
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
  String get detailCookingInstructions => 'Cooking Instructions';

  @override
  String get detailPrepTime => 'Prep Time';

  @override
  String get detailCookTime => 'Cook Time';

  @override
  String get detailServingsShort => 'Servings';

  @override
  String get detailDifficultyEasy => 'Easy';

  @override
  String get detailDifficultyMedium => 'Medium';

  @override
  String get detailDifficultyHard => 'Hard';

  @override
  String get detailClose => 'Close';

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
  String get savedTitle => 'Saved';

  @override
  String get savedHeroSubtitle =>
      'Your personal cookbook. Bookmark dishes from any cuisine and they\'ll land here so you can revisit them anytime.';

  @override
  String savedCountHeading(int count) {
    return 'Saved ($count)';
  }

  @override
  String get savedEmptyTitle => 'Nothing saved yet';

  @override
  String get savedEmptySubtitle =>
      'You haven\'t saved any recipes yet. Tap the bookmark icon on any recipe card to start building your personal cookbook!';

  @override
  String get savedEmptyCta => 'Explore Recipes now';

  @override
  String get savedCloudSyncedBadge => 'CLOUD SYNCED';

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
  String get aiCreatorCardTitle => 'Generate Custom AI Recipe';

  @override
  String get aiCreatorCardSubtitle =>
      'Enter ingredients you have or a craving, and watch our AI Chef instantly cook up a custom step-by-step culinary masterpiece in your preferred language.';

  @override
  String get aiCreatorIngredientsLabel => 'Ingredients / Food Idea';

  @override
  String get aiCreatorIdeaHintLong =>
      'e.g. Tomato, eggs, scallions or \'A light healthy tofu dinner\'';

  @override
  String get aiCreatorCreateBtn => 'Create';

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
  String get aiCreatorQuote1 => 'Sharpening the knives and chopping scallions…';

  @override
  String get aiCreatorQuote2 => 'Roasting raw spices to unlock golden aromas…';

  @override
  String get aiCreatorQuote3 =>
      'Simmering authentic stock and checking seasonings…';

  @override
  String get aiCreatorQuote4 =>
      'Curating high-quality ingredients for your custom palate…';

  @override
  String get aiCreatorQuote5 =>
      'Assembling delicate step-by-step instructions for perfect execution…';

  @override
  String get aiCompanionTitle => 'AI Kitchen Companion';

  @override
  String get aiCompanionActiveFocus => 'Active Focus: Global';

  @override
  String get aiCompanionGreeting =>
      'Hi! I am your Global Gastronomy AI Chef. Ask me anything about ingredient substitutes, cooking tricks, or request a completely new custom recipe!';

  @override
  String get aiCompanionSuggestionsLabel => 'Gourmet Suggestions';

  @override
  String get aiCompanionEmptyTitle => 'Ask me anything about cooking';

  @override
  String get aiCompanionEmptySubtitle =>
      'Substitutes, techniques, dietary swaps - I\'ve got you.';

  @override
  String get aiCompanionInputHint =>
      'Ask AI how to make a dish, ask for keto/vegan options...';

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
  String aiCompanionActiveFocusCuisine(String cuisine) {
    return 'Active Focus: $cuisine';
  }

  @override
  String get aiCompanionSuggestion1 =>
      'What is a good vegetarian substitute for fish sauce?';

  @override
  String get aiCompanionSuggestion2 =>
      'Suggest an authentic side dish for Korean Kimchi Jjigae.';

  @override
  String get aiCompanionSuggestion3 =>
      'Can you explain Szechuan peppercorn numbing effect?';

  @override
  String get aiCompanionSuggestion4 =>
      'How do I control the heat level in Burmese Mohinga?';

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
  String get errorNetwork =>
      'Couldn\'t reach the server. Check your connection and try again.';

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
  String get authEmail => 'Email address';

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
  String get authSignInHere => 'Log in';

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
  String get authErrorProviderDisabled =>
      'This sign-in method isn\'t enabled for this app yet. Ask the operator to enable it in Firebase Console → Authentication → Sign-in method.';

  @override
  String get authErrorUnauthorizedDomain =>
      'This domain isn\'t authorized for Google sign-in. Add it in Firebase Console → Authentication → Settings → Authorized domains.';

  @override
  String get authErrorPopupBlocked =>
      'Your browser blocked the sign-in popup. Allow popups for this site and try again.';

  @override
  String get authErrorAccountExists =>
      'An account with this email already exists using a different sign-in method. Try signing in with email + password instead.';

  @override
  String get authSuccessSignIn => 'Logged in successfully. Happy cooking!';

  @override
  String get authSuccessRegister => 'Account registered successfully! Welcome!';

  @override
  String get authSuccessGoogle => 'Logged in with Google successfully!';

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

  @override
  String get detailStartCooking => 'Start cooking';

  @override
  String get cookExit => 'Exit cooking';

  @override
  String cookStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get cookPrev => 'Back';

  @override
  String get cookNext => 'Next';

  @override
  String get cookFinish => 'Finish cooking';

  @override
  String get cookFinishShort => 'Finish';

  @override
  String get cookStepDone => 'Mark step done';

  @override
  String get cookStepUndo => 'Mark as not done';

  @override
  String get cookIngredients => 'Ingredients';

  @override
  String cookIngredientsCount(int count) {
    return 'Ingredients ($count)';
  }

  @override
  String cookServingsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servings',
      one: '1 serving',
    );
    return '$_temp0';
  }

  @override
  String get cookServingsIncrease => 'More servings';

  @override
  String get cookServingsDecrease => 'Fewer servings';

  @override
  String get cookUnitsOriginal => 'Original';

  @override
  String get cookUnitsMetric => 'Metric';

  @override
  String get cookUnitsImperial => 'Imperial';

  @override
  String get cookFinishedTitle => 'All done!';

  @override
  String get cookFinishedBody => 'You finished every step. Bon appétit!';

  @override
  String get cookFinishedStay => 'Keep recipe open';

  @override
  String get cookFinishedExit => 'Exit cooking';

  @override
  String get cookNoStepsTitle => 'No steps yet';

  @override
  String get cookNoStepsBody =>
      'This recipe doesn\'t have step-by-step instructions to cook through.';

  @override
  String get cookBackToRecipe => 'Back to recipe';

  @override
  String get reviewsTitle => 'Community Gallery & Reviews';

  @override
  String get reviewsSubtitle =>
      'See creations from fellow home chefs, or upload a photo of your own cooking masterwork!';

  @override
  String get reviewsAverage => 'AVERAGE RATING';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
      zero: 'No reviews yet',
    );
    return '$_temp0';
  }

  @override
  String reviewsUploadedCooks(int count) {
    return 'Uploaded: $count';
  }

  @override
  String get reviewsEmptyState =>
      'No community photos shared yet. Be the first to cook and review this dish!';

  @override
  String get reviewsLoginPrompt =>
      'Please sign in to share your cooking and rate this recipe.';

  @override
  String get reviewsLoginCta => 'Sign in to review';

  @override
  String get reviewsFormTitle => 'Share Your Culinary Triumph';

  @override
  String get reviewsRatingLabel => 'Rating';

  @override
  String get reviewsAuthorLabel => 'Chef name';

  @override
  String get reviewsAuthorHint => 'Enter your nickname...';

  @override
  String get reviewsCommentLabel => 'Kitchen notes';

  @override
  String get reviewsCommentHint =>
      'How did it taste? Any substitutions or tips? (e.g. added extra garlic!)';

  @override
  String get reviewsPhotoHint => 'Tap to attach a photo of your cooked dish';

  @override
  String get reviewsPublishBtn => 'Publish to community';

  @override
  String get reviewsPublishing => 'Publishing…';

  @override
  String get reviewsSubmitted => 'Successfully added to the community gallery!';

  @override
  String get reviewsPostAnother => 'Post another review';

  @override
  String get reviewsPhotoTooLarge => 'Photo is too large, try a smaller image.';

  @override
  String get reviewsErrorGeneric => 'Couldn\'t post review. Try again.';

  @override
  String get reviewsDeleteTooltip => 'Delete review';

  @override
  String get reviewsDeleteConfirm => 'Delete your review?';

  @override
  String get reviewsAnonymousChef => 'Home Chef';

  @override
  String get reviewsLightboxCloseTooltip => 'Close photo';
}
