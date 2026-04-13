import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart' as share_plus;

import '../../core/theme.dart';
import '../../core/tarteeb_data.dart';
import '../../core/sounds.dart';
import '../../core/storage.dart';

class TarteebState {
  final List<TarteebPair> pairs;
  final int currentRound;
  final int score;
  final bool revealed;
  final bool? lastCorrect;
  final bool gameOver;
  final List<bool> results;

  const TarteebState({
    this.pairs = const [],
    this.currentRound = 0,
    this.score = 0,
    this.revealed = false,
    this.lastCorrect,
    this.gameOver = false,
    this.results = const [],
  });

  TarteebState copyWith({
    List<TarteebPair>? pairs,
    int? currentRound,
    int? score,
    bool? revealed,
    bool? lastCorrect,
    bool? gameOver,
    List<bool>? results,
  }) {
    return TarteebState(
      pairs: pairs ?? this.pairs,
      currentRound: currentRound ?? this.currentRound,
      score: score ?? this.score,
      revealed: revealed ?? this.revealed,
      lastCorrect: lastCorrect,
      gameOver: gameOver ?? this.gameOver,
      results: results ?? this.results,
    );
  }

  TarteebPair? get currentPair => currentRound < pairs.length ? pairs[currentRound] : null;
}

class TarteebNotifier extends StateNotifier<TarteebState> {
  TarteebNotifier() : super(const TarteebState()) {
    _init();
  }

  void _init() {
    final pairs = getDailyTarteebPairs();
    final puzzleNum = getTarteebPuzzleNumber();
    final saved = GameStorage().loadTarteebState(puzzleNum);

    if (saved != null && saved['puzzleNumber'] == puzzleNum) {
      state = TarteebState(
        pairs: pairs,
        currentRound: saved['currentRound'] as int? ?? 0,
        score: saved['score'] as int? ?? 0,
        results: List<bool>.from(saved['results'] ?? []),
        gameOver: saved['gameOver'] as bool? ?? false,
      );
    } else {
      state = TarteebState(pairs: pairs);
    }
  }

  void _saveState() {
    final puzzleNum = getTarteebPuzzleNumber();
    GameStorage().saveTarteebState(puzzleNum, {
      'puzzleNumber': puzzleNum,
      'currentRound': state.currentRound,
      'score': state.score,
      'results': state.results,
      'gameOver': state.gameOver,
    });
  }

  void _updateStats() {
    final stats = GameStorage().loadTarteebStats();
    stats['played'] = (stats['played'] as int) + 1;
    stats['totalScore'] = (stats['totalScore'] as int) + state.score;
    if (state.score == state.pairs.length) {
      stats['currentStreak'] = (stats['currentStreak'] as int) + 1;
      final maxStreak = stats['maxStreak'] as int;
      final curStreak = stats['currentStreak'] as int;
      if (curStreak > maxStreak) stats['maxStreak'] = curStreak;
    } else {
      stats['currentStreak'] = 0;
    }
    GameStorage().saveTarteebStats(stats);
  }

  void guess(bool guessedHigher) {
    if (state.revealed || state.gameOver || state.currentPair == null) return;

    final pair = state.currentPair!;
    final correct = guessedHigher == pair.isHigherCorrect;

    if (correct) {
      SoundManager().correct();
    } else {
      SoundManager().wrong();
    }

    state = state.copyWith(
      revealed: true,
      lastCorrect: correct,
      score: correct ? state.score + 1 : state.score,
      results: [...state.results, correct],
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      final nextRound = state.currentRound + 1;
      if (nextRound >= state.pairs.length) {
        state = state.copyWith(gameOver: true, currentRound: nextRound, revealed: false);
        _saveState();
        _updateStats();
      } else {
        state = state.copyWith(currentRound: nextRound, revealed: false, lastCorrect: null);
        _saveState();
      }
    });
  }
}

final tarteebProvider = StateNotifierProvider<TarteebNotifier, TarteebState>(
  (ref) => TarteebNotifier(),
);

class TarteebScreen extends ConsumerWidget {
  const TarteebScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gs = ref.watch(tarteebProvider);

