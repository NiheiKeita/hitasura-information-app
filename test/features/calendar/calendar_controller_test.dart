import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_example_app/core/clock/clock.dart';
import 'package:flutter_example_app/core/storage/stats_repository.dart';
import 'package:flutter_example_app/features/calendar/controller/calendar_controller.dart';
import 'package:flutter_example_app/features/practice/domain/enums.dart';

class FakeClock implements Clock {
  FakeClock(this._now);
  final DateTime _now;

  @override
  DateTime now() => _now;
}

class FakeStatsRepository implements StatsRepository {
  DateTime? lastMonth;

  @override
  Future<void> recordAnswer({
    required DateTime date,
    required Category category,
    required PracticeMode mode,
    required bool correct,
  }) async {}

  @override
  Future<void> recordBest({
    required Category category,
    required PracticeMode mode,
    required Difficulty difficulty,
    required int correctCount,
    required int maxStreak,
    required int? timeMillis,
  }) async {}

  @override
  Future<StatsSummary> loadSummary({required DateTime now}) async {
    return const StatsSummary(
      todayAnswered: 0,
      todayCorrect: 0,
      last7DaysAnswered: 0,
      totalsAnswered: 0,
      totalsCorrect: 0,
      bestRecords: [],
    );
  }

  @override
  Future<DailyStats?> loadDailyStats({required DateTime date}) async {
    return null;
  }

  @override
  Future<Map<DateTime, DailyStats>> loadDailyStatsRange({
    required DateTime start,
    required DateTime end,
  }) async {
    return {};
  }

  @override
  Future<Map<DateTime, DailyStats>> loadMonthlyStats({
    required DateTime month,
  }) async {
    lastMonth = month;
    return {
      DateTime(month.year, month.month, 1): DailyStats(
        answered: 3,
        correct: 2,
        categoryCounts: {
          for (final category in Category.values) category: 0,
        },
        modeCounts: {
          for (final mode in PracticeMode.values) mode: 0,
        },
      ),
    };
  }

  @override
  Future<BestRecord?> loadBest({
    required Category category,
    required PracticeMode mode,
    required Difficulty difficulty,
  }) async {
    return null;
  }
}

void main() {
  test('CalendarController loads current month and navigates', () async {
    final repo = FakeStatsRepository();
    final controller = CalendarController(
      statsRepository: repo,
      clock: FakeClock(DateTime(2024, 5, 20)),
    );

    await controller.start();
    expect(controller.focusedMonth, DateTime(2024, 5, 1));
    expect(controller.monthlyStats.isNotEmpty, true);
    expect(repo.lastMonth, DateTime(2024, 5, 1));

    await controller.goToNextMonth();
    expect(controller.focusedMonth, DateTime(2024, 6, 1));
    expect(repo.lastMonth, DateTime(2024, 6, 1));
  });
}
