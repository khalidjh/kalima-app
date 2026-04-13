import 'words.dart';

class RawabetCategory {
  final String name;
  final List<String> words;
  final int colorIndex;

  const RawabetCategory({
    required this.name,
    required this.words,
    required this.colorIndex,
  });
}

class RawabetPuzzle {
  final int id;
  final List<RawabetCategory> categories;

  const RawabetPuzzle({required this.id, required this.categories});

  List<String> get allWords {
    return categories.expand((c) => c.words).toList();
  }
}

RawabetPuzzle getDailyRawabetPuzzle() {
  final num = getPuzzleNumber();
  final idx = (num - 1) % rawabetPuzzles.length;
  return rawabetPuzzles[idx];
}

const List<RawabetPuzzle> rawabetPuzzles = [
  RawabetPuzzle(id: 1, categories: [
    RawabetCategory(name: 'فواكه', words: ['تفاح', 'برتقال', 'موز', 'عنب'], colorIndex: 0),
    RawabetCategory(name: 'حيوانات البحر', words: ['سمكة', 'حوت', 'دلفين', 'قرش'], colorIndex: 1),
    RawabetCategory(name: 'ألوان', words: ['أحمر', 'أزرق', 'أخضر', 'أصفر'], colorIndex: 2),
    RawabetCategory(name: 'أيام الأسبوع', words: ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 2, categories: [
    RawabetCategory(name: 'مشروبات', words: ['قهوة', 'شاي', 'عصير', 'لبن'], colorIndex: 0),
    RawabetCategory(name: 'مدن سعودية', words: ['الرياض', 'جدة', 'مكة', 'المدينة'], colorIndex: 1),
    RawabetCategory(name: 'أدوات المطبخ', words: ['ملعقة', 'شوكة', 'سكين', 'طنجرة'], colorIndex: 2),
    RawabetCategory(name: 'طيور', words: ['عقاب', 'حمامة', 'بلبل', 'غراب'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 3, categories: [
    RawabetCategory(name: 'رياضات', words: ['كرة القدم', 'تنس', 'سباحة', 'ملاكمة'], colorIndex: 0),
    RawabetCategory(name: 'أشهر رمضان', words: ['سحور', 'إفطار', 'تراويح', 'زكاة'], colorIndex: 1),
    RawabetCategory(name: 'مهن', words: ['طبيب', 'مهندس', 'معلم', 'محامي'], colorIndex: 2),
    RawabetCategory(name: 'أجزاء الوجه', words: ['عين', 'أنف', 'فم', 'أذن'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 4, categories: [
    RawabetCategory(name: 'خضروات', words: ['جزر', 'بطاطا', 'بصل', 'ثوم'], colorIndex: 0),
    RawabetCategory(name: 'أنبياء', words: ['موسى', 'عيسى', 'إبراهيم', 'يوسف'], colorIndex: 1),
    RawabetCategory(name: 'وسائل النقل', words: ['قطار', 'طائرة', 'سفينة', 'حافلة'], colorIndex: 2),
    RawabetCategory(name: 'تحيات عربية', words: ['أهلاً', 'مرحباً', 'هلاً', 'السلام'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 5, categories: [
    RawabetCategory(name: 'توابل', words: ['زعفران', 'كمون', 'فلفل', 'قرفة'], colorIndex: 0),
    RawabetCategory(name: 'دول الخليج', words: ['الكويت', 'البحرين', 'قطر', 'عمان'], colorIndex: 1),
    RawabetCategory(name: 'أدوات دراسية', words: ['قلم', 'كتاب', 'مسطرة', 'ممحاة'], colorIndex: 2),
    RawabetCategory(name: 'تعابير الفرح', words: ['ماشاء الله', 'يهلا', 'بالتوفيق', 'مبروك'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 6, categories: [
    RawabetCategory(name: 'أكلات شعبية', words: ['كبسة', 'مندي', 'هريسة', 'مطبق'], colorIndex: 0),
    RawabetCategory(name: 'أجزاء الجسم', words: ['قلب', 'كبد', 'رئة', 'كلية'], colorIndex: 1),
    RawabetCategory(name: 'فصول السنة', words: ['ربيع', 'صيف', 'خريف', 'شتاء'], colorIndex: 2),
    RawabetCategory(name: 'ما بعد الموت', words: ['جنة', 'نار', 'برزخ', 'حساب'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 7, categories: [
    RawabetCategory(name: 'حيوانات الصحراء', words: ['جمل', 'ثعلب', 'ضب', 'ورل'], colorIndex: 0),
    RawabetCategory(name: 'كواكب', words: ['المريخ', 'زحل', 'المشتري', 'الزهرة'], colorIndex: 1),
    RawabetCategory(name: 'ملابس', words: ['ثوب', 'عباءة', 'غترة', 'إزار'], colorIndex: 2),
    RawabetCategory(name: 'أسماء قرآنية للنساء', words: ['مريم', 'هاجر', 'آسيا', 'بلقيس'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 8, categories: [
    RawabetCategory(name: 'أنواع الرز', words: ['بسمتي', 'ياباني', 'برياني', 'مصري'], colorIndex: 0),
    RawabetCategory(name: 'عواصم عربية', words: ['بغداد', 'دمشق', 'القاهرة', 'عمّان'], colorIndex: 1),
    RawabetCategory(name: 'مشاعر', words: ['فرح', 'حزن', 'غضب', 'خوف'], colorIndex: 2),
    RawabetCategory(name: 'أسماء أنهار', words: ['النيل', 'الفرات', 'دجلة', 'الأردن'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 9, categories: [
    RawabetCategory(name: 'أنواع الخبز', words: ['رقاق', 'تنور', 'صامولي', 'بغل'], colorIndex: 0),
    RawabetCategory(name: 'أدوات الموسيقى', words: ['عود', 'ناي', 'طبلة', 'ربابة'], colorIndex: 1),
    RawabetCategory(name: 'أوقات الصلاة', words: ['فجر', 'ظهر', 'عصر', 'مغرب'], colorIndex: 2),
    RawabetCategory(name: 'معادن نفيسة', words: ['ذهب', 'فضة', 'بلاتين', 'ماس'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 10, categories: [
    RawabetCategory(name: 'نجوم كرة القدم العرب', words: ['سالم الدوسري', 'يسف النسيري', 'عمر عبد الودود', 'عبد الرزاق حمد الله'], colorIndex: 0),
    RawabetCategory(name: 'أنواع الصيام', words: ['رمضان', 'شوال', 'عاشوراء', 'قضاء'], colorIndex: 1),
    RawabetCategory(name: 'ألعاب شعبية', words: ['الغميضة', 'الحجلة', 'البليات', 'الطاق طاق'], colorIndex: 2),
    RawabetCategory(name: 'صفات الله الحسنى', words: ['الرحمن', 'الغفور', 'الكريم', 'العليم'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 11, categories: [
    RawabetCategory(name: 'حلويات عربية', words: ['كنافة', 'بقلاوة', 'لقيمات', 'هريسة'], colorIndex: 0),
    RawabetCategory(name: 'أنواع القهوة', words: ['إسبريسو', 'كابتشينو', 'لاتيه', 'أمريكانو'], colorIndex: 1),
    RawabetCategory(name: 'أرقام عربية', words: ['واحد', 'اثنان', 'ثلاثة', 'أربعة'], colorIndex: 2),
    RawabetCategory(name: 'أقمار الكواكب', words: ['القمر', 'فوبوس', 'تيتان', 'يوروبا'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 12, categories: [
    RawabetCategory(name: 'أنواع السمك', words: ['سلمون', 'تونة', 'هامور', 'زبيدي'], colorIndex: 0),
    RawabetCategory(name: 'مدن مصرية', words: ['الإسكندرية', 'أسوان', 'الأقصر', 'بورسعيد'], colorIndex: 1),
    RawabetCategory(name: 'أدوات البناء', words: ['مطرقة', 'مسمار', 'مبرد', 'منشار'], colorIndex: 2),
    RawabetCategory(name: 'أنواع العقود', words: ['بيع', 'إجارة', 'هبة', 'رهن'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 13, categories: [
    RawabetCategory(name: 'حشرات', words: ['نملة', 'نحلة', 'فراشة', 'جندب'], colorIndex: 0),
    RawabetCategory(name: 'أسماء أدوات الكتابة القديمة', words: ['قلم', 'مداد', 'لوح', 'ريشة'], colorIndex: 1),
    RawabetCategory(name: 'مواسم دينية', words: ['عيد الفطر', 'عيد الأضحى', 'رمضان', 'الحج'], colorIndex: 2),
    RawabetCategory(name: 'أسماء شعراء عرب', words: ['المتنبي', 'أبو نواس', 'امرؤ القيس', 'الجاحظ'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 14, categories: [
    RawabetCategory(name: 'محاصيل زراعية', words: ['قمح', 'شعير', 'ذرة', 'أرز'], colorIndex: 0),
    RawabetCategory(name: 'تضاريس جغرافية', words: ['جبل', 'وادي', 'سهل', 'هضبة'], colorIndex: 1),
    RawabetCategory(name: 'حروف التعليل', words: ['لأن', 'بسبب', 'إذ', 'كيلا'], colorIndex: 2),
    RawabetCategory(name: 'أسماء سور قرآنية', words: ['البقرة', 'النساء', 'الكهف', 'يوسف'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 15, categories: [
    RawabetCategory(name: 'رواد الفضاء العرب', words: ['هزاع المنصوري', 'سلطان النيادي', 'علي القرني', 'رائد سلام'], colorIndex: 0),
    RawabetCategory(name: 'أنواع الشعر', words: ['عمودي', 'حر', 'هايكو', 'ملحمي'], colorIndex: 1),
    RawabetCategory(name: 'أسماء بحار', words: ['المتوسط', 'الأحمر', 'العربي', 'الأسود'], colorIndex: 2),
    RawabetCategory(name: 'صنوف الجيش', words: ['مشاة', 'مدرعات', 'بحرية', 'جوية'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 16, categories: [
    RawabetCategory(name: 'أنواع الجبن', words: ['شيدر', 'موزاريلا', 'بري', 'فيتا'], colorIndex: 0),
    RawabetCategory(name: 'علماء مسلمون', words: ['ابن سينا', 'الخوارزمي', 'البيروني', 'ابن رشد'], colorIndex: 1),
    RawabetCategory(name: 'أدوات الطبخ', words: ['موقد', 'فرن', 'مقلاة', 'خلاط'], colorIndex: 2),
    RawabetCategory(name: 'أنواع الخيمة', words: ['شعر', 'قماش', 'نايلون', 'جلد'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 17, categories: [
    RawabetCategory(name: 'أنواع الصلوات', words: ['فريضة', 'سنة', 'تطوع', 'وتر'], colorIndex: 0),
    RawabetCategory(name: 'مدن مغربية', words: ['الرباط', 'فاس', 'مراكش', 'الدار البيضاء'], colorIndex: 1),
    RawabetCategory(name: 'أوزان الشعر', words: ['طويل', 'بسيط', 'كامل', 'وافر'], colorIndex: 2),
    RawabetCategory(name: 'حيوانات مفترسة', words: ['أسد', 'نمر', 'ضبع', 'ذئب'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 18, categories: [
    RawabetCategory(name: 'مواد البناء', words: ['إسمنت', 'رمل', 'حصى', 'طابوق'], colorIndex: 0),
    RawabetCategory(name: 'أجزاء الشجرة', words: ['جذر', 'ساق', 'ورقة', 'ثمرة'], colorIndex: 1),
    RawabetCategory(name: 'أنواع المطر', words: ['رذاذ', 'وابل', 'طل', 'صيب'], colorIndex: 2),
    RawabetCategory(name: 'أسماء الملائكة', words: ['جبريل', 'ميكائيل', 'إسرافيل', 'عزرائيل'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 19, categories: [
    RawabetCategory(name: 'تقنيات حديثة', words: ['ذكاء اصطناعي', 'بلوكتشين', 'ميتافيرس', 'سحابة'], colorIndex: 0),
    RawabetCategory(name: 'أسماء زهور', words: ['وردة', 'ياسمين', 'زنبق', 'أقحوان'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الأكل البحري', words: ['جمبري', 'كراب', 'أخطبوط', 'بطلينوس'], colorIndex: 2),
    RawabetCategory(name: 'صفات الرجل الكريم', words: ['جود', 'سخاء', 'كرم', 'عطاء'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 20, categories: [
    RawabetCategory(name: 'أنواع التمر', words: ['مجدول', 'خلاص', 'سكري', 'أجوة'], colorIndex: 0),
    RawabetCategory(name: 'فنانون عرب', words: ['فيروز', 'أم كلثوم', 'عبد الحليم', 'ووردة'], colorIndex: 1),
    RawabetCategory(name: 'أسماء صحراوات', words: ['الربع الخالي', 'النفود', 'الدهناء', 'الدبدبة'], colorIndex: 2),
    RawabetCategory(name: 'مصطلحات النحو', words: ['مبتدأ', 'خبر', 'فاعل', 'مفعول'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 21, categories: [
    RawabetCategory(name: 'مكونات الشاورما', words: ['لحم', 'طحينة', 'توم', 'فلفل'], colorIndex: 0),
    RawabetCategory(name: 'أسماء خلفاء راشدين', words: ['أبوبكر', 'عمر', 'عثمان', 'علي'], colorIndex: 1),
    RawabetCategory(name: 'ظواهر طبيعية', words: ['زلزال', 'بركان', 'إعصار', 'تسونامي'], colorIndex: 2),
    RawabetCategory(name: 'أدوات الاستفهام', words: ['من', 'ما', 'متى', 'كيف'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 22, categories: [
    RawabetCategory(name: 'أنواع البيت', words: ['فيلا', 'شقة', 'قصر', 'خيمة'], colorIndex: 0),
    RawabetCategory(name: 'أعضاء الحواس', words: ['عين', 'أذن', 'أنف', 'لسان'], colorIndex: 1),
    RawabetCategory(name: 'أسماء بحيرات', words: ['تشاد', 'فيكتوريا', 'بايكال', 'تيتيكاكا'], colorIndex: 2),
    RawabetCategory(name: 'تصنيف القرآن', words: ['جزء', 'حزب', 'ربع', 'سورة'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 23, categories: [
    RawabetCategory(name: 'أنواع العسل', words: ['سدر', 'أكاسيا', 'مانوكا', 'زهور'], colorIndex: 0),
    RawabetCategory(name: 'مدن عراقية', words: ['الموصل', 'البصرة', 'أربيل', 'كربلاء'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الصيد', words: ['قنص', 'شبكة', 'سنارة', 'مصيدة'], colorIndex: 2),
    RawabetCategory(name: 'أسماء مشهورة من التاريخ الإسلامي', words: ['صلاح الدين', 'خالد بن الوليد', 'طارق بن زياد', 'نور الدين'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 24, categories: [
    RawabetCategory(name: 'أنواع الخضرة', words: ['نعنع', 'بقدونس', 'كزبرة', 'ريحان'], colorIndex: 0),
    RawabetCategory(name: 'مؤسسو دول عربية', words: ['عبد العزيز', 'محمد علي', 'قابوس', 'زايد'], colorIndex: 1),
    RawabetCategory(name: 'أنواع المحيطات', words: ['الهادئ', 'الأطلسي', 'الهندي', 'المتجمد'], colorIndex: 2),
    RawabetCategory(name: 'مصطلحات صرفية', words: ['مصدر', 'فعل', 'اسم', 'حرف'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 26, categories: [
    RawabetCategory(name: 'وجبات يومية', words: ['فطور', 'غداء', 'عشاء', 'سحور'], colorIndex: 0),
    RawabetCategory(name: 'أنواع الشاي', words: ['أخضر', 'أسود', 'مورينغا', 'نعنع'], colorIndex: 1),
    RawabetCategory(name: 'دول أفريقية عربية', words: ['المغرب', 'تونس', 'الجزائر', 'ليبيا'], colorIndex: 2),
    RawabetCategory(name: 'أسماء كواكب المجموعة الشمسية بالترتيب', words: ['عطارد', 'الزهرة', 'الأرض', 'المريخ'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 27, categories: [
    RawabetCategory(name: 'طيور لا تطير', words: ['نعامة', 'بطريق', 'كيوي', 'إيمو'], colorIndex: 0),
    RawabetCategory(name: 'أنواع التربة', words: ['طينية', 'رملية', 'صخرية', 'طباشيرية'], colorIndex: 1),
    RawabetCategory(name: 'أسماء تلال مكة', words: ['أبو قبيس', 'أبي قبيس', 'قعيقعان', 'هندي'], colorIndex: 2),
    RawabetCategory(name: 'أنواع الصوم المنهي عنه', words: ['الوصال', 'الدهر', 'الصمت', 'يوم الشك'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 28, categories: [
    RawabetCategory(name: 'مواد خام للأقمشة', words: ['قطن', 'حرير', 'صوف', 'كتان'], colorIndex: 0),
    RawabetCategory(name: 'أسماء خلجان', words: ['العقبة', 'السويس', 'عدن', 'عمان'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الرياضة المائية', words: ['تجديف', 'غطس', 'إبحار', 'تزلج مائي'], colorIndex: 2),
    RawabetCategory(name: 'شروط الصلاة الصحيحة', words: ['طهارة', 'استقبال القبلة', 'وقت', 'نية'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 30, categories: [
    RawabetCategory(name: 'أنواع العقود الرياضية', words: ['إعارة', 'انتقال حر', 'بيع', 'تمديد'], colorIndex: 0),
    RawabetCategory(name: 'أسماء من سورة يوسف', words: ['يعقوب', 'يوسف', 'بنيامين', 'زليخا'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الأسماك في الخليج', words: ['كنعد', 'شعري', 'ربيان', 'بياح'], colorIndex: 2),
    RawabetCategory(name: 'مصطلحات الشطرنج', words: ['رخ', 'وزير', 'بيدق', 'فيل'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 31, categories: [
    RawabetCategory(name: 'أشجار', words: ['نخلة', 'سرو', 'زيتون', 'سنديان'], colorIndex: 0),
    RawabetCategory(name: 'أسماء سيوف مشهورة', words: ['ذوالفقار', 'البتار', 'الصمصامة', 'المهند'], colorIndex: 1),
    RawabetCategory(name: 'أنواع السحاب', words: ['ركامي', 'ضبابي', 'مزني', 'طبقي'], colorIndex: 2),
    RawabetCategory(name: 'مصطلحات كرة القدم', words: ['تسلل', 'ركلة', 'شوط', 'ضربة'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 32, categories: [
    RawabetCategory(name: 'أنواع المكسرات', words: ['لوز', 'جوز', 'فستق', 'كاجو'], colorIndex: 0),
    RawabetCategory(name: 'أركان الإسلام', words: ['شهادة', 'صلاة', 'صيام', 'حج'], colorIndex: 1),
    RawabetCategory(name: 'عملات عربية', words: ['ريال', 'دينار', 'درهم', 'جنيه'], colorIndex: 2),
    RawabetCategory(name: 'أنواع الأواني', words: ['صحن', 'كوب', 'إبريق', 'صينية'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 33, categories: [
    RawabetCategory(name: 'أنواع اللحوم', words: ['ضأن', 'بقر', 'دجاج', 'إبل'], colorIndex: 0),
    RawabetCategory(name: 'مدن شامية', words: ['حلب', 'بيروت', 'نابلس', 'إربد'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الحجارة', words: ['رخام', 'جرانيت', 'بازلت', 'حجر رملي'], colorIndex: 2),
    RawabetCategory(name: 'أسماء غزوات', words: ['بدر', 'أحد', 'الخندق', 'حنين'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 34, categories: [
    RawabetCategory(name: 'أنواع العطور', words: ['مسك', 'عود', 'عنبر', 'بخور'], colorIndex: 0),
    RawabetCategory(name: 'رتب عسكرية', words: ['عقيد', 'نقيب', 'لواء', 'ملازم'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الغيوم', words: ['قزع', 'سمحاق', 'كثيف', 'منخفض'], colorIndex: 2),
    RawabetCategory(name: 'مصطلحات بلاغية', words: ['استعارة', 'تشبيه', 'كناية', 'مجاز'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 35, categories: [
    RawabetCategory(name: 'أطعمة مخللة', words: ['خيار', 'زيتون', 'لفت', 'ليمون'], colorIndex: 0),
    RawabetCategory(name: 'أسماء بنات عربية شائعة', words: ['نورة', 'سارة', 'ليلى', 'فاطمة'], colorIndex: 1),
    RawabetCategory(name: 'أدوات النجارة', words: ['مسحج', 'إزميل', 'فأرة', 'قمط'], colorIndex: 2),
    RawabetCategory(name: 'أسماء أبواب الجنة', words: ['الريان', 'الصلاة', 'الجهاد', 'الصدقة'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 36, categories: [
    RawabetCategory(name: 'بهارات هندية', words: ['كركم', 'هيل', 'قرنفل', 'زنجبيل'], colorIndex: 0),
    RawabetCategory(name: 'أنواع الشعر الشعبي', words: ['نبطي', 'زجل', 'موشح', 'مواليا'], colorIndex: 1),
    RawabetCategory(name: 'أدوات الزراعة', words: ['محراث', 'منجل', 'فأس', 'معول'], colorIndex: 2),
    RawabetCategory(name: 'أنواع الأرض', words: ['صحراء', 'غابة', 'مرعى', 'بادية'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 37, categories: [
    RawabetCategory(name: 'أنواع الحلويات الغربية', words: ['تشيزكيك', 'براوني', 'تيراميسو', 'كريب'], colorIndex: 0),
    RawabetCategory(name: 'مدن ليبية', words: ['طرابلس', 'بنغازي', 'مصراتة', 'سبها'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الأسلحة القديمة', words: ['سيف', 'رمح', 'قوس', 'درع'], colorIndex: 2),
    RawabetCategory(name: 'أسماء أولاد النبي', words: ['القاسم', 'عبدالله', 'إبراهيم', 'الطيب'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 38, categories: [
    RawabetCategory(name: 'فواكه استوائية', words: ['مانجو', 'أناناس', 'جوافة', 'باباي'], colorIndex: 0),
    RawabetCategory(name: 'أنواع القماش', words: ['دانتيل', 'شيفون', 'ساتان', 'مخمل'], colorIndex: 1),
    RawabetCategory(name: 'مصطلحات طبية', words: ['تشخيص', 'أعراض', 'وصفة', 'جرعة'], colorIndex: 2),
    RawabetCategory(name: 'أسماء رياح العرب', words: ['صبا', 'دبور', 'شمال', 'جنوب'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 39, categories: [
    RawabetCategory(name: 'منتجات ألبان', words: ['زبدة', 'قشطة', 'لبنة', 'روب'], colorIndex: 0),
    RawabetCategory(name: 'مدن سودانية', words: ['الخرطوم', 'أم درمان', 'بورتسودان', 'كسلا'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الشوربة', words: ['عدس', 'شوفان', 'فطر', 'طماطم'], colorIndex: 2),
    RawabetCategory(name: 'أركان الإيمان', words: ['ملائكة', 'كتب', 'رسل', 'قدر'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 40, categories: [
    RawabetCategory(name: 'أنواع القبعات', words: ['طاقية', 'عمامة', 'طربوش', 'شماغ'], colorIndex: 0),
    RawabetCategory(name: 'جامعات عربية', words: ['الأزهر', 'القاهرة', 'الملك سعود', 'بيرزيت'], colorIndex: 1),
    RawabetCategory(name: 'مصطلحات قانونية', words: ['دعوى', 'حكم', 'استئناف', 'نقض'], colorIndex: 2),
    RawabetCategory(name: 'أنواع الزواحف', words: ['حرباء', 'سلحفاة', 'تمساح', 'أفعى'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 41, categories: [
    RawabetCategory(name: 'أنواع السلطات', words: ['فتوش', 'تبولة', 'سيزر', 'يونانية'], colorIndex: 0),
    RawabetCategory(name: 'أبراج فلكية', words: ['الحمل', 'الثور', 'الجوزاء', 'العقرب'], colorIndex: 1),
    RawabetCategory(name: 'أدوات تنظيف', words: ['مكنسة', 'ممسحة', 'سطل', 'إسفنجة'], colorIndex: 2),
    RawabetCategory(name: 'أنواع السور القرآنية', words: ['مكية', 'مدنية', 'طوال', 'مفصل'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 42, categories: [
    RawabetCategory(name: 'مشروبات ساخنة', words: ['كاكاو', 'سحلب', 'يانسون', 'بابونج'], colorIndex: 0),
    RawabetCategory(name: 'جبال عربية', words: ['أحد', 'طويق', 'لبنان', 'أطلس'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الخطوط الجوية', words: ['السعودية', 'الإماراتية', 'القطرية', 'الخليجية'], colorIndex: 2),
    RawabetCategory(name: 'أسماء أصابع اليد', words: ['إبهام', 'سبابة', 'وسطى', 'بنصر'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 43, categories: [
    RawabetCategory(name: 'أنواع الصلصات', words: ['ثومية', 'حارة', 'كاتشب', 'مايونيز'], colorIndex: 0),
    RawabetCategory(name: 'علوم إسلامية', words: ['فقه', 'تفسير', 'حديث', 'عقيدة'], colorIndex: 1),
    RawabetCategory(name: 'أنواع السيارات', words: ['صالون', 'دفع رباعي', 'هاتشباك', 'بيكب'], colorIndex: 2),
    RawabetCategory(name: 'مصطلحات فلكية', words: ['نجم', 'مجرة', 'ثقب أسود', 'سديم'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 44, categories: [
    RawabetCategory(name: 'أنواع العصائر', words: ['برتقال', 'تفاح', 'رمان', 'ليمون'], colorIndex: 0),
    RawabetCategory(name: 'مدن يمنية', words: ['صنعاء', 'عدن', 'تعز', 'المكلا'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الأحذية', words: ['حذاء', 'صندل', 'نعل', 'جزمة'], colorIndex: 2),
    RawabetCategory(name: 'صفات الخيل', words: ['أصيل', 'جموح', 'أدهم', 'أشقر'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 45, categories: [
    RawabetCategory(name: 'أنواع الأجبان العربية', words: ['حلوم', 'عكاوي', 'نابلسي', 'جبنة بيضاء'], colorIndex: 0),
    RawabetCategory(name: 'أسماء قبائل عربية', words: ['قريش', 'تميم', 'عنزة', 'غامد'], colorIndex: 1),
    RawabetCategory(name: 'مصطلحات اقتصادية', words: ['تضخم', 'ركود', 'عرض', 'طلب'], colorIndex: 2),
    RawabetCategory(name: 'أنواع البرق', words: ['خلبي', 'صاعق', 'كروي', 'خطي'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 46, categories: [
    RawabetCategory(name: 'مكونات البيتزا', words: ['عجينة', 'صلصة', 'جبنة', 'زيتون'], colorIndex: 0),
    RawabetCategory(name: 'دول آسيوية مسلمة', words: ['ماليزيا', 'إندونيسيا', 'باكستان', 'بنغلاديش'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الأبواب', words: ['خشبي', 'حديدي', 'زجاجي', 'أوتوماتيكي'], colorIndex: 2),
    RawabetCategory(name: 'أسماء السيرة النبوية', words: ['هجرة', 'بيعة', 'إسراء', 'معراج'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 47, categories: [
    RawabetCategory(name: 'أنواع المعكرونة', words: ['سباغيتي', 'بيني', 'لازانيا', 'فيتوتشيني'], colorIndex: 0),
    RawabetCategory(name: 'شعراء المعلقات', words: ['زهير', 'عنترة', 'لبيد', 'طرفة'], colorIndex: 1),
    RawabetCategory(name: 'أجزاء المسجد', words: ['محراب', 'منبر', 'مئذنة', 'قبة'], colorIndex: 2),
    RawabetCategory(name: 'أنواع الطباعة', words: ['ليزر', 'حبرية', 'حرارية', 'ثلاثية'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 48, categories: [
    RawabetCategory(name: 'فواكه مجففة', words: ['تين', 'مشمش', 'زبيب', 'قراصيا'], colorIndex: 0),
    RawabetCategory(name: 'مدن أردنية', words: ['الزرقاء', 'العقبة', 'جرش', 'الكرك'], colorIndex: 1),
    RawabetCategory(name: 'أنواع النوافذ', words: ['منزلقة', 'مفصلية', 'ثابتة', 'دوارة'], colorIndex: 2),
    RawabetCategory(name: 'مصطلحات الحاسوب', words: ['معالج', 'ذاكرة', 'شاشة', 'لوحة'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 49, categories: [
    RawabetCategory(name: 'أنواع الزيوت', words: ['زيتون', 'سمسم', 'نارجيل', 'عباد الشمس'], colorIndex: 0),
    RawabetCategory(name: 'أسماء صحابيات', words: ['خديجة', 'عائشة', 'حفصة', 'زينب'], colorIndex: 1),
    RawabetCategory(name: 'أدوات القياس', words: ['ميزان', 'مسطرة', 'شريط', 'بوصلة'], colorIndex: 2),
    RawabetCategory(name: 'أنواع الأقفال', words: ['مفتاح', 'رقمي', 'بصمة', 'سلسلة'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 50, categories: [
    RawabetCategory(name: 'أنواع الشوكولاتة', words: ['داكنة', 'بيضاء', 'بالحليب', 'خام'], colorIndex: 0),
    RawabetCategory(name: 'مدن تونسية', words: ['سوسة', 'صفاقس', 'قيروان', 'نابل'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الرقص العربي', words: ['دبكة', 'عرضة', 'رزفة', 'خطوة'], colorIndex: 2),
    RawabetCategory(name: 'مصطلحات رياضية', words: ['معادلة', 'مثلث', 'دائرة', 'أس'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 51, categories: [
    RawabetCategory(name: 'أدوات الخياطة', words: ['إبرة', 'خيط', 'مقص', 'دبوس'], colorIndex: 0),
    RawabetCategory(name: 'أسواق عربية تاريخية', words: ['عكاظ', 'المباركية', 'الحميدية', 'خان الخليلي'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الإضاءة', words: ['شمعة', 'مصباح', 'ثريا', 'كشاف'], colorIndex: 2),
    RawabetCategory(name: 'مكونات الدم', words: ['بلازما', 'صفائح', 'كريات حمراء', 'كريات بيضاء'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 52, categories: [
    RawabetCategory(name: 'أنواع الأرز المطبوخ', words: ['كبسة', 'مقلوبة', 'مجبوس', 'منسف'], colorIndex: 0),
    RawabetCategory(name: 'بحار داخلية', words: ['قزوين', 'الميت', 'آرال', 'مرمرة'], colorIndex: 1),
    RawabetCategory(name: 'أنواع المتاجر', words: ['بقالة', 'صيدلية', 'مخبز', 'جزارة'], colorIndex: 2),
    RawabetCategory(name: 'مصطلحات التجويد', words: ['إدغام', 'إخفاء', 'إقلاب', 'إظهار'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 53, categories: [
    RawabetCategory(name: 'أنواع الحساء العربي', words: ['جريش', 'مرقوق', 'ثريد', 'عصيدة'], colorIndex: 0),
    RawabetCategory(name: 'مدن فلسطينية', words: ['القدس', 'غزة', 'رام الله', 'الخليل'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الأثاث', words: ['أريكة', 'طاولة', 'خزانة', 'سرير'], colorIndex: 2),
    RawabetCategory(name: 'أسماء منازل القمر', words: ['الثريا', 'الدبران', 'الهقعة', 'الهنعة'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 54, categories: [
    RawabetCategory(name: 'أنواع الحبوب', words: ['عدس', 'حمص', 'فاصوليا', 'فول'], colorIndex: 0),
    RawabetCategory(name: 'عواصم أوروبية', words: ['لندن', 'باريس', 'برلين', 'روما'], colorIndex: 1),
    RawabetCategory(name: 'أنواع السفن', words: ['بارجة', 'مركب', 'يخت', 'قارب'], colorIndex: 2),
    RawabetCategory(name: 'أسماء سورة الفاتحة', words: ['الحمد', 'الشفاء', 'السبع', 'الكافية'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 55, categories: [
    RawabetCategory(name: 'وجبات سريعة', words: ['برغر', 'شاورما', 'فلافل', 'بروستد'], colorIndex: 0),
    RawabetCategory(name: 'أنهار عربية', words: ['العاصي', 'الليطاني', 'أبو رقراق', 'شبيلي'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الحدائق', words: ['عامة', 'نباتية', 'حيوان', 'معلقة'], colorIndex: 2),
    RawabetCategory(name: 'علامات الترقيم', words: ['فاصلة', 'نقطة', 'تعجب', 'استفهام'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 56, categories: [
    RawabetCategory(name: 'أنواع الخل', words: ['تفاح', 'عنب', 'أبيض', 'بلسمي'], colorIndex: 0),
    RawabetCategory(name: 'مدن جزائرية', words: ['وهران', 'قسنطينة', 'عنابة', 'سطيف'], colorIndex: 1),
    RawabetCategory(name: 'أنواع المراكب الشراعية', words: ['داو', 'سنبوك', 'بوم', 'جلبوت'], colorIndex: 2),
    RawabetCategory(name: 'أركان الوضوء', words: ['وجه', 'يدان', 'رأس', 'رجلان'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 57, categories: [
    RawabetCategory(name: 'أنواع البن', words: ['عربي', 'برازيلي', 'كولومبي', 'إثيوبي'], colorIndex: 0),
    RawabetCategory(name: 'مسلسلات عربية', words: ['طاش ما طاش', 'باب الحارة', 'حريم السلطان', 'خلصانة بشياكة'], colorIndex: 1),
    RawabetCategory(name: 'أنواع التأمين', words: ['صحي', 'سيارات', 'حياة', 'سفر'], colorIndex: 2),
    RawabetCategory(name: 'مصطلحات صوفية', words: ['مريد', 'شيخ', 'طريقة', 'ذكر'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 58, categories: [
    RawabetCategory(name: 'أنواع المخبوزات', words: ['كرواسون', 'دونات', 'بريوش', 'سينابون'], colorIndex: 0),
    RawabetCategory(name: 'مضائق بحرية', words: ['هرمز', 'باب المندب', 'جبل طارق', 'ملقا'], colorIndex: 1),
    RawabetCategory(name: 'أنواع النسيج', words: ['تريكو', 'كروشيه', 'تطريز', 'نسيج'], colorIndex: 2),
    RawabetCategory(name: 'أنواع الميراث', words: ['فرض', 'تعصيب', 'رد', 'حجب'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 59, categories: [
    RawabetCategory(name: 'أنواع البيض', words: ['مسلوق', 'مقلي', 'أومليت', 'شكشوكة'], colorIndex: 0),
    RawabetCategory(name: 'مدن إماراتية', words: ['دبي', 'أبوظبي', 'الشارقة', 'العين'], colorIndex: 1),
    RawabetCategory(name: 'أنواع المفاتيح', words: ['عادي', 'إلكتروني', 'بطاقة', 'ذكي'], colorIndex: 2),
    RawabetCategory(name: 'مراحل نمو الإنسان', words: ['رضيع', 'طفل', 'شاب', 'كهل'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 60, categories: [
    RawabetCategory(name: 'أنواع القهوة العربية', words: ['هرري', 'خولاني', 'يمني', 'بلدي'], colorIndex: 0),
    RawabetCategory(name: 'أسماء حروب تاريخية', words: ['القادسية', 'اليرموك', 'حطين', 'عين جالوت'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الساعات', words: ['يدوية', 'جدارية', 'رقمية', 'رملية'], colorIndex: 2),
    RawabetCategory(name: 'أنواع الطلاق', words: ['رجعي', 'بائن', 'خلع', 'تفريق'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 61, categories: [
    RawabetCategory(name: 'أنواع الصابون', words: ['نابلسي', 'غار', 'مرسيليا', 'سائل'], colorIndex: 0),
    RawabetCategory(name: 'مدن كويتية', words: ['حولي', 'الجهراء', 'الأحمدي', 'الفروانية'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الآبار', words: ['ارتوازي', 'سطحي', 'نفطي', 'جوفي'], colorIndex: 2),
    RawabetCategory(name: 'مقاصد الشريعة', words: ['نفس', 'عقل', 'مال', 'نسل'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 62, categories: [
    RawabetCategory(name: 'أنواع الشطائر', words: ['كلوب', 'فرنسي', 'لبناني', 'مكسيكي'], colorIndex: 0),
    RawabetCategory(name: 'شخصيات ألف ليلة وليلة', words: ['شهرزاد', 'شهريار', 'علاء الدين', 'سندباد'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الطوابق', words: ['أرضي', 'علوي', 'سفلي', 'سطح'], colorIndex: 2),
    RawabetCategory(name: 'مصطلحات صحفية', words: ['تحقيق', 'عمود', 'افتتاحية', 'مانشيت'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 63, categories: [
    RawabetCategory(name: 'أنواع الأرضيات', words: ['بلاط', 'رخام', 'باركيه', 'سيراميك'], colorIndex: 0),
    RawabetCategory(name: 'مدن لبنانية', words: ['صيدا', 'طرابلس', 'جبيل', 'زحلة'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الغزل العربي', words: ['عذري', 'صريح', 'بدوي', 'حضري'], colorIndex: 2),
    RawabetCategory(name: 'مكونات العين', words: ['قرنية', 'شبكية', 'بؤبؤ', 'عدسة'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 64, categories: [
    RawabetCategory(name: 'أنواع المربيات', words: ['فراولة', 'مشمش', 'تين', 'برتقال'], colorIndex: 0),
    RawabetCategory(name: 'خطاطون مشهورون', words: ['ابن مقلة', 'ابن البواب', 'هاشم البغدادي', 'حامد الآمدي'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الجسور', words: ['معلق', 'قنطرة', 'متحرك', 'عائم'], colorIndex: 2),
    RawabetCategory(name: 'أنواع النكاح المحرم', words: ['شغار', 'متعة', 'تحليل', 'سر'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 65, categories: [
    RawabetCategory(name: 'أنواع الأسماك النهرية', words: ['بلطي', 'قرموط', 'بوري', 'مبروك'], colorIndex: 0),
    RawabetCategory(name: 'مدن بحرينية', words: ['المنامة', 'المحرق', 'الرفاع', 'عيسى'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الأقمشة التقليدية', words: ['إحرام', 'بشت', 'شال', 'مشلح'], colorIndex: 2),
    RawabetCategory(name: 'مصطلحات بحرية', words: ['ميناء', 'مرسى', 'رصيف', 'حوض'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 66, categories: [
    RawabetCategory(name: 'أنواع السمبوسة', words: ['لحمة', 'جبنة', 'خضار', 'دجاج'], colorIndex: 0),
    RawabetCategory(name: 'رحالة عرب', words: ['ابن بطوطة', 'ابن جبير', 'المسعودي', 'الإدريسي'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الحبال', words: ['قنب', 'نايلون', 'معدني', 'قطني'], colorIndex: 2),
    RawabetCategory(name: 'شروط لا إله إلا الله', words: ['علم', 'يقين', 'صدق', 'إخلاص'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 67, categories: [
    RawabetCategory(name: 'أنواع البسكويت', words: ['دايجستف', 'أوريو', 'بتي فور', 'غريبة'], colorIndex: 0),
    RawabetCategory(name: 'مدن عمانية', words: ['مسقط', 'صلالة', 'نزوى', 'صحار'], colorIndex: 1),
    RawabetCategory(name: 'أنواع المحاكم', words: ['جزائية', 'تجارية', 'أسرة', 'عمالية'], colorIndex: 2),
    RawabetCategory(name: 'أنواع الإعراب', words: ['رفع', 'نصب', 'جر', 'جزم'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 68, categories: [
    RawabetCategory(name: 'مكونات الكشري', words: ['عدس', 'أرز', 'مكرونة', 'بصل مقلي'], colorIndex: 0),
    RawabetCategory(name: 'صحف سماوية', words: ['التوراة', 'الإنجيل', 'الزبور', 'القرآن'], colorIndex: 1),
    RawabetCategory(name: 'أنواع السلالم', words: ['حلزوني', 'كهربائي', 'متحرك', 'عادي'], colorIndex: 2),
    RawabetCategory(name: 'مصطلحات موسيقية', words: ['مقام', 'إيقاع', 'لحن', 'سلم'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 69, categories: [
    RawabetCategory(name: 'أنواع الفطائر', words: ['سبانخ', 'لحمة', 'جبنة', 'زعتر'], colorIndex: 0),
    RawabetCategory(name: 'مدن قطرية', words: ['الدوحة', 'الوكرة', 'الخور', 'الريان'], colorIndex: 1),
    RawabetCategory(name: 'أنواع المتاحف', words: ['تاريخي', 'فني', 'علمي', 'وطني'], colorIndex: 2),
    RawabetCategory(name: 'أنواع الجموع', words: ['سالم', 'تكسير', 'مؤنث', 'قلة'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 70, categories: [
    RawabetCategory(name: 'أنواع الشوربة الشعبية', words: ['حريرة', 'كشك', 'فتة', 'شوربة رأس'], colorIndex: 0),
    RawabetCategory(name: 'معارك بحرية إسلامية', words: ['ذات الصواري', 'ليبانتو', 'بلاط الشهداء', 'الزلاقة'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الحقائب', words: ['ظهر', 'يد', 'سفر', 'لابتوب'], colorIndex: 2),
    RawabetCategory(name: 'أنواع الاستثناء النحوي', words: ['تام', 'مفرغ', 'منقطع', 'متصل'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 71, categories: [
    RawabetCategory(name: 'أنواع العجائن', words: ['فيلو', 'بف', 'سابلي', 'عشر دقائق'], colorIndex: 0),
    RawabetCategory(name: 'مدن سورية', words: ['اللاذقية', 'حمص', 'دير الزور', 'إدلب'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الأنابيب', words: ['نحاسي', 'بلاستيكي', 'حديدي', 'مطاطي'], colorIndex: 2),
    RawabetCategory(name: 'مراتب الدين', words: ['إسلام', 'إيمان', 'إحسان', 'تقوى'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 72, categories: [
    RawabetCategory(name: 'أطباق مصرية', words: ['كشري', 'ملوخية', 'فتة', 'حواوشي'], colorIndex: 0),
    RawabetCategory(name: 'مفكرون عرب معاصرون', words: ['إدوارد سعيد', 'محمد أركون', 'نصر أبو زيد', 'محمد عابد الجابري'], colorIndex: 1),
    RawabetCategory(name: 'أنواع المحركات', words: ['بنزين', 'ديزل', 'كهربائي', 'هجين'], colorIndex: 2),
    RawabetCategory(name: 'أبواب النحو', words: ['مبتدأ', 'إضافة', 'نعت', 'حال'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 73, categories: [
    RawabetCategory(name: 'أنواع الكيك', words: ['إسفنجي', 'شوكولاتة', 'جزر', 'ريد فلفت'], colorIndex: 0),
    RawabetCategory(name: 'واحات عربية', words: ['سيوة', 'تيميمون', 'الأحساء', 'توزر'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الأسوار', words: ['حجري', 'حديدي', 'خشبي', 'شبكي'], colorIndex: 2),
    RawabetCategory(name: 'أنواع الحج', words: ['إفراد', 'تمتع', 'قران', 'عمرة'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 74, categories: [
    RawabetCategory(name: 'أنواع المثلجات', words: ['فانيلا', 'شوكولاتة', 'فراولة', 'فستق'], colorIndex: 0),
    RawabetCategory(name: 'مدن عراقية أخرى', words: ['النجف', 'سامراء', 'تكريت', 'الحلة'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الأقلام', words: ['جاف', 'حبر', 'رصاص', 'فلوماستر'], colorIndex: 2),
    RawabetCategory(name: 'سنن الفطرة', words: ['سواك', 'ختان', 'تقليم', 'استنشاق'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 75, categories: [
    RawabetCategory(name: 'مشروبات غازية', words: ['كولا', 'سفن', 'فانتا', 'سبرايت'], colorIndex: 0),
    RawabetCategory(name: 'شعراء العصر الحديث', words: ['نزار قباني', 'محمود درويش', 'أمل دنقل', 'بدر شاكر السياب'], colorIndex: 1),
    RawabetCategory(name: 'أنواع البطاريات', words: ['ليثيوم', 'قلوية', 'رصاص', 'شمسية'], colorIndex: 2),
    RawabetCategory(name: 'أنواع الوقف في القرآن', words: ['لازم', 'جائز', 'مطلق', 'ممنوع'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 76, categories: [
    RawabetCategory(name: 'أنواع الأومليت', words: ['فرنسي', 'إسباني', 'عربي', 'إيطالي'], colorIndex: 0),
    RawabetCategory(name: 'جزر عربية', words: ['سقطرى', 'فرسان', 'قشم', 'أرواد'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الطلاء', words: ['زيتي', 'مائي', 'بلاستيكي', 'خشبي'], colorIndex: 2),
    RawabetCategory(name: 'نواقض الوضوء', words: ['نوم', 'لمس', 'دم', 'ريح'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 77, categories: [
    RawabetCategory(name: 'أطباق شامية', words: ['محاشي', 'يبرق', 'كبة', 'فتوش'], colorIndex: 0),
    RawabetCategory(name: 'روائيون عرب', words: ['نجيب محفوظ', 'غسان كنفاني', 'الطيب صالح', 'أحلام مستغانمي'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الأسقف', words: ['مسطح', 'مائل', 'قبة', 'جمالون'], colorIndex: 2),
    RawabetCategory(name: 'أقسام التوحيد', words: ['ربوبية', 'ألوهية', 'أسماء', 'صفات'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 78, categories: [
    RawabetCategory(name: 'أنواع التوابل الحلوة', words: ['فانيلا', 'قرفة', 'يانسون', 'هيل'], colorIndex: 0),
    RawabetCategory(name: 'مدن سعودية أخرى', words: ['تبوك', 'أبها', 'حائل', 'نجران'], colorIndex: 1),
    RawabetCategory(name: 'أنواع المراوح', words: ['سقفية', 'أرضية', 'مكتبية', 'شفاطة'], colorIndex: 2),
    RawabetCategory(name: 'مبطلات الصلاة', words: ['كلام', 'أكل', 'ضحك', 'انحراف'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 79, categories: [
    RawabetCategory(name: 'أنواع الدقيق', words: ['قمح', 'ذرة', 'شوفان', 'لوز'], colorIndex: 0),
    RawabetCategory(name: 'قنوات عربية', words: ['الجزيرة', 'العربية', 'روتانا', 'أم بي سي'], colorIndex: 1),
    RawabetCategory(name: 'أنواع المظلات', words: ['شمسية', 'مطرية', 'عسكرية', 'شاطئ'], colorIndex: 2),
    RawabetCategory(name: 'مصطلحات التصوف', words: ['حال', 'مقام', 'فناء', 'كشف'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 80, categories: [
    RawabetCategory(name: 'مأكولات خليجية', words: ['مجبوس', 'ثريد', 'هريس', 'بلاليط'], colorIndex: 0),
    RawabetCategory(name: 'عواصم آسيوية', words: ['طوكيو', 'بكين', 'دلهي', 'جاكرتا'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الستائر', words: ['قماش', 'خيزران', 'رول', 'عمودية'], colorIndex: 2),
    RawabetCategory(name: 'أنواع الإمامة', words: ['كبرى', 'صغرى', 'صلاة', 'دعاء'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 81, categories: [
    RawabetCategory(name: 'أنواع الحمص', words: ['مسبحة', 'بليلة', 'حمص بطحينة', 'فلافل'], colorIndex: 0),
    RawabetCategory(name: 'مدن مغربية أخرى', words: ['طنجة', 'أغادير', 'مكناس', 'تطوان'], colorIndex: 1),
    RawabetCategory(name: 'أنواع المناشف', words: ['يد', 'استحمام', 'شعر', 'مطبخ'], colorIndex: 2),
    RawabetCategory(name: 'مصطلحات أصول الفقه', words: ['قياس', 'إجماع', 'اجتهاد', 'استحسان'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 82, categories: [
    RawabetCategory(name: 'أنواع المقبلات', words: ['حمص', 'متبل', 'تبولة', 'بابا غنوج'], colorIndex: 0),
    RawabetCategory(name: 'ملاعب كرة قدم عربية', words: ['لوسيل', 'المدينة', 'برج العرب', 'الجوهرة'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الشنط', words: ['جلد', 'قماش', 'بلاستيك', 'ورق'], colorIndex: 2),
    RawabetCategory(name: 'أنواع المد في التجويد', words: ['طبيعي', 'متصل', 'منفصل', 'لازم'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 83, categories: [
    RawabetCategory(name: 'أنواع البقلاوة', words: ['فستقية', 'جوزية', 'كاجوية', 'عسلية'], colorIndex: 0),
    RawabetCategory(name: 'مدن أندلسية', words: ['قرطبة', 'غرناطة', 'إشبيلية', 'طليطلة'], colorIndex: 1),
    RawabetCategory(name: 'أنواع المصاعد', words: ['كهربائي', 'هيدروليكي', 'سلم متحرك', 'بانورامي'], colorIndex: 2),
    RawabetCategory(name: 'أنواع الذنوب', words: ['كبيرة', 'صغيرة', 'لمم', 'فاحشة'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 84, categories: [
    RawabetCategory(name: 'أنواع البرغر', words: ['لحم', 'دجاج', 'سمك', 'نباتي'], colorIndex: 0),
    RawabetCategory(name: 'مؤرخون عرب', words: ['ابن خلدون', 'الطبري', 'ابن الأثير', 'ابن كثير'], colorIndex: 1),
    RawabetCategory(name: 'أنواع المسابح', words: ['أولمبي', 'خاص', 'أطفال', 'علاجي'], colorIndex: 2),
    RawabetCategory(name: 'أنواع السجود', words: ['صلاة', 'سهو', 'تلاوة', 'شكر'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 85, categories: [
    RawabetCategory(name: 'أنواع الكفتة', words: ['مشوية', 'داوود باشا', 'بالصينية', 'أصابع'], colorIndex: 0),
    RawabetCategory(name: 'قصور تاريخية عربية', words: ['الحمراء', 'الأخيضر', 'المشتى', 'عمرة'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الأرفف', words: ['خشبي', 'معدني', 'زجاجي', 'معلق'], colorIndex: 2),
    RawabetCategory(name: 'مفسدات الصيام', words: ['أكل', 'شرب', 'جماع', 'تقيؤ'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 86, categories: [
    RawabetCategory(name: 'أنواع الأسماك المشوية', words: ['دنيس', 'سبيطي', 'قاروص', 'شعور'], colorIndex: 0),
    RawabetCategory(name: 'عواصم أفريقية', words: ['نيروبي', 'أديس أبابا', 'أكرا', 'داكار'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الغرف', words: ['نوم', 'معيشة', 'طعام', 'مكتب'], colorIndex: 2),
    RawabetCategory(name: 'شروط الزكاة', words: ['نصاب', 'حول', 'ملك', 'نماء'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 87, categories: [
    RawabetCategory(name: 'أنواع المعجنات الشامية', words: ['صفيحة', 'مناقيش', 'فطيرة', 'لحم بعجين'], colorIndex: 0),
    RawabetCategory(name: 'عالمات مسلمات', words: ['مريم الأسطرلابي', 'فاطمة الفهري', 'زبيدة بنت جعفر', 'لبانة القرطبية'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الكراسي', words: ['مكتب', 'هزاز', 'طعام', 'كنبة'], colorIndex: 2),
    RawabetCategory(name: 'أسماء يوم القيامة', words: ['الحاقة', 'القارعة', 'الطامة', 'الصاخة'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 88, categories: [
    RawabetCategory(name: 'توابل مغربية', words: ['راس الحانوت', 'حريصة', 'شرمولة', 'زعتر بري'], colorIndex: 0),
    RawabetCategory(name: 'أودية عربية', words: ['حنيفة', 'رم', 'قاديشا', 'بوسكورة'], colorIndex: 1),
    RawabetCategory(name: 'أنواع المرايا', words: ['جدارية', 'يدوية', 'مكبرة', 'جانبية'], colorIndex: 2),
    RawabetCategory(name: 'مصطلحات العمارة الإسلامية', words: ['مشربية', 'إيوان', 'صحن', 'زخرفة'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 89, categories: [
    RawabetCategory(name: 'أنواع التغميسات', words: ['لبنة', 'جواكامولي', 'صلصة', 'محمرة'], colorIndex: 0),
    RawabetCategory(name: 'مجلات عربية تاريخية', words: ['المقتطف', 'الهلال', 'العربي', 'الرسالة'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الساحات', words: ['عامة', 'رياضية', 'تجارية', 'عسكرية'], colorIndex: 2),
    RawabetCategory(name: 'صفات المنافقين', words: ['كذب', 'خيانة', 'غدر', 'فجور'], colorIndex: 3),
  ]),
  RawabetPuzzle(id: 90, categories: [
    RawabetCategory(name: 'أنواع الإفطار الشرقي', words: ['شكشوكة', 'فتة', 'مناقيش', 'بيض بالقاورمة'], colorIndex: 0),
    RawabetCategory(name: 'مخترعون عرب ومسلمون', words: ['ابن الهيثم', 'الجزري', 'عباس بن فرناس', 'جابر بن حيان'], colorIndex: 1),
    RawabetCategory(name: 'أنواع الممرات', words: ['ممشى', 'نفق', 'جسر', 'رواق'], colorIndex: 2),
    RawabetCategory(name: 'أنواع النسك', words: ['إفراد', 'تمتع', 'قران', 'عمرة مفردة'], colorIndex: 3),
  ]),
];
