import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'package:flutter_example_app/core/storage/stats_repository.dart';
import 'package:flutter_example_app/features/home/presentation/home_presentation.dart';
import 'package:flutter_example_app/features/mode_select/presentation/mode_select_presentation.dart';
import 'package:flutter_example_app/features/practice/domain/answer_input.dart';
import 'package:flutter_example_app/features/practice/domain/enums.dart';
import 'package:flutter_example_app/features/practice/domain/problem.dart';
import 'package:flutter_example_app/features/practice/presentation/practice_presentation.dart';
import 'package:flutter_example_app/features/ranking/presentation/ranking_presentation.dart';
import 'package:flutter_example_app/features/result/presentation/result_presentation.dart';
import 'package:flutter_example_app/features/stats/presentation/stats_presentation.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        WidgetbookCategory(
          name: 'Screens',
          children: [
            _homeCases(),
            _modeSelectCases(),
            _practiceCases(),
            _resultCases(),
            _statsCases(),
            _rankingCases(),
          ],
        ),
      ],
      addons: [
        ThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF0B1E4B),
                  primary: const Color(0xFF0B1E4B),
                  secondary: const Color(0xFF2F5AA8),
                  surface: Colors.white,
                ),
                scaffoldBackgroundColor: Colors.white,
                useMaterial3: true,
                textTheme: ThemeData.light()
                    .textTheme
                    .apply(
                      bodyColor: const Color(0xFF1F2A44),
                      displayColor: const Color(0xFF1F2A44),
                    ),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF0B1E4B),
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                outlinedButtonTheme: OutlinedButtonThemeData(
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: Color(0xFFCED6E5)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  ),
                ),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  backgroundColor: Colors.white,
                  selectedItemColor: Color(0xFF0B1E4B),
                  unselectedItemColor: Color(0xFF8D98B3),
                ),
              ),
            ),
          ],
          themeBuilder: (context, theme, child) =>
              Theme(data: theme, child: child),
        ),
      ],
    );
  }
}

WidgetbookComponent _homeCases() {
  return WidgetbookComponent(
    name: 'Home',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (context) => HomePresentation(
          todayAnswered: context.knobs.int.input(
            label: 'Today Answered',
            initialValue: 12,
          ),
          onSelectCategory: (_) {},
          onOpenStats: () {},
          onOpenRanking: () {},
        ),
      ),
    ],
  );
}

WidgetbookComponent _modeSelectCases() {
  return WidgetbookComponent(
    name: 'Mode Select',
    useCases: [
      WidgetbookUseCase(
        name: 'Factorization',
        builder: (context) => ModeSelectPresentation(
          category: Category.factorization,
          mode: PracticeMode.infinite,
          difficulty: Difficulty.easy,
          onModeChanged: (_) {},
          onDifficultyChanged: (_) {},
          onStart: () {},
        ),
      ),
    ],
  );
}

