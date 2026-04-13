import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart' as share_plus;

import '../../core/theme.dart';
import '../../core/words.dart';
import '../../core/sounds.dart';
import '../../core/storage.dart';

enum LetterState { empty, tbd, correct, present, absent }

class HuroufState {
  final List<List<String>> guesses;
  final List<List<LetterState>> states;
  final int currentRow;
  final int currentCol;
  final String targetWord;
  final bool won;
  final bool lost;
  final String? invalidShakeRow;
  final bool showResult;
  final List<bool> revealedRows;
  final String? message;

  const HuroufState({
    this.guesses = const [],
    this.states = const [],
    this.currentRow = 0,
    this.currentCol = 0,
    this.targetWord = '',
    this.won = false,
    this.lost = false,
    this.invalidShakeRow,
    this.showResult = false,
    this.revealedRows = const [],
    this.message,
  });

  HuroufState copyWith({
    List<List<String>>? guesses,
    List<List<LetterState>>? states,
    int? currentRow,
    int? currentCol,
    bool? won,
    bool? lost,
    String? invalidShakeRow,
    bool? showResult,
    List<bool>? revealedRows,
    String? message,
  }) {
    return HuroufState(
      guesses: guesses ?? this.guesses,
      states: states ?? this.states,
      currentRow: currentRow ?? this.currentRow,
      currentCol: currentCol ?? this.currentCol,
      targetWord: targetWord,
      won: won ?? this.won,
      lost: lost ?? this.lost,
      invalidShakeRow: invalidShakeRow,
      showResult: showResult ?? this.showResult,
      revealedRows: revealedRows ?? this.revealedRows,
      message: message,
    );
  }
}

class HuroufNotifier extends StateNotifier<HuroufState> {
  HuroufNotifier() : super(HuroufState(targetWord: getDailyWord())) {
    _initBoard();
  }

  void _initBoard() {
    state = HuroufState(
      guesses: List.generate(6, (_) => List.generate(5, (_) => '')),
      states: List.generate(6, (_) => List.generate(5, (_) => LetterState.empty)),
      targetWord: getDailyWord(),
      revealedRows: List.generate(6, (_) => false),
    );
  }

  void addLetter(String letter) {
    if (state.won || state.lost || state.currentCol >= 5) return;
    final newGuesses = state.guesses.map((r) => List<String>.from(r)).toList();
    newGuesses[state.currentRow][state.currentCol] = letter;
    SoundManager().tap();
    state = state.copyWith(
      guesses: newGuesses,
      currentCol: state.currentCol + 1,
      invalidShakeRow: null,
      message: null,
    );
  }

  void removeLetter() {
    if (state.won || state.lost || state.currentCol <= 0) return;
    final newGuesses = state.guesses.map((r) => List<String>.from(r)).toList();
    newGuesses[state.currentRow][state.currentCol - 1] = '';
    SoundManager().tap();
    state = state.copyWith(
      guesses: newGuesses,
      currentCol: state.currentCol - 1,
      invalidShakeRow: null,
      message: null,
    );
  }

  void submitGuess() {
    if (state.won || state.lost) return;
    if (state.currentCol < 5) {
      state = state.copyWith(invalidShakeRow: 'row_${state.currentRow}');
      SoundManager().wrong();
      return;
    }

    final guess = state.guesses[state.currentRow].join();

    // Validate guess
    if (!isValidGuess(guess)) {
      state = state.copyWith(
        invalidShakeRow: 'row_${state.currentRow}',
        message: '\u0643\u0644\u0645\u0629 \u063a\u064a\u0631 \u0645\u0648\u062c\u0648\u062f\u0629',
      );
      SoundManager().wrong();
      return;
    }

    final target = state.targetWord;
    final rowStates = List.generate(5, (_) => LetterState.absent);
    final targetChars = target.split('');
    final guessChars = guess.split('');

    for (int i = 0; i < 5; i++) {
      if (guessChars[i] == targetChars[i]) {
        rowStates[i] = LetterState.correct;
        targetChars[i] = '';
        guessChars[i] = '';
      }
    }

    for (int i = 0; i < 5; i++) {
      if (guessChars[i].isEmpty) continue;
      final idx = targetChars.indexOf(guessChars[i]);
      if (idx >= 0) {
        rowStates[i] = LetterState.present;
        targetChars[idx] = '';
      }
    }

    final newStates = state.states.map((r) => List<LetterState>.from(r)).toList();
    newStates[state.currentRow] = rowStates;

    final won = rowStates.every((s) => s == LetterState.correct);
    final lost = !won && state.currentRow == 5;

    final newRevealed = List<bool>.from(state.revealedRows);
    newRevealed[state.currentRow] = true;

    if (won) {
      SoundManager().win();
      _updateStats(true, state.currentRow + 1);
    } else if (lost) {
      SoundManager().wrong();
      _updateStats(false, 0);
    } else {
      SoundManager().correct();
    }

    state = state.copyWith(
      states: newStates,
      currentRow: state.currentRow + 1,
      currentCol: 0,
      won: won,
      lost: lost,
      invalidShakeRow: null,
      revealedRows: newRevealed,
      message: null,
    );
  }

