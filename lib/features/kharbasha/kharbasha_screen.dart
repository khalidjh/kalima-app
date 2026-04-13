import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme.dart';
import '../../core/kharbasha_data.dart';
import '../../core/sounds.dart';

class KharbashaState {
  final KharbashaPuzzle puzzle;
  final String currentGuess;
  final int attemptsLeft;
  final bool won;
  final bool lost;
  final bool shake;
  final bool showResult;
  final List<String> availableLetters;

  const KharbashaState({
    required this.puzzle,
    this.currentGuess = '',
    this.attemptsLeft = 5,
    this.won = false,
    this.lost = false,
    this.shake = false,
    this.showResult = false,
    this.availableLetters = const [],
  });

  KharbashaState copyWith({
    String? currentGuess,
    int? attemptsLeft,
    bool? won,
    bool? lost,
    bool? shake,
    bool? showResult,
    List<String>? availableLetters,
  }) {
    return KharbashaState(
      puzzle: puzzle,
      currentGuess: currentGuess ?? this.currentGuess,
      attemptsLeft: attemptsLeft ?? this.attemptsLeft,
      won: won ?? this.won,
      lost: lost ?? this.lost,
      shake: shake ?? false,
      showResult: showResult ?? this.showResult,
      availableLetters: availableLetters ?? this.availableLetters,
    );
  }
}

class KharbashaNotifier extends StateNotifier<KharbashaState> {
  KharbashaNotifier() : super(KharbashaState(puzzle: getDailyKharbashaPuzzle())) {
    _init();
  }

  void _init() {
    final puzzle = getDailyKharbashaPuzzle();
    state = KharbashaState(
      puzzle: puzzle,
      availableLetters: puzzle.scrambled.split(''),
    );
  }

  void tapLetter(int index) {
    if (state.won || state.lost) return;
    if (state.currentGuess.length >= state.puzzle.word.length) return;

    SoundManager().tap();
    final letter = state.availableLetters[index];
    final newAvailable = List<String>.from(state.availableLetters);
    newAvailable[index] = '';

    state = state.copyWith(
      currentGuess: state.currentGuess + letter,
      availableLetters: newAvailable,
    );
  }

  void removeLast() {
    if (state.won || state.lost || state.currentGuess.isEmpty) return;
    SoundManager().tap();

    final removed = state.currentGuess[state.currentGuess.length - 1];
    final newAvailable = List<String>.from(state.availableLetters);

    // Find first empty spot that was this letter
    for (int i = 0; i < newAvailable.length; i++) {
      if (newAvailable[i].isEmpty) {
        // Check if original scrambled had this letter at position i
        if (state.puzzle.scrambled[i] == removed) {
          newAvailable[i] = removed;
          break;
        }
      }
    }
    // Fallback: just fill first empty
    if (!newAvailable.contains(removed)) {
      for (int i = 0; i < newAvailable.length; i++) {
        if (newAvailable[i].isEmpty) {
          newAvailable[i] = removed;
          break;
        }
      }
    }

    state = state.copyWith(
      currentGuess: state.currentGuess.substring(0, state.currentGuess.length - 1),
      availableLetters: newAvailable,
    );
  }

  void submit() {
    if (state.won || state.lost) return;
    if (state.currentGuess.length != state.puzzle.word.length) return;

    if (state.currentGuess == state.puzzle.word) {
      SoundManager().win();
      state = state.copyWith(won: true);
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) state = state.copyWith(showResult: true);
      });
    } else {
      SoundManager().wrong();
      final newAttempts = state.attemptsLeft - 1;
      state = state.copyWith(
        attemptsLeft: newAttempts,
        shake: true,
        currentGuess: '',
        availableLetters: state.puzzle.scrambled.split(''),
        lost: newAttempts == 0,
      );
      if (newAttempts == 0) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) state = state.copyWith(showResult: true);
        });
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) state = state.copyWith(shake: false);
      });
    }
  }

  void dismissResult() => state = state.copyWith(showResult: false);
}

final kharbashaProvider = StateNotifierProvider<KharbashaNotifier, KharbashaState>(
  (ref) => KharbashaNotifier(),
);

class KharbashaScreen extends ConsumerStatefulWidget {
  const KharbashaScreen({super.key});

  @override
  ConsumerState<KharbashaScreen> createState() => _KharbashaScreenState();
}

class _KharbashaScreenState extends ConsumerState<KharbashaScreen> {
  late ConfettiController _confettiController;
  bool _didWin = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gs = ref.watch(kharbashaProvider);

