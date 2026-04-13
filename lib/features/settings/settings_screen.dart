import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme.dart';
import '../../core/sounds.dart';
import '../../core/storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _soundEnabled;
  late bool _hardMode;
  late bool _notifications;

  @override
  void initState() {
    super.initState();
    _soundEnabled = GameStorage().soundEnabled;
    _hardMode = GameStorage().hardMode;
    _notifications = GameStorage().notificationsEnabled;
  }

  @override
  Widget build(BuildContext context) {
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
                        '\u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a',
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
                      Container(
                        decoration: KalimaTheme.card3D(),
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          children: [
                            _SettingsTile(
                              icon: Icons.volume_up_rounded,
                              title: '\u0627\u0644\u0623\u0635\u0648\u0627\u062a',
                              subtitle: '\u062a\u0623\u062b\u064a\u0631\u0627\u062a \u0635\u0648\u062a\u064a\u0629 \u0648\u0627\u0647\u062a\u0632\u0627\u0632',
                              trailing: Switch.adaptive(
                                value: _soundEnabled,
                                activeTrackColor: KalimaColors.accent,
                                onChanged: (v) {
                                  setState(() => _soundEnabled = v);
                                  GameStorage().setSoundEnabled(v);
                                  SoundManager().toggleSound();
                                },
                              ),
                            ),
                            _divider(),
                            _SettingsTile(
                              icon: Icons.fitness_center_rounded,
                              title: '\u0627\u0644\u0648\u0636\u0639 \u0627\u0644\u0635\u0639\u0628',
                              subtitle: '\u064a\u062c\u0628 \u0627\u0633\u062a\u062e\u062f\u0627\u0645 \u0627\u0644\u062d\u0631\u0648\u0641 \u0627\u0644\u0645\u0643\u062a\u0634\u0641\u0629',
                              trailing: Switch.adaptive(
                                value: _hardMode,
                                activeTrackColor: KalimaColors.accent,
                                onChanged: (v) {
                                  setState(() => _hardMode = v);
                                  GameStorage().setHardMode(v);
                                },
                              ),
                            ),
                            _divider(),
                            _SettingsTile(
                              icon: Icons.notifications_rounded,
                              title: '\u0627\u0644\u0625\u0634\u0639\u0627\u0631\u0627\u062a',
                              subtitle: '\u062a\u0630\u0643\u064a\u0631 \u064a\u0648\u0645\u064a \u0628\u0627\u0644\u0644\u063a\u0632',
                              trailing: Switch.adaptive(
                                value: _notifications,
                                activeTrackColor: KalimaColors.accent,
                                onChanged: (v) {
                                  setState(() => _notifications = v);
                                  GameStorage().setNotificationsEnabled(v);
                                },
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                      const SizedBox(height: 24),
                      // About
                      Container(
                        decoration: KalimaTheme.card3D(),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              '\u0643\u0644\u0645\u0629',
                              style: KalimaTheme.cairoW900.copyWith(fontSize: 28, color: KalimaColors.accent),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'v2.0.0',
                              style: KalimaTheme.cairoW600.copyWith(fontSize: 13, color: KalimaColors.white.withValues(alpha: 0.4)),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '\u0623\u0644\u0639\u0627\u0628 \u0643\u0644\u0645\u0627\u062a \u064a\u0648\u0645\u064a\u0629 \u0628\u0627\u0644\u0639\u0631\u0628\u064a\u0629',
                              style: KalimaTheme.cairoW600.copyWith(fontSize: 14, color: KalimaColors.white.withValues(alpha: 0.6)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\u062d\u0631\u0648\u0641 \u2022 \u0631\u0648\u0627\u0628\u0637 \u2022 \u0646\u062d\u0644\u0629 \u2022 \u062e\u0631\u0628\u0634\u0629 \u2022 \u062a\u0631\u062a\u064a\u0628',
                              textAlign: TextAlign.center,
                              style: KalimaTheme.cairoW400.copyWith(fontSize: 13, color: KalimaColors.white.withValues(alpha: 0.4)),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'kalima.fun',
                              style: KalimaTheme.cairoW700.copyWith(fontSize: 14, color: KalimaColors.accent.withValues(alpha: 0.6)),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
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

  Widget _divider() {
    return Divider(
      height: 1,
      color: KalimaColors.white.withValues(alpha: 0.06),
      indent: 56,
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: KalimaColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: KalimaColors.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: KalimaTheme.cairoW700.copyWith(fontSize: 15, color: KalimaColors.white)),
                Text(subtitle, style: KalimaTheme.cairoW400.copyWith(fontSize: 12, color: KalimaColors.white.withValues(alpha: 0.4))),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