  void _updateStats(bool won, int attempts) {
    final stats = GameStorage().loadHuroufStats();
    stats['played'] = (stats['played'] as int) + 1;
    if (won) {
      stats['won'] = (stats['won'] as int) + 1;
      stats['currentStreak'] = (stats['currentStreak'] as int) + 1;
      final maxStreak = stats['maxStreak'] as int;
      final curStreak = stats['currentStreak'] as int;
      if (curStreak > maxStreak) stats['maxStreak'] = curStreak;
      final dist = List<int>.from(stats['distribution'] as List);
      if (attempts >= 1 && attempts <= 6) dist[attempts - 1]++;
      stats['distribution'] = dist;
    } else {
      stats['currentStreak'] = 0;
    }
    GameStorage().saveHuroufStats(stats);
    GameStorage().markGameCompleted('hurouf', getPuzzleNumber());
  }

  void showResultDialog() => state = state.copyWith(showResult: true);
  void dismissResult() => state = state.copyWith(showResult: false);
  void clearShake() => state = state.copyWith(invalidShakeRow: null, message: null);

  String generateShareText() {
    final puzzleNum = getPuzzleNumber();
    final buffer = StringBuffer('\u0643\u0644\u0645\u0629 \u062d\u0631\u0648\u0641 #$puzzleNum\n');
    buffer.writeln(state.won ? '${state.currentRow}/6' : 'X/6');
    for (int r = 0; r < state.currentRow && r < 6; r++) {
      for (int c = 0; c < 5; c++) {
        final s = state.states[r][c];
        buffer.write(s == LetterState.correct ? '\ud83d\udfe9' : s == LetterState.present ? '\ud83d\udfe8' : '\u2b1b');
      }
      buffer.writeln();
    }
    buffer.write('kalima.fun');
    return buffer.toString().trim();
  }
}

final huroufProvider = StateNotifierProvider<HuroufNotifier, HuroufState>(
  (ref) => HuroufNotifier(),
);

class HuroufScreen extends ConsumerStatefulWidget {
  const HuroufScreen({super.key});

  @override
  ConsumerState<HuroufScreen> createState() => _HuroufScreenState();
}

class _HuroufScreenState extends ConsumerState<HuroufScreen> {
  late ConfettiController _confettiController;
  bool _didWin = false;
  bool _didLose = false;

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
    final gameState = ref.watch(huroufProvider);

    if (gameState.won && !_didWin) {
      _didWin = true;
      _confettiController.play();
      Future.delayed(const Duration(milliseconds: 2200), () {
        if (mounted) ref.read(huroufProvider.notifier).showResultDialog();
      });
    } else if (gameState.lost && !_didLose) {
      _didLose = true;
      Future.delayed(const Duration(milliseconds: 2200), () {
        if (mounted) ref.read(huroufProvider.notifier).showResultDialog();
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: KalimaTheme.backgroundGradient,
            child: SafeArea(
              child: Column(
                children: [
                  _AppBar(gameState: gameState),
                  if (gameState.message != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 48),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: KalimaColors.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        gameState.message!,
                        style: KalimaTheme.cairoW700.copyWith(
                          fontSize: 14,
                          color: KalimaColors.white,
                        ),
                      ),
                    ).animate().fadeIn(duration: 200.ms).then().fadeOut(delay: 1500.ms),
                  Expanded(
                    child: Center(child: _GameGrid(gameState: gameState)),
                  ),
                  _Keyboard(gameState: gameState),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [
                KalimaColors.correct,
                KalimaColors.present,
                KalimaColors.accent,
                KalimaColors.cardTeal,
                KalimaColors.cardCoral,
              ],
              maxBlastForce: 20,
              minBlastForce: 5,
            ),
          ),
          if (gameState.showResult)
            _ResultOverlay(
              won: gameState.won,
              targetWord: gameState.targetWord,
              attempts: gameState.currentRow,
              onShare: () {
                final text = ref.read(huroufProvider.notifier).generateShareText();
                share_plus.Share.share(text);
              },
              onClose: () {
                ref.read(huroufProvider.notifier).dismissResult();
                context.pop();
              },
            ),
        ],
      ),
    );
  }
}

