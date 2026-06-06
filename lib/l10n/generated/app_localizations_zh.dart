// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppL10nZh extends AppL10n {
  AppL10nZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '环球美味食谱';

  @override
  String get navExplore => '探索';

  @override
  String get navAiCreator => 'AI 创作';

  @override
  String get navAiCompanion => 'AI 帮手';

  @override
  String get navSaved => '收藏';

  @override
  String get languageEnglish => '英语';

  @override
  String get languageChinese => '中文';

  @override
  String get languageThai => '泰语';

  @override
  String get languageJapanese => '日语';

  @override
  String get languageKorean => '韩语';

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
  String get cuisineIndian => '印度菜';

  @override
  String get cuisineItalian => '意大利菜';

  @override
  String get cuisineAmericanWestern => '美式 / 西式';

  @override
  String get cuisineMexican => '墨西哥菜';

  @override
  String get exploreSearchHint => '搜索食谱、食材或标签';

  @override
  String get exploreEmptyTitle => '暂时没有匹配的食谱';

  @override
  String get exploreEmptySubtitle => '试试别的菜系,或清除搜索。';

  @override
  String get exploreErrorTitle => '无法加载食谱';

  @override
  String get exploreErrorRetry => '重试';

  @override
  String recipeMinutesShort(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String recipeServings(int count) {
    return '$count 人份';
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
  String get savedEmptyTitle => '还没有收藏的食谱';

  @override
  String get savedEmptySubtitle => '在任意食谱上点心形,即可收藏在此。';

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
  String get aiCompanionTitle => 'AI 厨房帮手';

  @override
  String get aiCompanionEmptyTitle => '做饭遇到问题随时问我';

  @override
  String get aiCompanionEmptySubtitle => '替代食材、技法、饮食调整,都帮你想清楚。';

  @override
  String get aiCompanionInputHint => '输入你的问题…';

  @override
  String get aiCompanionSend => '发送';

  @override
  String get aiCompanionStop => '停止';

  @override
  String get aiCompanionClear => '清空对话';

  @override
  String get aiCompanionTyping => '正在思考…';

  @override
  String get aiCompanionRateLimited => '本小时消息次数过多,请稍后再试。';

  @override
  String get aiCompanionSuggestion1 => '鱼露的素食替代品?';

  @override
  String get aiCompanionSuggestion2 => '快手无麸质晚餐有哪些?';

  @override
  String get aiCompanionSuggestion3 => '如何爆香印度香料?';

  @override
  String get aiCompanionSuggestion4 => '什么菜配泡菜最好吃?';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsAbout => '关于 Savor';

  @override
  String get settingsAboutBody =>
      'Savor Global Recipes 把世界各地的美食汇集在一个安静、美观的图书馆,并提供 AI 工具帮你为自己的厨房改造它们。';

  @override
  String get settingsClose => '关闭';

  @override
  String get commonClose => '关闭';

  @override
  String get commonCancel => '取消';

  @override
  String get commonRetry => '重试';

  @override
  String get commonError => '出错了';

  @override
  String get commonLoading => '加载中…';

  @override
  String get commonNotFound => '未找到';

  @override
  String get commonOk => '确定';

  @override
  String get commonDelete => '删除';

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
      '开发模式 — 尚未配置 Firebase。任何邮箱与密码都会在本设备上创建一个本地测试账号。';

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
}
