import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart' as share_plus;

import '../../core/theme.dart';
import '../../core/rawabet_data.dart';
import '../../core/words.dart';
import '../../core/sounds.dart';
import '../../core/storage.dart';

class RawabetState {
  final RawabetPuzzle puzzle;
  final List<String> gridWords;
  final Set<String> selectedWords;
  final List<RawabetCategory> solvedGroups;
  final int mistakesLeft;
  final bool won;
  final bool lost;
  final bool shakeSelection;
  final bool showResult;

  const RawabetState({
    required this.puzzle,
    required this.gridWords,
    this.selectedWords = const {},
    this.solvedGroups = const [],
    this.mistakesLeft = 4,
    this.won = false,
    this.lost = false,
    this.shakeSelection = false,
    this.showResult = false,
  });

  RawabetState copyWith({
    List<String>? gridWords,
    Set<String>? selectedWords,
    List<RawabetCategory>? solvedGroups,
    int? mistakesLeft,
    bool? won,
    bool? lost,
    bool? shakeSelection,
    bool? showResult,
  }) {
    return RawabetState(
      puzzle: puzzle,
      gridWords: gridWords ?? this.gridWords,
      selectedWords: selectedWords ?? this.selectedWords,
      solvedGroups: solvedGroups ?? this.solvedGroups,
      mistakesLeft: mistakesLeft ?? this.mistakesLeft,
      won: won ?? this.won,
      lost: lost ?? this.lost,
      shakeSelection: shakeSelection ?? false,
      showResult: showResult ?? this.showResult,
    );
  }

  List<String> get unsolvedWords {
    final solved = solvedGroups.expand((g) => g.words).toSet();
    return gridWords.where((w) => !solved.contains(w)).toList();
  }
}

class RawabetNotifier extends StateNotifier<RawabetState> {
  RawabetNotifier()
      : super(RawabetState(
          puzzle: getDailyRawabetPuzzle(),
          gridWords: [],
        )) {
    _init();
  }

  void _init() {
    final puzzle = getDailyRawabetPuzzle();
    final puzzleNum = getPuzzleNumber();
    final saved = GameStorage().loadRawabetState(puzzleNum);

    if (saved != null && saved['puzzleNumber'] == puzzleNum) {
      final solvedNames = List<String>.from(saved['solvedGroups'] ?? []);
      final solvedGroups = puzzle.categories
          .where((c) => solvedNames.contains(c.name))
          .toList();
      final gridWords = List<String>.from(saved['gridWords'] ?? []);
      state = RawabetState(
        puzzle: puzzle,
        gridWords: gridWords,
        solvedGroups: solvedGroups,
        mistakesLeft: saved['mistakesLeft'] as int? ?? 4,
        won: saved['won'] as bool? ?? false,
        lost: saved['lost'] as bool? ?? false,
      );
    } else {
      final allWords = puzzle.allWords;
      allWords.shuffle(Random(puzzleNum));
      state = RawabetState(puzzle: puzzle, gridWords: allWords);
    }
  }

  void _saveState() {
    final puzzleNum = getPuzzleNumber();
    GameStorage().saveRawabetState(puzzleNum, {
      'puzzleNumber': puzzleNum,
      'gridWords': state.gridWords,
      'solvedGroups': state.solvedGroups.map((g) => g.name).toList(),
      'mistakesLeft': state.mistakesLeft,
      'won': state.won,
      'lost': state.lost,
    });
  }

  void _updateStats(bool won) {
    final stats = GameStorage().loadRawabetStats();
    stats['played'] = (stats['played'] as int) + 1;
    if (won) {
      stats['won'] = (stats['won'] as int) + 1;
      stats['currentStreak'] = (stats['currentStreak'] as int) + 1;
      final maxStreak = stats['maxStreak'] as int;
      final curStreak = stats['currentStreak'] as int;
      if (curStreak > maxStreak) stats['maxStreak'] = curStreak;
    } else {
      stats['currentStreak'] = 0;
    }
    GameStorage().saveRawabetStats(stats);
  }

  void toggleWord(String word) {
    if (state.won || state.lost) return;
    SoundManager().tap();
    final newSelected = Set<String>.from(state.selectedWords);
    if (newSelected.contains(word)) {
      newSelected.remove(word);
    } else if (newSelected.length < 4) {
      newSelected.add(word);
    }
    state = state.copyWith(selectedWords: newSelected, shakeSelection: false);
  }

