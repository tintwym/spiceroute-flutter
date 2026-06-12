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
  String get navAiCreator => 'Sáng tạo';

  @override
  String get navAiCompanion => 'Trợ lý';

  @override
  String get navSaved => 'Đã lưu';

  @override
  String get languageEnglish => 'Tiếng Anh';

  @override
  String get languageChinese => 'Tiếng Trung';

  @override
  String get languageBurmese => 'Tiếng Miến';

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
  String get cuisineVietnamese => 'Việt Nam';

  @override
  String get cuisineIndian => 'Ấn Độ';

  @override
  String get cuisineItalian => 'Ý';

  @override
  String get cuisineAmericanWestern => 'Mỹ / Phương Tây';

  @override
  String get cuisineMexican => 'Mexico';

  @override
  String get cuisineFrench => 'Pháp';

  @override
  String get cuisineGreek => 'Hy Lạp';

  @override
  String get cuisineSpanish => 'Tây Ban Nha';

  @override
  String get cuisineMalaysian => 'Malaysia';

  @override
  String get cuisineGerman => 'Đức';

  @override
  String get cuisineIndonesian => 'Indonesia';

  @override
  String get exploreSearchHint => 'Tìm công thức, nguyên liệu, thẻ';

  @override
  String get exploreSearchHintLong =>
      'Tìm công thức, nguyên liệu hoặc ẩm thực...';

  @override
  String get heroBadge => 'CULINARY STUDIO';

  @override
  String get heroTitle => 'SpiceRoute';

  @override
  String heroSubtitle(int cuisines) {
    return 'Hành trình ẩm thực qua $cuisines nền văn hóa khác biệt. Lọc công thức chính gốc, trò chuyện cùng AI Chef hoặc tạo bản dịch theo ý bạn.';
  }

  @override
  String brandTagline(int cuisines, int languages) {
    return '$cuisines ẩm thực · $languages ngôn ngữ';
  }

  @override
  String exploreResultCount(int count, String scope) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hiển thị $count công thức trong $scope',
      one: 'Hiển thị 1 công thức trong $scope',
      zero: 'Không có công thức trong $scope',
    );
    return '$_temp0';
  }

  @override
  String get communityBadge => 'ĐỒNG BỘ THỜI GIAN THỰC';

  @override
  String get communityTitle => 'Bảng Ẩm Thực Cộng Đồng';

  @override
  String get communitySubtitle =>
      'Xem những người yêu ẩm thực khác đang nấu gì, hoặc tải lên tác phẩm của chính bạn cho bất kỳ nền ẩm thực quốc tế nào!';

  @override
  String get communityShowcaseTitle => 'Khoe Món Của Bạn';

  @override
  String get communityUploadCta => 'Bấm để tải ảnh tác phẩm ẩm thực';

  @override
  String get communityUploadHint => 'JPEG / PNG (tự động nén)';

  @override
  String get communityChefLabel => 'Tên đầu bếp';

  @override
  String get communityChefHint => 'Ví dụ: Nonna Sophia, Alex';

  @override
  String get communityCaptionLabel => 'Chú thích / Câu chuyện';

  @override
  String get communityCaptionHint =>
      'Làm cho bữa tối Chủ Nhật! Thay bằng thảo mộc tươi.';

  @override
  String get communityShareBtn => 'CHIA SẺ LÊN BẢNG TRỰC TIẾP';

  @override
  String communityFeedTitle(int count) {
    return 'BẢNG TIN TRỰC TIẾP ($count ẢNH)';
  }

  @override
  String get communityEmptyTitle => 'Chưa có ảnh nào';

  @override
  String get communityEmptySubtitle =>
      'Hãy là người đầu tiên đăng ảnh kiệt tác của bạn cho nền ẩm thực này!';

  @override
  String get communitySharedToast => 'Đã chia sẻ lên bảng trực tiếp!';

  @override
  String communityByLine(String name) {
    return 'bởi $name';
  }

  @override
  String get communityRemovePhoto => 'GỠ ẢNH';

  @override
  String get communityUploading => 'Đang nén và chia sẻ…';

  @override
  String get communityUploaded => 'Đã đăng lên bảng cộng đồng';

  @override
  String communityFilteredTo(String cuisine) {
    return 'Đã lọc: $cuisine';
  }

  @override
  String storiesHeading(String cuisine) {
    return 'Di sản ẩm thực $cuisine và sự giao thoa';
  }

  @override
  String get storiesSubtitle =>
      'Khám phá cách bày bữa truyền thống và câu chuyện văn hoá — chạm thẻ để lọc công thức.';

  @override
  String get storiesActiveBadge => 'ĐANG CHỌN';

  @override
  String get footerBlurb =>
      'Một cánh cổng ẩm thực thanh lịch tổng hợp các công thức chọn lọc từ nhiều truyền thống ẩm thực khác biệt. Nâng tầm bữa cơm nhà bạn bằng hương vị quốc tế và hỗ trợ AI theo thời gian thực.';

  @override
  String get footerQuickNav => 'ĐIỀU HƯỚNG NHANH';

  @override
  String get footerLinkExplore => 'Khám phá công thức';

  @override
  String get footerLinkCreator => 'AI Tạo Công Thức';

  @override
  String get footerLinkCompanion => 'AI Chef Đồng Hành';

  @override
  String get footerLinkSaved => 'Sổ Tay Đã Lưu';

  @override
  String get footerConnect => 'KẾT NỐI VỚI CHÚNG TÔI';

  @override
  String get footerEmailHint => 'Địa chỉ email của bạn';

  @override
  String get footerJoin => 'Tham gia';

  @override
  String get footerJoinedToast => 'Cảm ơn bạn đã tham gia!';

  @override
  String footerCopyright(int year, String brand) {
    return '© $year $brand. Mọi quyền được bảo lưu.';
  }

  @override
  String get footerLicense => 'Phát hành theo Giấy phép MIT.';

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
  String get exploreByRegion => 'KHÁM PHÁ THEO KHU VỰC';

  @override
  String get selectCuisineTradition => 'CHỌN TRUYỀN THỐNG ẨM THỰC';

  @override
  String get regionEastAsia => 'Các nước Đông Á';

  @override
  String get regionMainlandSoutheastAsia => 'Đông Nam Á lục địa';

  @override
  String get regionMaritimeSoutheastAsia => 'Đông Nam Á hải đảo';

  @override
  String get regionSouthAsia => 'Nam Á';

  @override
  String get regionEurope => 'Châu Âu';

  @override
  String get regionAmericas => 'Châu Mỹ';

  @override
  String get regionMiddleEastAfrica => 'Trung Đông & Châu Phi';

  @override
  String get courseGroupEarlyDay => 'Đầu ngày';

  @override
  String get courseGroupDaytimeCasual => 'Ban ngày / Bữa nhẹ';

  @override
  String get courseGroupBeforeMain => 'Trước món chính';

  @override
  String get courseGroupMainEvent => 'Món chính';

  @override
  String get courseGroupSweetEnding => 'Kết thúc ngọt ngào';

  @override
  String get courseGroupAfterHours => 'Khuya';

  @override
  String get courseGroupLiquids => 'Đồ uống';

  @override
  String get courseBreakfast => 'Bữa sáng & Bữa xế';

  @override
  String get courseHighTea => 'Trà chiều & Tiệc trà';

  @override
  String get courseLunch => 'Bữa trưa & Cơm hộp';

  @override
  String get courseSoupsSaladsBowls => 'Súp, Nước dùng & Salad';

  @override
  String get courseAppetizer => 'Khai vị, Món mở đầu & Đồ ăn tay';

  @override
  String get courseSharingBoards => 'Khay chia sẻ, Đĩa & Charcuterie';

  @override
  String get courseMainCourse => 'Món chính giàu đạm';

  @override
  String get courseSideDish => 'Món phụ';

  @override
  String get courseDessert => 'Tráng miệng & Đồ ngọt';

  @override
  String get courseSnack => 'Ăn vặt & Bữa khuya';

  @override
  String get courseAlcoholicDrinks => 'Đồ uống có cồn & Cocktail';

  @override
  String get courseZeroProofDrinks => 'Đồ uống không cồn';

  @override
  String get dietaryVegan => 'Thuần chay';

  @override
  String get dietaryVegetarian => 'Ăn chay';

  @override
  String get dietaryMealPrep => 'Chuẩn bị sẵn';

  @override
  String get dietaryQuickEasy => 'Nhanh & Dễ';

  @override
  String get dietaryPastaSoup => 'Pasta & Súp';

  @override
  String get dietaryBloodSugarBalanced => 'Cân bằng đường huyết';

  @override
  String get dietarySwicy => '\"Swicy\" (Ngọt & Cay)';

  @override
  String get dietaryAntiInflammatory => 'Chống viêm & Trường thọ';

  @override
  String get dietaryGroupRestrictions => 'Hạn chế Ăn uống';

  @override
  String get dietaryGroupWellness => 'Sức khỏe & Lối sống';

  @override
  String get dietaryGroupCookingFormats => 'Cách nấu';

  @override
  String get filterSearchCourses => 'Tìm bữa ăn (vd: Tráng miệng, Món chính…)';

  @override
  String get filterSearchDietary =>
      'Tìm chế độ ăn (vd: Không Gluten, Thuần chay…)';

  @override
  String filterChoicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lựa chọn',
      one: '1 lựa chọn',
    );
    return '$_temp0';
  }

  @override
  String get filterExpandAll => 'MỞ TẤT CẢ';

  @override
  String get filterCollapseAll => 'ĐÓNG TẤT CẢ';

  @override
  String get filterNoMatches => 'Không tìm thấy';

  @override
  String get filterClearSearch => 'Xoá tìm kiếm';

  @override
  String get filterDismissMenu => 'Đóng menu';

  @override
  String recipeMinutesShort(int minutes) {
    return '$minutes phút';
  }

  @override
  String recipeHoursShort(int hours) {
    return '$hours giờ';
  }

  @override
  String recipeHoursMinutesShort(int hours, int minutes) {
    return '$hours giờ $minutes phút';
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
  String get detailCookingInstructions => 'Hướng dẫn nấu';

  @override
  String get detailPrepTime => 'Thời gian chuẩn bị';

  @override
  String get detailCookTime => 'Thời gian nấu';

  @override
  String get detailServingsShort => 'Khẩu phần';

  @override
  String get detailDifficultyEasy => 'Dễ';

  @override
  String get detailDifficultyMedium => 'Trung bình';

  @override
  String get detailDifficultyHard => 'Khó';

  @override
  String get detailClose => 'Đóng';

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
  String get savedHeroSubtitle =>
      'Sổ tay cá nhân của bạn. Đánh dấu món ăn từ bất kỳ nền ẩm thực nào và chúng sẽ xuất hiện tại đây để bạn xem lại bất cứ lúc nào.';

  @override
  String savedCountHeading(int count) {
    return 'Công thức đã lưu ($count)';
  }

  @override
  String get savedEmptyTitle => 'Chưa lưu công thức nào';

  @override
  String get savedEmptySubtitle =>
      'Nhấn vào biểu tượng tim ở bất kỳ công thức nào để lưu lại đây.';

  @override
  String get savedEmptyCta => 'Khám phá công thức ngay';

  @override
  String get savedCloudSyncedBadge => 'ĐỒNG BỘ ĐÁM MÂY';

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
  String get aiCreatorCardTitle => 'Tạo Công Thức AI Tùy Chỉnh';

  @override
  String get aiCreatorCardSubtitle =>
      'Nhập nguyên liệu bạn có hoặc món bạn thèm, và xem AI Chef ngay lập tức nấu nên một kiệt tác công thức từng bước trong ngôn ngữ bạn chọn.';

  @override
  String get aiCreatorIngredientsLabel => 'Nguyên liệu / Ý tưởng món ăn';

  @override
  String get aiCreatorIdeaHintLong =>
      'Ví dụ: Cà chua, trứng, hành lá hoặc \'Bữa tối nhẹ nhàng với đậu phụ\'';

  @override
  String get aiCreatorCreateBtn => 'Tạo';

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
  String get aiCreatorQuote1 => 'Đang mài dao và thái hành lá…';

  @override
  String get aiCreatorQuote2 => 'Đang rang gia vị để khơi hương thơm vàng óng…';

  @override
  String get aiCreatorQuote3 => 'Đang ninh nước dùng truyền thống và nêm nếm…';

  @override
  String get aiCreatorQuote4 =>
      'Đang chọn nguyên liệu chất lượng cao theo khẩu vị của bạn…';

  @override
  String get aiCreatorQuote5 =>
      'Đang biên soạn hướng dẫn từng bước cho một món hoàn hảo…';

  @override
  String get aiCompanionTitle => 'AI Trợ lý nhà bếp';

  @override
  String get aiCompanionActiveFocus => 'Trọng tâm: Toàn cầu';

  @override
  String get aiCompanionGreeting =>
      'Xin chào! Tôi là AI Chef Ẩm Thực Toàn Cầu. Hãy hỏi tôi về cách thay thế nguyên liệu, mẹo nấu ăn, hoặc yêu cầu một công thức hoàn toàn mới!';

  @override
  String get aiCompanionSuggestionsLabel => 'Gợi ý sành ăn';

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
  String aiCompanionActiveFocusCuisine(String cuisine) {
    return 'Trọng tâm: $cuisine';
  }

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
  String get authErrorProviderDisabled =>
      'Phương thức đăng nhập này chưa được bật cho ứng dụng. Vui lòng yêu cầu quản trị viên bật trong Firebase Console → Authentication → Sign-in method.';

  @override
  String get authErrorUnauthorizedDomain =>
      'Tên miền này chưa được ủy quyền cho đăng nhập Google. Thêm vào trong Firebase Console → Authentication → Settings → Authorized domains.';

  @override
  String get authErrorPopupBlocked =>
      'Trình duyệt đã chặn cửa sổ đăng nhập. Cho phép cửa sổ bật lên cho trang này rồi thử lại.';

  @override
  String get authErrorAccountExists =>
      'Email này đã được đăng ký bằng phương thức đăng nhập khác. Vui lòng đăng nhập bằng email và mật khẩu.';

  @override
  String get authSuccessSignIn => 'Đăng nhập thành công. Chúc nấu ăn vui vẻ!';

  @override
  String get authSuccessRegister => 'Tạo tài khoản thành công. Chào mừng bạn!';

  @override
  String get authSuccessGoogle => 'Đăng nhập Google thành công!';

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

  @override
  String get detailStartCooking => 'Bắt đầu nấu';

  @override
  String get cookExit => 'Thoát chế độ nấu';

  @override
  String cookStepOf(int current, int total) {
    return 'Bước $current / $total';
  }

  @override
  String get cookPrev => 'Trước';

  @override
  String get cookNext => 'Tiếp';

  @override
  String get cookFinish => 'Hoàn tất nấu';

  @override
  String get cookFinishShort => 'Xong';

  @override
  String get cookStepDone => 'Đánh dấu xong';

  @override
  String get cookStepUndo => 'Bỏ đánh dấu';

  @override
  String get cookIngredients => 'Nguyên liệu';

  @override
  String cookIngredientsCount(int count) {
    return 'Nguyên liệu ($count)';
  }

  @override
  String cookServingsLabel(int count) {
    return '$count phần';
  }

  @override
  String get cookServingsIncrease => 'Tăng khẩu phần';

  @override
  String get cookServingsDecrease => 'Giảm khẩu phần';

  @override
  String get cookUnitsOriginal => 'Gốc';

  @override
  String get cookUnitsMetric => 'Hệ mét';

  @override
  String get cookUnitsImperial => 'Hệ Anh';

  @override
  String get cookFinishedTitle => 'Hoàn thành!';

  @override
  String get cookFinishedBody =>
      'Bạn đã hoàn thành tất cả các bước. Chúc ngon miệng!';

  @override
  String get cookFinishedStay => 'Giữ công thức';

  @override
  String get cookFinishedExit => 'Thoát chế độ nấu';

  @override
  String get cookNoStepsTitle => 'Chưa có bước nào';

  @override
  String get cookNoStepsBody =>
      'Công thức này chưa có hướng dẫn từng bước để theo dõi.';

  @override
  String get cookBackToRecipe => 'Quay lại công thức';

  @override
  String get reviewsTitle => 'Thư viện cộng đồng & đánh giá';

  @override
  String get reviewsSubtitle =>
      'Xem tác phẩm của các đầu bếp tại gia khác, hoặc tải lên ảnh món bạn vừa nấu!';

  @override
  String get reviewsAverage => 'ĐIỂM TRUNG BÌNH';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count đánh giá',
      one: '1 đánh giá',
      zero: 'Chưa có đánh giá',
    );
    return '$_temp0';
  }

  @override
  String reviewsUploadedCooks(int count) {
    return 'Ảnh đã tải lên: $count';
  }

  @override
  String get reviewsEmptyState =>
      'Chưa có ảnh nào từ cộng đồng. Hãy là người đầu tiên nấu và đánh giá món này!';

  @override
  String get reviewsLoginPrompt =>
      'Vui lòng đăng nhập để chia sẻ món ăn và đánh giá công thức này.';

  @override
  String get reviewsLoginCta => 'Đăng nhập để đánh giá';

  @override
  String get reviewsFormTitle => 'Khoe thành quả của bạn';

  @override
  String get reviewsRatingLabel => 'Điểm';

  @override
  String get reviewsAuthorLabel => 'Tên đầu bếp';

  @override
  String get reviewsAuthorHint => 'Nhập biệt danh của bạn…';

  @override
  String get reviewsCommentLabel => 'Ghi chú bếp';

  @override
  String get reviewsCommentHint =>
      'Hương vị thế nào? Có thay thế hay mẹo gì không? (Ví dụ: thêm tỏi!)';

  @override
  String get reviewsPhotoHint => 'Nhấn để đính kèm ảnh món bạn nấu';

  @override
  String get reviewsPublishBtn => 'Đăng lên cộng đồng';

  @override
  String get reviewsPublishing => 'Đang đăng…';

  @override
  String get reviewsSubmitted => 'Đã thêm vào thư viện cộng đồng thành công!';

  @override
  String get reviewsPostAnother => 'Viết đánh giá khác';

  @override
  String get reviewsPhotoTooLarge => 'Ảnh quá lớn, thử ảnh nhỏ hơn.';

  @override
  String get reviewsErrorGeneric =>
      'Không gửi được đánh giá. Vui lòng thử lại.';

  @override
  String get reviewsDeleteTooltip => 'Xoá đánh giá';

  @override
  String get reviewsDeleteConfirm => 'Xoá đánh giá của bạn?';

  @override
  String get reviewsAnonymousChef => 'Đầu bếp tại gia';

  @override
  String get reviewsLightboxCloseTooltip => 'Đóng ảnh';
}
