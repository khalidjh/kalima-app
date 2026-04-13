import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme.dart';
import 'core/sounds.dart';
import 'core/storage.dart';
import 'features/home/home_screen.dart';
import 'features/hurouf/hurouf_screen.dart';
import 'features/rawabet/rawabet_screen.dart';
import 'features/nahla/nahla_screen.dart';
import 'features/kharbasha/kharbasha_screen.dart';
import 'features/tarteeb/tarteeb_screen.dart';
import 'features/stats/stats_screen.dart';
import 'features/waffle/waffle_screen.dart';
import 'features/settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: KalimaColors.background,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  await GameStorage().init();
  await SoundManager().init();

  runApp(const ProviderScope(child: KalimaApp()));
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/waffle', builder: (context, state) => const WaffleScreen()),
    GoRoute(path: '/hurouf', builder: (context, state) => const HuroufScreen()),
    GoRoute(path: '/rawabet', builder: (context, state) => const RawabetScreen()),
    GoRoute(path: '/nahla', builder: (context, state) => const NahlaScreen()),
    GoRoute(path: '/kharbasha', builder: (context, state) => const KharbashaScreen()),
    GoRoute(path: '/tarteeb', builder: (context, state) => const TarteebScreen()),
    GoRoute(path: '/stats', builder: (context, state) => const StatsScreen()),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
  ],
);

class KalimaApp extends StatelessWidget {
  const KalimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '\u0643\u0644\u0645\u0629',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        scaffoldBackgroundColor: KalimaColors.background,
        colorScheme: const ColorScheme.dark(
          primary: KalimaColors.accent,
          surface: KalimaColors.surface,
        ),
        useMaterial3: true,
      ),
      locale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
