import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart' as share_plus;

import '../../core/theme.dart';
import '../../core/sounds.dart';
import '../../core/storage.dart';
import '../../core/waffle_data.dart';

class WaffleScreen extends StatefulWidget {
  const WaffleScreen({super.key});

  @override
  State<WaffleScreen> createState() => _WaffleScreenState();
}

class _WaffleScreenState extends State<WaffleScreen> with TickerProviderStateMixin {
  late WafflePuzzle puzzle;
  late List<List<String?>> grid;
  int swaps = 0;
  static const maxSwaps = 15;
  String gameStatus = 'playing'; // playing, won, lost
  List<int>? selected; // [row, col] or null
  bool showHelp = false;
  String? shakeKey;

  final _storage = GameStorage();

  @override
  void initState() {
    super.initState();
    puzzle = getTodayWafflePuzzle()!;
    _loadOrInit();
  }

  void _loadOrInit() {
    final saved = _storage.getJson('waffle_state');
    final puzzleNum = getWafflePuzzleNumber();

    if (saved != null && saved['puzzleNumber'] == puzzleNum) {
      grid = (saved['grid'] as List).map<List<String?>>((row) {
        return (row as List).map<String?>((c) => c as String?).toList();
      }).toList();
      swaps = saved['swaps'] as int;
      gameStatus = saved['gameStatus'] as String;
    } else {
      grid = _shuffleGrid(puzzle.solution);
      _save();
      showHelp = true;
    }
  }

  List<List<String?>> _shuffleGrid(List<List<String?>> solution) {
    final positions = getWaffleCellPositions();
    final letters = <String>[];
    for (final pos in positions) {
      letters.add(solution[pos[0]][pos[1]]!);
    }

    final rng = Random();
    final shuffled = List<String>.from(letters);
    for (int i = shuffled.length - 1; i > 0; i--) {
      final j = rng.nextInt(i + 1);
      final temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }

    // Ensure not already solved
    bool isSolved = true;
    for (int idx = 0; idx < positions.length; idx++) {
      if (shuffled[idx] != solution[positions[idx][0]][positions[idx][1]]) {
        isSolved = false;
        break;
      }
    }
    if (isSolved && shuffled.length >= 2) {
      final temp = shuffled[0];
      shuffled[0] = shuffled[1];
      shuffled[1] = temp;
    }

    final newGrid = List.generate(5, (r) => List<String?>.filled(5, null));
    for (int idx = 0; idx < positions.length; idx++) {
      newGrid[positions[idx][0]][positions[idx][1]] = shuffled[idx];
    }
    return newGrid;
  }

  void _save() {
    _storage.setJson('waffle_state', {
      'puzzleNumber': getWafflePuzzleNumber(),
      'grid': grid,
      'swaps': swaps,
      'gameStatus': gameStatus,
    });
  }

  String _getCellColor(int row, int col) {
    if (!isWaffleCell(row, col)) return 'empty';
    final letter = grid[row][col];
    final target = puzzle.solution[row][col];
    if (letter == target) return 'correct';

    final wordLetters = <String>[];
    if (row == 0 || row == 2 || row == 4) {
      for (int c = 0; c < 5; c++) {
        if (puzzle.solution[row][c] != null) wordLetters.add(puzzle.solution[row][c]!);
      }
    }
    if (col == 0 || col == 2 || col == 4) {
      for (int r = 0; r < 5; r++) {
        if (isWaffleCell(r, col) && puzzle.solution[r][col] != null) {
          wordLetters.add(puzzle.solution[r][col]!);
        }
      }
    }
    if (letter != null && wordLetters.contains(letter)) return 'present';
    return 'absent';
  }

  bool _checkSolved() {
    for (final pos in getWaffleCellPositions()) {
      if (grid[pos[0]][pos[1]] != puzzle.solution[pos[0]][pos[1]]) return false;
    }
    return true;
  }

  void _onCellTap(int row, int col) {
    if (gameStatus != 'playing') return;
    if (!isWaffleCell(row, col)) return;

    // Don't select correct cells
    if (grid[row][col] == puzzle.solution[row][col]) {
      setState(() => shakeKey = '$row-$col');
      Future.delayed(300.ms, () {
        if (mounted) setState(() => shakeKey = null);
      });
      HapticFeedback.lightImpact();
      return;
    }

    if (selected == null) {
      setState(() => selected = [row, col]);
      SoundManager().tap();
      HapticFeedback.selectionClick();
    } else {
      final sr = selected![0];
      final sc = selected![1];

      if (sr == row && sc == col) {
        setState(() => selected = null);
        return;
      }

      // Don't swap with correct cell
      if (grid[sr][sc] == puzzle.solution[sr][sc]) {
        setState(() {
          shakeKey = '$sr-$sc';
          selected = [row, col];
        });
        Future.delayed(300.ms, () {
          if (mounted) setState(() => shakeKey = null);
        });
        return;
      }

      // Swap
      setState(() {
        final temp = grid[sr][sc];
        grid[sr][sc] = grid[row][col];
        grid[row][col] = temp;
        swaps++;
        selected = null;

        if (_checkSolved()) {
          gameStatus = 'won';
          SoundManager().correct();
          HapticFeedback.heavyImpact();
          GameStorage().markGameCompleted('waffle', getWafflePuzzleNumber());
        } else if (swaps >= maxSwaps) {
          gameStatus = 'lost';
          HapticFeedback.heavyImpact();
          GameStorage().markGameCompleted('waffle', getWafflePuzzleNumber());
        } else {
          SoundManager().tap();
          HapticFeedback.mediumImpact();
        }
      });
      _save();
    }
  }

