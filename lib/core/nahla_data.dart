import 'words.dart';

class NahlaPuzzle {
  final List<String> letters;
  final String requiredLetter;
  final List<String> validWords;
  final List<String> pangrams;
  final int maxScore;

  const NahlaPuzzle({
    required this.letters,
    required this.requiredLetter,
    required this.validWords,
    this.pangrams = const [],
    this.maxScore = 0,
  });
}

int calculateWordScore(String word, List<String> letters) {
  final len = word.length;
  int score = len <= 3 ? 1 : len;
  if (isPangram(word, letters)) score += 7;
  return score;
}

bool isPangram(String word, List<String> letters) {
  return letters.every((l) => word.contains(l));
}

String getRank(int score, int maxScore) {
  final pct = maxScore > 0 ? (score / maxScore) * 100 : 0.0;
  if (pct >= 100) return 'نحلة ذهبية';
  if (pct >= 75) return 'عبقري';
  if (pct >= 60) return 'مبدع';
  if (pct >= 45) return 'رائع';
  if (pct >= 30) return 'ممتاز';
  if (pct >= 15) return 'جيد';
  return 'مبتدئ';
}

double getRankProgress(int score, int maxScore) {
  if (maxScore <= 0) return 0;
  return (score / maxScore).clamp(0.0, 1.0);
}

NahlaPuzzle getDailyNahlaPuzzle() {
  final days = getPuzzleNumber() - 1;
  final idx = days % nahlaPuzzles.length;
  return nahlaPuzzles[idx];
}

int getNahlaPuzzleNumber() => getPuzzleNumber();

int _calcMax(NahlaPuzzle p) {
  return p.validWords.fold(0, (sum, w) {
    return sum + calculateWordScore(w, p.letters);
  });
}

final List<NahlaPuzzle> nahlaPuzzles = _initPuzzles();

List<NahlaPuzzle> _initPuzzles() {
  return _rawPuzzles.map((p) {
    final max = _calcMax(p);
    return NahlaPuzzle(
      letters: p.letters,
      requiredLetter: p.requiredLetter,
      validWords: p.validWords,
      pangrams: p.pangrams,
      maxScore: max,
    );
  }).toList();
}

