import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart' as share_plus;

import '../../core/theme.dart';
import '../../core/nahla_data.dart';
import '../../core/sounds.dart';
import '../../core/storage.dart';

class NahlaState {
  final NahlaPuzzle puzzle;
  final List<String> foundWords;
  final int score;
  final String currentInput;
  final List<String> shuffledLetters;
  final String? message;

  const NahlaState({
    required this.puzzle,
    this.foundWords = const [],
    this.score = 0,
    this.currentInput = '',
    this.shuffledLetters = const [],
    this.message,
  });

  NahlaState copyWith({
    List<String>? foundWords,
    int? score,
    String? currentInput,
    List<String>? shuffledLetters,
    String? message,
  }) {
    return NahlaState(
      puzzle: puzzle,
      foundWords: foundWords ?? this.foundWords,
      score: score ?? this.score,
      currentInput: currentInput ?? this.currentInput,
      shuffledLetters: shuffledLetters ?? this.shuffledLetters,
      message: message,
    );
  }
}

class NahlaNotifier extends StateNotifier<NahlaState> {
  NahlaNotifier() : super(NahlaState(puzzle: getDailyNahlaPuzzle())) {
    _init();
  }

  void _init() {
    final puzzle = getDailyNahlaPuzzle();
    final puzzleNum = getNahlaPuzzleNumber();
    final saved = GameStorage().loadNahlaState(puzzleNum);

    if (saved != null && saved['puzzleNumber'] == puzzleNum) {
      final others = puzzle.letters.where((l) => l != puzzle.requiredLetter).toList()..shuffle(Random(puzzleNum));
      state = NahlaState(
        puzzle: puzzle,
        foundWords: List<String>.from(saved['foundWords'] ?? []),
        score: saved['score'] as int? ?? 0,
        shuffledLetters: others,
      );
    } else {
      final others = puzzle.letters.where((l) => l != puzzle.requiredLetter).toList()..shuffle(Random(puzzleNum));
      state = NahlaState(
        puzzle: puzzle,
        shuffledLetters: others,
      );
    }
  }

  void _saveState() {
    final puzzleNum = getNahlaPuzzleNumber();
    GameStorage().saveNahlaState(puzzleNum, {
      'puzzleNumber': puzzleNum,
      'foundWords': state.foundWords,
      'score': state.score,
    });
  }

  void addLetter(String letter) {
    SoundManager().tap();
    state = state.copyWith(currentInput: state.currentInput + letter, message: null);
  }

  void removeLetter() {
    if (state.currentInput.isEmpty) return;
    SoundManager().tap();
    state = state.copyWith(
      currentInput: state.currentInput.substring(0, state.currentInput.length - 1),
      message: null,
    );
  }

  void submitWord() {
    final word = state.currentInput;
    if (word.length < 3) {
      state = state.copyWith(message: '\u0643\u0644\u0645\u0629 \u0642\u0635\u064a\u0631\u0629 \u062c\u062f\u0627\u064b', currentInput: '');
      SoundManager().wrong();
      return;
    }

    if (!word.contains(state.puzzle.requiredLetter)) {
      state = state.copyWith(message: '\u064a\u062c\u0628 \u0627\u0633\u062a\u062e\u062f\u0627\u0645 \u0627\u0644\u062d\u0631\u0641 \u0627\u0644\u0645\u0637\u0644\u0648\u0628', currentInput: '');
      SoundManager().wrong();
      return;
    }

    if (state.foundWords.contains(word)) {
      state = state.copyWith(message: '\u0648\u062c\u062f\u062a\u0647\u0627 \u0645\u0633\u0628\u0642\u0627\u064b', currentInput: '');
      return;
    }

    if (!state.puzzle.validWords.contains(word)) {
      state = state.copyWith(message: '\u0643\u0644\u0645\u0629 \u063a\u064a\u0631 \u0645\u0642\u0628\u0648\u0644\u0629', currentInput: '');
      SoundManager().wrong();
      return;
    }

    final wordScore = calculateWordScore(word, state.puzzle.letters);
    final newFound = [...state.foundWords, word];
    final newScore = state.score + wordScore;
    SoundManager().correct();

    final isPan = isPangram(word, state.puzzle.letters);
    state = state.copyWith(
      foundWords: newFound,
      score: newScore,
      currentInput: '',
      message: isPan ? '\u0628\u0627\u0646\u062c\u0631\u0627\u0645! +${wordScore}' : '+$wordScore',
    );
    _saveState();
  }

  void shuffleLetters() {
    SoundManager().shuffle();
    final others = state.shuffledLetters.toList()..shuffle();
    state = state.copyWith(shuffledLetters: others);
  }

  void clearInput() {
    state = state.copyWith(currentInput: '', message: null);
  }
}

final nahlaProvider = StateNotifierProvider<NahlaNotifier, NahlaState>(
  (ref) => NahlaNotifier(),
);

class NahlaScreen extends ConsumerWidget {
  const NahlaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gs = ref.watch(nahlaProvider);
    final rank = getRank(gs.score, gs.puzzle.maxScore);
    final progress = getRankProgress(gs.score, gs.puzzle.maxScore);