  int get stars {
    if (gameStatus != 'won') return 0;
    final extra = (swaps - 10).clamp(0, 999);
    return (5 - (extra ~/ 3)).clamp(0, 5);
  }

  void _share() {
    final puzzleNum = getWafflePuzzleNumber();
    final starStr = List.filled(stars, '\u2b50').join();
    var gridStr = '';
    for (int r = 0; r < 5; r++) {
      var line = '';
      for (int c = 0; c < 5; c++) {
        if (!isWaffleCell(r, c)) {
          line += '  ';
          continue;
        }
        if (gameStatus == 'won') {
          line += '\ud83d\udfe9';
        } else {
          final color = _getCellColor(r, c);
          if (color == 'correct') {
            line += '\ud83d\udfe9';
          } else if (color == 'present') {
            line += '\ud83d\udfe7';
          } else {
            line += '\u2b1b';
          }
        }
      }
      gridStr += '$line\n';
    }
    final text = '\u0648\u0627\u0641\u0644 \u0643\u0644\u0645\u0629 #$puzzleNum\n$starStr ($swaps/$maxSwaps)\n\n$gridStr\nkalima.fun/waffle';
    share_plus.Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final remaining = maxSwaps - swaps;

    return Scaffold(
      body: Container(
        decoration: KalimaTheme.backgroundGradient,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white70, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    Text(
                      '\u0648\u0627\u0641\u0644',
                      style: KalimaTheme.cairoW900.copyWith(fontSize: 24, color: KalimaColors.white),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.help_outline_rounded, color: Colors.white70, size: 20),
                      onPressed: () => setState(() => showHelp = true),
                    ),
                  ],
                ),
              ),

              // Swaps counter
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: KalimaColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.swap_horiz_rounded, color: KalimaColors.accent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '$remaining',
                      style: KalimaTheme.cairoW800.copyWith(fontSize: 18, color: KalimaColors.white),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '\u062a\u0628\u062f\u064a\u0644\u0629 \u0645\u062a\u0628\u0642\u064a\u0629',
                      style: KalimaTheme.cairoW500.copyWith(fontSize: 12, color: Colors.white54),
                    ),
                  ],
                ),
              ),

              // Grid
              Expanded(
                child: Center(
                  child: _buildGrid(),
                ),
              ),

              // Result
              if (gameStatus != 'playing') _buildResult(),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      // Help overlay
      floatingActionButton: showHelp ? null : null,
      // Using a simple stack overlay for help
    );
  }

  Widget _buildGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    final tileSize = ((screenWidth - 80) / 5).clamp(48.0, 64.0);
    final gap = 6.0;

    return SizedBox(
      width: tileSize * 5 + gap * 4,
      height: tileSize * 5 + gap * 4,
      child: Stack(
        children: [
          for (int r = 0; r < 5; r++)
            for (int c = 0; c < 5; c++)
              if (isWaffleCell(r, c))
                Positioned(
                  left: c * (tileSize + gap),
                  top: r * (tileSize + gap),
                  child: _buildTile(r, c, tileSize),
                ),
          // Help modal
          if (showHelp) _buildHelpOverlay(),
        ],
      ),
    );
  }

  Widget _buildTile(int row, int col, double size) {
    final letter = grid[row][col] ?? '';
    final colorName = _getCellColor(row, col);
    final isSelected = selected != null && selected![0] == row && selected![1] == col;
    final isShaking = shakeKey == '$row-$col';
    final isCorrectCell = colorName == 'correct';

    Color tileColor;
    if (gameStatus == 'won') {
      tileColor = KalimaColors.correct;
    } else if (colorName == 'correct') {
      tileColor = KalimaColors.correct;
    } else if (colorName == 'present') {
      tileColor = KalimaColors.present;
    } else {
      tileColor = KalimaColors.absent;
    }

    Widget tile = GestureDetector(
      onTap: () => _onCellTap(row, col),
      child: AnimatedContainer(
        duration: 200.ms,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: KalimaColors.accent, width: 3)
              : null,
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: KalimaColors.accent.withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
            if (isCorrectCell && gameStatus == 'playing')
              BoxShadow(
                color: KalimaColors.correct.withValues(alpha: 0.3),
                blurRadius: 10,
              ),
          ],
        ),
        child: Center(
          child: Text(
            letter,
            style: KalimaTheme.cairoW800.copyWith(
              fontSize: size * 0.45,
              color: KalimaColors.white,
              shadows: const [
                Shadow(color: Color(0x66000000), blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
          ),
        ),
      ),
    );

    if (isShaking) {
      tile = tile.animate(onComplete: (_) {}).shakeX(hz: 6, amount: 4, duration: 300.ms);
    }

    return tile.animate().fadeIn(duration: 300.ms, delay: Duration(milliseconds: (row * 5 + col) * 30));
  }

  Widget _buildResult() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: KalimaTheme.glass,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (gameStatus == 'won') ...[
            Text(
              List.filled(stars, '\u2b50').join(),
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              '\u0623\u062d\u0633\u0646\u062a!',
              style: KalimaTheme.cairoW900.copyWith(fontSize: 24, color: KalimaColors.white),
            ),
            Text(
              '\u062d\u0644\u0644\u062a \u0627\u0644\u0648\u0627\u0641\u0644 \u0628\u0640 $swaps \u062a\u0628\u062f\u064a\u0644\u0629',
              style: KalimaTheme.cairoW500.copyWith(fontSize: 14, color: Colors.white60),
            ),
          ] else ...[
            Text(
              '\u0627\u0646\u062a\u0647\u062a \u0627\u0644\u062a\u0628\u062f\u064a\u0644\u0627\u062a!',
              style: KalimaTheme.cairoW900.copyWith(fontSize: 22, color: KalimaColors.white),
            ),
            Text(
              '\u062d\u0627\u0648\u0644 \u0645\u0631\u0629 \u0623\u062e\u0631\u0649 \u063a\u062f\u0627',
              style: KalimaTheme.cairoW500.copyWith(fontSize: 14, color: Colors.white60),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _share,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: KalimaTheme.neonButton(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.share_rounded, color: Color(0xFF0F0C00), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '\u0645\u0634\u0627\u0631\u0643\u0629',
                        style: KalimaTheme.cairoW700.copyWith(fontSize: 14, color: const Color(0xFF0F0C00)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildHelpOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => showHelp = false),
        child: Container(
          color: Colors.black.withValues(alpha: 0.85),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: KalimaColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\u0643\u064a\u0641 \u062a\u0644\u0639\u0628 \u0648\u0627\u0641\u0644\u061f',
                    style: KalimaTheme.cairoW900.copyWith(fontSize: 20, color: KalimaColors.white),
                  ),
                  const SizedBox(height: 16),
                  _helpLine('\u0627\u0636\u063a\u0637 \u0639\u0644\u0649 \u062d\u0631\u0641 \u062b\u0645 \u0627\u0636\u063a\u0637 \u0639\u0644\u0649 \u0622\u062e\u0631 \u0644\u062a\u0628\u062f\u064a\u0644\u0647\u0645\u0627'),
                  _helpLine('\u0644\u062f\u064a\u0643 \u0661\u0665 \u062a\u0628\u062f\u064a\u0644\u0629 \u0643\u062d\u062f \u0623\u0642\u0635\u0649'),
                  _helpLine('\u0631\u062a\u0651\u0628 \u0643\u0644 \u0627\u0644\u062d\u0631\u0648\u0641 \u0644\u062a\u0643\u0648\u064a\u0646 \u0666 \u0643\u0644\u0645\u0627\u062a'),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _colorBox(KalimaColors.correct, '\u0635\u062d\u064a\u062d'),
                      const SizedBox(width: 12),
                      _colorBox(KalimaColors.present, '\u0645\u0643\u0627\u0646 \u062e\u0627\u0637\u0626'),
                      const SizedBox(width: 12),
                      _colorBox(KalimaColors.absent, '\u063a\u064a\u0631 \u0645\u0648\u062c\u0648\u062f'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => setState(() => showHelp = false),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: KalimaTheme.neonButton(),
                      child: Center(
                        child: Text(
                          '\u0641\u0647\u0645\u062a!',
                          style: KalimaTheme.cairoW700.copyWith(fontSize: 16, color: const Color(0xFF0F0C00)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _helpLine(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: KalimaColors.accent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: KalimaTheme.cairoW500.copyWith(fontSize: 14, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorBox(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: KalimaTheme.cairoW500.copyWith(fontSize: 11, color: Colors.white60),
        ),
      ],
    );
  }
}
