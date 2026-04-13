import 'dart:math';
import 'words.dart';

class TarteebPair {
  final String itemA;
  final double valueA;
  final String itemB;
  final double valueB;
  final String unit;
  final String category;

  const TarteebPair({
    required this.itemA,
    required this.valueA,
    required this.itemB,
    required this.valueB,
    required this.unit,
    required this.category,
  });

  bool get isHigherCorrect => valueB > valueA;
}

const List<TarteebPair> _allPairs = [
  // Population
  TarteebPair(itemA: 'القاهرة', valueA: 21, itemB: 'الرياض', valueB: 7.6, unit: 'مليون', category: 'عدد سكان المدن'),
  TarteebPair(itemA: 'الرياض', valueA: 7.6, itemB: 'جدة', valueB: 4.6, unit: 'مليون', category: 'عدد سكان المدن'),
  TarteebPair(itemA: 'جدة', valueA: 4.6, itemB: 'دبي', valueB: 3.5, unit: 'مليون', category: 'عدد سكان المدن'),
  TarteebPair(itemA: 'بغداد', valueA: 7.6, itemB: 'عمّان', valueB: 4.2, unit: 'مليون', category: 'عدد سكان المدن'),
  TarteebPair(itemA: 'الخرط��م', valueA: 5.3, itemB: 'تونس', valueB: 2.6, unit: 'مليون', category: 'عدد سكان المدن'),
  TarteebPair(itemA: 'صنعاء', valueA: 4, itemB: 'الكويت', valueB: 3, unit: '��ليون', category: 'عدد سكان المدن'),
  TarteebPair(itemA: 'الدوحة', valueA: 2.4, itemB: 'بيروت', valueB: 2.4, unit: 'مليون', category: 'عدد سكان المدن'),
  TarteebPair(itemA: 'مكة', valueA: 2, itemB: 'الرباط', valueB: 1.9, unit: 'مليون', category: 'عدد سكان المدن'),
  TarteebPair(itemA: 'أبوظبي', valueA: 1.5, itemB: 'المدينة', valueB: 1.4, unit: 'مليون', category: 'عدد سكان المدن'),
  TarteebPair(itemA: 'الجزائ��', valueA: 3.4, itemB: 'الدمام', valueB: 1.2, unit: 'مليون', category: 'عدد سكان المدن'),
  TarteebPair(itemA: 'نواكشوط', valueA: 1.2, itemB: 'مسقط', valueB: 1.4, unit: 'مليون', category: 'عدد سكان المدن'),
  TarteebPair(itemA: 'القاهرة', valueA: 21, itemB: 'بغداد', valueB: 7.6, unit: 'مليون', category: 'عدد سكان ا��مدن'),
  // Area
  TarteebPair(itemA: 'ا��جزائر', valueA: 2381, itemB: 'السع��دية', valueB: 2150, unit: 'ألف كم\u00b2', category: 'مساحة الدول'),
  TarteebPair(itemA: 'السعودية', valueA: 2150, itemB: 'السودان', valueB: 1861, unit: 'ألف كم\u00b2', category: 'مساحة الدول'),
  TarteebPair(itemA: 'السودان', valueA: 1861, itemB: 'ليبيا', valueB: 1759, unit: 'ألف كم\u00b2', category: 'مساحة الدول'),
  TarteebPair(itemA: 'ليبيا', valueA: 1759, itemB: 'مصر', valueB: 1002, unit: 'ألف كم\u00b2', category: 'مساحة الدول'),
  TarteebPair(itemA: 'مصر', valueA: 1002, itemB: 'اليمن', valueB: 527, unit: 'ألف كم\u00b2', category: 'مساحة الدول'),
  TarteebPair(itemA: 'اليمن', valueA: 527, itemB: 'المغرب', valueB: 446, unit: 'ألف كم\u00b2', category: 'مساحة الدول'),
  TarteebPair(itemA: 'المغ��ب', valueA: 446, itemB: 'العراق', valueB: 438, unit: 'ألف كم\u00b2', category: 'مساحة الدول'),
  TarteebPair(itemA: 'العراق', valueA: 438, itemB: 'عمان', valueB: 309, unit: 'أ��ف كم\u00b2', category: 'مساحة الدول'),
  TarteebPair(itemA: 'عمان', valueA: 309, itemB: 'سوريا', valueB: 185, unit: 'ألف كم\u00b2', category: 'مساحة الدول'),
  TarteebPair(itemA: 'سوريا', valueA: 185, itemB: 'الأردن', valueB: 89, unit: 'ألف كم\u00b2', category: 'مساحة الدول'),
  TarteebPair(itemA: 'الأر��ن', valueA: 89, itemB: 'الإمارات', valueB: 83, unit: 'ألف كم\u00b2', category: 'مساحة الدول'),
  TarteebPair(itemA: 'فلسطين', valueA: 27, itemB: 'الكويت', valueB: 17, unit: 'ألف كم\u00b2', category: 'مساحة الدول'),
  TarteebPair(itemA: 'قطر', valueA: 11.6, itemB: 'لبنان', valueB: 10.4, unit: 'ألف كم\u00b2', category: 'مساحة الدول'),
  TarteebPair(itemA: 'لب��ان', valueA: 10.4, itemB: 'البحرين', valueB: 0.8, unit: 'ألف كم\u00b2', category: 'مساحة الدول'),
  // Towers
  TarteebPair(itemA: 'برج خليفة', valueA: 828, itemB: 'برج الساعة', valueB: 601, unit: 'متر', category: 'ارتفاع الأبراج'),
  TarteebPair(itemA: 'برج الساعة', valueA: 601, itemB: 'برج المملكة', valueB: 302, unit: 'متر', category: 'ارتفاع الأبراج'),
  TarteebPair(itemA: 'برج المملكة', valueA: 302, itemB: 'برج الفيصلية', valueB: 267, unit: 'متر', category: 'ارتفاع الأبراج'),
  TarteebPair(itemA: 'برج الفيصلية', valueA: 267, itemB: 'أهرام الجيزة', valueB: 146, unit: 'متر', category: 'ارتفاع الأبراج'),
  TarteebPair(itemA: 'برج خليفة', valueA: 828, itemB: '��هرام الجيزة', valueB: 146, unit: 'متر', category: 'ارتفاع الأبراج'),
  // Distances
  TarteebPair(itemA: 'الرياض - جدة', valueA: 950, itemB: 'مكة - المد��نة', valueB: 420, unit: 'كم', category: 'مسافات بين المدن'),
  TarteebPair(itemA: 'مكة - المدينة', valueA: 420, itemB: 'الري��ض - الدمام', valueB: 400, unit: 'كم', category: 'م��افات بين المدن'),
  TarteebPair(itemA: 'القاهرة - بيروت', valueA: 660, itemB: 'دبي - أبوظبي', valueB: 130, unit: 'كم', category: 'مسافات بين المدن'),
  TarteebPair(itemA: 'الرياض - جدة', valueA: 950, itemB: 'القاهرة - بيروت', valueB: 660, unit: 'كم', category: 'مسافات بين المدن'),
];

List<TarteebPair> getDailyTarteebPairs() {
  final seed = getPuzzleNumber();
  final rng = Random(seed);
  final shuffled = List<TarteebPair>.from(_allPairs);
  shuffled.shuffle(rng);
  return shuffled.take(10).toList();
}

int getTarteebPuzzleNumber() => getPuzzleNumber();
