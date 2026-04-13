import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._();
  factory SoundManager() => _instance;
  SoundManager._();

  bool _soundEnabled = true;
  bool get soundEnabled => _soundEnabled;

  // Pool of audio players to allow overlapping sounds
  final List<AudioPlayer> _players = [];
  static const int _poolSize = 4;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('sound_enabled') ?? true;

    // Pre-create a pool of players
    for (var i = 0; i < _poolSize; i++) {
      final player = AudioPlayer();
      await player.setReleaseMode(ReleaseMode.stop);
      _players.add(player);
    }
  }

  Future<void> toggleSound() async {
    _soundEnabled = !_soundEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', _soundEnabled);
  }

  /// Get the next available player from the pool (round-robin).
  int _nextPlayer = 0;
  AudioPlayer _getPlayer() {
    if (_players.isEmpty) return AudioPlayer(); // fallback before init
    final player = _players[_nextPlayer % _players.length];
    _nextPlayer++;
    return player;
  }

  void _play(String assetName) {
    if (!_soundEnabled) return;
    final player = _getPlayer();
    player.play(AssetSource('sounds/$assetName'));
  }

  void tap() {
    if (!_soundEnabled) return;
    HapticFeedback.lightImpact();
    _play('tap.wav');
  }

  void correct() {
    if (!_soundEnabled) return;
    HapticFeedback.mediumImpact();
    _play('correct.wav');
  }

  void wrong() {
    if (!_soundEnabled) return;
    HapticFeedback.heavyImpact();
    _play('wrong.wav');
  }

  void win() {
    if (!_soundEnabled) return;
    HapticFeedback.mediumImpact();
    _play('win.wav');
  }

  void flip() {
    if (!_soundEnabled) return;
    HapticFeedback.selectionClick();
    _play('flip.wav');
  }

  void shuffle() {
    if (!_soundEnabled) return;
    HapticFeedback.selectionClick();
    _play('shuffle.wav');
  }

  /// Clean up players when no longer needed.
  void dispose() {
    for (final player in _players) {
      player.dispose();
    }
    _players.clear();
  }
}