class _AppBar extends ConsumerWidget {
  final HuroufState gameState;
  const _AppBar({required this.gameState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: KalimaColors.white),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Text(
              '\u062d\u0631\u0648\u0641',
              textAlign: TextAlign.center,
              style: KalimaTheme.cairoW900.copyWith(fontSize: 22, color: KalimaColors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded, color: KalimaColors.white),
            onPressed: () {
              final text = ref.read(huroufProvider.notifier).generateShareText();
              share_plus.Share.share(text);
            },
          ),
        ],
      ),
    );
  }
}

class _GameGrid extends ConsumerWidget {
  final HuroufState gameState;
  const _GameGrid({required this.gameState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(6, (row) {
          final isShaking = gameState.invalidShakeRow == 'row_$row';
          final isRevealed = gameState.revealedRows.isNotEmpty && gameState.revealedRows[row];

          Widget rowWidget = Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (col) {
              return _Tile(
                letter: gameState.guesses[row][col],
                state: gameState.states[row][col],
                isRevealed: isRevealed,
                revealDelay: col * 250,
              );
            }),
          );

          if (isShaking) {
            rowWidget = rowWidget.animate(key: ValueKey('shake_$row')).shake(duration: 400.ms, hz: 5);
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: rowWidget,
          );
        }),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String letter;
  final LetterState state;
  final bool isRevealed;
  final int revealDelay;

  const _Tile({
    required this.letter,
    required this.state,
    required this.isRevealed,
    required this.revealDelay,
  });

  Color get _backgroundColor {
    switch (state) {
      case LetterState.correct: return KalimaColors.correct;
      case LetterState.present: return KalimaColors.present;
      case LetterState.absent: return KalimaColors.absent;
      case LetterState.empty:
      case LetterState.tbd: return KalimaColors.surface;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = (MediaQuery.of(context).size.width - 72) / 5;
    final clampedSize = size.clamp(48.0, 64.0);

    final isRevealing = state != LetterState.empty && state != LetterState.tbd;
    final decoration = isRevealing
        ? KalimaTheme.tileRevealed(_backgroundColor)
        : letter.isEmpty
            ? KalimaTheme.tileEmpty
            : KalimaTheme.tile3D();

    Widget tile = Container(
      width: clampedSize,
      height: clampedSize,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: decoration,
      child: Center(
        child: letter.isNotEmpty
            ? Text(
                letter,
                style: KalimaTheme.cairoW900.copyWith(
                  fontSize: clampedSize * 0.45,
                  color: KalimaColors.white,
                ),
              )
            : null,
      ),
    );

    if (isRevealed && isRevealing) {
      tile = tile
          .animate(key: ValueKey('reveal_${letter}_$revealDelay'))
          .flipV(duration: 400.ms, delay: revealDelay.ms)
          .then()
          .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.08, 1.08), duration: 100.ms)
          .then()
          .scale(begin: const Offset(1.08, 1.08), end: const Offset(1.0, 1.0), duration: 100.ms);
    }

    return tile;
  }
}

