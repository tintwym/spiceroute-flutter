// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppL10nTh extends AppL10n {
  AppL10nTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'Savor สูตรอาหารทั่วโลก';

  @override
  String get navExplore => 'สำรวจ';

  @override
  String get navAiCreator => 'AI สร้างสูตร';

  @override
  String get navAiCompanion => 'AI ผู้ช่วย';

  @override
  String get navSaved => 'บันทึก';

  @override
  String get languageEnglish => 'อังกฤษ';

  @override
  String get languageChinese => 'จีน';

  @override
  String get languageThai => 'ไทย';

  @override
  String get languageJapanese => 'ญี่ปุ่น';

  @override
  String get languageKorean => 'เกาหลี';

  @override
  String get cuisineAll => 'ทั้งหมด';

  @override
  String get cuisineKorean => 'เกาหลี';

  @override
  String get cuisineJapanese => 'ญี่ปุ่น';

  @override
  String get cuisineChinese => 'จีน';

  @override
  String get cuisineBurmese => 'พม่า';

  @override
  String get cuisineThai => 'ไทย';

  @override
  String get cuisineIndian => 'อินเดีย';

  @override
  String get cuisineItalian => 'อิตาเลียน';

  @override
  String get cuisineAmericanWestern => 'อเมริกัน / ตะวันตก';

  @override
  String get cuisineMexican => 'เม็กซิกัน';

  @override
  String get exploreSearchHint => 'ค้นหาสูตร วัตถุดิบ หรือแท็ก';

  @override
  String get exploreEmptyTitle => 'ยังไม่พบสูตรที่ตรงกัน';

  @override
  String get exploreEmptySubtitle => 'ลองอาหารชาติอื่น หรือล้างคำค้น';

  @override
  String get exploreErrorTitle => 'โหลดสูตรไม่สำเร็จ';

  @override
  String get exploreErrorRetry => 'ลองใหม่';

  @override
  String recipeMinutesShort(int minutes) {
    return '$minutes นาที';
  }

  @override
  String recipeServings(int count) {
    return '$count ที่';
  }

  @override
  String get recipePremiumBadge => 'คัดสรร';

  @override
  String get recipeAiBadge => 'สร้างโดย AI';

  @override
  String get recipeSpiceLevel0 => 'ไม่เผ็ด';

  @override
  String get recipeSpiceLevel1 => 'เผ็ดน้อย';

  @override
  String get recipeSpiceLevel2 => 'เผ็ดปานกลาง';

  @override
  String get recipeSpiceLevel3 => 'เผ็ดจัด';

  @override
  String get detailIngredients => 'วัตถุดิบ';

  @override
  String get detailSteps => 'วิธีทำ';

  @override
  String detailStepNumber(int number) {
    return 'ขั้นที่ $number';
  }

  @override
  String get detailNoDescription => 'ยังไม่มีคำอธิบาย';

  @override
  String get detailSave => 'บันทึก';

  @override
  String get detailSaved => 'บันทึกแล้ว';

  @override
  String get detailUnsave => 'ลบจากที่บันทึก';

  @override
  String get detailShare => 'แชร์';

  @override
  String get detailBack => 'ย้อนกลับ';

  @override
  String get savedTitle => 'สูตรที่บันทึกไว้';

  @override
  String get savedEmptyTitle => 'ยังไม่ได้บันทึกอะไร';

  @override
  String get savedEmptySubtitle => 'แตะรูปหัวใจที่สูตรไหน เพื่อบันทึกไว้ที่นี่';

  @override
  String get savedClearAll => 'ล้างทั้งหมด';

  @override
  String get savedClearConfirm => 'ล้างสูตรที่บันทึกไว้ทั้งหมดหรือไม่?';

  @override
  String get savedClearConfirmYes => 'ล้าง';

  @override
  String get savedClearConfirmNo => 'ยกเลิก';

  @override
  String get aiCreatorTitle => 'AI สร้างสูตรอาหาร';

  @override
  String get aiCreatorIdeaLabel => 'วันนี้อยากทำอะไรดี?';

  @override
  String get aiCreatorIdeaHint => 'เช่น พาสต้าเห็ดอบอุ่นๆ ใช้ไวน์ที่เหลือ';

  @override
  String get aiCreatorCuisineLabel => 'ชาติของอาหาร';

  @override
  String get aiCreatorCuisineAuto => 'ให้ AI เลือกให้';

  @override
  String get aiCreatorLanguageLabel => 'ภาษาของสูตร';

  @override
  String get aiCreatorGenerate => 'สร้างสูตร';

  @override
  String get aiCreatorRegenerate => 'ลองอีกครั้ง';

  @override
  String get aiCreatorSaveBtn => 'บันทึกลงสูตรของฉัน';

  @override
  String get aiCreatorSavedToast => 'บันทึกแล้ว! ดูได้ในแท็บที่บันทึกไว้';

  @override
  String get aiCreatorErrorTitle => 'สร้างสูตรไม่สำเร็จ';

  @override
  String get aiCreatorRateLimited => 'วันนี้สร้างสูตรครบโควต้าแล้ว ลองพรุ่งนี้';

  @override
  String get aiCompanionTitle => 'AI ผู้ช่วยในครัว';

  @override
  String get aiCompanionEmptyTitle => 'ถามอะไรเรื่องทำอาหารก็ได้';

  @override
  String get aiCompanionEmptySubtitle =>
      'ของแทน เทคนิค ปรับสูตรเฉพาะอาหาร เราช่วยได้';

  @override
  String get aiCompanionInputHint => 'พิมพ์คำถามของคุณ…';

  @override
  String get aiCompanionSend => 'ส่ง';

  @override
  String get aiCompanionStop => 'หยุด';

  @override
  String get aiCompanionClear => 'ล้างบทสนทนา';

  @override
  String get aiCompanionTyping => 'กำลังคิด…';

  @override
  String get aiCompanionRateLimited =>
      'ส่งข้อความเยอะเกินใน 1 ชั่วโมง ลองใหม่ภายหลัง';

  @override
  String get aiCompanionSuggestion1 => 'ใช้อะไรแทนน้ำปลาแบบวีแกน?';

  @override
  String get aiCompanionSuggestion2 => 'เมนูเย็นไร้กลูเตนทำเร็วๆ?';

  @override
  String get aiCompanionSuggestion3 => 'วิธีเจียวเครื่องเทศอินเดีย?';

  @override
  String get aiCompanionSuggestion4 => 'อะไรกินคู่กับกิมจิอร่อย?';

  @override
  String get settingsLanguage => 'ภาษา';

  @override
  String get settingsAbout => 'เกี่ยวกับ Savor';

  @override
  String get settingsAboutBody =>
      'Savor Global Recipes รวมอาหารจากทั่วโลกไว้ในห้องสมุดที่สงบและสวยงาม พร้อมเครื่องมือ AI ให้คุณรีมิกซ์เป็นเวอร์ชันของครัวคุณ';

  @override
  String get settingsClose => 'ปิด';

  @override
  String get commonClose => 'ปิด';

  @override
  String get commonCancel => 'ยกเลิก';

  @override
  String get commonRetry => 'ลองใหม่';

  @override
  String get commonError => 'เกิดข้อผิดพลาด';

  @override
  String get commonLoading => 'กำลังโหลด…';

  @override
  String get commonNotFound => 'ไม่พบ';

  @override
  String get commonOk => 'ตกลง';

  @override
  String get commonDelete => 'ลบ';

  @override
  String get authSignIn => 'เข้าสู่ระบบ';

  @override
  String get authSignOut => 'ออกจากระบบ';

  @override
  String get authRegister => 'สร้างบัญชี';

  @override
  String get authAccount => 'บัญชี';

  @override
  String get authEmail => 'อีเมล';

  @override
  String get authPassword => 'รหัสผ่าน';

  @override
  String get authDisplayName => 'ชื่อที่แสดง';

  @override
  String get authContinueWithGoogle => 'ดำเนินการต่อด้วย Google';

  @override
  String get authOrDivider => 'หรือ';

  @override
  String get authForgotPassword => 'ลืมรหัสผ่าน?';

  @override
  String get authResetSent =>
      'ถ้าอีเมลนี้ลงทะเบียนไว้ เราได้ส่งลิงก์รีเซ็ตให้แล้ว';

  @override
  String get authNoAccountYet => 'ยังไม่มีบัญชี?';

  @override
  String get authHasAccount => 'มีบัญชีอยู่แล้ว?';

  @override
  String get authSignUpHere => 'สร้างเลย';

  @override
  String get authSignInHere => 'เข้าสู่ระบบ';

  @override
  String get authProtectedTitle => 'ต้องเข้าสู่ระบบ';

  @override
  String get authProtectedBody =>
      'เข้าสู่ระบบเพื่อเผยแพร่สูตรของคุณ จะได้ให้เครดิตผู้สร้างและแก้ไขหรือลบได้ภายหลัง';

  @override
  String get authNotConfigured =>
      'ยังไม่ได้ตั้งค่าการเข้าสู่ระบบ ต้องเพิ่มคอนฟิก Firebase';

  @override
  String get authErrorInvalid => 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';

  @override
  String get authErrorEmailInUse => 'อีเมลนี้ลงทะเบียนแล้ว';

  @override
  String get authErrorWeakPassword =>
      'เลือกรหัสผ่านที่แข็งแรงกว่านี้ (อย่างน้อย 6 ตัวอักษร)';

  @override
  String get authErrorNetwork => 'เกิดข้อผิดพลาดเครือข่าย ลองอีกครั้ง';

  @override
  String get authErrorGeneric => 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ';

  @override
  String get recipeOwnerYou => 'โดยคุณ';

  @override
  String recipeOwnerBy(String name) {
    return 'โดย $name';
  }

  @override
  String get myRecipesTitle => 'สูตรของฉัน';

  @override
  String get myRecipesEmptyTitle => 'ยังไม่มีอะไรที่นี่';

  @override
  String get myRecipesEmptySubtitle =>
      'สูตรที่คุณเผยแพร่หรือบันทึกใน AI Creator จะปรากฏที่นี่';

  @override
  String get navMyRecipes => 'ของฉัน';

  @override
  String get detailEdit => 'แก้ไข';

  @override
  String get detailDelete => 'ลบ';

  @override
  String get detailDeleteConfirm => 'ลบสูตรนี้? การกระทำนี้ย้อนกลับไม่ได้';

  @override
  String get detailDeleteOk => 'ลบ';

  @override
  String get detailDeletedToast => 'ลบสูตรแล้ว';
}
