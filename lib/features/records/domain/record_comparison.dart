import '../../practice/domain/enums.dart';
import 'practice_record.dart';
import 'record_aggregator.dart';

class RecordComparison {
  const RecordComparison({
    required this.mode,
    required this.currentTimeMillis,
    required this.previousTodayBestMillis,
    required this.previousWeekBestMillis,
    required this.previousAllTimeBestMillis,
  });

  final PracticeMode mode;
  final int currentTimeMillis;
  final int? previousTodayBestMillis;
  final int? previousWeekBestMillis;
  final int? previousAllTimeBestMillis;

  bool get isAllTimeBest =>
      previousAllTimeBestMillis == null ||
      currentTimeMillis < previousAllTimeBestMillis!;

  bool get isTodayBest =>
      previousTodayBestMillis == null ||
      currentTimeMillis < previousTodayBestMillis!;

  bool get isWeekBest =>
      previousWeekBestMillis == null ||
      currentTimeMillis < previousWeekBestMillis!;

  int get displayedAllTimeBestMillis =>
      isAllTimeBest ? currentTimeMillis : previousAllTimeBestMillis!;

  int get displayedTodayBestMillis =>
      isTodayBest ? currentTimeMillis : previousTodayBestMillis!;

  int get displayedWeekBestMillis =>
      isWeekBest ? currentTimeMillis : previousWeekBestMillis!;

  int? get gapToAllTimeBestMillis {
    if (isAllTimeBest) return null;
    return currentTimeMillis - previousAllTimeBestMillis!;
  }

  int? get gapToTodayBestMillis {
    if (isTodayBest) return null;
    return currentTimeMillis - previousTodayBestMillis!;
  }

  static RecordComparison build({
    required PracticeMode mode,
    required int currentTimeMillis,
    required List<PracticeRecord> previousRecords,
    required DateTime now,
  }) {
    return RecordComparison(
      mode: mode,
      currentTimeMillis: currentTimeMillis,
      previousTodayBestMillis:
          RecordAggregator.bestToday(previousRecords, now),
      previousWeekBestMillis:
          RecordAggregator.bestThisWeek(previousRecords, now),
      previousAllTimeBestMillis: RecordAggregator.bestAllTime(previousRecords),
    );
  }
}
