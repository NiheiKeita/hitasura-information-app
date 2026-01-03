import '../../features/practice/domain/enums.dart';

class StatsSummary {
  const StatsSummary({
    required this.todayAnswered,
    required this.todayCorrect,
    required this.last7DaysAnswered,
    required this.totalsAnswered,
    required this.totalsCorrect,
    required this.bestRecords,
  });

  final int todayAnswered;
  final int todayCorrect;
  final int last7DaysAnswered;
  final int totalsAnswered;
  final int totalsCorrect;
  final List<BestRecordEntry> bestRecords;
}

class BestRecordEntry {
  const BestRecordEntry({
    required this.category,
    required this.mode,
    required this.difficulty,
    required this.record,
  });

  final Category category;
  final PracticeMode mode;
  final Difficulty difficulty;
  final BestRecord record;
}

class BestRecord {
  const BestRecord({
    this.bestTimeMillis,
    this.bestCorrectCount,
    this.bestMaxStreak,
  });

  final int? bestTimeMillis;
  final int? bestCorrectCount;
  final int? bestMaxStreak;
}

class DailyStats {
  const DailyStats({
    required this.answered,
    required this.correct,
    required this.categoryCounts,
    required this.modeCounts,
  });

  final int answered;
  final int correct;
  final Map<Category, int> categoryCounts;
  final Map<PracticeMode, int> modeCounts;

  double get accuracy => answered == 0 ? 0 : correct / answered;

  DailyStats copyWith({
    int? answered,
    int? correct,
    Map<Category, int>? categoryCounts,
    Map<PracticeMode, int>? modeCounts,
  }) {
    return DailyStats(
      answered: answered ?? this.answered,
      correct: correct ?? this.correct,
      categoryCounts: categoryCounts ?? this.categoryCounts,
      modeCounts: modeCounts ?? this.modeCounts,
    );
  }
}

abstract class StatsRepository {
  Future<void> recordAnswer({
    required DateTime date,
    required Category category,
    required PracticeMode mode,
    required bool correct,
  });

  Future<void> recordBest({
    required Category category,
    required PracticeMode mode,
    required Difficulty difficulty,
    required int correctCount,
    required int maxStreak,
    required int? timeMillis,
  });

  Future<StatsSummary> loadSummary({required DateTime now});

  Future<DailyStats?> loadDailyStats({required DateTime date});

  Future<Map<DateTime, DailyStats>> loadDailyStatsRange({
    required DateTime start,
    required DateTime end,
  });

  Future<Map<DateTime, DailyStats>> loadMonthlyStats({
    required DateTime month,
  });

  Future<BestRecord?> loadBest({
    required Category category,
    required PracticeMode mode,
    required Difficulty difficulty,
  });
}