WidgetbookComponent _practiceCases() {
  return WidgetbookComponent(
    name: 'Practice',
    useCases: [
      WidgetbookUseCase(
        name: 'Factorization Easy',
        builder: (context) => PracticePresentation(
          sessionInfo: const PracticeSessionInfo(
            category: Category.factorization,
            mode: PracticeMode.infinite,
            difficulty: Difficulty.easy,
          ),
          questionText: context.knobs.string(
            label: 'Question',
            initialValue: 'x^2 + 5x + 6',
          ),
          progressText: '3/5 (連続 2)',
          elapsedText: '00:32',
          feedback: null,
          countdownText: null,
          quadraticCoefficients: const ExpandedCoefficients(1, 5, 6),
          canSubmit: false,
          onDigit: (_) {},
          onBackspace: () {},
          onClear: () {},
          onSubmit: () {},
          onFinish: () {},
          onSelectFactorField: (_) {},
          onSelectPrimeField: (_) {},
          onToggleSign: () {},
          factorizationInput: const FactorizationInputState(
            a: 1,
            b: null,
            c: 1,
            d: null,
            signBIsNegative: false,
            signDIsNegative: false,
            activeField: FactorField.b,
            lockA: true,
            lockC: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Factorization Hard',
        builder: (context) => PracticePresentation(
          sessionInfo: const PracticeSessionInfo(
            category: Category.factorization,
            mode: PracticeMode.timeAttack10,
            difficulty: Difficulty.hard,
          ),
          questionText: '6x^2 - 5x - 6',
          progressText: '8/10',
          elapsedText: '01:10',
          feedback: AnswerFeedback.correct,
          countdownText: null,
          quadraticCoefficients: const ExpandedCoefficients(6, -5, -6),
          canSubmit: true,
          onDigit: (_) {},
          onBackspace: () {},
          onClear: () {},
          onSubmit: () {},
          onFinish: () {},
          onSelectFactorField: (_) {},
          onSelectPrimeField: (_) {},
          onToggleSign: () {},
          factorizationInput: const FactorizationInputState(
            a: 2,
            b: 3,
            c: 3,
            d: 2,
            signBIsNegative: true,
            signDIsNegative: false,
            activeField: FactorField.signB,
            lockA: false,
            lockC: false,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Prime Factorization',
        builder: (context) => PracticePresentation(
          sessionInfo: const PracticeSessionInfo(
            category: Category.primeFactorization,
            mode: PracticeMode.infinite,
            difficulty: Difficulty.normal,
          ),
          questionText: '360',
          progressText: '5/7 (連続 3)',
          elapsedText: '00:45',
          feedback: null,
          countdownText: null,
          quadraticCoefficients: null,
          canSubmit: true,
          onDigit: (_) {},
          onBackspace: () {},
          onClear: () {},
          onSubmit: () {},
          onFinish: () {},
          onSelectFactorField: (_) {},
          onSelectPrimeField: (_) {},
          onToggleSign: null,
          primeInput: const PrimeInputState(
            primes: [2, 3, 5, 7],
            exponents: [3, 2, 1, 0],
            activeIndex: 1,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Prime Factorization Empty',
        builder: (context) => PracticePresentation(
          sessionInfo: const PracticeSessionInfo(
            category: Category.primeFactorization,
            mode: PracticeMode.infinite,
            difficulty: Difficulty.easy,
          ),
          questionText: '90',
          progressText: '1/2 (連続 1)',
          elapsedText: '00:10',
          feedback: AnswerFeedback.incorrect,
          countdownText: 'よーい',
          quadraticCoefficients: null,
          canSubmit: false,
          onDigit: (_) {},
          onBackspace: () {},
          onClear: () {},
          onSubmit: () {},
          onFinish: () {},
          onSelectFactorField: (_) {},
          onSelectPrimeField: (_) {},
          onToggleSign: null,
          primeInput: const PrimeInputState(
            primes: [2, 3, 5, 7],
            exponents: [0, 0, 0, 0],
            activeIndex: 0,
          ),
        ),
      ),
    ],
  );
}

WidgetbookComponent _resultCases() {
  return WidgetbookComponent(
    name: 'Result',
    useCases: [
      WidgetbookUseCase(
        name: 'Infinite',
        builder: (context) => ResultPresentation(
          result: const PracticeResult(
            category: Category.factorization,
            mode: PracticeMode.infinite,
            difficulty: Difficulty.normal,
            answeredCount: 12,
            correctCount: 10,
            maxStreak: 4,
            elapsedMillis: 48200,
          ),
          banner: null,
          onRetry: () {},
          onHome: () {},
        ),
      ),
      WidgetbookUseCase(
        name: 'Time Attack',
        builder: (context) => ResultPresentation(
          result: const PracticeResult(
            category: Category.primeFactorization,
            mode: PracticeMode.timeAttack10,
            difficulty: Difficulty.easy,
            answeredCount: 10,
            correctCount: 9,
            maxStreak: 5,
            elapsedMillis: 33100,
          ),
          banner: null,
          onRetry: () {},
          onHome: () {},
        ),
      ),
    ],
  );
}

WidgetbookComponent _statsCases() {
  return WidgetbookComponent(
    name: 'Stats',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (context) => StatsPresentation(
          summary: StatsSummary(
            todayAnswered: 14,
            todayCorrect: 12,
            last7DaysAnswered: 120,
            totalsAnswered: 420,
            totalsCorrect: 356,
            bestRecords: [
              BestRecordEntry(
                category: Category.factorization,
                mode: PracticeMode.infinite,
                difficulty: Difficulty.easy,
                record: const BestRecord(
                  bestCorrectCount: 30,
                  bestMaxStreak: 12,
                ),
              ),
              BestRecordEntry(
                category: Category.factorization,
                mode: PracticeMode.timeAttack10,
                difficulty: Difficulty.normal,
                record: const BestRecord(bestTimeMillis: 25000),
              ),
              BestRecordEntry(
                category: Category.primeFactorization,
                mode: PracticeMode.infinite,
                difficulty: Difficulty.hard,
                record: const BestRecord(bestCorrectCount: 18, bestMaxStreak: 7),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

WidgetbookComponent _rankingCases() {
  return WidgetbookComponent(
    name: 'Ranking',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (context) => const RankingPresentation(),
      ),
    ],
  );
}