class _Keyboard extends ConsumerWidget {
  final HuroufState gameState;
  const _Keyboard({required this.gameState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...keyboardRows.map((row) => _buildRow(context, ref, row)),
        _buildActionRow(context, ref),
      ],
    );
  }

  Widget _buildRow(BuildContext context, WidgetRef ref, String row) {
    final screenWidth = MediaQuery.of(context).size.width;
    final keyWidth = (screenWidth - 32 - (row.length - 1) * 4) / row.length;
    final clampedWidth = keyWidth.clamp(26.0, 36.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: row.split('').map((letter) {
          final usedState = _getLetterState(letter);
          return _KeyButton(
            letter: letter,
            width: clampedWidth,
            state: usedState,
            onTap: () => ref.read(huroufProvider.notifier).addLetter(letter),
          );
        }).toList(),
      ),
    );
  }

  LetterState _getLetterState(String letter) {
    LetterState result = LetterState.empty;
    for (int r = 0; r < 6; r++) {
      for (int c = 0; c < 5; c++) {
        if (gameState.guesses[r][c] == letter) {
          final s = gameState.states[r][c];
          if (s == LetterState.correct) return LetterState.correct;
          if (s == LetterState.present && result != LetterState.correct) result = LetterState.present;
          if (s == LetterState.absent && result == LetterState.empty) result = LetterState.absent;
        }
      }
    }
    return result;
  }

  Widget _buildActionRow(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ActionButton(
            label: '\u0645\u0633\u062d',
            onTap: () => ref.read(huroufProvider.notifier).removeLetter(),
          ),
          const SizedBox(width: 4),
          ...'\u0629\u0649\u0625\u0623\u0622\u0621\u0626\u0624'.split('').map((letter) {
            final usedState = _getLetterState(letter);
            return _KeyButton(
              letter: letter,
              width: 28,
              state: usedState,
              onTap: () => ref.read(huroufProvider.notifier).addLetter(letter),
            );
          }),
          const SizedBox(width: 4),
          _ActionButton(
            label: '\u0625\u062f\u062e\u0627\u0644',
            onTap: () => ref.read(huroufProvider.notifier).submitGuess(),
            isPrimary: true,
          ),
        ],
      ),
    );
  }
}

class _KeyButton extends StatefulWidget {
  final String letter;
  final double width;
  final LetterState state;
  final VoidCallback onTap;

  const _KeyButton({
    required this.letter,
    required this.width,
    required this.state,
    required this.onTap,
  });

  @override
  State<_KeyButton> createState() => _KeyButtonState();
}

class _KeyButtonState extends State<_KeyButton> {
  bool _pressed = false;

  Color get _bgColor {
    switch (widget.state) {
      case LetterState.correct: return KalimaColors.correct;
      case LetterState.present: return KalimaColors.present;
      case LetterState.absent: return KalimaColors.absent;
      case LetterState.empty:
      case LetterState.tbd: return KalimaColors.surface;
    }
  }

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
        transform: _pressed
            ? (Matrix4.identity()..translateByDouble(0.0, 2.0, 0.0, 1.0))
            : Matrix4.identity(),
        width: widget.width,
        height: 46,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: KalimaTheme.key3D(color: _bgColor),
        child: Center(
          child: Text(
            widget.letter,
            style: KalimaTheme.cairoW900.copyWith(fontSize: 17, color: KalimaColors.white),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionButton({required this.label, required this.onTap, this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isPrimary ? KalimaColors.accent.withValues(alpha: 0.2) : KalimaColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: isPrimary
              ? Border.all(color: KalimaColors.accent.withValues(alpha: 0.4), width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: KalimaTheme.cairoW700.copyWith(
              fontSize: 13,
              color: isPrimary ? KalimaColors.accent : KalimaColors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultOverlay extends StatelessWidget {
  final bool won;
  final String targetWord;
  final int attempts;
  final VoidCallback onShare;
  final VoidCallback onClose;

  const _ResultOverlay({
    required this.won,
    required this.targetWord,
    required this.attempts,
    required this.onShare,
    required this.onClose,
  });

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
                style: KalimaTheme.cairoW900.copyWith(
                  fontSize: 28,
                  color: won ? KalimaColors.correct : KalimaColors.cardCoral,
                ),
              ),
              const SizedBox(height: 16),
              if (!won)
                Text(
                  '\u0627\u0644\u0643\u0644\u0645\u0629: $targetWord',
                  style: KalimaTheme.cairoW700.copyWith(fontSize: 20, color: KalimaColors.white),
                ),
              if (won)
                Text(
                  '\u0645\u062d\u0627\u0648\u0644\u0627\u062a: $attempts',
                  style: KalimaTheme.cairoW700.copyWith(
                    fontSize: 20,
                    color: KalimaColors.white.withValues(alpha: 0.7),
                  ),
                ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: onShare,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: KalimaTheme.neonButton(),
                      child: Text(
                        '\u0645\u0634\u0627\u0631\u0643\u0629',
                        style: KalimaTheme.cairoW700.copyWith(fontSize: 16, color: KalimaColors.background),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: onClose,
                    child: Text(
                      '\u0631\u062c\u0648\u0639',
                      style: KalimaTheme.cairoW700.copyWith(
                        fontSize: 16,
                        color: KalimaColors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate().scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0), duration: 300.ms).fadeIn(),
      ),
    );
  }
}
