// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppL10nJa extends AppL10n {
  AppL10nJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'SpiceRoute';

  @override
  String get navExplore => '探す';

  @override
  String get navAiCreator => 'AI作成';

  @override
  String get navAiCompanion => 'AIアシスタント';

  @override
  String get navSaved => '保存';

  @override
  String get languageEnglish => '英語';

  @override
  String get languageChinese => '中国語';

  @override
  String get languageThai => 'タイ語';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageKorean => '韓国語';

  @override
  String get cuisineAll => 'すべて';

  @override
  String get cuisineKorean => '韓国料理';

  @override
  String get cuisineJapanese => '和食';

  @override
  String get cuisineChinese => '中華';

  @override
  String get cuisineBurmese => 'ミャンマー料理';

  @override
  String get cuisineThai => 'タイ料理';

  @override
  String get cuisineIndian => 'インド料理';

  @override
  String get cuisineItalian => 'イタリアン';

  @override
  String get cuisineAmericanWestern => 'アメリカン / 洋食';

  @override
  String get cuisineMexican => 'メキシカン';

  @override
  String get exploreSearchHint => 'レシピ・食材・タグを検索';

  @override
  String get exploreEmptyTitle => '該当するレシピがありません';

  @override
  String get exploreEmptySubtitle => '別の料理ジャンルを試すか、検索をクリアしてください。';

  @override
  String get exploreErrorTitle => 'レシピを読み込めませんでした';

  @override
  String get exploreErrorRetry => '再試行';

  @override
  String recipeMinutesShort(int minutes) {
    return '$minutes 分';
  }

  @override
  String recipeServings(int count) {
    return '$count 人前';
  }

  @override
  String recipeKcal(int kcal) {
    return '$kcal kcal';
  }

  @override
  String get recipePremiumBadge => 'セレクト';

  @override
  String get recipeAiBadge => 'AI 生成';

  @override
  String get recipeSpiceLevel0 => '辛くない';

  @override
  String get recipeSpiceLevel1 => 'ピリ辛';

  @override
  String get recipeSpiceLevel2 => '辛口';

  @override
  String get recipeSpiceLevel3 => '激辛';

  @override
  String get detailIngredients => '材料';

  @override
  String get detailSteps => '作り方';

  @override
  String detailStepNumber(int number) {
    return 'ステップ $number';
  }

  @override
  String get detailNoDescription => '説明はありません。';

  @override
  String get detailSave => '保存';

  @override
  String get detailSaved => '保存済み';

  @override
  String get detailUnsave => '保存を解除';

  @override
  String get detailShare => '共有';

  @override
  String get detailBack => '戻る';

  @override
  String get savedTitle => '保存したレシピ';

  @override
  String get savedEmptyTitle => 'まだ保存はありません';

  @override
  String get savedEmptySubtitle => '気になるレシピのハートをタップで保存できます。';

  @override
  String get savedClearAll => 'すべて削除';

  @override
  String get savedClearConfirm => '保存したレシピをすべて削除しますか?';

  @override
  String get savedClearConfirmYes => '削除';

  @override
  String get savedClearConfirmNo => 'キャンセル';

  @override
  String get aiCreatorTitle => 'AI レシピ作成';

  @override
  String get aiCreatorIdeaLabel => '今日はどんなものを作りますか?';

  @override
  String get aiCreatorIdeaHint => '例:残ったワインで作る温かいきのこパスタ';

  @override
  String get aiCreatorCuisineLabel => '料理ジャンル';

  @override
  String get aiCreatorCuisineAuto => 'AI におまかせ';

  @override
  String get aiCreatorLanguageLabel => 'レシピの言語';

  @override
  String get aiCreatorGenerate => 'レシピを生成';

  @override
  String get aiCreatorRegenerate => 'もう一度';

  @override
  String get aiCreatorSaveBtn => 'マイレシピに保存';

  @override
  String get aiCreatorSavedToast => '保存しました!「保存」タブで確認できます。';

  @override
  String get aiCreatorErrorTitle => 'レシピの生成に失敗しました';

  @override
  String get aiCreatorRateLimited => '本日の無料生成回数を使い切りました。明日また試してください。';

  @override
  String get aiCompanionTitle => 'AI キッチンアシスタント';

  @override
  String get aiCompanionEmptyTitle => '料理について何でも聞いてください';

  @override
  String get aiCompanionEmptySubtitle => '代用品・テクニック・食事制限の調整、お任せを。';

  @override
  String get aiCompanionInputHint => '質問を入力...';

  @override
  String get aiCompanionSend => '送信';

  @override
  String get aiCompanionStop => '停止';

  @override
  String get aiCompanionClear => '会話をクリア';

  @override
  String get aiCompanionTyping => '考え中...';

  @override
  String get aiCompanionRateLimited => '1時間あたりの送信制限に達しました。後でもう一度どうぞ。';

  @override
  String get aiCompanionSuggestion1 => 'ナンプラーのヴィーガン代用品は?';

  @override
  String get aiCompanionSuggestion2 => 'グルテンフリーの簡単夕食は?';

  @override
  String get aiCompanionSuggestion3 => 'インドのスパイスをテンパリングするには?';

  @override
  String get aiCompanionSuggestion4 => 'キムチに合う料理は?';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsAppearance => '外観';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get settingsThemeSystem => 'システムに合わせる';

  @override
  String get settingsThemeLight => 'ライト';

  @override
  String get settingsThemeDark => 'ダーク';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsAccount => 'アカウント';

  @override
  String settingsAccountSignedInAs(String name) {
    return '$name としてサインイン中';
  }

  @override
  String get settingsAccountGuest => 'サインインしていません';

  @override
  String get settingsAbout => 'SpiceRoute について';

  @override
  String get settingsAboutBody =>
      'SpiceRoute は世界の料理を、静かで美しい一冊にまとめ、AI ツールであなたのキッチン用にアレンジします。';

  @override
  String settingsVersion(String version) {
    return 'バージョン $version';
  }

  @override
  String get settingsClose => '閉じる';

  @override
  String get navSettings => '設定';

  @override
  String get commonClose => '閉じる';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonRetry => '再試行';

  @override
  String get commonError => 'エラーが発生しました';

  @override
  String get commonLoading => '読み込み中...';

  @override
  String get commonNotFound => '見つかりません';

  @override
  String get commonOk => 'OK';

  @override
  String get commonDelete => '削除';

  @override
  String get commonHome => 'ホームに戻る';

  @override
  String get authSignIn => 'ログイン';

  @override
  String get authSignOut => 'ログアウト';

  @override
  String get authRegister => 'アカウント作成';

  @override
  String get authAccount => 'アカウント';

  @override
  String get authEmail => 'メールアドレス';

  @override
  String get authPassword => 'パスワード';

  @override
  String get authDisplayName => '表示名';

  @override
  String get authContinueWithGoogle => 'Google で続行';

  @override
  String get authOrDivider => 'または';

  @override
  String get authForgotPassword => 'パスワードを忘れた場合';

  @override
  String get authResetSent => '登録済みのメールにはリセット用リンクを送信しました。';

  @override
  String get authNoAccountYet => 'アカウントをお持ちではありませんか?';

  @override
  String get authHasAccount => 'アカウントをお持ちですか?';

  @override
  String get authSignUpHere => '作成する';

  @override
  String get authSignInHere => 'ログインする';

  @override
  String get authProtectedTitle => 'ログインが必要です';

  @override
  String get authProtectedBody =>
      'レシピを公開するにはログインしてください。投稿者として表示され、後で編集・削除できます。';

  @override
  String get authNotConfigured => 'ログインがまだ設定されていません。Firebase の設定を追加してください。';

  @override
  String get authDevModeBanner =>
      '開発モード - Firebase が未設定です。任意のメールとパスワードでこの端末にローカルテストアカウントが作成されます。';

  @override
  String get authWelcomeTitle => 'おかえりなさい';

  @override
  String get authWelcomeSubtitle => 'ログインしてカスタムレシピと料理メモを取り戻しましょう';

  @override
  String get authRegisterTitle => '料理アカウントを作成';

  @override
  String get authRegisterSubtitle => '登録してレシピを同期・管理しましょう';

  @override
  String get authNameLabel => 'あなたのシェフネーム';

  @override
  String get authNameHint => '例: シェフ・オリバー';

  @override
  String get authEmailHint => 'chef@example.com';

  @override
  String get authPrimarySignIn => 'スタジオへ';

  @override
  String get authPrimaryRegister => 'アカウント作成';

  @override
  String get authFirebaseNote => '注意: Firebase コンソールでメール/パスワードログインを有効にしてください。';

  @override
  String get authErrorInvalid => 'メールまたはパスワードが正しくありません。';

  @override
  String get authErrorEmailInUse => 'そのメールアドレスは既に登録されています。';

  @override
  String get authErrorWeakPassword => 'より強いパスワードを設定してください(6文字以上)。';

  @override
  String get authErrorNetwork => 'ネットワークエラーです。再試行してください。';

  @override
  String get authErrorGeneric => 'ログイン中にエラーが発生しました。';

  @override
  String get recipeOwnerYou => 'あなたが投稿';

  @override
  String recipeOwnerBy(String name) {
    return '投稿者: $name';
  }

  @override
  String get myRecipesTitle => 'マイレシピ';

  @override
  String get myRecipesEmptyTitle => 'まだ何もありません';

  @override
  String get myRecipesEmptySubtitle =>
      '公開したレシピや AI Creator で保存したレシピがここに表示されます。';

  @override
  String get navMyRecipes => 'マイ';

  @override
  String get detailEdit => '編集';

  @override
  String get detailDelete => '削除';

  @override
  String get detailDeleteConfirm => 'このレシピを削除しますか?元に戻せません。';

  @override
  String get detailDeleteOk => '削除';

  @override
  String get detailDeletedToast => 'レシピを削除しました。';
}
