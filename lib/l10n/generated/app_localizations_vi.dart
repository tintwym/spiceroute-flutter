// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppL10nVi extends AppL10n {
  AppL10nVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'SpiceRoute';

  @override
  String get navExplore => 'Khám phá';

  @override
  String get navAiCreator => 'AI Sáng tạo';

  @override
  String get navAiCompanion => 'AI Trợ lý';

  @override
  String get navSaved => 'Đã lưu';

  @override
  String get languageEnglish => 'Tiếng Anh';

  @override
  String get languageChinese => 'Tiếng Trung';

  @override
  String get languageThai => 'Tiếng Thái';

  @override
  String get languageJapanese => 'Tiếng Nhật';

  @override
  String get languageKorean => 'Tiếng Hàn';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get cuisineAll => 'Tất cả';

  @override
  String get cuisineKorean => 'Hàn Quốc';

  @override
  String get cuisineJapanese => 'Nhật Bản';

  @override
  String get cuisineChinese => 'Trung Hoa';

  @override
  String get cuisineBurmese => 'Myanmar';

  @override
  String get cuisineThai => 'Thái Lan';

  @override
  String get cuisineIndian => 'Ấn Độ';

  @override
  String get cuisineItalian => 'Ý';

  @override
  String get cuisineAmericanWestern => 'Mỹ / Phương Tây';

  @override
  String get cuisineMexican => 'Mexico';

  @override
  String get exploreSearchHint => 'Tìm công thức, nguyên liệu, thẻ';

  @override
  String get exploreEmptyTitle => 'Chưa có công thức phù hợp';

  @override
  String get exploreEmptySubtitle => 'Hãy thử món ăn khác hoặc xóa từ khóa.';

  @override
  String get exploreErrorTitle => 'Không tải được công thức';

  @override
  String get exploreErrorRetry => 'Thử lại';

  @override
  String get filterCuisineLabel => 'CHỌN ẨM THỰC';

  @override
  String get filterCourseLabel => 'CHỌN BỮA';

  @override
  String get filterDietaryLabel => 'CHẾ ĐỘ ĂN, LỐI SỐNG & ĐỊNH DẠNG';

  @override
  String get filterAllCuisines => 'Tất cả ẩm thực';

  @override
  String get filterAllCourses => 'Tất cả các bữa';

  @override
  String get filterAllDietary => 'Tất cả yêu cầu';

  @override
  String get courseBreakfast => 'Bữa sáng';

  @override
  String get courseLunch => 'Bữa trưa';

  @override
  String get courseDinner => 'Bữa tối';

  @override
  String get courseAppetizer => 'Khai vị';

  @override
  String get courseMainCourse => 'Món chính';

  @override
  String get courseSideDish => 'Món phụ';

  @override
  String get courseSoup => 'Súp';

  @override
  String get courseSalad => 'Salad';

  @override
  String get courseSnack => 'Ăn vặt';

  @override
  String get courseDessert => 'Tráng miệng';

  @override
  String get dietaryVegetarian => 'Ăn chay';

  @override
  String get dietaryVegan => 'Thuần chay';

  @override
  String get dietaryGlutenFree => 'Không gluten';

  @override
  String get dietaryDairyFree => 'Không sữa';

  @override
  String get dietaryNutFree => 'Không hạt';

  @override
  String get dietaryHighProtein => 'Giàu protein';

  @override
  String get dietaryLowCarb => 'Ít carb';

  @override
  String get dietaryQuick => 'Nhanh (dưới 30 phút)';

  @override
  String recipeMinutesShort(int minutes) {
    return '$minutes phút';
  }

  @override
  String recipeServings(int count) {
    return '$count phần';
  }

  @override
  String recipeKcal(int kcal) {
    return '$kcal kcal';
  }

  @override
  String get recipePremiumBadge => 'Tuyển chọn';

  @override
  String get recipeAiBadge => 'Tạo bởi AI';

  @override
  String get recipeSpiceLevel0 => 'Không cay';

  @override
  String get recipeSpiceLevel1 => 'Cay nhẹ';

  @override
  String get recipeSpiceLevel2 => 'Cay';

  @override
  String get recipeSpiceLevel3 => 'Rất cay';

  @override
  String get detailIngredients => 'Nguyên liệu';

  @override
  String get detailSteps => 'Cách làm';

  @override
  String detailStepNumber(int number) {
    return 'Bước $number';
  }

  @override
  String get detailNoDescription => 'Chưa có mô tả.';

  @override
  String get detailSave => 'Lưu';

  @override
  String get detailSaved => 'Đã lưu';

  @override
  String get detailUnsave => 'Bỏ lưu';

  @override
  String get detailShare => 'Chia sẻ';

  @override
  String get detailBack => 'Quay lại';

  @override
  String get savedTitle => 'Công thức đã lưu';

  @override
  String get savedEmptyTitle => 'Chưa lưu công thức nào';

  @override
  String get savedEmptySubtitle =>
      'Nhấn vào biểu tượng tim ở bất kỳ công thức nào để lưu lại đây.';

  @override
  String get savedClearAll => 'Xóa tất cả';

  @override
  String get savedClearConfirm => 'Xóa toàn bộ công thức đã lưu?';

  @override
  String get savedClearConfirmYes => 'Xóa';

  @override
  String get savedClearConfirmNo => 'Hủy';

  @override
  String get aiCreatorTitle => 'AI Tạo công thức';

  @override
  String get aiCreatorIdeaLabel => 'Hôm nay bạn muốn nấu món gì?';

  @override
  String get aiCreatorIdeaHint => 'VD: Mì pasta nấm ấm áp với rượu vang còn dư';

  @override
  String get aiCreatorCuisineLabel => 'Loại ẩm thực';

  @override
  String get aiCreatorCuisineAuto => 'Để AI tự chọn';

  @override
  String get aiCreatorLanguageLabel => 'Ngôn ngữ công thức';

  @override
  String get aiCreatorGenerate => 'Tạo công thức';

  @override
  String get aiCreatorRegenerate => 'Thử lại';

  @override
  String get aiCreatorSaveBtn => 'Lưu vào công thức của tôi';

  @override
  String get aiCreatorSavedToast => 'Đã lưu! Bạn có thể tìm trong mục Đã lưu.';

  @override
  String get aiCreatorErrorTitle => 'Không tạo được công thức';

  @override
  String get aiCreatorRateLimited =>
      'Bạn đã dùng hết lượt tạo miễn phí hôm nay. Hãy thử lại vào ngày mai.';

  @override
  String get aiCompanionTitle => 'AI Trợ lý nhà bếp';

  @override
  String get aiCompanionEmptyTitle => 'Hỏi tôi bất cứ điều gì về nấu ăn';

  @override
  String get aiCompanionEmptySubtitle =>
      'Nguyên liệu thay thế, kỹ thuật, điều chỉnh dinh dưỡng - cứ hỏi nhé.';

  @override
  String get aiCompanionInputHint => 'Nhập câu hỏi...';

  @override
  String get aiCompanionSend => 'Gửi';

  @override
  String get aiCompanionStop => 'Dừng';

  @override
  String get aiCompanionClear => 'Xóa hội thoại';

  @override
  String get aiCompanionTyping => 'Đang suy nghĩ...';

  @override
  String get aiCompanionRateLimited =>
      'Quá nhiều tin nhắn trong giờ này. Vui lòng thử lại sau.';

  @override
  String get aiCompanionSuggestion1 => 'Thay nước mắm cho người ăn chay?';

  @override
  String get aiCompanionSuggestion2 => 'Bữa tối không gluten đơn giản?';

  @override
  String get aiCompanionSuggestion3 => 'Cách phi gia vị Ấn Độ?';

  @override
  String get aiCompanionSuggestion4 => 'Món gì hợp với kim chi?';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsAppearance => 'Giao diện';

  @override
  String get settingsTheme => 'Chủ đề';

  @override
  String get settingsThemeSystem => 'Theo hệ thống';

  @override
  String get settingsThemeLight => 'Sáng';

  @override
  String get settingsThemeDark => 'Tối';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsAccount => 'Tài khoản';

  @override
  String settingsAccountSignedInAs(String name) {
    return 'Đăng nhập với tên $name';
  }

  @override
  String get settingsAccountGuest => 'Chưa đăng nhập';

  @override
  String get settingsAbout => 'Về SpiceRoute';

  @override
  String get settingsAboutBody =>
      'SpiceRoute mang ẩm thực thế giới đến với một thư viện gọn gàng, đẹp mắt, kèm công cụ AI để biến tấu cho căn bếp của bạn.';

  @override
  String settingsVersion(String version) {
    return 'Phiên bản $version';
  }

  @override
  String get settingsClose => 'Đóng';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get commonClose => 'Đóng';

  @override
  String get commonCancel => 'Hủy';

  @override
  String get commonRetry => 'Thử lại';

  @override
  String get commonError => 'Đã xảy ra lỗi';

  @override
  String get commonLoading => 'Đang tải...';

  @override
  String get commonNotFound => 'Không tìm thấy';

  @override
  String get commonOk => 'OK';

  @override
  String get commonDelete => 'Xóa';

  @override
  String get commonHome => 'Về trang chủ';

  @override
  String get authSignIn => 'Đăng nhập';

  @override
  String get authSignOut => 'Đăng xuất';

  @override
  String get authRegister => 'Tạo tài khoản';

  @override
  String get authAccount => 'Tài khoản';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Mật khẩu';

  @override
  String get authDisplayName => 'Tên hiển thị';

  @override
  String get authContinueWithGoogle => 'Tiếp tục với Google';

  @override
  String get authOrDivider => 'hoặc';

  @override
  String get authForgotPassword => 'Quên mật khẩu?';

  @override
  String get authResetSent =>
      'Nếu email đã đăng ký, liên kết đặt lại mật khẩu đã được gửi.';

  @override
  String get authNoAccountYet => 'Chưa có tài khoản?';

  @override
  String get authHasAccount => 'Đã có tài khoản?';

  @override
  String get authSignUpHere => 'Tạo ngay';

  @override
  String get authSignInHere => 'Đăng nhập';

  @override
  String get authProtectedTitle => 'Cần đăng nhập';

  @override
  String get authProtectedBody =>
      'Đăng nhập để đăng công thức của bạn, giữ tên tác giả và có thể chỉnh sửa hoặc xóa sau này.';

  @override
  String get authNotConfigured =>
      'Đăng nhập chưa được cấu hình. Hãy thêm cấu hình Firebase để bật.';

  @override
  String get authDevModeBanner =>
      'Chế độ dev - Firebase chưa được cấu hình. Bất kỳ email + mật khẩu nào cũng tạo tài khoản thử nghiệm cục bộ trên thiết bị này.';

  @override
  String get authWelcomeTitle => 'Chào mừng trở lại';

  @override
  String get authWelcomeSubtitle =>
      'Đăng nhập để truy cập công thức và nhật ký nấu ăn của bạn';

  @override
  String get authRegisterTitle => 'Tạo tài khoản đầu bếp';

  @override
  String get authRegisterSubtitle =>
      'Tham gia để đồng bộ và quản lý công thức riêng của bạn';

  @override
  String get authNameLabel => 'Tên đầu bếp của bạn';

  @override
  String get authNameHint => 'VD: Chef Oliver';

  @override
  String get authEmailHint => 'chef@example.com';

  @override
  String get authPrimarySignIn => 'Vào Studio';

  @override
  String get authPrimaryRegister => 'Tạo tài khoản';

  @override
  String get authFirebaseNote =>
      'Lưu ý: bật đăng nhập email/mật khẩu trong Firebase console.';

  @override
  String get authErrorInvalid => 'Email hoặc mật khẩu không đúng.';

  @override
  String get authErrorEmailInUse => 'Email này đã được đăng ký.';

  @override
  String get authErrorWeakPassword =>
      'Hãy chọn mật khẩu mạnh hơn (tối thiểu 6 ký tự).';

  @override
  String get authErrorNetwork => 'Lỗi mạng. Vui lòng thử lại.';

  @override
  String get authErrorGeneric => 'Đã xảy ra lỗi khi đăng nhập.';

  @override
  String get recipeOwnerYou => 'Tác giả: bạn';

  @override
  String recipeOwnerBy(String name) {
    return 'Tác giả: $name';
  }

  @override
  String get myRecipesTitle => 'Công thức của tôi';

  @override
  String get myRecipesEmptyTitle => 'Chưa có công thức nào';

  @override
  String get myRecipesEmptySubtitle =>
      'Công thức bạn đăng hoặc lưu từ AI Creator sẽ hiển thị ở đây.';

  @override
  String get navMyRecipes => 'Của tôi';

  @override
  String get detailEdit => 'Sửa';

  @override
  String get detailDelete => 'Xóa';

  @override
  String get detailDeleteConfirm => 'Xóa công thức này? Không thể hoàn tác.';

  @override
  String get detailDeleteOk => 'Xóa';

  @override
  String get detailDeletedToast => 'Đã xóa công thức.';
}
