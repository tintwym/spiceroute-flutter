// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppL10nKo extends AppL10n {
  AppL10nKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'SpiceRoute';

  @override
  String get navExplore => '탐색';

  @override
  String get navAiCreator => '만들기';

  @override
  String get navAiCompanion => '도우미';

  @override
  String get navSaved => '저장';

  @override
  String get languageEnglish => '영어';

  @override
  String get languageChinese => '중국어';

  @override
  String get languageBurmese => '버마어';

  @override
  String get languageJapanese => '일본어';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageVietnamese => '베트남어';

  @override
  String get cuisineAll => '전체';

  @override
  String get cuisineKorean => '한식';

  @override
  String get cuisineJapanese => '일식';

  @override
  String get cuisineChinese => '중식';

  @override
  String get cuisineBurmese => '미얀마식';

  @override
  String get cuisineThai => '태국식';

  @override
  String get cuisineVietnamese => '베트남식';

  @override
  String get cuisineIndian => '인도식';

  @override
  String get cuisineItalian => '이탈리안';

  @override
  String get cuisineAmericanWestern => '아메리칸 / 양식';

  @override
  String get cuisineMexican => '멕시칸';

  @override
  String get cuisineFrench => '프렌치';

  @override
  String get cuisineGreek => '그리스';

  @override
  String get cuisineSpanish => '스페인';

  @override
  String get cuisineMalaysian => '말레이시아';

  @override
  String get cuisineGerman => '독일';

  @override
  String get cuisineIndonesian => '인도네시아';

  @override
  String get exploreSearchHint => '레시피, 재료, 태그 검색';

  @override
  String get exploreSearchHintLong => '레시피, 재료 또는 요리를 검색...';

  @override
  String get heroBadge => 'CULINARY STUDIO';

  @override
  String get heroTitle => 'SpiceRoute';

  @override
  String heroSubtitle(int cuisines) {
    return '$cuisines가지 서로 다른 식문화를 둘러보는 미식 여행을 시작하세요. 정통 레시피를 필터링하고, AI 셰프와 대화하고, 원하는 언어로 번역을 만들어 보세요.';
  }

  @override
  String brandTagline(int cuisines, int languages) {
    return '요리 $cuisines가지 · 언어 $languages개';
  }

  @override
  String exploreResultCount(int count, String scope) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$scope에서 레시피 $count개 표시 중',
      one: '$scope에서 레시피 1개 표시 중',
      zero: '$scope에 레시피가 없어요',
    );
    return '$_temp0';
  }

  @override
  String get communityBadge => '실시간 동기화';

  @override
  String get communityTitle => '커뮤니티 요리 게시판';

  @override
  String get communitySubtitle =>
      '다른 음식 애호가들이 무엇을 만들고 있는지 살펴보거나, 어떤 세계 요리든 직접 만든 작품을 업로드하세요!';

  @override
  String get communityShowcaseTitle => '당신의 요리를 자랑하세요';

  @override
  String get communityUploadCta => '클릭해서 요리 사진을 업로드';

  @override
  String get communityUploadHint => 'JPEG / PNG (자동 압축)';

  @override
  String get communityChefLabel => '셰프 / 요리사 이름';

  @override
  String get communityChefHint => '예: 노나 소피아, 알렉스';

  @override
  String get communityCaptionLabel => '캡션 / 사연';

  @override
  String get communityCaptionHint => '일요일 저녁으로 만들었어요! 신선한 허브로 대체했어요.';

  @override
  String get communityShareBtn => '라이브 보드에 공유';

  @override
  String communityFeedTitle(int count) {
    return '라이브 피드 ($count장)';
  }

  @override
  String get communityEmptyTitle => '아직 사진이 없어요';

  @override
  String get communityEmptySubtitle => '이 요리의 첫 번째 작품 사진을 가장 먼저 올려 보세요!';

  @override
  String get communitySharedToast => '라이브 보드에 공유했어요!';

  @override
  String communityByLine(String name) {
    return '$name님';
  }

  @override
  String get communityRemovePhoto => '사진 삭제';

  @override
  String get communityUploading => '압축 후 공유 중…';

  @override
  String get communityUploaded => '라이브 피드에 공개되었습니다';

  @override
  String get communityUploadErrorPhotoTooLarge =>
      '사진이 너무 커요. 더 작은 이미지를 선택해 주세요.';

  @override
  String get communityUploadErrorPickFailed =>
      '사진 선택 화면을 열 수 없어요. 앱의 사진 권한을 확인한 뒤 다시 시도해 주세요.';

  @override
  String get communityUploadErrorGeneric => '사진을 공유하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String communityFilteredTo(String cuisine) {
    return '필터: $cuisine';
  }

  @override
  String storiesHeading(String cuisine) {
    return '$cuisine의 식문화 역사와 크로스컬처 연결';
  }

  @override
  String get storiesSubtitle =>
      '하루 한 끼, 식탁 위에 깃든 역사적 배경과 전통 접근법 요약 (카드를 클릭하여 필터링)';

  @override
  String get storiesActiveBadge => '선택됨';

  @override
  String get footerBlurb =>
      '다양한 요리 전통에서 엄선한 레시피를 모은 우아한 미식 게이트웨이. 국제적인 풍미와 실시간 AI 도움으로 가정 요리를 한 단계 끌어올리세요.';

  @override
  String get footerQuickNav => '퀵 내비게이션';

  @override
  String get footerLinkExplore => '레시피 탐색';

  @override
  String get footerLinkCreator => 'AI 레시피 작성기';

  @override
  String get footerLinkCompanion => 'AI 셰프 어시스턴트';

  @override
  String get footerLinkSaved => '내 저장 요리책';

  @override
  String get footerConnect => '함께하기';

  @override
  String get footerEmailHint => '이메일 주소';

  @override
  String get footerJoin => '허브 가입';

  @override
  String get footerJoinedToast => '허브 가입에 감사드려요!';

  @override
  String footerCopyright(int year, String brand) {
    return '© $year $brand. 모든 권리 보유.';
  }

  @override
  String get footerLicense => 'MIT 라이선스로 공개됩니다.';

  @override
  String get exploreEmptyTitle => '일치하는 레시피가 없어요';

  @override
  String get exploreEmptySubtitle => '다른 음식을 골라보거나 검색을 비워 보세요.';

  @override
  String get exploreErrorTitle => '레시피를 불러오지 못했어요';

  @override
  String get exploreErrorRetry => '다시 시도';

  @override
  String get filterCuisineLabel => '요리 분야 선택';

  @override
  String get filterCourseLabel => '코스 선택';

  @override
  String get filterDietaryLabel => '식단, 라이프스타일, 형식 제한';

  @override
  String get filterAllCuisines => '모든 요리';

  @override
  String get filterAllCourses => '모든 코스';

  @override
  String get filterAllDietary => '모든 조건';

  @override
  String get exploreByRegion => '지역별로 탐색';

  @override
  String get selectCuisineTradition => '요리 전통 선택';

  @override
  String get regionEastAsia => '동아시아 국가';

  @override
  String get regionMainlandSoutheastAsia => '동남아시아 본토';

  @override
  String get regionMaritimeSoutheastAsia => '해양 동남아시아';

  @override
  String get regionSouthAsia => '남아시아';

  @override
  String get regionEurope => '유럽';

  @override
  String get regionAmericas => '아메리카';

  @override
  String get regionMiddleEastAfrica => '중동 및 아프리카';

  @override
  String get courseGroupEarlyDay => '이른 하루';

  @override
  String get courseGroupDaytimeCasual => '낮 / 가벼운 식사';

  @override
  String get courseGroupBeforeMain => '메인 전에';

  @override
  String get courseGroupMainEvent => '메인 코스';

  @override
  String get courseGroupSweetEnding => '달콤한 마무리';

  @override
  String get courseGroupAfterHours => '야간 시간';

  @override
  String get courseGroupLiquids => '음료';

  @override
  String get courseBreakfast => '아침 & 브런치';

  @override
  String get courseHighTea => '하이 티 & 애프터눈 티';

  @override
  String get courseLunch => '점심 & 도시락';

  @override
  String get courseSoupsSaladsBowls => '수프, 브로스 & 샐러드';

  @override
  String get courseAppetizer => '전채, 스타터 & 핑거푸드';

  @override
  String get courseSharingBoards => '셰어링 플래터, 보드 & 샤퀴테리';

  @override
  String get courseMainCourse => '고단백 메인 코스';

  @override
  String get courseSideDish => '사이드 디시';

  @override
  String get courseDessert => '디저트 & 단 음식';

  @override
  String get courseSnack => '간식 & 야식';

  @override
  String get courseAlcoholicDrinks => '주류 & 칵테일';

  @override
  String get courseZeroProofDrinks => '무알코올 음료';

  @override
  String get dietaryVegan => '비건';

  @override
  String get dietaryVegetarian => '베지테리언';

  @override
  String get dietaryMealPrep => '밀프렙';

  @override
  String get dietaryQuickEasy => '빠르고 쉬운';

  @override
  String get dietaryPastaSoup => '파스타 & 수프';

  @override
  String get dietaryBloodSugarBalanced => '혈당 밸런스';

  @override
  String get dietarySwicy => '\"Swicy\" (달콤+매콤)';

  @override
  String get dietaryAntiInflammatory => '항염 & 장수';

  @override
  String get dietaryGlutenFree => '글루텐프리';

  @override
  String get dietaryDairyFree => '유제품 무첨가';

  @override
  String get dietaryNutFree => '견과류 무첨가';

  @override
  String get dietaryEggFree => '달걀 무첨가';

  @override
  String get dietaryGroupRestrictions => '식단 제한';

  @override
  String get dietaryGroupAllergenFree => '알레르기 유발 성분 제외';

  @override
  String get dietaryGroupWellness => '웰니스 & 라이프스타일';

  @override
  String get dietaryGroupCookingFormats => '조리 형식';

  @override
  String get filterSearchCourses => '코스 검색 (예: 디저트, 메인…)';

  @override
  String get filterSearchDietary => '식단 검색 (예: 글루텐프리, 비건…)';

  @override
  String filterChoicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개',
      one: '1개',
    );
    return '$_temp0';
  }

  @override
  String get filterExpandAll => '모두 펼치기';

  @override
  String get filterCollapseAll => '모두 접기';

  @override
  String get filterNoMatches => '일치 항목 없음';

  @override
  String get filterClearSearch => '검색 지우기';

  @override
  String get filterDismissMenu => '메뉴 닫기';

  @override
  String recipeMinutesShort(int minutes) {
    return '$minutes분';
  }

  @override
  String recipeHoursShort(int hours) {
    return '$hours시간';
  }

  @override
  String recipeHoursMinutesShort(int hours, int minutes) {
    return '$hours시간 $minutes분';
  }

  @override
  String recipeServings(int count) {
    return '$count인분';
  }

  @override
  String recipeKcal(int kcal) {
    return '$kcal kcal';
  }

  @override
  String get recipePremiumBadge => '엄선';

  @override
  String get recipeAiBadge => 'AI 생성';

  @override
  String get recipeSpiceLevel0 => '맵지 않음';

  @override
  String get recipeSpiceLevel1 => '약간 매움';

  @override
  String get recipeSpiceLevel2 => '매움';

  @override
  String get recipeSpiceLevel3 => '아주 매움';

  @override
  String get detailIngredients => '재료';

  @override
  String get detailCookingInstructions => '조리 방법';

  @override
  String get detailPrepTime => '준비 시간';

  @override
  String get detailCookTime => '조리 시간';

  @override
  String get detailServingsShort => '분량';

  @override
  String get detailDifficultyEasy => '쉬움';

  @override
  String get detailDifficultyMedium => '보통';

  @override
  String get detailDifficultyHard => '어려움';

  @override
  String get detailClose => '닫기';

  @override
  String get detailSteps => '조리법';

  @override
  String detailStepNumber(int number) {
    return '$number단계';
  }

  @override
  String get detailNoDescription => '설명이 없습니다.';

  @override
  String get detailSave => '저장';

  @override
  String get detailSaved => '저장됨';

  @override
  String get detailUnsave => '저장 해제';

  @override
  String get detailShare => '공유';

  @override
  String get detailBack => '뒤로';

  @override
  String get savedTitle => '내가 저장한 레시피';

  @override
  String get savedHeroSubtitle => '당신만의 요리책. 어떤 요리든 북마크해 두면 언제든 다시 꺼내 볼 수 있어요.';

  @override
  String savedCountHeading(int count) {
    return '내 저장 레시피 ($count)';
  }

  @override
  String get savedEmptyTitle => '아직 저장한 레시피가 없어요';

  @override
  String get savedEmptySubtitle => '마음에 드는 레시피의 하트를 눌러 저장하세요.';

  @override
  String get savedEmptyCta => '레시피 탐색하기';

  @override
  String get savedCloudSyncedBadge => '클라우드 동기화';

  @override
  String get savedClearAll => '전체 삭제';

  @override
  String get savedClearConfirm => '저장한 레시피를 모두 삭제할까요?';

  @override
  String get savedClearConfirmYes => '삭제';

  @override
  String get savedClearConfirmNo => '취소';

  @override
  String get aiCreatorTitle => 'AI 레시피 만들기';

  @override
  String get aiCreatorCardTitle => '맞춤 AI 레시피 생성';

  @override
  String get aiCreatorCardSubtitle =>
      '가지고 있는 재료나 먹고 싶은 것을 입력하면, AI 셰프가 원하는 언어로 단계별 맞춤 요리를 곧바로 만들어 드려요.';

  @override
  String get aiCreatorIngredientsLabel => '재료 / 아이디어';

  @override
  String get aiCreatorIdeaHintLong => '예: 토마토, 달걀, 쪽파 또는 \'가벼운 두부 저녁\'';

  @override
  String get aiCreatorCreateBtn => '만들기';

  @override
  String get aiCreatorIdeaLabel => '오늘은 무엇을 만들까요?';

  @override
  String get aiCreatorIdeaHint => '예: 남은 와인으로 만드는 따뜻한 버섯 파스타';

  @override
  String get aiCreatorCuisineLabel => '음식 종류';

  @override
  String get aiCreatorCuisineAuto => 'AI 가 골라줘요';

  @override
  String get aiCreatorLanguageLabel => '레시피 언어';

  @override
  String get aiCreatorGenerate => '레시피 생성';

  @override
  String get aiCreatorRegenerate => '다시 시도';

  @override
  String get aiCreatorSaveBtn => '내 레시피에 저장';

  @override
  String get aiCreatorSavedToast => '저장됐어요! \"저장\" 탭에서 볼 수 있어요.';

  @override
  String get aiCreatorErrorTitle => '레시피를 만들 수 없어요';

  @override
  String get aiCreatorRateLimited => '오늘의 무료 생성 한도를 모두 사용했어요. 내일 다시 시도해 주세요.';

  @override
  String get aiCreatorQuote1 => '칼을 갈고 대파를 다지는 중…';

  @override
  String get aiCreatorQuote2 => '향신료를 볶아 황금빛 향을 끌어올리는 중…';

  @override
  String get aiCreatorQuote3 => '정성스러운 육수를 끓이고 간을 맞추는 중…';

  @override
  String get aiCreatorQuote4 => '당신의 입맛에 맞춰 최상급 재료를 고르는 중…';

  @override
  String get aiCreatorQuote5 => '완벽한 결과를 위해 단계별 안내를 정리하는 중…';

  @override
  String get aiCompanionTitle => 'AI 주방 도우미';

  @override
  String get aiCompanionActiveFocus => '활성 포커스: 글로벌';

  @override
  String get aiCompanionGreeting =>
      '안녕하세요! 글로벌 미식 AI 셰프예요. 재료 대체, 요리 팁, 완전히 새로운 맞춤 레시피까지 무엇이든 물어보세요!';

  @override
  String get aiCompanionSuggestionsLabel => '고메 추천';

  @override
  String get aiCompanionEmptyTitle => '요리에 관해 무엇이든 물어보세요';

  @override
  String get aiCompanionEmptySubtitle => '재료 대체, 기술, 식이 조절까지 도와드려요.';

  @override
  String get aiCompanionInputHint => '질문을 입력하세요...';

  @override
  String get aiCompanionSend => '보내기';

  @override
  String get aiCompanionStop => '중지';

  @override
  String get aiCompanionClear => '대화 비우기';

  @override
  String get aiCompanionTyping => '생각 중...';

  @override
  String get aiCompanionRateLimited => '이번 시간에 메시지가 너무 많아요. 잠시 후 다시 시도해 주세요.';

  @override
  String aiCompanionActiveFocusCuisine(String cuisine) {
    return '활성 포커스: $cuisine';
  }

  @override
  String get aiCompanionSuggestion1 => '피쉬 소스의 비건 대체품은?';

  @override
  String get aiCompanionSuggestion2 => '글루텐프리 간단한 저녁 메뉴?';

  @override
  String get aiCompanionSuggestion3 => '인도 향신료를 어떻게 볶아요?';

  @override
  String get aiCompanionSuggestion4 => '김치와 잘 어울리는 음식은?';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsAppearance => '디스플레이';

  @override
  String get settingsTheme => '테마';

  @override
  String get settingsThemeSystem => '시스템 기본값';

  @override
  String get settingsThemeLight => '라이트';

  @override
  String get settingsThemeDark => '다크';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsAccount => '계정';

  @override
  String settingsAccountSignedInAs(String name) {
    return '$name 님으로 로그인됨';
  }

  @override
  String get settingsAccountGuest => '로그인되지 않음';

  @override
  String get settingsAbout => 'SpiceRoute 소개';

  @override
  String get settingsAboutBody =>
      'SpiceRoute는 전 세계의 요리를 차분하고 아름다운 도서관에 모으고, AI 도구로 당신의 주방에 맞게 다듬어 줍니다.';

  @override
  String settingsVersion(String version) {
    return '버전 $version';
  }

  @override
  String get settingsClose => '닫기';

  @override
  String get navSettings => '설정';

  @override
  String get commonClose => '닫기';

  @override
  String get commonCancel => '취소';

  @override
  String get commonRetry => '다시 시도';

  @override
  String get commonError => '문제가 발생했어요';

  @override
  String get errorNetwork => '서버에 연결할 수 없습니다. 인터넷 연결을 확인하고 다시 시도해 주세요.';

  @override
  String get commonLoading => '불러오는 중...';

  @override
  String get commonNotFound => '찾을 수 없음';

  @override
  String get commonOk => '확인';

  @override
  String get commonDelete => '삭제';

  @override
  String get commonHome => '홈으로 돌아가기';

  @override
  String get authSignIn => '로그인';

  @override
  String get authSignOut => '로그아웃';

  @override
  String get authRegister => '계정 만들기';

  @override
  String get authAccount => '계정';

  @override
  String get authEmail => '이메일';

  @override
  String get authPassword => '비밀번호';

  @override
  String get authDisplayName => '표시 이름';

  @override
  String get authContinueWithGoogle => 'Google로 계속하기';

  @override
  String get authOrDivider => '또는';

  @override
  String get authForgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get authResetSent => '등록된 이메일이라면 재설정 링크를 보내드렸어요.';

  @override
  String get authNoAccountYet => '아직 계정이 없으신가요?';

  @override
  String get authHasAccount => '이미 계정이 있나요?';

  @override
  String get authSignUpHere => '지금 만들기';

  @override
  String get authSignInHere => '로그인';

  @override
  String get authProtectedTitle => '로그인이 필요해요';

  @override
  String get authProtectedBody =>
      '레시피를 공개로 등록하려면 로그인해 주세요. 작성자로 표시되고 나중에 수정-삭제할 수 있어요.';

  @override
  String get authNotConfigured => '로그인 설정이 아직 안 됐어요. Firebase 설정을 추가해 주세요.';

  @override
  String get authDevModeBanner =>
      '개발 모드 - Firebase가 설정돼 있지 않아요. 아무 이메일-비밀번호로 이 기기에 로컬 테스트 계정이 만들어져요.';

  @override
  String get authWelcomeTitle => '다시 오신 걸 환영해요';

  @override
  String get authWelcomeSubtitle => '로그인하면 나만의 레시피와 요리 노트를 다시 볼 수 있어요';

  @override
  String get authRegisterTitle => '요리 계정 만들기';

  @override
  String get authRegisterSubtitle => '함께 가입해서 나만의 레시피를 동기화하고 관리해요';

  @override
  String get authNameLabel => '셰프 이름';

  @override
  String get authNameHint => '예: 셰프 올리버';

  @override
  String get authEmailHint => 'chef@example.com';

  @override
  String get authPrimarySignIn => '스튜디오 입장';

  @override
  String get authPrimaryRegister => '계정 만들기';

  @override
  String get authErrorInvalid => '이메일 또는 비밀번호가 올바르지 않아요.';

  @override
  String get authErrorEmailInUse => '이미 가입된 이메일이에요.';

  @override
  String get authErrorWeakPassword => '더 강한 비밀번호를 사용해 주세요 (6자 이상).';

  @override
  String get authErrorNetwork => '네트워크 오류예요. 다시 시도해 주세요.';

  @override
  String get authErrorGeneric => '로그인 중 오류가 발생했어요.';

  @override
  String get authErrorProviderDisabled =>
      '이 앱에서 이 로그인 방법이 아직 활성화되지 않았습니다. 관리자에게 Firebase Console → Authentication → Sign-in method 에서 활성화하도록 요청하세요.';

  @override
  String get authErrorUnauthorizedDomain =>
      '이 도메인은 Google 로그인을 위해 승인되지 않았습니다. Firebase Console → Authentication → Settings → Authorized domains 에서 추가하세요.';

  @override
  String get authErrorPopupBlocked =>
      '브라우저가 로그인 팝업을 차단했습니다. 이 사이트의 팝업을 허용하고 다시 시도하세요.';

  @override
  String get authErrorAccountExists =>
      '이 이메일은 다른 로그인 방식으로 이미 등록되어 있습니다. 이메일과 비밀번호로 로그인해 보세요.';

  @override
  String get authSuccessSignIn => '로그인되었습니다. 즐거운 요리 되세요!';

  @override
  String get authSuccessRegister => '계정이 생성되었습니다. 환영합니다!';

  @override
  String get authSuccessGoogle => 'Google 로그인 완료!';

  @override
  String get recipeOwnerYou => '내가 작성';

  @override
  String recipeOwnerBy(String name) {
    return '작성자: $name';
  }

  @override
  String get myRecipesTitle => '내 레시피';

  @override
  String get myRecipesEmptyTitle => '아직 비어 있어요';

  @override
  String get myRecipesEmptySubtitle =>
      '내가 등록하거나 AI Creator에서 저장한 레시피가 여기에 표시돼요.';

  @override
  String get navMyRecipes => '내 것';

  @override
  String get detailEdit => '수정';

  @override
  String get detailDelete => '삭제';

  @override
  String get detailDeleteConfirm => '이 레시피를 삭제할까요? 되돌릴 수 없어요.';

  @override
  String get detailDeleteOk => '삭제';

  @override
  String get detailDeletedToast => '레시피를 삭제했어요.';

  @override
  String get detailStartCooking => '요리 시작';

  @override
  String get cookExit => '요리 종료';

  @override
  String cookStepOf(int current, int total) {
    return '$total단계 중 $current단계';
  }

  @override
  String get cookPrev => '이전';

  @override
  String get cookNext => '다음';

  @override
  String get cookFinish => '요리 완료';

  @override
  String get cookFinishShort => '완료';

  @override
  String get cookStepDone => '완료 표시';

  @override
  String get cookStepUndo => '완료 해제';

  @override
  String get cookIngredients => '재료';

  @override
  String cookIngredientsCount(int count) {
    return '재료 ($count)';
  }

  @override
  String cookServingsLabel(int count) {
    return '$count인분';
  }

  @override
  String get cookServingsIncrease => '분량 늘리기';

  @override
  String get cookServingsDecrease => '분량 줄이기';

  @override
  String get cookUnitsOriginal => '원본';

  @override
  String get cookUnitsMetric => '미터법';

  @override
  String get cookUnitsImperial => '야드파운드';

  @override
  String get cookFinishedTitle => '모두 완료!';

  @override
  String get cookFinishedBody => '모든 단계를 마쳤어요. 맛있게 드세요!';

  @override
  String get cookFinishedStay => '레시피 그대로 두기';

  @override
  String get cookFinishedExit => '요리 종료';

  @override
  String get cookNoStepsTitle => '단계가 없어요';

  @override
  String get cookNoStepsBody => '이 레시피에는 아직 단계별 설명이 없습니다.';

  @override
  String get cookBackToRecipe => '레시피로 돌아가기';

  @override
  String get reviewsTitle => '커뮤니티 갤러리 및 후기';

  @override
  String get reviewsSubtitle => '다른 홈 셰프들의 요리 작품을 보거나, 직접 만든 요리 사진을 업로드해 보세요!';

  @override
  String get reviewsAverage => '평균 평점';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '후기 $count개',
      one: '후기 1개',
      zero: '아직 후기가 없습니다',
    );
    return '$_temp0';
  }

  @override
  String reviewsUploadedCooks(int count) {
    return '업로드 사진: $count';
  }

  @override
  String get reviewsEmptyState => '아직 등록된 사진이 없습니다. 직접 요리하고 첫 번째 후기를 작성해 보세요!';

  @override
  String get reviewsLoginPrompt => '요리를 등록하고 평점을 남기려면 먼저 로그인해 주세요.';

  @override
  String get reviewsLoginCta => '로그인하고 후기 남기기';

  @override
  String get reviewsFormTitle => '나만의 요리 인증하기';

  @override
  String get reviewsRatingLabel => '평점';

  @override
  String get reviewsAuthorLabel => '닉네임';

  @override
  String get reviewsAuthorHint => '여기에 닉네임을 적어주세요…';

  @override
  String get reviewsCommentLabel => '요리 한 줄 평';

  @override
  String get reviewsCommentHint =>
      '맛은 어땠나요? 나만의 꿀팁이나 대체 재료가 있다면 공유해 주세요 (예: 마늘 가득!)';

  @override
  String get reviewsPhotoHint => '탭하여 완성된 요리 사진을 첨부하세요';

  @override
  String get reviewsPublishBtn => '커뮤니티에 전송';

  @override
  String get reviewsPublishing => '게시 중…';

  @override
  String get reviewsSubmitted => '갤러리에 정상적으로 등록되었습니다!';

  @override
  String get reviewsPostAnother => '다른 후기 남기기';

  @override
  String get reviewsPhotoTooLarge => '사진이 너무 큽니다. 작은 사진으로 다시 시도해 주세요.';

  @override
  String get reviewsErrorGeneric => '후기 등록에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get reviewsDeleteTooltip => '후기 삭제';

  @override
  String get reviewsDeleteConfirm => '내 후기를 삭제하시겠어요?';

  @override
  String get reviewsAnonymousChef => '홈 셰프';

  @override
  String get reviewsLightboxCloseTooltip => '사진 닫기';
}
