import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/ads/ad_config.dart';
import 'core/ads/ad_service.dart';
import 'core/ads/admob_ad_service.dart';
import 'core/ads/noop_ad_service.dart';
import 'core/clock/clock.dart';
import 'core/storage/stats_repository_prefs.dart';
import 'features/practice/domain/generators/problem_generator.dart';
import 'features/practice/domain/generators/info_problem_generator.dart';
import 'router.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.statsRepository,
    required this.infoProblemGenerator,
    required this.clock,
    required this.adService,
  });

  final StatsRepositoryPrefs statsRepository;
  final InfoProblemGenerator infoProblemGenerator;
  final Clock clock;
  final AdService adService;

  @override
  Widget build(BuildContext context) {
    final router = createRouter(
      statsRepository: statsRepository,
      infoProblemGenerator: infoProblemGenerator,
      clock: clock,
      adService: adService,
    );

    return MaterialApp.router(
      title: 'Hitasura Jouhou',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0EA5E9),
          primary: const Color(0xFF0EA5E9),
          secondary: const Color(0xFF38BDF8),
          surface: Colors.white,
          error: const Color(0xFFEF4444),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        useMaterial3: true,
        textTheme: ThemeData.light()
            .textTheme
            .apply(
              bodyColor: const Color(0xFF0F172A),
              displayColor: const Color(0xFF0F172A),
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0284C7),
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: const StadiumBorder(),
            side: const BorderSide(color: Color(0xFFCED6E5)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF0EA5E9),
          unselectedItemColor: Color(0xFF8D98B3),
        ),
      ),
      routerConfig: router,
    );
  }

  static Future<App> bootstrap() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    final adService = _buildAdService();
    await adService.init();
    return App(
      statsRepository: StatsRepositoryPrefs(prefs: prefs),
      infoProblemGenerator: FixedInfoProblemGenerator(),
      clock: SystemClock(),
      adService: adService,
    );
  }

  static AdService _buildAdService() {
    final interstitialId = AdConfig.interstitialId();
    final bannerId = AdConfig.bannerId();
    if (interstitialId.isEmpty && bannerId.isEmpty) {
      return NoopAdService();
    }
    return AdMobAdService(clock: SystemClock(), adUnitId: interstitialId);
  }
}
