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
  String get navAiCreator => 'AI 만들기';

  @override
  String get navAiCompanion => 'AI 도우미';

  @override
  String get navSaved => '저장';

  @override
  String get languageEnglish => '영어';

  @override
  String get languageChinese => '중국어';

  @override
  String get languageThai => '태국어';

  @override
  String get languageJapanese => '일본어';

  @override
  String get languageKorean => '한국어';

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
  String get cuisineIndian => '인도식';

  @override
  String get cuisineItalian => '이탈리안';

  @override
  String get cuisineAmericanWestern => '아메리칸 / 양식';

  @override
  String get cuisineMexican => '멕시칸';

  @override
  String get exploreSearchHint => '레시피, 재료, 태그 검색';

  @override
  String get exploreEmptyTitle => '일치하는 레시피가 없어요';

  @override
  String get exploreEmptySubtitle => '다른 음식을 골라보거나 검색을 비워 보세요.';

  @override
  String get exploreErrorTitle => '레시피를 불러오지 못했어요';

  @override
  String get exploreErrorRetry => '다시 시도';

  @override
  String recipeMinutesShort(int minutes) {
    return '$minutes분';
  }

  @override
  String recipeServings(int count) {
    return '$count인분';
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
  String get savedEmptyTitle => '아직 저장한 레시피가 없어요';

  @override
  String get savedEmptySubtitle => '마음에 드는 레시피의 하트를 눌러 저장하세요.';

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
  String get aiCompanionTitle => 'AI 주방 도우미';

  @override
  String get aiCompanionEmptyTitle => '요리에 관해 무엇이든 물어보세요';

  @override
  String get aiCompanionEmptySubtitle => '재료 대체, 기술, 식이 조절까지 도와드려요.';

  @override
  String get aiCompanionInputHint => '질문을 입력하세요…';

  @override
  String get aiCompanionSend => '보내기';

  @override
  String get aiCompanionStop => '중지';

  @override
  String get aiCompanionClear => '대화 비우기';

  @override
  String get aiCompanionTyping => '생각 중…';

  @override
  String get aiCompanionRateLimited => '이번 시간에 메시지가 너무 많아요. 잠시 후 다시 시도해 주세요.';

  @override
  String get aiCompanionSuggestion1 => '피쉬 소스의 비건 대체품은?';

  @override
  String get aiCompanionSuggestion2 => '글루텐프리 간단한 저녁 메뉴?';

  @override
  String get aiCompanionSuggestion3 => '인도 향신료를 어떻게 볶아요?';

  @override
  String get aiCompanionSuggestion4 => '김치와 잘 어울리는 음식은?';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsAbout => 'Savor 소개';

  @override
  String get settingsAboutBody =>
      'Savor 글로벌 레시피는 전 세계의 요리를 차분하고 아름다운 도서관에 모으고, AI 도구로 당신의 주방에 맞게 다듬어 줍니다.';

  @override
  String get settingsClose => '닫기';

  @override
  String get commonClose => '닫기';

  @override
  String get commonCancel => '취소';

  @override
  String get commonRetry => '다시 시도';

  @override
  String get commonError => '문제가 발생했어요';

  @override
  String get commonLoading => '불러오는 중…';

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
      '레시피를 공개로 등록하려면 로그인해 주세요. 작성자로 표시되고 나중에 수정·삭제할 수 있어요.';

  @override
  String get authNotConfigured => '로그인 설정이 아직 안 됐어요. Firebase 설정을 추가해 주세요.';

  @override
  String get authDevModeBanner =>
      '개발 모드 — Firebase가 설정돼 있지 않아요. 아무 이메일·비밀번호로 이 기기에 로컬 테스트 계정이 만들어져요.';

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
  String get authFirebaseNote => '참고: Firebase 콘솔에서 이메일/비밀번호 로그인을 활성화해 주세요.';

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
}
