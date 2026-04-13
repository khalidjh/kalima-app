import 'dart:math';
import 'words.dart';

class KharbashaPuzzle {
  final String word;
  final String hint;
  final String scrambled;

  const KharbashaPuzzle({
    required this.word,
    required this.hint,
    required this.scrambled,
  });
}

class _WordHint {
  final String word;
  final String hint;
  const _WordHint(this.word, this.hint);
}

const List<_WordHint> _wordsWithHints = [
  _WordHint('قهوة', 'مشروب ساخن \u2615'),
  _WordHint('مدرسة', 'مكان للتعليم \ud83c\udfeb'),
  _WordHint('طائرة', 'وسيلة سفر \u2708\ufe0f'),
  _WordHint('هاتف', 'جهاز اتصال \ud83d\udcf1'),
  _WordHint('كتاب', 'مصدر معرفة \ud83d\udcd6'),
  _WordHint('مسجد', 'مكان عبادة \ud83d\udd4c'),
  _WordHint('بحر', 'ماء مالح \ud83c\udf0a'),
  _WordHint('شمس', 'نجم ساطع \u2600\ufe0f'),
  _WordHint('قمر', 'يضيء الليل \ud83c\udf19'),
  _WordHint('وردة', 'زهرة جميلة \ud83c\udf39'),
  _WordHint('جبل', 'مرتفع طبيعي \u26f0\ufe0f'),
  _WordHint('سيارة', 'وسيلة تنقل \ud83d\ude97'),
  _WordHint('حديقة', 'مكان أخضر \ud83c\udf33'),
  _WordHint('ساعة', 'تقيس الوقت \u231a'),
  _WordHint('فراشة', 'حشرة ملونة \ud83e\udd8b'),
  _WordHint('نافذة', 'فتحة في الجدار \ud83e\ude9f'),
  _WordHint('مطبخ', 'مكان الطبخ \ud83c\udf73'),
  _WordHint('سلم', 'درجات \ud83e\ude9c'),
  _WordHint('قطة', 'حيوان أليف \ud83d\udc31'),
  _WordHint('حصان', 'حيوان يركض \ud83d\udc34'),
  _WordHint('عصفور', 'يطير في السماء \ud83d\udc26'),
  _WordHint('سمكة', 'تعيش في الماء \ud83d\udc1f'),
  _WordHint('مفتاح', 'يفتح الباب \ud83d\udd11'),
  _WordHint('مظلة', 'تحمي من المطر \u2602\ufe0f'),
  _WordHint('صاروخ', 'يصل للفضاء \ud83d\ude80'),
  _WordHint('كرة', 'تُلعب بها \u26bd'),
  _WordHint('نجمة', 'تلمع في السماء \u2b50'),
  _WordHint('دجاجة', 'طائر مزرعة \ud83d\udc14'),
  _WordHint('قلم', 'يكتب به \u270f\ufe0f'),
  _WordHint('برتقال', 'فاكهة حمضية \ud83c\udf4a'),
  _WordHint('مزرعة', 'أرض زراعية \ud83c\udf3e'),
  _WordHint('طبيب', 'يعالج المرضى \ud83d\udc68\u200d\u2695\ufe0f'),
  _WordHint('رئيس', 'القائد \ud83d\udc54'),
  _WordHint('فيلم', 'تشاهده في السينما \ud83c\udfac'),
  _WordHint('مطار', 'مكان إقلاع الطائرات \ud83d\udee5\ufe0f'),
  _WordHint('كنز', 'ذهب مخفي \ud83d\udc8e'),
  _WordHint('سرير', 'تنام عليه \ud83d\udecf\ufe0f'),
  _WordHint('ثلاجة', 'تحفظ الطعام \ud83e\uddca'),
  _WordHint('عصفورة', 'طائر صغير \ud83d\udc26'),
  _WordHint('خيمة', 'بيت من قماش \u26fa'),
  _WordHint('مصباح', 'يضيء الغرفة \ud83d\udca1'),
  _WordHint('سحابة', 'بيضاء في السماء \u2601\ufe0f'),
  _WordHint('دراجة', 'تركبها وتدور \ud83d\udeb2'),
  _WordHint('طاولة', 'تضع عليها الأشياء'),
  _WordHint('بوصلة', 'تشير للاتجاه \ud83e\udded'),
  _WordHint('زجاجة', 'وعاء زجاجي'),
  _WordHint('موسيقى', 'أصوات جميلة \ud83c\udfb5'),
  _WordHint('حقيبة', 'تحمل فيها أشياءك \ud83d\udc5c'),
  _WordHint('سلحفاة', 'تمشي ببطء \ud83d\udc22'),
  _WordHint('دفتر', 'تكتب فيه \ud83d\udcd3'),
];

String _scrambleSeeded(String word, int seed) {
  final letters = word.split('');
  final rng = Random(seed);
  List<String> result;
  int attempts = 0;
  do {
    result = List.from(letters);
    for (int i = result.length - 1; i > 0; i--) {
      final j = rng.nextInt(i + 1);
      final tmp = result[i];
      result[i] = result[j];
      result[j] = tmp;
    }
    attempts++;
  } while (result.join() == word && attempts < 50);
  return result.join();
}

KharbashaPuzzle getDailyKharbashaPuzzle() {
  final days = getPuzzleNumber() - 1;
  final idx = days % _wordsWithHints.length;
  final entry = _wordsWithHints[idx];
  return KharbashaPuzzle(
    word: entry.word,
    hint: entry.hint,
    scrambled: _scrambleSeeded(entry.word, days),
  );
}

int getKharbashaPuzzleNumber() => getPuzzleNumber();
