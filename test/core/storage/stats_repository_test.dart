import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_example_app/core/storage/stats_repository_prefs.dart';
import 'package:flutter_example_app/features/practice/domain/enums.dart';

void main() {
  test('recordAnswer updates daily and totals', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repo = StatsRepositoryPrefs(prefs: prefs);

    final date = DateTime(2024, 1, 2);
    await repo.recordAnswer(
      date: date,
      category: Category.pseudocodeExecution,
      mode: PracticeMode.infinite,
      correct: true,
    );
    await repo.recordAnswer(
      date: date,
      category: Category.binaryToDecimal,
      mode: PracticeMode.timeAttack10,
      correct: false,
    );

    final summary = await repo.loadSummary(now: date);
    expect(summary.todayAnswered, 2);
    expect(summary.todayCorrect, 1);
    expect(summary.totalsAnswered, 2);
    expect(summary.totalsCorrect, 1);

    final daily = await repo.loadDailyStats(date: date);
    expect(daily?.answered, 2);
    expect(daily?.correct, 1);
    expect(daily?.categoryCounts[Category.pseudocodeExecution], 1);
    expect(daily?.categoryCounts[Category.binaryToDecimal], 1);
    expect(daily?.modeCounts[PracticeMode.infinite], 1);
    expect(daily?.modeCounts[PracticeMode.timeAttack10], 1);
  });

  test('loadMonthlyStats returns only studied days', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repo = StatsRepositoryPrefs(prefs: prefs);

    await repo.recordAnswer(
      date: DateTime(2024, 2, 2),
      category: Category.decimalToBinary,
      mode: PracticeMode.infinite,
      correct: true,
    );
    await repo.recordAnswer(
      date: DateTime(2024, 2, 5),
      category: Category.controlFlowTrace,
      mode: PracticeMode.timeAttack10,
      correct: true,
    );

    final monthStats = await repo.loadMonthlyStats(
      month: DateTime(2024, 2, 1),
    );
    expect(monthStats.length, 2);
    expect(monthStats.containsKey(DateTime(2024, 2, 2)), true);
    expect(monthStats.containsKey(DateTime(2024, 2, 5)), true);
  });

  test('recordBest updates min or max depending on mode', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repo = StatsRepositoryPrefs(prefs: prefs);

    await repo.recordBest(
      category: Category.pseudocodeExecution,
      mode: PracticeMode.timeAttack10,
      difficulty: Difficulty.easy,
      correctCount: 0,
      maxStreak: 0,
      timeMillis: 30000,
    );
    await repo.recordBest(
      category: Category.pseudocodeExecution,
      mode: PracticeMode.timeAttack10,
      difficulty: Difficulty.easy,
      correctCount: 0,
      maxStreak: 0,
      timeMillis: 25000,
    );

    final timeBest = await repo.loadBest(
      category: Category.pseudocodeExecution,
      mode: PracticeMode.timeAttack10,
      difficulty: Difficulty.easy,
    );
    expect(timeBest?.bestTimeMillis, 25000);

    await repo.recordBest(
      category: Category.controlFlowTrace,
      mode: PracticeMode.infinite,
      difficulty: Difficulty.normal,
      correctCount: 10,
      maxStreak: 4,
      timeMillis: null,
    );
    await repo.recordBest(
      category: Category.controlFlowTrace,
      mode: PracticeMode.infinite,
      difficulty: Difficulty.normal,
      correctCount: 12,
      maxStreak: 3,
      timeMillis: null,
    );

    final infiniteBest = await repo.loadBest(
      category: Category.controlFlowTrace,
      mode: PracticeMode.infinite,
      difficulty: Difficulty.normal,
    );
    expect(infiniteBest?.bestCorrectCount, 12);
    expect(infiniteBest?.bestMaxStreak, 3);
  });
}