const List<NahlaPuzzle> _rawPuzzles = [
  NahlaPuzzle(
    letters: ['ك', 'ت', 'ب', 'ر', 'م', 'ا', 'ل'],
    requiredLetter: 'ك',
    validWords: ['كتب', 'كتاب', 'كاتب', 'مكتب', 'كلام', 'ملك', 'تكلم', 'كلم', 'كرم', 'كبر', 'بكر', 'ركب', 'ركاب', 'بكت', 'مبارك', 'بارك', 'كامل', 'مالك', 'مكر', 'ماكر', 'كمال', 'ركام', 'تملك', 'كرام', 'تكبر', 'تبارك', 'ترك', 'ركل', 'مركب', 'مكتمل', 'تكرار', 'ابتكر', 'ابتكار', 'كبار', 'مبتكر', 'بركات', 'متكبر'],
  ),
  NahlaPuzzle(
    letters: ['ش', 'ر', 'ق', 'ة', 'م', 'ا', 'ل'],
    requiredLetter: 'ش',
    validWords: ['شرق', 'شمال', 'شام', 'شامة', 'مشرق', 'رشق', 'شقة', 'شاشة', 'شاش', 'شمل', 'شملة', 'قشر', 'قشرة', 'مشقة', 'شرم', 'شمة', 'قماش', 'قماشة', 'شارة', 'شرقة', 'شرارة', 'شمر', 'رشم', 'قرش', 'مشرقة', 'شمام', 'شقاق', 'شقر', 'شرة'],
  ),
  NahlaPuzzle(
    letters: ['ع', 'ل', 'م', 'د', 'ر', 'ة', 'ي'],
    requiredLetter: 'ع',
    validWords: ['علم', 'علمي', 'عرة', 'عمد', 'عميد', 'معلم', 'معمل', 'عمل', 'عملة', 'عملي', 'رعي', 'رعية', 'عري', 'عمدة', 'لمع', 'لمعة', 'عدة', 'عمر', 'عمرة', 'معدة', 'مرعي', 'ريع', 'درع', 'مدعي', 'معد', 'عيد', 'علة', 'عدل', 'علمية', 'ردع', 'مدرعة', 'معرة', 'عدم'],
  ),
  NahlaPuzzle(
    letters: ['ن', 'و', 'ر', 'ة', 'م', 'ا', 'ح'],
    requiredLetter: 'ن',
    validWords: ['نور', 'نورة', 'نار', 'نمرة', 'نومة', 'نام', 'نمو', 'منارة', 'منور', 'منح', 'منحة', 'مونة', 'حانة', 'نوم', 'نحو', 'حنان', 'نحر', 'نمر', 'مرن', 'نوح', 'رمان', 'حنا', 'حنون', 'مران', 'نوار', 'مناورة', 'ران', 'حرن', 'ناور', 'محن', 'مناور', 'ونة', 'مرونة', 'مرنة', 'حرمان', 'نحام', 'امن', 'مانح'],
  ),
  NahlaPuzzle(
    letters: ['ب', 'ح', 'ر', 'ة', 'م', 'ل', 'ي'],
    requiredLetter: 'ب',
    validWords: ['بحر', 'بحرة', 'بحري', 'بري', 'برية', 'بلة', 'بلي', 'بيرة', 'برميل', 'حبر', 'حبرية', 'ربح', 'رحب', 'بلم', 'حبل', 'بريم', 'بحيرة', 'بحرية', 'مبرة', 'ريبة', 'حبة', 'مرحب', 'بلح', 'محبة', 'حرب', 'حربة', 'حربي', 'ربي', 'مربي'],
  ),
  NahlaPuzzle(
    letters: ['ص', 'ف', 'ة', 'ر', 'م', 'ن', 'ا'],
    requiredLetter: 'ص',
    validWords: ['صفر', 'صفرة', 'صفا', 'صنف', 'صار', 'صارم', 'صارمة', 'صرامة', 'صنارة', 'مصفاة', 'رصف', 'صنم', 'نصر', 'نصف', 'نصرة', 'مصر', 'مصنف', 'ناصر', 'ناصرة', 'صرف', 'منصف', 'منصة', 'رصاص', 'صام', 'صرة', 'مصران', 'صنافة', 'صفن', 'صمام', 'صنفرة', 'مصنفة'],
  ),
  NahlaPuzzle(
    letters: ['ط', 'ب', 'خ', 'ة', 'م', 'ر', 'ي'],
    requiredLetter: 'ط',
    validWords: ['طبخ', 'طبخة', 'طبيخ', 'طرة', 'طرية', 'طير', 'طيرة', 'بطيخ', 'بطيخة', 'مطبخ', 'خبط', 'خبطة', 'ربط', 'رطب', 'رطبة', 'بيطر', 'مطر', 'مطرة', 'خطر', 'خطة', 'خطير', 'خطيرة', 'مخطط', 'طبية', 'طيب', 'طيبة', 'خيط', 'خريطة', 'مطبخة', 'ربيطة', 'مطربة', 'بطر', 'خطب', 'خطبة', 'مرطب'],
  ),
  NahlaPuzzle(
    letters: ['ج', 'ب', 'ل', 'ة', 'م', 'ا', 'ن'],
    requiredLetter: 'ج',
    validWords: ['جبل', 'جمل', 'جملة', 'جناة', 'جنة', 'جان', 'جال', 'جبال', 'لجنة', 'نجل', 'نجلة', 'بنج', 'جنب', 'جانب', 'جمال', 'نجم', 'نجمة', 'مجال', 'جبان', 'جبانة', 'جلب', 'جلبة', 'جلا', 'مجلة', 'منجل', 'جبنة', 'جمة', 'جنا', 'جامل', 'مجمل', 'نجاة'],
  ),
  NahlaPuzzle(
    letters: ['و', 'ز', 'ن', 'ة', 'م', 'ر', 'ي'],
    requiredLetter: 'و',
    validWords: ['وزن', 'وزنة', 'وزير', 'وزيرة', 'موز', 'موزة', 'ورم', 'ورمة', 'نورة', 'نورية', 'رومي', 'رومية', 'وزر', 'وزرة', 'مور', 'نوري', 'مروية', 'زور', 'زورة', 'نوم', 'يوم', 'نور', 'روم'],
  ),
  NahlaPuzzle(
    letters: ['ض', 'و', 'ء', 'ن', 'ر', 'ة', 'م'],
    requiredLetter: 'ض',
    validWords: ['ضوء', 'ضمن', 'رضم', 'نضرة', 'مضر', 'مضرة', 'روضة', 'روض', 'وضوء', 'ضرة', 'نضر', 'مرض', 'مضمون', 'ضمور', 'ضمة', 'وضر', 'ضرر', 'ضرورة', 'مروض'],
  ),
  NahlaPuzzle(
    letters: ['ذ', 'ه', 'ب', 'ة', 'م', 'ر', 'ي'],
    requiredLetter: 'ذ',
    validWords: ['ذهب', 'ذهبي', 'مذهب', 'مذهبي', 'ذرة', 'ذري', 'ذمة', 'ذمي', 'بذر', 'بذرة', 'مهذب', 'مهذبة', 'ذهبية', 'مذهبية'],
  ),
  NahlaPuzzle(
    letters: ['ث', 'ل', 'ج', 'ة', 'م', 'ر', 'ي'],
    requiredLetter: 'ث',
    validWords: ['ثلج', 'ثلجي', 'ثلة', 'ثمرة', 'مثل', 'مثلي', 'مثير', 'مثيرة', 'ثلث', 'ثرثرة', 'ثرية', 'ريث', 'ثمر', 'ثري', 'ثلم', 'ثملة', 'ملثم', 'ملثمة', 'ثمة', 'جثة', 'جثم', 'مثلج', 'مثلجة'],
  ),
  NahlaPuzzle(
    letters: ['ظ', 'ل', 'م', 'ة', 'ر', 'ي', 'ف'],
    requiredLetter: 'ظ',
    validWords: ['ظلم', 'ظلمة', 'ظرف', 'ظريف', 'ظريفة', 'مظلم', 'مظلمة', 'ظفر', 'لفظ', 'لفظي', 'لفظية', 'فظة', 'ظلمي', 'مظلة'],
  ),
  NahlaPuzzle(
    letters: ['خ', 'ي', 'ر', 'ة', 'م', 'ل', 'ب'],
    requiredLetter: 'خ',
    validWords: ['خير', 'خيرة', 'خيري', 'خيل', 'خبيرة', 'خبير', 'خبر', 'خبري', 'مخيل', 'مخيلة', 'مخبر', 'مخبري', 'مخرمة', 'خلبة', 'خلة', 'خرمة', 'بخل', 'بخيل', 'مخلة', 'خمرة', 'خمر', 'خيمة', 'خيرية', 'خربة', 'خرب', 'خليل', 'خليلة', 'مخيم', 'مخيمة'],
  ),
];
