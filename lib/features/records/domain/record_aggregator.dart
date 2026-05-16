import 'practice_record.dart';

DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

DateTime startOfWeek(DateTime now) {
  final today = _dateOnly(now);
  final weekday = today.weekday;
  return today.subtract(Duration(days: weekday - DateTime.monday));
}

class RecordAggregator {
  const RecordAggregator._();

  static List<PracticeRecord> filterToday(
    List<PracticeRecord> records,
    DateTime now,
  ) {
    final today = _dateOnly(now);
    final tomorrow = today.add(const Duration(days: 1));
    return records
        .where(
          (r) =>
              !r.playedAt.isBefore(today) && r.playedAt.isBefore(tomorrow),
        )
        .toList();
  }

  static List<PracticeRecord> filterThisWeek(
    List<PracticeRecord> records,
    DateTime now,
  ) {
    final start = startOfWeek(now);
    final end = start.add(const Duration(days: 7));
    return records
        .where(
          (r) => !r.playedAt.isBefore(start) && r.playedAt.isBefore(end),
        )
        .toList();
  }

  static int? bestTimeMillis(List<PracticeRecord> records) {
    if (records.isEmpty) return null;
    return records
        .map((r) => r.clearTimeMillis)
        .reduce((a, b) => a < b ? a : b);
  }

  static int? bestToday(List<PracticeRecord> records, DateTime now) {
    return bestTimeMillis(filterToday(records, now));
  }

  static int? bestThisWeek(List<PracticeRecord> records, DateTime now) {
    return bestTimeMillis(filterThisWeek(records, now));
  }

  static int? bestAllTime(List<PracticeRecord> records) {
    return bestTimeMillis(records);
  }
}