    return Scaffold(
      body: Container(
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
                        '\u062a\u0631\u062a\u064a\u0628',
                        textAlign: TextAlign.center,
                        style: KalimaTheme.cairoW900.copyWith(fontSize: 22, color: KalimaColors.white),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              // Score + round
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\u0627\u0644\u0646\u062a\u064a\u062c\u0629: ${gs.score}/${gs.pairs.length}',
                      style: KalimaTheme.cairoW700.copyWith(fontSize: 16, color: KalimaColors.accent),
                    ),
                    Text(
                      '\u062c\u0648\u0644\u0629 ${gs.currentRound + 1}/${gs.pairs.length}',
                      style: KalimaTheme.cairoW600.copyWith(fontSize: 14, color: KalimaColors.white.withValues(alpha: 0.5)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Progress dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(gs.pairs.length, (i) {
                  Color dotColor;
                  if (i < gs.results.length) {
                    dotColor = gs.results[i] ? KalimaColors.correct : KalimaColors.error;
                  } else if (i == gs.currentRound && !gs.gameOver) {
                    dotColor = KalimaColors.accent;
                  } else {
                    dotColor = KalimaColors.absent;
                  }
                  return Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dotColor,
                      boxShadow: i == gs.currentRound && !gs.gameOver
                          ? [BoxShadow(color: KalimaColors.accent.withValues(alpha: 0.5), blurRadius: 6)]
                          : null,
                    ),
                  );
                }),
              ),
              const Spacer(),
              if (!gs.gameOver && gs.currentPair != null) ...[
                // Category
                Text(
                  gs.currentPair!.category,
                  style: KalimaTheme.cairoW600.copyWith(fontSize: 14, color: KalimaColors.white.withValues(alpha: 0.5)),
                ),
                const SizedBox(height: 16),
                // Comparison cards
                _ComparisonCards(gs: gs, ref: ref),
              ],
              if (gs.gameOver) _GameOverView(gs: gs),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComparisonCards extends StatelessWidget {
  final TarteebState gs;
  final WidgetRef ref;

  const _ComparisonCards({required this.gs, required this.ref});

  @override
  Widget build(BuildContext context) {
    final pair = gs.currentPair!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Item A (known)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: KalimaTheme.card3D(color: KalimaColors.cardTeal.withValues(alpha: 0.15)),
            child: Column(
              children: [
                Text(pair.itemA, style: KalimaTheme.cairoW900.copyWith(fontSize: 24, color: KalimaColors.white)),
                const SizedBox(height: 4),
                Text(
                  '${pair.valueA} ${pair.unit}',
                  style: KalimaTheme.cairoW700.copyWith(fontSize: 18, color: KalimaColors.cardTeal),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // VS
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: KalimaColors.surface,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 6)],
            ),
            child: Center(
              child: Text('VS', style: KalimaTheme.cairoW900.copyWith(fontSize: 14, color: KalimaColors.accent)),
            ),
          ),
          const SizedBox(height: 12),
          // Item B
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: KalimaTheme.card3D(color: KalimaColors.cardPink.withValues(alpha: 0.15)),
            child: Column(
              children: [
                Text(pair.itemB, style: KalimaTheme.cairoW900.copyWith(fontSize: 24, color: KalimaColors.white)),
                const SizedBox(height: 4),
                if (gs.revealed)
                  Text(
                    '${pair.valueB} ${pair.unit}',
                    style: KalimaTheme.cairoW700.copyWith(fontSize: 18, color: KalimaColors.cardPink),
                  ).animate().fadeIn(duration: 300.ms)
                else
                  Text('?', style: KalimaTheme.cairoW900.copyWith(fontSize: 22, color: KalimaColors.white.withValues(alpha: 0.3))),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Buttons or result
          if (!gs.revealed)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ChoiceButton(
                  label: '\u0623\u0639\u0644\u0649',
                  icon: Icons.arrow_upward_rounded,
                  color: KalimaColors.correct,
                  onTap: () => ref.read(tarteebProvider.notifier).guess(true),
                ),
                _ChoiceButton(
                  label: '\u0623\u062f\u0646\u0649',
                  icon: Icons.arrow_downward_rounded,
                  color: KalimaColors.cardCoral,
                  onTap: () => ref.read(tarteebProvider.notifier).guess(false),
                ),
              ],
            )
          else
            Text(
              gs.lastCorrect == true ? '\u2705 \u0635\u062d!' : '\u274c \u062e\u0637\u0623',
              style: KalimaTheme.cairoW900.copyWith(
                fontSize: 22,
                color: gs.lastCorrect == true ? KalimaColors.correct : KalimaColors.error,
              ),
            ).animate().scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0), duration: 200.ms),
        ],
      ),
    );
  }
}

class _ChoiceButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ChoiceButton({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  State<_ChoiceButton> createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<_ChoiceButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        transform: _pressed ? (Matrix4.identity()..translateByDouble(0.0, 2.0, 0.0, 1.0)) : Matrix4.identity(),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: KalimaTheme.neonButton(color: widget.color),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, color: KalimaColors.background, size: 20),
            const SizedBox(width: 6),
            Text(widget.label, style: KalimaTheme.cairoW700.copyWith(fontSize: 16, color: KalimaColors.background)),
          ],
        ),
      ),
    );
  }
}

class _GameOverView extends StatelessWidget {
  final TarteebState gs;
  const _GameOverView({required this.gs});

  @override
  Widget build(BuildContext context) {
    final emojis = gs.results.map((r) => r ? '\u2705' : '\u274c').join();
    return Column(
      children: [
        Text(
          '\u0627\u0646\u062a\u0647\u062a!',
          style: KalimaTheme.cairoW900.copyWith(fontSize: 32, color: KalimaColors.accent),
        ),
        const SizedBox(height: 8),
        Text(
          '${gs.score}/${gs.pairs.length}',
          style: KalimaTheme.cairoW800.copyWith(fontSize: 48, color: KalimaColors.white),
        ),
        const SizedBox(height: 8),
        Text(emojis, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            final text = '\u0643\u0644\u0645\u0629 \u062a\u0631\u062a\u064a\u0628 #${getTarteebPuzzleNumber()}\n${gs.score}/${gs.pairs.length}\n$emojis\nkalima.fun';
            share_plus.Share.share(text);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            decoration: KalimaTheme.neonButton(),
            child: Text(
              '\u0645\u0634\u0627\u0631\u0643\u0629',
              style: KalimaTheme.cairoW700.copyWith(fontSize: 16, color: KalimaColors.background),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }
}
