import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme.dart';
import '../../core/words.dart';
import '../../core/sounds.dart';
import '../../core/storage.dart';
import '../../core/waffle_data.dart';
import '../../core/nahla_data.dart';
import '../../core/kharbasha_data.dart';
import '../../core/tarteeb_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  Duration _timeToReset = Duration.zero;

  // Completion status per game
  Map<String, bool> _completed = {};
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _loadCompletionStatus();
    _updateCountdown();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateCountdown() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 3));
    final midnight = DateTime(now.year, now.month, now.day + 1);
    setState(() {
      _timeToReset = midnight.difference(now);
    });
  }

  void _loadCompletionStatus() {
    final storage = GameStorage();
    final huroufPuzzle = getPuzzleNumber();
    final wafflePuzzle = getWafflePuzzleNumber();
    final rawabetPuzzle = getPuzzleNumber();
    final nahlaPuzzle = getNahlaPuzzleNumber();
    final kharbashaPuzzle = getKharbashaPuzzleNumber();
    final tarteebPuzzle = getTarteebPuzzleNumber();

    // Hurouf: check completion marker
    final huroufDone = storage.isGameCompleted('hurouf', huroufPuzzle);

    // Waffle: check game status or completion marker
    bool waffleDone = storage.isGameCompleted('waffle', wafflePuzzle);
    if (!waffleDone) {
      final waffleState = storage.getJson('waffle_state');
      if (waffleState != null &&
          waffleState['puzzleNumber'] == wafflePuzzle &&
          (waffleState['gameStatus'] == 'won' || waffleState['gameStatus'] == 'lost')) {
        waffleDone = true;
      }
    }

    // Rawabet: check saved state
    final rawabetState = storage.loadRawabetState(rawabetPuzzle);
    final rawabetDone = rawabetState != null &&
        (rawabetState['won'] == true || rawabetState['lost'] == true);

    // Nahla: check if played today (has score)
    final nahlaState = storage.loadNahlaState(nahlaPuzzle);
    final nahlaDone = nahlaState != null && (nahlaState['score'] as int? ?? 0) > 0;

    // Kharbasha: check saved state
    final kharbashaState = storage.loadKharbashaState(kharbashaPuzzle);
    final kharbashaDone = kharbashaState != null &&
        (kharbashaState['won'] == true || kharbashaState['lost'] == true);

    // Tarteeb: check saved state
    final tarteebState = storage.loadTarteebState(tarteebPuzzle);
    final tarteebDone = tarteebState != null && tarteebState['gameOver'] == true;

    // Load streak from hurouf stats
    final stats = storage.loadHuroufStats();
    final streak = stats['currentStreak'] as int? ?? 0;

    setState(() {
      _completed = {
        'waffle': waffleDone,
        'hurouf': huroufDone,
        'rawabet': rawabetDone,
        'nahla': nahlaDone,
        'kharbasha': kharbashaDone,
        'tarteeb': tarteebDone,
      };
      _streak = streak;
    });
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final puzzleNum = getPuzzleNumber();
    return Scaffold(
      body: Container(
        decoration: KalimaTheme.backgroundGradient,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Logo
                Text(
                  '\u0643\u0644\u0645\u0629',
                  style: KalimaTheme.cairoW900.copyWith(
                    fontSize: 56,
                    color: KalimaColors.accent,
                    shadows: [
                      Shadow(
                        color: KalimaColors.accent.withValues(alpha: 0.4),
                        blurRadius: 30,
                      ),
                      const Shadow(
                        color: Color(0x66000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                    letterSpacing: 4,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.3, end: 0),
                Text(
                  '\u0623\u0644\u0639\u0627\u0628 \u0643\u0644\u0645\u0627\u062a \u064a\u0648\u0645\u064a\u0629',
                  style: KalimaTheme.cairoW600.copyWith(
                    fontSize: 16,
                    color: KalimaColors.white.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: KalimaColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: KalimaColors.accent.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    '\u0627\u0644\u0644\u063a\u0632 #$puzzleNum',
                    style: KalimaTheme.cairoW700.copyWith(
                      fontSize: 13,
                      color: KalimaColors.accent.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                if (_streak > 0) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 6),
                      Text(
                        '$_streak',
                        style: KalimaTheme.cairoW900.copyWith(
                          fontSize: 24,
                          color: KalimaColors.accent,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'يوم متتالي',
                        style: KalimaTheme.cairoW500.copyWith(
                          fontSize: 13,
                          color: KalimaColors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 32),
                // Game cards
                _GameCard(
                  title: '\u0648\u0627\u0641\u0644',
                  subtitle: '\u0628\u062f\u0651\u0644 \u0627\u0644\u062d\u0631\u0648\u0641 \u0644\u062a\u0643\u0648\u064a\u0646 \u0666 \u0643\u0644\u0645\u0627\u062a',
                  icon: Icons.grid_4x4_rounded,
                  color1: const Color(0xFF10B981),
                  color2: const Color(0xFF059669),
                  onTap: () => _go(context, '/waffle'),
                  badge: _completed['waffle'] == true ? null : '\u062c\u062f\u064a\u062f',
                  completed: _completed['waffle'] == true,
                )
                    .animate()
                    .fadeIn(delay: 80.ms, duration: 500.ms)
                    .slideY(begin: 0.15, end: 0),
                const SizedBox(height: 14),
                _GameCard(
                  title: '\u062d\u0631\u0648\u0641',
                  subtitle: '\u062e\u0645\u0651\u0646 \u0627\u0644\u0643\u0644\u0645\u0629 \u0641\u064a \u0666 \u0645\u062d\u0627\u0648\u0644\u0627\u062a',
                  icon: Icons.grid_on_rounded,
                  color1: const Color(0xFF06B6D4),
                  color2: const Color(0xFF0891B2),
                  onTap: () => _go(context, '/hurouf'),
                  completed: _completed['hurouf'] == true,
                )
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 500.ms)
                    .slideY(begin: 0.15, end: 0),
                const SizedBox(height: 14),
                _GameCard(
                  title: '\u0631\u0648\u0627\u0628\u0637',
                  subtitle: '\u0635\u0646\u0651\u0641 \u0661\u0666 \u0643\u0644\u0645\u0629 \u0641\u064a \u0664 \u0645\u062c\u0645\u0648\u0639\u0627\u062a',
                  icon: Icons.dashboard_rounded,
                  color1: const Color(0xFFF97316),
                  color2: const Color(0xFFEA580C),
                  onTap: () => _go(context, '/rawabet'),
                  completed: _completed['rawabet'] == true,
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 500.ms)
                    .slideY(begin: 0.15, end: 0),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _GameCardSmall(
                        title: '\u0646\u062d\u0644\u0629',
                        icon: Icons.hexagon_rounded,
                        color: const Color(0xFFFFD700),
                        onTap: () => _go(context, '/nahla'),
                        completed: _completed['nahla'] == true,
                      )
                          .animate()
                          .fadeIn(delay: 300.ms, duration: 500.ms)
                          .slideX(begin: -0.15, end: 0),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _GameCardSmall(
                        title: '\u062e\u0631\u0628\u0634\u0629',
                        icon: Icons.shuffle_rounded,
                        color: const Color(0xFF8B5CF6),
                        onTap: () => _go(context, '/kharbasha'),
                        completed: _completed['kharbasha'] == true,
                      )
                          .animate()
                          .fadeIn(delay: 350.ms, duration: 500.ms)
                          .slideY(begin: 0.15, end: 0),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _GameCardSmall(
                        title: '\u062a\u0631\u062a\u064a\u0628',
                        icon: Icons.swap_vert_rounded,
                        color: const Color(0xFFEC4899),
                        onTap: () => _go(context, '/tarteeb'),
                        completed: _completed['tarteeb'] == true,
                      )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 500.ms)
                          .slideX(begin: 0.15, end: 0),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Countdown timer
                Text(
                  'اللغز القادم بعد ${_formatDuration(_timeToReset)}',
                  style: KalimaTheme.cairoW500.copyWith(
                    fontSize: 13,
                    color: KalimaColors.white.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 20),
                // Bottom nav
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _NavPill(
                      icon: Icons.bar_chart_rounded,
                      label: '\u0625\u062d\u0635\u0627\u0626\u064a\u0627\u062a',
                      onTap: () => _go(context, '/stats'),
                    ),
                    const SizedBox(width: 16),
                    _NavPill(
                      icon: Icons.settings_rounded,
                      label: '\u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a',
                      onTap: () => _go(context, '/settings'),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 400.ms),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _go(BuildContext context, String path) {
    SoundManager().tap();
    HapticFeedback.mediumImpact();
    context.push(path).then((_) => _loadCompletionStatus());
  }
}

class _GameCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color1;
  final Color color2;
  final VoidCallback onTap;
  final String? badge;
  final bool completed;

  const _GameCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color1,
    required this.color2,
    required this.onTap,
    this.badge,
    this.completed = false,
  });

  @override
  State<_GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<_GameCard> {
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
        duration: const Duration(milliseconds: 100),
        transform: _pressed
            ? (Matrix4.identity()..translateByDouble(0.0, 2.0, 0.0, 1.0))
            : Matrix4.identity(),
        height: 120,
        decoration: KalimaTheme.gameCard(
          color1: widget.color1,
          color2: widget.color2,
        ),
        child: Stack(
          children: [
            Container(decoration: KalimaTheme.topHighlight),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.title,
                              style: KalimaTheme.cairoW900.copyWith(
                                fontSize: 28,
                                color: KalimaColors.white,
                                shadows: const [
                                  Shadow(
                                    color: Color(0x44000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            if (widget.completed) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: KalimaColors.correct.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: KalimaColors.correct.withValues(alpha: 0.4),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '\u2713 \u0623\u0646\u0647\u064a\u062a',
                                  style: KalimaTheme.cairoW800.copyWith(
                                    fontSize: 10,
                                    color: const Color(0xFF0F0C00),
                                  ),
                                ),
                              ),
                            ] else if (widget.badge != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: KalimaColors.accent,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: KalimaColors.accent.withValues(alpha: 0.4),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  widget.badge!,
                                  style: KalimaTheme.cairoW800.copyWith(
                                    fontSize: 10,
                                    color: const Color(0xFF0F0C00),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          widget.subtitle,
                          style: KalimaTheme.cairoW600.copyWith(
                            fontSize: 13,
                            color: KalimaColors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: KalimaColors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(widget.icon, color: KalimaColors.white, size: 28),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameCardSmall extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool completed;

  const _GameCardSmall({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.completed = false,
  });

  @override
  State<_GameCardSmall> createState() => _GameCardSmallState();
}

class _GameCardSmallState extends State<_GameCardSmall> {
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
        duration: const Duration(milliseconds: 100),
        transform: _pressed
            ? (Matrix4.identity()..translateByDouble(0.0, 2.0, 0.0, 1.0))
            : Matrix4.identity(),
        height: 110,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.color.withValues(alpha: 0.2),
              widget.color.withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.color.withValues(alpha: 0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Top highlight
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.4],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, color: widget.color, size: 30),
                  const SizedBox(height: 8),
                  Text(
                    widget.title,
                    style: KalimaTheme.cairoW800.copyWith(
                      fontSize: 15,
                      color: KalimaColors.white,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.completed)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: KalimaColors.correct,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: KalimaColors.correct.withValues(alpha: 0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, color: Color(0xFF0F0C00), size: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: KalimaColors.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: KalimaColors.white.withValues(alpha: 0.6), size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: KalimaTheme.cairoW600.copyWith(
                fontSize: 13,
                color: KalimaColors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
