import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme.dart';
import '../../core/storage.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final huroufStats = GameStorage().loadHuroufStats();
    final rawabetStats = GameStorage().loadRawabetStats();

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
                        '\u0625\u062d\u0635\u0627\u0626\u064a\u0627\u062a',
                        textAlign: TextAlign.center,
                        style: KalimaTheme.cairoW900.copyWith(fontSize: 22, color: KalimaColors.white),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _StatsCard(
                        title: '\u062d\u0631\u0648\u0641',
                        color: KalimaColors.cardTeal,
                        played: huroufStats['played'] as int,
                        won: huroufStats['won'] as int,
                        currentStreak: huroufStats['currentStreak'] as int,
                        maxStreak: huroufStats['maxStreak'] as int,
                        distribution: List<int>.from(huroufStats['distribution'] as List),
                      ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 16),
                      _StatsCard(
                        title: '\u0631\u0648\u0627\u0628\u0637',
                        color: KalimaColors.cardCoral,
                        played: rawabetStats['played'] as int,
                        won: rawabetStats['won'] as int,
                        currentStreak: rawabetStats['currentStreak'] as int,
                        maxStreak: rawabetStats['maxStreak'] as int,
                      ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final Color color;
  final int played;
  final int won;
  final int currentStreak;
  final int maxStreak;
  final List<int>? distribution;

  const _StatsCard({
    required this.title,
    required this.color,
    required this.played,
    required this.won,
    required this.currentStreak,
    required this.maxStreak,
    this.distribution,
  });

  @override
  Widget build(BuildContext context) {
    final winPct = played > 0 ? (won / played * 100).round() : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: KalimaTheme.card3D(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: KalimaTheme.cairoW900.copyWith(fontSize: 20, color: color)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatNum(value: '$played', label: '\u0644\u0639\u0628'),
              _StatNum(value: '$winPct%', label: '\u0641\u0648\u0632'),
              _StatNum(value: '$currentStreak', label: '\u0633\u0644\u0633\u0644\u0629'),
              _StatNum(value: '$maxStreak', label: '\u0623\u0639\u0644\u0649'),
            ],
          ),
          if (distribution != null && played > 0) ...[
            const SizedBox(height: 20),
            Text(
              '\u062a\u0648\u0632\u064a\u0639 \u0627\u0644\u0645\u062d\u0627\u0648\u0644\u0627\u062a',
              style: KalimaTheme.cairoW700.copyWith(fontSize: 14, color: KalimaColors.white.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 8),
            ...List.generate(6, (i) {
              final count = distribution![i];
              final maxCount = distribution!.reduce((a, b) => a > b ? a : b);
              final ratio = maxCount > 0 ? count / maxCount : 0.0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: Text(
                        '${i + 1}',
                        style: KalimaTheme.cairoW700.copyWith(fontSize: 13, color: KalimaColors.white.withValues(alpha: 0.6)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Container(
                          width: (constraints.maxWidth * ratio).clamp(24.0, constraints.maxWidth),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '$count',
                            style: KalimaTheme.cairoW700.copyWith(fontSize: 12, color: KalimaColors.white),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            }),
          ],
          if (played == 0)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Center(
                child: Text(
                  '\u0627\u0644\u0639\u0628 \u0623\u0648\u0644\u0627\u064b \u0644\u0631\u0624\u064a\u0629 \u0625\u062d\u0635\u0627\u0626\u064a\u0627\u062a\u0643',
                  style: KalimaTheme.cairoW600.copyWith(fontSize: 14, color: KalimaColors.white.withValues(alpha: 0.3)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatNum extends StatelessWidget {
  final String value;
  final String label;

  const _StatNum({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: KalimaTheme.cairoW900.copyWith(fontSize: 24, color: KalimaColors.white)),
        Text(label, style: KalimaTheme.cairoW600.copyWith(fontSize: 12, color: KalimaColors.white.withValues(alpha: 0.5))),
      ],
    );
  }
}
