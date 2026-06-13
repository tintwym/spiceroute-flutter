// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppL10nZh extends AppL10n {
  AppL10nZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'SpiceRoute';

  @override
  String get navExplore => '探索';

  @override
  String get navAiCreator => '创作';

  @override
  String get navAiCompanion => '帮手';

  @override
  String get navSaved => '收藏';

  @override
  String get languageEnglish => '英语';

  @override
  String get languageChinese => '中文';

  @override
  String get languageBurmese => '缅甸语';

  @override
  String get languageJapanese => '日语';

  @override
  String get languageKorean => '韩语';

  @override
  String get languageVietnamese => '越南语';

  @override
  String get cuisineAll => '全部';

  @override
  String get cuisineKorean => '韩国菜';

  @override
  String get cuisineJapanese => '日本料理';

  @override
  String get cuisineChinese => '中国菜';

  @override
  String get cuisineBurmese => '缅甸菜';

  @override
  String get cuisineThai => '泰国菜';

  @override
  String get cuisineVietnamese => '越南菜';

  @override
  String get cuisineIndian => '印度菜';

  @override
  String get cuisineItalian => '意大利菜';

  @override
  String get cuisineAmericanWestern => '美式 / 西式';

  @override
  String get cuisineMexican => '墨西哥菜';

  @override
  String get cuisineFrench => '法国菜';

  @override
  String get cuisineGreek => '希腊菜';

  @override
  String get cuisineSpanish => '西班牙菜';

  @override
  String get cuisineMalaysian => '马来西亚菜';

  @override
  String get cuisineGerman => '德国菜';

  @override
  String get cuisineIndonesian => '印度尼西亚菜';

  @override
  String get exploreSearchHint => '搜索食谱、食材或标签';

  @override
  String get exploreSearchHintLong => '搜索菜谱、食材或菜系...';

  @override
  String get heroBadge => 'CULINARY STUDIO';

  @override
  String get heroTitle => 'SpiceRoute';

  @override
  String heroSubtitle(int cuisines) {
    return '开启横跨 $cuisines 种不同文化的美食之旅。筛选地道食谱、与 AI 大厨对话,或生成自定义翻译。';
  }

  @override
  String brandTagline(int cuisines, int languages) {
    return '$cuisines 种菜系 · $languages 种语言';
  }

  @override
  String exploreResultCount(int count, String scope) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '在 $scope 中显示 $count 道食谱',
      one: '在 $scope 中显示 1 道食谱',
      zero: '$scope没有食谱',
    );
    return '$_temp0';
  }

  @override
  String get communityBadge => '实时同步';

  @override
  String get communityTitle => '美食社区分享墙';

  @override
  String get communitySubtitle => '看看其他美食爱好者正在烹饪什么,或为任何国际菜系上传你自己的作品!';

  @override
  String get communityShowcaseTitle => '展示你的拿手菜';

  @override
  String get communityUploadCta => '点击上传美食作品';

  @override
  String get communityUploadHint => 'JPEG / PNG(自动压缩)';

  @override
  String get communityChefLabel => '厨师 / 主厨名字';

  @override
  String get communityChefHint => '如:Nonna Sophia、Alex';

  @override
  String get communityCaptionLabel => '标题 / 故事';

  @override
  String get communityCaptionHint => '做给周日晚餐!换成了新鲜香草。';

  @override
  String get communityShareBtn => '分享到实时墙';

  @override
  String communityFeedTitle(int count) {
    return '实时动态($count 张)';
  }

  @override
  String get communityEmptyTitle => '暂时没有社区照片';

  @override
  String get communityEmptySubtitle => '成为第一个为这道菜系上传作品照片的人!';

  @override
  String get communitySharedToast => '已分享到实时墙!';

  @override
  String communityByLine(String name) {
    return '@$name';
  }

  @override
  String get communityRemovePhoto => '重置照片';

  @override
  String get communityUploading => '正在压缩与分享…';

  @override
  String get communityUploaded => '已成功发布到实时美食社区';

  @override
  String get communityUploadErrorPhotoTooLarge => '照片太大,请选一张更小的图片。';

  @override
  String get communityUploadErrorPickFailed => '无法打开图库,请检查应用的相册权限后重试。';

  @override
  String get communityUploadErrorGeneric => '分享失败,请稍后再试。';

  @override
  String communityFilteredTo(String cuisine) {
    return '筛选中：$cuisine';
  }

  @override
  String storiesHeading(String cuisine) {
    return '$cuisine饮食文化与世际交融';
  }

  @override
  String get storiesSubtitle => '探索各餐期经典膳食与源远流长的历史背景，点击卡片可筛选食谱。';

  @override
  String get storiesActiveBadge => '进行中';

  @override
  String get footerBlurb =>
      '一座优雅的美食之门,精选来自多种饮食传统的食谱。借助国际风味与实时 AI 助手,让你的家常菜更上一层楼。';

  @override
  String get footerQuickNav => '快速导航';

  @override
  String get footerLinkExplore => '浏览食谱';

  @override
  String get footerLinkCreator => 'AI 食谱创作';

  @override
  String get footerLinkCompanion => 'AI 厨房助手';

  @override
  String get footerLinkSaved => '我的菜谱本';

  @override
  String get footerConnect => '联系我们';

  @override
  String get footerEmailHint => '你的邮箱';

  @override
  String get footerJoin => '加入';

  @override
  String get footerJoinedToast => '感谢加入!';

  @override
  String footerCopyright(int year, String brand) {
    return '© $year $brand. 保留所有权利。';
  }

  @override
  String get footerLicense => '基于 MIT 许可发布。';

  @override
  String get exploreEmptyTitle => '暂时没有匹配的食谱';

  @override
  String get exploreEmptySubtitle => '试试别的菜系,或清除搜索。';

  @override
  String get exploreErrorTitle => '无法加载食谱';

  @override
  String get exploreErrorRetry => '重试';

  @override
  String get filterCuisineLabel => '选择菜系';

  @override
  String get filterCourseLabel => '选择餐别';

  @override
  String get filterDietaryLabel => '饮食、生活方式与形式偏好';

  @override
  String get filterAllCuisines => '所有菜系';

  @override
  String get filterAllCourses => '所有餐别';

  @override
  String get filterAllDietary => '所有偏好';

  @override
  String get exploreByRegion => '按地区探索';

  @override
  String get selectCuisineTradition => '选择菜系传统';

  @override
  String get regionEastAsia => '东亚国家';

  @override
  String get regionMainlandSoutheastAsia => '中南半岛';

  @override
  String get regionMaritimeSoutheastAsia => '海洋东南亚';

  @override
  String get regionSouthAsia => '南亚';

  @override
  String get regionEurope => '欧洲';

  @override
  String get regionAmericas => '美洲';

  @override
  String get regionMiddleEastAfrica => '中东与非洲';

  @override
  String get courseGroupEarlyDay => '晨光时段';

  @override
  String get courseGroupDaytimeCasual => '白天 / 轻食';

  @override
  String get courseGroupBeforeMain => '主菜之前';

  @override
  String get courseGroupMainEvent => '主菜登场';

  @override
  String get courseGroupSweetEnding => '甜蜜收尾';

  @override
  String get courseGroupAfterHours => '深夜时光';

  @override
  String get courseGroupLiquids => '饮品';

  @override
  String get courseBreakfast => '早餐与早午餐';

  @override
  String get courseHighTea => '下午茶与高茶';

  @override
  String get courseLunch => '午餐与便当';

  @override
  String get courseSoupsSaladsBowls => '汤品、清汤与沙拉';

  @override
  String get courseAppetizer => '开胃菜、前菜与小食';

  @override
  String get courseSharingBoards => '分享拼盘、冷盘与熟食拼盘';

  @override
  String get courseMainCourse => '高蛋白主菜';

  @override
  String get courseSideDish => '配菜';

  @override
  String get courseDessert => '甜点与糖果';

  @override
  String get courseSnack => '零食与夜宵';

  @override
  String get courseAlcoholicDrinks => '酒类饮品与鸡尾酒';

  @override
  String get courseZeroProofDrinks => '无酒精饮品';

  @override
  String get dietaryVegan => '纯素';

  @override
  String get dietaryVegetarian => '素食';

  @override
  String get dietaryMealPrep => '备餐';

  @override
  String get dietaryQuickEasy => '快手简单';

  @override
  String get dietaryPastaSoup => '面食与汤品';

  @override
  String get dietaryBloodSugarBalanced => '血糖平衡';

  @override
  String get dietarySwicy => '「Swicy」 (甜辣)';

  @override
  String get dietaryAntiInflammatory => '抗炎与长寿';

  @override
  String get dietaryGlutenFree => '无麸质';

  @override
  String get dietaryDairyFree => '无乳制品';

  @override
  String get dietaryNutFree => '无坚果';

  @override
  String get dietaryEggFree => '无鸡蛋';

  @override
  String get dietaryGroupRestrictions => '饮食限制';

  @override
  String get dietaryGroupAllergenFree => '无过敏原';

  @override
  String get dietaryGroupWellness => '健康与生活方式';

  @override
  String get dietaryGroupCookingFormats => '烹饪方式';

  @override
  String get filterSearchCourses => '搜索餐式（如：甜点、主菜…）';

  @override
  String get filterSearchDietary => '搜索饮食偏好（如：无麸质、纯素…）';

  @override
  String get filterTabCourse => '按餐式';

  @override
  String get filterTabDiet => '按饮食偏好';

  @override
  String get filterCourseHeading => '餐式筛选';

  @override
  String get filterDietHeading => '饮食与生活方式';

  @override
  String filterChoicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 项',
      one: '1 项',
    );
    return '$_temp0';
  }

  @override
  String get filterExpandAll => '全部展开';

  @override
  String get filterCollapseAll => '全部收起';

  @override
  String get filterNoMatches => '无匹配项';

  @override
  String get filterClearSearch => '清除搜索';

  @override
  String get filterDismissMenu => '关闭菜单';

  @override
  String recipeMinutesShort(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String recipeHoursShort(int hours) {
    return '$hours 小时';
  }

  @override
  String recipeHoursMinutesShort(int hours, int minutes) {
    return '$hours 小时 $minutes 分钟';
  }

  @override
  String recipeServings(int count) {
    return '$count 人份';
  }

  @override
  String recipeKcal(int kcal) {
    return '$kcal 千卡';
  }

  @override
  String get recipePremiumBadge => '精选';

  @override
  String get recipeAiBadge => 'AI 生成';

  @override
  String get recipeSpiceLevel0 => '不辣';

  @override
  String get recipeSpiceLevel1 => '微辣';

  @override
  String get recipeSpiceLevel2 => '中辣';

  @override
  String get recipeSpiceLevel3 => '重辣';

  @override
  String get detailIngredients => '食材';

  @override
  String get detailCookingInstructions => '烹饪步骤';

  @override
  String get detailPrepTime => '准备时间';

  @override
  String get detailCookTime => '烹饪时间';

  @override
  String get detailServingsShort => '份量';

  @override
  String get detailDifficultyEasy => '简单';

  @override
  String get detailDifficultyMedium => '适中';

  @override
  String get detailDifficultyHard => '困难';

  @override
  String get detailClose => '关闭';

  @override
  String get detailSteps => '做法';

  @override
  String detailStepNumber(int number) {
    return '步骤 $number';
  }

  @override
  String get detailNoDescription => '暂无介绍。';

  @override
  String get detailSave => '收藏';

  @override
  String get detailSaved => '已收藏';

  @override
  String get detailUnsave => '取消收藏';

  @override
  String get detailShare => '分享';

  @override
  String get detailBack => '返回';

  @override
  String get savedTitle => '我的收藏';

  @override
  String get savedHeroSubtitle => '你的私人菜谱本。收藏任意菜系的菜品,它们都会出现在这里,方便随时回顾。';

  @override
  String savedCountHeading(int count) {
    return '我的收藏菜谱 ($count)';
  }

  @override
  String get savedEmptyTitle => '还没有收藏的食谱';

  @override
  String get savedEmptySubtitle => '在任意食谱上点心形,即可收藏在此。';

  @override
  String get savedEmptyCta => '立即浏览食谱';

  @override
  String get savedCloudSyncedBadge => '云端同步';

  @override
  String get savedClearAll => '全部清除';

  @override
  String get savedClearConfirm => '清空所有已收藏的食谱吗?';

  @override
  String get savedClearConfirmYes => '清除';

  @override
  String get savedClearConfirmNo => '取消';

  @override
  String get aiCreatorTitle => 'AI 食谱创作';

  @override
  String get aiCreatorCardTitle => '生成自定义 AI 食谱';

  @override
  String get aiCreatorCardSubtitle =>
      '输入手边的食材或想吃的口味,AI 大厨即刻为你用偏好的语言生成一份分步烹饪杰作。';

  @override
  String get aiCreatorIngredientsLabel => '食材 / 美食灵感';

  @override
  String get aiCreatorIdeaHintLong => '如:番茄、鸡蛋、葱花,或「清淡健康的豆腐晚餐」';

  @override
  String get aiCreatorCreateBtn => '生成';

  @override
  String get aiCreatorIdeaLabel => '今天想做点什么?';

  @override
  String get aiCreatorIdeaHint => '例如:用剩的红酒做一道暖心蘑菇意面';

  @override
  String get aiCreatorCuisineLabel => '菜系';

  @override
  String get aiCreatorCuisineAuto => '让 AI 帮我选';

  @override
  String get aiCreatorLanguageLabel => '食谱语言';

  @override
  String get aiCreatorGenerate => '生成食谱';

  @override
  String get aiCreatorRegenerate => '再来一次';

  @override
  String get aiCreatorSaveBtn => '加入我的收藏';

  @override
  String get aiCreatorSavedToast => '已收藏!可在「我的收藏」中查看。';

  @override
  String get aiCreatorErrorTitle => '生成食谱失败';

  @override
  String get aiCreatorRateLimited => '今天的免费生成次数用完了,明天再来吧。';

  @override
  String get aiCreatorQuote1 => '正在磨刀切葱花…';

  @override
  String get aiCreatorQuote2 => '正在烘焙香料,释放黄金香气…';

  @override
  String get aiCreatorQuote3 => '正在熬煮原汁高汤,精心调味…';

  @override
  String get aiCreatorQuote4 => '正在为你的口味甄选高品质食材…';

  @override
  String get aiCreatorQuote5 => '正在编写精细的分步说明,确保完美出菜…';

  @override
  String get aiCompanionTitle => 'AI 厨房帮手';

  @override
  String get aiCompanionActiveFocus => '当前焦点:全球';

  @override
  String get aiCompanionGreeting =>
      '你好!我是全球美食 AI 大厨。可以问我食材替代、烹饪技巧,或直接让我为你创作一份全新的定制食谱!';

  @override
  String get aiCompanionSuggestionsLabel => '美食灵感';

  @override
  String get aiCompanionEmptyTitle => '做饭遇到问题随时问我';

  @override
  String get aiCompanionEmptySubtitle => '替代食材、技法、饮食调整,都帮你想清楚。';

  @override
  String get aiCompanionInputHint => '输入你的问题...';

  @override
  String get aiCompanionSend => '发送';

  @override
  String get aiCompanionStop => '停止';

  @override
  String get aiCompanionClear => '清空对话';

  @override
  String get aiCompanionTyping => '正在思考...';

  @override
  String get aiCompanionRateLimited => '本小时消息次数过多,请稍后再试。';

  @override
  String aiCompanionActiveFocusCuisine(String cuisine) {
    return '当前焦点:$cuisine';
  }

  @override
  String get aiCompanionSuggestion1 => '鱼露的素食替代品?';

  @override
  String get aiCompanionSuggestion2 => '快手无麸质晚餐有哪些?';

  @override
  String get aiCompanionSuggestion3 => '如何爆香印度香料?';

  @override
  String get aiCompanionSuggestion4 => '什么菜配泡菜最好吃?';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsAppearance => '外观';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsThemeSystem => '跟随系统';

  @override
  String get settingsThemeLight => '浅色';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsAccount => '账户';

  @override
  String settingsAccountSignedInAs(String name) {
    return '已登录:$name';
  }

  @override
  String get settingsAccountGuest => '未登录';

  @override
  String get settingsAbout => '关于 SpiceRoute';

  @override
  String get settingsAboutBody =>
      'SpiceRoute 把世界各地的美食汇集在一个安静、美观的图书馆,并提供 AI 工具帮你为自己的厨房改造它们。';

  @override
  String settingsVersion(String version) {
    return '版本 $version';
  }

  @override
  String get settingsClose => '关闭';

  @override
  String get navSettings => '设置';

  @override
  String get commonClose => '关闭';

  @override
  String get commonCancel => '取消';

  @override
  String get commonRetry => '重试';

  @override
  String get commonError => '出错了';

  @override
  String get errorNetwork => '无法连接到服务器。请检查您的网络连接后重试。';

  @override
  String get commonLoading => '加载中...';

  @override
  String get commonNotFound => '未找到';

  @override
  String get commonOk => '确定';

  @override
  String get commonDelete => '删除';

  @override
  String get commonHome => '返回首页';

  @override
  String get authSignIn => '登录';

  @override
  String get authSignOut => '退出登录';

  @override
  String get authRegister => '创建账户';

  @override
  String get authAccount => '账户';

  @override
  String get authEmail => '邮箱';

  @override
  String get authPassword => '密码';

  @override
  String get authDisplayName => '昵称';

  @override
  String get authContinueWithGoogle => '使用 Google 登录';

  @override
  String get authOrDivider => '或';

  @override
  String get authForgotPassword => '忘记密码?';

  @override
  String get authResetSent => '如该邮箱已注册,我们已发送重置链接。';

  @override
  String get authNoAccountYet => '还没有账户?';

  @override
  String get authHasAccount => '已经有账户?';

  @override
  String get authSignUpHere => '立即创建';

  @override
  String get authSignInHere => '去登录';

  @override
  String get authProtectedTitle => '需要登录';

  @override
  String get authProtectedBody => '登录后再发布食谱,这样才能保留作者归属,并方便日后修改或删除。';

  @override
  String get authNotConfigured => '尚未配置登录功能,需添加 Firebase 配置。';

  @override
  String get authDevModeBanner =>
      '开发模式 - 尚未配置 Firebase。任何邮箱与密码都会在本设备上创建一个本地测试账号。';

  @override
  String get authWelcomeTitle => '欢迎回来';

  @override
  String get authWelcomeSubtitle => '登录后可同步你的私房食谱与烹饪笔记';

  @override
  String get authRegisterTitle => '创建美食账户';

  @override
  String get authRegisterSubtitle => '加入我们,同步并管理属于你的食谱';

  @override
  String get authNameLabel => '你的厨师名';

  @override
  String get authNameHint => '例如 Oliver 大厨';

  @override
  String get authEmailHint => 'chef@example.com';

  @override
  String get authPrimarySignIn => '进入工作室';

  @override
  String get authPrimaryRegister => '立即创建';

  @override
  String get authErrorInvalid => '邮箱或密码不正确。';

  @override
  String get authErrorEmailInUse => '该邮箱已被注册。';

  @override
  String get authErrorWeakPassword => '请使用更强的密码(至少 6 个字符)。';

  @override
  String get authErrorNetwork => '网络出错,请重试。';

  @override
  String get authErrorGeneric => '登录时出错。';

  @override
  String get authErrorProviderDisabled =>
      '此应用尚未启用此登录方式。请管理员在 Firebase Console → Authentication → Sign-in method 中启用。';

  @override
  String get authErrorUnauthorizedDomain =>
      '此域名未授权用于 Google 登录。请在 Firebase Console → Authentication → Settings → Authorized domains 中添加。';

  @override
  String get authErrorPopupBlocked => '浏览器拦截了登录弹窗。请允许此站点的弹出窗口后重试。';

  @override
  String get authErrorAccountExists => '此邮箱已使用其他登录方式注册。请改用邮箱和密码登录。';

  @override
  String get authSuccessSignIn => '登录成功,愿你做菜愉快!';

  @override
  String get authSuccessRegister => '账号创建成功!欢迎加入!';

  @override
  String get authSuccessGoogle => '已通过 Google 登录成功!';

  @override
  String get recipeOwnerYou => '由你发布';

  @override
  String recipeOwnerBy(String name) {
    return '作者:$name';
  }

  @override
  String get myRecipesTitle => '我的食谱';

  @override
  String get myRecipesEmptyTitle => '这里还是空的';

  @override
  String get myRecipesEmptySubtitle => '你发布的或在 AI 创作中保存的食谱会显示在此。';

  @override
  String get navMyRecipes => '我的';

  @override
  String get detailEdit => '编辑';

  @override
  String get detailDelete => '删除';

  @override
  String get detailDeleteConfirm => '删除这道食谱吗?此操作无法撤销。';

  @override
  String get detailDeleteOk => '删除';

  @override
  String get detailDeletedToast => '食谱已删除。';

  @override
  String get detailStartCooking => '开始烹饪';

  @override
  String get cookExit => '退出烹饪';

  @override
  String cookStepOf(int current, int total) {
    return '第 $current / $total 步';
  }

  @override
  String get cookPrev => '上一步';

  @override
  String get cookNext => '下一步';

  @override
  String get cookFinish => '完成烹饪';

  @override
  String get cookFinishShort => '完成';

  @override
  String get cookStepDone => '标记完成';

  @override
  String get cookStepUndo => '撤销完成';

  @override
  String get cookIngredients => '食材';

  @override
  String cookIngredientsCount(int count) {
    return '食材（$count）';
  }

  @override
  String cookServingsLabel(int count) {
    return '$count 人份';
  }

  @override
  String get cookServingsIncrease => '增加份量';

  @override
  String get cookServingsDecrease => '减少份量';

  @override
  String get cookUnitsOriginal => '原文';

  @override
  String get cookUnitsMetric => '公制';

  @override
  String get cookUnitsImperial => '英制';

  @override
  String get cookFinishedTitle => '全部完成！';

  @override
  String get cookFinishedBody => '您已完成所有步骤。祝您用餐愉快！';

  @override
  String get cookFinishedStay => '保留食谱';

  @override
  String get cookFinishedExit => '退出烹饪';

  @override
  String get cookNoStepsTitle => '暂无步骤';

  @override
  String get cookNoStepsBody => '此食谱尚未提供分步说明。';

  @override
  String get cookBackToRecipe => '返回食谱';

  @override
  String get reviewsTitle => '美食社区相册与评价';

  @override
  String get reviewsSubtitle => '看看其他家庭主厨的热情创作,或上传你亲手制作的美食大作!';

  @override
  String get reviewsAverage => '平均得分';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条评价',
      one: '1 条评价',
      zero: '暂无评价',
    );
    return '$_temp0';
  }

  @override
  String reviewsUploadedCooks(int count) {
    return '晒图数:$count';
  }

  @override
  String get reviewsEmptyState => '尚无社区分享照片。快来做这道菜,发表第一份晒照和评价吧!';

  @override
  String get reviewsLoginPrompt => '请登录以发表你的美食并评分。';

  @override
  String get reviewsLoginCta => '登录后即可评价';

  @override
  String get reviewsFormTitle => '分享你的丰盛之作';

  @override
  String get reviewsRatingLabel => '评分';

  @override
  String get reviewsAuthorLabel => '大厨姓名';

  @override
  String get reviewsAuthorHint => '请输入你的昵称…';

  @override
  String get reviewsCommentLabel => '烹饪心得';

  @override
  String get reviewsCommentHint => '味道如何?有什么小贴士吗?(例如:多加了点蒜蓉!)';

  @override
  String get reviewsPhotoHint => '轻触可附上你的成菜照片';

  @override
  String get reviewsPublishBtn => '发表到美食社区';

  @override
  String get reviewsPublishing => '正在发布…';

  @override
  String get reviewsSubmitted => '已成功加入社区美食墙!';

  @override
  String get reviewsPostAnother => '再发一条评价';

  @override
  String get reviewsPhotoTooLarge => '图片过大,请换张更小的图。';

  @override
  String get reviewsErrorGeneric => '发布失败,请稍后再试。';

  @override
  String get reviewsDeleteTooltip => '删除评价';

  @override
  String get reviewsDeleteConfirm => '要删除你的评价吗?';

  @override
  String get reviewsAnonymousChef => '民间主厨';

  @override
  String get reviewsLightboxCloseTooltip => '关闭图片';
}