  void submit() {
    if (state.selectedWords.length != 4 || state.won || state.lost) return;

    final selected = state.selectedWords;
    RawabetCategory? matched;

    for (final cat in state.puzzle.categories) {
      if (cat.words.toSet().containsAll(selected) && selected.containsAll(cat.words.toSet())) {
        matched = cat;
        break;
      }
    }

    if (matched != null) {
      final newSolved = [...state.solvedGroups, matched];
      final newWon = newSolved.length == 4;
      SoundManager().correct();
      state = state.copyWith(
        solvedGroups: newSolved,
        selectedWords: {},
        won: newWon,
      );
      _saveState();
      if (newWon) {
        _updateStats(true);
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (mounted) state = state.copyWith(showResult: true);
        });
      }
    } else {
      final newMistakes = state.mistakesLeft - 1;
      SoundManager().wrong();
      state = state.copyWith(
        mistakesLeft: newMistakes,
        shakeSelection: true,
        lost: newMistakes == 0,
      );
      _saveState();
      if (newMistakes == 0) {
        _updateStats(false);
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) state = state.copyWith(showResult: true);
        });
      }
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) state = state.copyWith(shakeSelection: false);
      });
    }
  }

  void shuffle() {
    if (state.won || state.lost) return;
    SoundManager().shuffle();
    final unsolved = List<String>.from(state.unsolvedWords)..shuffle();
    final solved = state.solvedGroups.expand((g) => g.words).toList();
    state = state.copyWith(gridWords: [...unsolved, ...solved], selectedWords: {});
  }

  void deselectAll() {
    SoundManager().tap();
    state = state.copyWith(selectedWords: {});
  }

  void dismissResult() => state = state.copyWith(showResult: false);

  String generateShareText() {
    final puzzleNum = getPuzzleNumber();
    final buffer = StringBuffer('\u0643\u0644\u0645\u0629 \u0631\u0648\u0627\u0628\u0637 #$puzzleNum\n');
    final emojis = ['\ud83d\udfe8', '\ud83d\udfe9', '\ud83d\udfe6', '\ud83d\udfe5'];
    for (final group in state.solvedGroups) {
      final idx = state.puzzle.categories.indexOf(group);
      buffer.writeln(emojis[idx.clamp(0, 3)] * 4);
    }
    buffer.write('kalima.fun');
    return buffer.toString().trim();
  }
}

final rawabetProvider = StateNotifierProvider<RawabetNotifier, RawabetState>(
  (ref) => RawabetNotifier(),
);

class RawabetScreen extends ConsumerStatefulWidget {
  const RawabetScreen({super.key});

  @override
  ConsumerState<RawabetScreen> createState() => _RawabetScreenState();
}

class _RawabetScreenState extends ConsumerState<RawabetScreen> {
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
    final gameState = ref.watch(rawabetProvider);

