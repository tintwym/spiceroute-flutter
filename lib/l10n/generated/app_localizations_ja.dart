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
  String get languageBurmese => 'ミャンマー語';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageKorean => '韓国語';

  @override
  String get languageVietnamese => 'ベトナム語';

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
  String get cuisineVietnamese => 'ベトナム料理';

  @override
  String get cuisineIndian => 'インド料理';

  @override
  String get cuisineItalian => 'イタリアン';

  @override
  String get cuisineAmericanWestern => 'アメリカン / 洋食';

  @override
  String get cuisineMexican => 'メキシカン';

  @override
  String get cuisineFrench => 'フレンチ';

  @override
  String get exploreSearchHint => 'レシピ・食材・タグを検索';

  @override
  String get exploreSearchHintLong => 'レシピ、食材、料理ジャンルで検索...';

  @override
  String get heroBadge => 'CULINARY STUDIO';

  @override
  String get heroTitle => 'SpiceRoute';

  @override
  String heroSubtitle(int cuisines) {
    return '$cuisines の異なる食文化を巡る料理の旅へ。本格レシピを絞り込み、AI シェフと会話し、好きな言語でカスタム翻訳を作成できます。';
  }

  @override
  String brandTagline(int cuisines, int languages) {
    return '料理 $cuisines 種 ・ 言語 $languages 種';
  }

  @override
  String exploreResultCount(int count, String scope) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$scopeのレシピを $count 件表示中',
      one: '$scopeのレシピを 1 件表示中',
      zero: '$scopeにレシピがありません',
    );
    return '$_temp0';
  }

  @override
  String get communityBadge => 'リアルタイム同期';

  @override
  String get communityTitle => 'コミュニティ・カリナリーボード';

  @override
  String get communitySubtitle =>
      'ほかのフード好きが今日作っている料理を見たり、世界中のどんな料理ジャンルでもあなたの一皿をシェアできます!';

  @override
  String get communityShowcaseTitle => 'あなたの一皿を披露';

  @override
  String get communityUploadCta => 'クリックして料理写真をアップロード';

  @override
  String get communityUploadHint => 'JPEG / PNG(自動圧縮)';

  @override
  String get communityChefLabel => 'シェフ名';

  @override
  String get communityChefHint => '例: ノンナ・ソフィア、アレックス';

  @override
  String get communityCaptionLabel => 'キャプション / エピソード';

  @override
  String get communityCaptionHint => '日曜日の夕食に。フレッシュハーブで代用しました!';

  @override
  String get communityShareBtn => 'ライブボードに共有';

  @override
  String communityFeedTitle(int count) {
    return 'ライブフィード ($count 枚)';
  }

  @override
  String get communityEmptyTitle => 'まだコミュニティ写真はありません';

  @override
  String get communityEmptySubtitle => 'この料理ジャンルの一枚を、いちばん最初にシェアしましょう!';

  @override
  String get communitySharedToast => 'ライブボードに共有しました!';

  @override
  String communityByLine(String name) {
    return 'by $name';
  }

  @override
  String get communityRemovePhoto => '写真を削除';

  @override
  String get communityUploading => '圧縮中・共有中…';

  @override
  String get communityUploaded => 'ライブフィードに公開しました';

  @override
  String communityFilteredTo(String cuisine) {
    return '絞り込み：$cuisine';
  }

  @override
  String storiesHeading(String cuisine) {
    return '$cuisineの食文化遺産と世界との繋がり';
  }

  @override
  String get storiesSubtitle => '朝食から夜食まで、伝統料理と歴史的な背景を探索（カードをタップでフィルター）';

  @override
  String get storiesActiveBadge => 'ACTIVE';

  @override
  String get footerBlurb =>
      '世界各地の料理伝統から厳選したレシピを揃えた、上品な料理ゲートウェイ。リアルタイム AI と共に、家庭料理を国際的な味へと格上げします。';

  @override
  String get footerQuickNav => 'クイックナビ';

  @override
  String get footerLinkExplore => 'レシピを探す';

  @override
  String get footerLinkCreator => 'AI レシピ作成';

  @override
  String get footerLinkCompanion => 'AI シェフアシスタント';

  @override
  String get footerLinkSaved => '保存したクックブック';

  @override
  String get footerConnect => 'つながる';

  @override
  String get footerEmailHint => 'メールアドレス';

  @override
  String get footerJoin => '参加する';

  @override
  String get footerJoinedToast => 'ご参加ありがとうございます!';

  @override
  String footerCopyright(int year, String brand) {
    return '© $year $brand. All rights reserved.';
  }

  @override
  String get footerLicense => 'MIT ライセンスで公開。';

  @override
  String get exploreEmptyTitle => '該当するレシピがありません';

  @override
  String get exploreEmptySubtitle => '別の料理ジャンルを試すか、検索をクリアしてください。';

  @override
  String get exploreErrorTitle => 'レシピを読み込めませんでした';

  @override
  String get exploreErrorRetry => '再試行';

  @override
  String get filterCuisineLabel => '料理ジャンルを選択';

  @override
  String get filterCourseLabel => 'コースを選択';

  @override
  String get filterDietaryLabel => '食事制限・ライフスタイル・形式';

  @override
  String get filterAllCuisines => 'すべての料理';

  @override
  String get filterAllCourses => 'すべてのコース';

  @override
  String get filterAllDietary => 'すべての条件';

  @override
  String get courseBreakfast => '朝食 & ブランチ';

  @override
  String get courseLunch => '昼食 / 弁当';

  @override
  String get courseAppetizer => '前菜・オードブル・フィンガーフード';

  @override
  String get courseSideDish => '副菜';

  @override
  String get courseDessert => 'デザート & スイーツ';

  @override
  String get courseSnack => 'おやつ & 夜食';

  @override
  String get courseDrinks => 'ドリンク & カクテル';

  @override
  String get dietaryVegan => 'ヴィーガン';

  @override
  String get dietaryVegetarian => 'ベジタリアン';

  @override
  String get dietaryMealPrep => '作り置き';

  @override
  String get dietaryQuickEasy => '時短・簡単';

  @override
  String get dietaryPastaSoup => 'パスタ & スープ';

  @override
  String get dietaryBloodSugarBalanced => '血糖値バランス';

  @override
  String get dietarySwicy => '「Swicy」 (甘辛)';

  @override
  String get dietaryAntiInflammatory => '抗炎症 & 長寿';

  @override
  String recipeMinutesShort(int minutes) {
    return '$minutes 分';
  }

  @override
  String recipeHoursShort(int hours) {
    return '$hours 時間';
  }

  @override
  String recipeHoursMinutesShort(int hours, int minutes) {
    return '$hours 時間 $minutes 分';
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
  String get detailCookingInstructions => '調理手順';

  @override
  String get detailPrepTime => '下準備';

  @override
  String get detailCookTime => '調理時間';

  @override
  String get detailServingsShort => '人数';

  @override
  String get detailDifficultyEasy => '簡単';

  @override
  String get detailDifficultyMedium => 'ふつう';

  @override
  String get detailDifficultyHard => '難しい';

  @override
  String get detailClose => '閉じる';

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
  String get savedHeroSubtitle =>
      'あなただけのクックブック。気に入った料理をブックマークすれば、いつでもここで見返せます。';

  @override
  String savedCountHeading(int count) {
    return '保存したレシピ ($count)';
  }

  @override
  String get savedEmptyTitle => 'まだ保存はありません';

  @override
  String get savedEmptySubtitle => '気になるレシピのハートをタップで保存できます。';

  @override
  String get savedEmptyCta => 'レシピを探す';

  @override
  String get savedCloudSyncedBadge => 'クラウド同期中';

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
  String get aiCreatorCardTitle => 'カスタム AI レシピを生成';

  @override
  String get aiCreatorCardSubtitle =>
      '手持ちの食材や食べたい気分を入力すると、AI シェフがあなたの好きな言語でステップ・バイ・ステップのオリジナル料理を即興で作ります。';

  @override
  String get aiCreatorIngredientsLabel => '食材 / アイデア';

  @override
  String get aiCreatorIdeaHintLong => '例: トマト、卵、ねぎ、または「軽くてヘルシーな豆腐ディナー」';

  @override
  String get aiCreatorCreateBtn => '作成';

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
  String get aiCreatorQuote1 => '包丁を研ぎ、ねぎを刻んでいます…';

  @override
  String get aiCreatorQuote2 => 'スパイスを焙煎し、黄金の香りを引き出しています…';

  @override
  String get aiCreatorQuote3 => '本格的なだしを煮込み、味を整えています…';

  @override
  String get aiCreatorQuote4 => 'あなたの好みに合わせて高品質な食材を厳選中…';

  @override
  String get aiCreatorQuote5 => '完璧な仕上がりのために繊細なステップを組み立てています…';

  @override
  String get aiCompanionTitle => 'AI キッチンアシスタント';

  @override
  String get aiCompanionActiveFocus => 'アクティブフォーカス: グローバル';

  @override
  String get aiCompanionGreeting =>
      'こんにちは!グローバル美食 AI シェフです。食材の代用、調理のコツ、全く新しいオリジナルレシピのリクエストまで、何でも聞いてください!';

  @override
  String get aiCompanionSuggestionsLabel => 'おすすめ';

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
  String aiCompanionActiveFocusCuisine(String cuisine) {
    return 'アクティブフォーカス: $cuisine';
  }

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
  String get authSuccessSignIn => 'ログインしました。良いお料理を!';

  @override
  String get authSuccessRegister => 'アカウントを登録しました。ようこそ!';

  @override
  String get authSuccessGoogle => 'Google でログインしました!';

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

  @override
  String get reviewsTitle => 'コミュニティ・ギャラリーとレビュー';

  @override
  String get reviewsSubtitle => '他のホームシェフの作品を見たり、あなた自身の素晴らしい料理写真をアップロードしましょう!';

  @override
  String get reviewsAverage => '平均評価';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のレビュー',
      one: '1 件のレビュー',
      zero: 'まだレビューはありません',
    );
    return '$_temp0';
  }

  @override
  String reviewsUploadedCooks(int count) {
    return '投稿写真: $count';
  }

  @override
  String get reviewsEmptyState => 'コミュニティ写真がまだ投稿されていません。一番乗りで作って投稿してみませんか?';

  @override
  String get reviewsLoginPrompt => '料理写真を共有して評価するには、サインインしてください。';

  @override
  String get reviewsLoginCta => 'サインインしてレビュー';

  @override
  String get reviewsFormTitle => 'あなたの料理写真をシェア';

  @override
  String get reviewsRatingLabel => '評価';

  @override
  String get reviewsAuthorLabel => 'シェフ名(ニックネーム)';

  @override
  String get reviewsAuthorHint => 'ニックネームを入力してください…';

  @override
  String get reviewsCommentLabel => 'キッチンノート';

  @override
  String get reviewsCommentHint => '味はどうでしたか?アレンジやコツはありましたか?(例: にんにくを多めに!)';

  @override
  String get reviewsPhotoHint => 'タップして調理済みの写真を添付';

  @override
  String get reviewsPublishBtn => 'コミュニティに公開';

  @override
  String get reviewsPublishing => '公開中…';

  @override
  String get reviewsSubmitted => 'コミュニティギャラリーへの追加に成功しました!';

  @override
  String get reviewsPostAnother => '別のレビューを投稿';

  @override
  String get reviewsPhotoTooLarge => '画像が大きすぎます。より小さい画像を選んでください。';

  @override
  String get reviewsErrorGeneric => '投稿に失敗しました。再度お試しください。';

  @override
  String get reviewsDeleteTooltip => 'レビューを削除';

  @override
  String get reviewsDeleteConfirm => 'あなたのレビューを削除しますか?';

  @override
  String get reviewsAnonymousChef => 'ホームシェフ';

  @override
  String get reviewsLightboxCloseTooltip => '写真を閉じる';
}