    return Scaffold(
      body: Container(
        decoration: KalimaTheme.backgroundGradient,
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: KalimaColors.white),
                      onPressed: () => context.pop(),
                    ),
                    Expanded(
                      child: Text(
                        '\u0646\u062d\u0644\u0629',
                        textAlign: TextAlign.center,
                        style: KalimaTheme.cairoW900.copyWith(fontSize: 22, color: KalimaColors.white),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_rounded, color: KalimaColors.white),
                      onPressed: () => share_plus.Share.share(
                        '\u0643\u0644\u0645\u0629 \u0646\u062d\u0644\u0629 #${getNahlaPuzzleNumber()}\n$rank - ${gs.score}/${gs.puzzle.maxScore}\n\u0643\u0644\u0645\u0627\u062a: ${gs.foundWords.length}\nkalima.fun',
                      ),
                    ),
                  ],
                ),
              ),
              // Score bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(rank, style: KalimaTheme.cairoW700.copyWith(fontSize: 14, color: KalimaColors.nahlaGold)),
                        Text('${gs.score}/${gs.puzzle.maxScore}', style: KalimaTheme.cairoW600.copyWith(fontSize: 13, color: KalimaColors.white.withValues(alpha: 0.6))),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: KalimaColors.surface,
                        valueColor: const AlwaysStoppedAnimation(KalimaColors.nahlaGold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Current input
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 48),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: KalimaColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2A2A4A)),
                ),
                child: Center(
                  child: Text(
                    gs.currentInput.isEmpty ? '\u0627\u0643\u062a\u0628 \u0643\u0644\u0645\u0629...' : gs.currentInput,
                    style: KalimaTheme.cairoW800.copyWith(
                      fontSize: 22,
                      color: gs.currentInput.isEmpty ? KalimaColors.white.withValues(alpha: 0.3) : KalimaColors.white,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ),
              if (gs.message != null) ...[
                const SizedBox(height: 8),
                Text(
                  gs.message!,
                  style: KalimaTheme.cairoW600.copyWith(
                    fontSize: 14,
                    color: gs.message!.contains('+') ? KalimaColors.correct : KalimaColors.cardCoral,
                  ),
                ).animate().fadeIn(duration: 200.ms),
              ],
              const Spacer(),
              // Hex letter buttons
              _HexGrid(gs: gs),
              const Spacer(),
              // Action row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _CircleAction(
                      icon: Icons.backspace_rounded,
                      onTap: () => ref.read(nahlaProvider.notifier).removeLetter(),
                    ),
                    _CircleAction(
                      icon: Icons.shuffle_rounded,
                      onTap: () => ref.read(nahlaProvider.notifier).shuffleLetters(),
                    ),
                    GestureDetector(
                      onTap: () => ref.read(nahlaProvider.notifier).submitWord(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                        decoration: KalimaTheme.neonButton(),
                        child: Text(
                          '\u0625\u062f\u062e\u0627\u0644',
                          style: KalimaTheme.cairoW700.copyWith(fontSize: 16, color: KalimaColors.background),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Found words
              if (gs.foundWords.isNotEmpty)
                Container(
                  height: 44,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: gs.foundWords.reversed.map((w) {
                      final isPan = isPangram(w, gs.puzzle.letters);
                      return Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isPan ? KalimaColors.nahlaGold.withValues(alpha: 0.2) : KalimaColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: isPan ? Border.all(color: KalimaColors.nahlaGold.withValues(alpha: 0.4)) : null,
                        ),
                        child: Text(w, style: KalimaTheme.cairoW600.copyWith(
                          fontSize: 14,
                          color: isPan ? KalimaColors.nahlaGold : KalimaColors.white.withValues(alpha: 0.7),
                        )),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HexGrid extends ConsumerWidget {
  final NahlaState gs;
  const _HexGrid({required this.gs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final others = gs.shuffledLetters;
    final center = gs.puzzle.requiredLetter;

    // Layout: row of 2, row of 3 (center in middle), row of 2
    final top = others.length >= 2 ? others.sublist(0, 2) : others;
    final bottom = others.length >= 4 ? others.sublist(2, 4) : [];
    final sides = others.length >= 6 ? others.sublist(4) : [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final l in top) _HexButton(letter: l, isCenter: false, onTap: () => ref.read(nahlaProvider.notifier).addLetter(l)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (sides.isNotEmpty)
              _HexButton(letter: sides[0], isCenter: false, onTap: () => ref.read(nahlaProvider.notifier).addLetter(sides[0])),
            _HexButton(letter: center, isCenter: true, onTap: () => ref.read(nahlaProvider.notifier).addLetter(center)),
            if (sides.length > 1)
              _HexButton(letter: sides[1], isCenter: false, onTap: () => ref.read(nahlaProvider.notifier).addLetter(sides[1])),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final l in bottom) _HexButton(letter: l, isCenter: false, onTap: () => ref.read(nahlaProvider.notifier).addLetter(l)),
          ],
        ),
      ],
    );
  }
}

class _HexButton extends StatefulWidget {
  final String letter;
  final bool isCenter;
  final VoidCallback onTap;

  const _HexButton({required this.letter, required this.isCenter, required this.onTap});

  @override
  State<_HexButton> createState() => _HexButtonState();
}

class _HexButtonState extends State<_HexButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        transform: _pressed ? (Matrix4.identity()..translateByDouble(0.0, 2.0, 0.0, 1.0)) : Matrix4.identity(),
        width: 64,
        height: 64,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: KalimaTheme.hexButton(
          color: widget.isCenter ? KalimaColors.nahlaGold.withValues(alpha: 0.2) : KalimaColors.surface,
          isCenter: widget.isCenter,
        ),
        child: Center(
          child: Text(
            widget.letter,
            style: KalimaTheme.cairoW900.copyWith(
              fontSize: 26,
              color: widget.isCenter ? KalimaColors.nahlaGold : KalimaColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: KalimaTheme.tile3D(),
        child: Icon(icon, color: KalimaColors.white.withValues(alpha: 0.7), size: 22),
      ),
    );
  }
}