    if (gameState.won && !_didWin) {
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
                  // AppBar
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
                            '\u0631\u0648\u0627\u0628\u0637',
                            textAlign: TextAlign.center,
                            style: KalimaTheme.cairoW900.copyWith(fontSize: 22, color: KalimaColors.white),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.share_rounded, color: KalimaColors.white),
                          onPressed: () {
                            final text = ref.read(rawabetProvider.notifier).generateShareText();
                            share_plus.Share.share(text);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Mistake dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\u0623\u062e\u0637\u0627\u0621 \u0645\u062a\u0628\u0642\u064a\u0629: ',
                        style: KalimaTheme.cairoW600.copyWith(
                          fontSize: 13,
                          color: KalimaColors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      ...List.generate(4, (i) {
                        final isRemaining = i < gameState.mistakesLeft;
                        return Container(
                          width: 14,
                          height: 14,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isRemaining ? KalimaColors.cardCoral : KalimaColors.absent,
                            boxShadow: isRemaining
                                ? [BoxShadow(color: KalimaColors.cardCoral.withValues(alpha: 0.5), blurRadius: 8)]
                                : null,
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Solved groups
                  ...gameState.solvedGroups.map((group) {
                    final colorIndex = group.colorIndex;
                    final color = KalimaColors.rawabetColors[colorIndex.clamp(0, 3)];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                      child: Container(
                        height: 56,
                        decoration: KalimaTheme.tileRevealed(color),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              group.name,
                              style: KalimaTheme.cairoW900.copyWith(fontSize: 14, color: KalimaColors.white),
                            ),
                            Text(
                              group.words.join('\u060c '),
                              style: KalimaTheme.cairoW400.copyWith(
                                fontSize: 11,
                                color: KalimaColors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms).scale(
                            begin: const Offset(0.9, 0.9),
                            end: const Offset(1.0, 1.0),
                          ),
                    );
                  }),
                  const SizedBox(height: 8),
                  // Grid
                  Expanded(
                    child: Center(child: _buildGrid(context, gameState)),
                  ),
                  // Actions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ActionChip(
                          label: '\u062e\u0644\u0637',
                          icon: Icons.shuffle_rounded,
                          onTap: () => ref.read(rawabetProvider.notifier).shuffle(),
                        ),
                        _ActionChip(
                          label: '\u0625\u0644\u063a\u0627\u0621',
                          icon: Icons.deselect_rounded,
                          onTap: () => ref.read(rawabetProvider.notifier).deselectAll(),
                        ),
                        _ActionChip(
                          label: '\u0625\u0631\u0633\u0627\u0644',
                          icon: Icons.check_rounded,
                          onTap: () => ref.read(rawabetProvider.notifier).submit(),
                          isPrimary: true,
                          enabled: gameState.selectedWords.length == 4,
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
              colors: KalimaColors.rawabetColors,
            ),
          ),
          if (gameState.showResult)
            _RawabetResultOverlay(
              won: gameState.won,
              solvedGroups: gameState.solvedGroups,
              puzzle: gameState.puzzle,
              onShare: () {
                final text = ref.read(rawabetProvider.notifier).generateShareText();
                share_plus.Share.share(text);
              },
              onClose: () {
                ref.read(rawabetProvider.notifier).dismissResult();
                context.pop();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, RawabetState gameState) {
    final unsolved = gameState.unsolvedWords;
    final isShaking = gameState.shakeSelection;

    Widget grid = Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: unsolved.map((word) {
        final isSelected = gameState.selectedWords.contains(word);
        return _RawabetTile(
          word: word,
          isSelected: isSelected,
          onTap: () => ref.read(rawabetProvider.notifier).toggleWord(word),
        );
      }).toList(),
    );

    if (isShaking) {
      grid = grid.animate().shake(duration: 400.ms, hz: 5);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: grid,
    );
  }
}

class _RawabetTile extends StatefulWidget {
  final String word;
  final bool isSelected;
  final VoidCallback onTap;

  const _RawabetTile({required this.word, required this.isSelected, required this.onTap});

  @override
  State<_RawabetTile> createState() => _RawabetTileState();
}

class _RawabetTileState extends State<_RawabetTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tileSize = (screenWidth - 64 - 24) / 4;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: _pressed
            ? (Matrix4.identity()..translateByDouble(0.0, 2.0, 0.0, 1.0))
            : Matrix4.identity(),
        width: tileSize,
        height: 56,
        decoration: BoxDecoration(
          color: widget.isSelected
              ? KalimaColors.accent.withValues(alpha: 0.25)
              : KalimaColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isSelected ? KalimaColors.accent : const Color(0xFF2A2A4A),
            width: widget.isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (widget.isSelected)
              BoxShadow(color: KalimaColors.accent.withValues(alpha: 0.2), blurRadius: 12),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.word,
            style: KalimaTheme.cairoW700.copyWith(fontSize: 14, color: KalimaColors.white),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;
  final bool enabled;

  const _ActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: isPrimary
            ? KalimaTheme.neonButton(enabled: enabled)
            : KalimaTheme.tile3D(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isPrimary && enabled
                  ? KalimaColors.background
                  : KalimaColors.white.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: KalimaTheme.cairoW700.copyWith(
                fontSize: 14,
                color: isPrimary && enabled
                    ? KalimaColors.background
                    : KalimaColors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RawabetResultOverlay extends StatelessWidget {
  final bool won;
  final List<RawabetCategory> solvedGroups;
  final RawabetPuzzle puzzle;
  final VoidCallback onShare;
  final VoidCallback onClose;

  const _RawabetResultOverlay({
    required this.won,
    required this.solvedGroups,
    required this.puzzle,
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
          padding: const EdgeInsets.all(24),
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
              ...puzzle.categories.map((cat) {
                final color = KalimaColors.rawabetColors[cat.colorIndex.clamp(0, 3)];
                final solved = solvedGroups.any((s) => s.name == cat.name);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: solved ? color : KalimaColors.absent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(cat.name, style: KalimaTheme.cairoW900.copyWith(fontSize: 13, color: KalimaColors.white)),
                        Text(
                          cat.words.join('\u060c '),
                          style: KalimaTheme.cairoW400.copyWith(fontSize: 11, color: KalimaColors.white.withValues(alpha: 0.8)),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
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
                      style: KalimaTheme.cairoW700.copyWith(fontSize: 16, color: KalimaColors.white.withValues(alpha: 0.6)),
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
