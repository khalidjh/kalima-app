import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._();
  factory SoundManager() => _instance;
  SoundManager._();

  bool _soundEnabled = true;
  bool get soundEnabled => _soundEnabled;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('sound_enabled') ?? true;
  }

  Future<void> toggleSound() async {
    _soundEnabled = !_soundEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', _soundEnabled);
  }

  void tap() {
    if (!_soundEnabled) return;
    HapticFeedback.lightImpact();
  }

  void correct() {
    if (!_soundEnabled) return;
    HapticFeedback.mediumImpact();
  }

  void wrong() {
    if (!_soundEnabled) return;
    HapticFeedback.heavyImpact();
  }

  void win() {
    if (!_soundEnabled) return;
    HapticFeedback.mediumImpact();
  }

  void flip() {
    if (!_soundEnabled) return;
    HapticFeedback.lightImpact();
  }

  void shuffle() {
    if (!_soundEnabled) return;
    HapticFeedback.selectionClick();
  }
}