    if (gs.won && !_didWin) {
      _didWin = true;
      _confettiController.play();
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: KalimaTheme.backgroundGradient,
            child: SafeArea(
              child: Column(
                children: [
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
                            '\u062e\u0631\u0628\u0634\u0629',
                            textAlign: TextAlign.center,
                            style: KalimaTheme.cairoW900.copyWith(fontSize: 22, color: KalimaColors.white),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Hint
                  Text(
                    gs.puzzle.hint,
                    style: KalimaTheme.cairoW700.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  // Attempt dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      final isRemaining = i < gs.attemptsLeft;
                      return Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isRemaining ? KalimaColors.cardPurple : KalimaColors.absent,
                          boxShadow: isRemaining
                              ? [BoxShadow(color: KalimaColors.cardPurple.withValues(alpha: 0.5), blurRadius: 6)]
                              : null,
                        ),
                      );
                    }),
                  ),
                  const Spacer(),
                  // Answer slots
                  _buildAnswerSlots(gs),
                  const SizedBox(height: 32),
                  // Scrambled letter tiles
                  _buildLetterTiles(gs),
                  const Spacer(),
                  // Actions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => ref.read(kharbashaProvider.notifier).removeLast(),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: KalimaTheme.tile3D(),
                            child: const Icon(Icons.backspace_rounded, color: KalimaColors.white, size: 22),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => ref.read(kharbashaProvider.notifier).submit(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            decoration: KalimaTheme.neonButton(
                              enabled: gs.currentGuess.length == gs.puzzle.word.length,
                            ),
                            child: Text(
                              '\u062a\u0623\u0643\u064a\u062f',
                              style: KalimaTheme.cairoW700.copyWith(
                                fontSize: 16,
                                color: gs.currentGuess.length == gs.puzzle.word.length
                                    ? KalimaColors.background
                                    : KalimaColors.white.withValues(alpha: 0.3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [KalimaColors.correct, KalimaColors.accent, KalimaColors.cardPurple],
            ),
          ),
          if (gs.showResult)
            _KharbashaResult(
              won: gs.won,
              word: gs.puzzle.word,
              onClose: () {
                ref.read(kharbashaProvider.notifier).dismissResult();
                context.pop();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAnswerSlots(KharbashaState gs) {
    final wordLen = gs.puzzle.word.length;
    final guessChars = gs.currentGuess.split('');

    Widget slots = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(wordLen, (i) {
        final hasLetter = i < guessChars.length;
        return Container(
          width: 48,
          height: 52,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: hasLetter
              ? KalimaTheme.tile3D(color: KalimaColors.surfaceLight)
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF3A3A5C), width: 2, strokeAlign: BorderSide.strokeAlignInside),
                ),
          child: Center(
            child: hasLetter
                ? Text(guessChars[i], style: KalimaTheme.cairoW900.copyWith(fontSize: 22, color: KalimaColors.white))
                : null,
          ),
        );
      }),
    );

    if (gs.shake) {
      slots = slots.animate().shake(duration: 400.ms, hz: 5);
    }

    return slots;
  }

  Widget _buildLetterTiles(KharbashaState gs) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(gs.availableLetters.length, (i) {
        final letter = gs.availableLetters[i];
        if (letter.isEmpty) {
          return SizedBox(
            width: 52,
            height: 56,
          );
        }
        return _LetterTile3D(
          letter: letter,
          onTap: () => ref.read(kharbashaProvider.notifier).tapLetter(i),
        );
      }),
    );
  }
}

class _LetterTile3D extends StatefulWidget {
  final String letter;
  final VoidCallback onTap;

  const _LetterTile3D({required this.letter, required this.onTap});

  @override
  State<_LetterTile3D> createState() => _LetterTile3DState();
}

class _LetterTile3DState extends State<_LetterTile3D> {
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
        transform: _pressed ? (Matrix4.identity()..translateByDouble(0.0, 3.0, 0.0, 1.0)) : Matrix4.identity(),
        width: 52,
        height: 56,
        decoration: KalimaTheme.tile3D(color: KalimaColors.cardPurple.withValues(alpha: 0.3)),
        child: Center(
          child: Text(
            widget.letter,
            style: KalimaTheme.cairoW900.copyWith(fontSize: 24, color: KalimaColors.white),
          ),
        ),
      ),
    );
  }
}

class _KharbashaResult extends StatelessWidget {
  final bool won;
  final String word;
  final VoidCallback onClose;

  const _KharbashaResult({required this.won, required this.word, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: KalimaColors.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: (won ? KalimaColors.correct : KalimaColors.cardCoral).withValues(alpha: 0.3),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                won ? '\ud83c\udf89 \u0623\u062d\u0633\u0646\u062a!' : '\ud83d\ude14 \u062d\u0638 \u0623\u0648\u0641\u0631',
                style: KalimaTheme.cairoW900.copyWith(fontSize: 28, color: won ? KalimaColors.correct : KalimaColors.cardCoral),
              ),
              const SizedBox(height: 12),
              Text(
                '\u0627\u0644\u0643\u0644\u0645\u0629: $word',
                style: KalimaTheme.cairoW700.copyWith(fontSize: 22, color: KalimaColors.white),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: onClose,
                child: Text(
                  '\u0631\u062c\u0648\u0639',
                  style: KalimaTheme.cairoW700.copyWith(fontSize: 16, color: KalimaColors.accent),
                ),
              ),
            ],
          ),
        ).animate().scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0), duration: 300.ms).fadeIn(),
      ),
    );
  }
}
