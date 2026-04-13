import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GameStorage {
  static final GameStorage _instance = GameStorage._();
  factory GameStorage() => _instance;
  GameStorage._();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs => _prefs!;

  // ---- Generic helpers ----

  Future<void> setJson(String key, Map<String, dynamic> data) async {
    await prefs.setString(key, jsonEncode(data));
  }

  Map<String, dynamic>? getJson(String key) {
    final s = prefs.getString(key);
    if (s == null) return null;
    return jsonDecode(s) as Map<String, dynamic>;
  }

  // ---- Hurouf (Wordle) ----

  String _huroufKey(int puzzleNum) => 'hurouf_$puzzleNum';

  Future<void> saveHuroufState(int puzzleNum, Map<String, dynamic> state) async {
    await setJson(_huroufKey(puzzleNum), state);
  }

  Map<String, dynamic>? loadHuroufState(int puzzleNum) {
    return getJson(_huroufKey(puzzleNum));
  }

  Future<void> saveHuroufStats(Map<String, dynamic> stats) async {
    await setJson('hurouf_stats', stats);
  }

  Map<String, dynamic> loadHuroufStats() {
    return getJson('hurouf_stats') ?? {
      'played': 0,
      'won': 0,
      'currentStreak': 0,
      'maxStreak': 0,
      'distribution': [0, 0, 0, 0, 0, 0],
    };
  }

  // ---- Rawabet (Connections) ----

  String _rawabetKey(int puzzleNum) => 'rawabet_$puzzleNum';

  Future<void> saveRawabetState(int puzzleNum, Map<String, dynamic> state) async {
    await setJson(_rawabetKey(puzzleNum), state);
  }

  Map<String, dynamic>? loadRawabetState(int puzzleNum) {
    return getJson(_rawabetKey(puzzleNum));
  }

  Future<void> saveRawabetStats(Map<String, dynamic> stats) async {
    await setJson('rawabet_stats', stats);
  }

  Map<String, dynamic> loadRawabetStats() {
    return getJson('rawabet_stats') ?? {
      'played': 0,
      'won': 0,
      'currentStreak': 0,
      'maxStreak': 0,
    };
  }

  // ---- Nahla (Spelling Bee) ----

  String _nahlaKey(int puzzleNum) => 'nahla_$puzzleNum';

  Future<void> saveNahlaState(int puzzleNum, Map<String, dynamic> state) async {
    await setJson(_nahlaKey(puzzleNum), state);
  }

  Map<String, dynamic>? loadNahlaState(int puzzleNum) {
    return getJson(_nahlaKey(puzzleNum));
  }

  Future<void> saveNahlaStats(Map<String, dynamic> stats) async {
    await setJson('nahla_stats', stats);
  }

  Map<String, dynamic> loadNahlaStats() {
    return getJson('nahla_stats') ?? {
      'played': 0,
      'maxScore': 0,
      'currentStreak': 0,
      'maxStreak': 0,
    };
  }

  // ---- Kharbasha (Scramble) ----

  String _kharbashaKey(int puzzleNum) => 'kharbasha_$puzzleNum';

  Future<void> saveKharbashaState(int puzzleNum, Map<String, dynamic> state) async {
    await setJson(_kharbashaKey(puzzleNum), state);
  }

  Map<String, dynamic>? loadKharbashaState(int puzzleNum) {
    return getJson(_kharbashaKey(puzzleNum));
  }

  Future<void> saveKharbashaStats(Map<String, dynamic> stats) async {
    await setJson('kharbasha_stats', stats);
  }

  Map<String, dynamic> loadKharbashaStats() {
    return getJson('kharbasha_stats') ?? {
      'played': 0,
      'won': 0,
      'currentStreak': 0,
      'maxStreak': 0,
    };
  }

  // ---- Tarteeb (Higher/Lower) ----

  String _tarteebKey(int puzzleNum) => 'tarteeb_$puzzleNum';

  Future<void> saveTarteebState(int puzzleNum, Map<String, dynamic> state) async {
    await setJson(_tarteebKey(puzzleNum), state);
  }

  Map<String, dynamic>? loadTarteebState(int puzzleNum) {
    return getJson(_tarteebKey(puzzleNum));
  }

  Future<void> saveTarteebStats(Map<String, dynamic> stats) async {
    await setJson('tarteeb_stats', stats);
  }

  Map<String, dynamic> loadTarteebStats() {
    return getJson('tarteeb_stats') ?? {
      'played': 0,
      'totalScore': 0,
      'currentStreak': 0,
      'maxStreak': 0,
    };
  }

  // ---- Game Completion Tracking ----

  Future<void> markGameCompleted(String game, int puzzleNum) async {
    await prefs.setInt('completed_${game}_puzzle', puzzleNum);
  }

  bool isGameCompleted(String game, int puzzleNum) {
    return prefs.getInt('completed_${game}_puzzle') == puzzleNum;
  }

  // ---- Settings ----

  bool get hardMode => prefs.getBool('hard_mode') ?? false;
  Future<void> setHardMode(bool v) => prefs.setBool('hard_mode', v);

  bool get soundEnabled => prefs.getBool('sound_enabled') ?? true;
  Future<void> setSoundEnabled(bool v) => prefs.setBool('sound_enabled', v);

  bool get notificationsEnabled => prefs.getBool('notifications_enabled') ?? true;
  Future<void> setNotificationsEnabled(bool v) => prefs.setBool('notifications_enabled', v);
}
