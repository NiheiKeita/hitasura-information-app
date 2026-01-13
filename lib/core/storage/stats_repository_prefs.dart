import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/practice/domain/enums.dart';
import 'prefs_keys.dart';
import 'stats_repository.dart';

class StatsRepositoryPrefs implements StatsRepository {
  StatsRepositoryPrefs({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  @override
  Future<void> recordAnswer({
    required DateTime date,
    required Category category,
    required PracticeMode mode,
    required bool correct,
  }) async {
    final dateKey = _formatDateKey(date);
    final statsKey = PrefsKeys.dailyStats(dateKey);
    final existing = _parseDailyStats(_prefs.getString(statsKey));

    final updatedCategoryCounts =
        Map<Category, int>.from(existing.categoryCounts);
    final updatedModeCounts =
        Map<PracticeMode, int>.from(existing.modeCounts);
    if (correct) {
      updatedCategoryCounts[category] =
          (updatedCategoryCounts[category] ?? 0) + 1;
      updatedModeCounts[mode] = (updatedModeCounts[mode] ?? 0) + 1;
    }

    final updated = existing.copyWith(
      answered: existing.answered + 1,
      correct: existing.correct + (correct ? 1 : 0),
      categoryCounts: updatedCategoryCounts,
      modeCounts: updatedModeCounts,
    );

    await _prefs.setString(statsKey, _encodeDailyStats(updated));
    await _prefs.setInt(
      PrefsKeys.dailyCorrect(dateKey),
      updated.correct,
    );

    final totalsAnswered = (_prefs.getInt(PrefsKeys.totalsAnswered) ?? 0) + 1;
    await _prefs.setInt(PrefsKeys.totalsAnswered, totalsAnswered);
    if (correct) {
      final totalsCorrect = (_prefs.getInt(PrefsKeys.totalsCorrect) ?? 0) + 1;
      await _prefs.setInt(PrefsKeys.totalsCorrect, totalsCorrect);
    }
  }

  @override
  Future<void> recordBest({
    required Category category,
    required PracticeMode mode,
    required Difficulty difficulty,
    required int correctCount,
    required int maxStreak,
    required int? timeMillis,
  }) async {
    final key = PrefsKeys.best(category.name, mode.name, difficulty.name);
    final existing = _prefs.getString(key);
    final current = _parseBest(existing);

    BestRecord updated = current ?? const BestRecord();

    if (mode == PracticeMode.timeAttack10) {
      if (timeMillis == null) {
        return;
      }
      final currentBest = updated.bestTimeMillis;
      if (currentBest == null || timeMillis < currentBest) {
        updated = BestRecord(
          bestTimeMillis: timeMillis,
          bestCorrectCount: updated.bestCorrectCount,
          bestMaxStreak: updated.bestMaxStreak,
        );
      }
    } else {
      final currentBest = updated.bestCorrectCount;
      final currentStreak = updated.bestMaxStreak;
      if (currentBest == null || correctCount > currentBest) {
        updated = BestRecord(
          bestTimeMillis: updated.bestTimeMillis,
          bestCorrectCount: correctCount,
          bestMaxStreak: maxStreak,
        );
      } else if (correctCount == currentBest &&
          (currentStreak == null || maxStreak > currentStreak)) {
        updated = BestRecord(
          bestTimeMillis: updated.bestTimeMillis,
          bestCorrectCount: correctCount,
          bestMaxStreak: maxStreak,
        );
      }
    }

    final encoded = _encodeBest(updated);
    await _prefs.setString(key, encoded);
  }

  @override
  Future<BestRecord?> loadBest({
    required Category category,
    required PracticeMode mode,
    required Difficulty difficulty,
  }) async {
    final key = PrefsKeys.best(category.name, mode.name, difficulty.name);
    return _parseBest(_prefs.getString(key));
  }

  @override
  Future<StatsSummary> loadSummary({required DateTime now}) async {
    final todayKey = _formatDateKey(now);
    final todayStats = await loadDailyStats(date: now);
    final todayCorrect = todayStats?.correct ??
        (_prefs.getInt(PrefsKeys.dailyCorrect(todayKey)) ?? 0);
    final todayAnswered = todayStats?.answered ?? todayCorrect;

    var last7Days = 0;
    for (var i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final stats = await loadDailyStats(date: date);
      if (stats != null) {
        last7Days += stats.correct;
      } else {
        final key = _formatDateKey(date);
        last7Days += _prefs.getInt(PrefsKeys.dailyCorrect(key)) ?? 0;
      }
    }

    final totalsCorrect = _prefs.getInt(PrefsKeys.totalsCorrect) ?? 0;
    final totalsAnswered =
        _prefs.getInt(PrefsKeys.totalsAnswered) ?? totalsCorrect;

    final bestRecords = <BestRecordEntry>[];
    for (final category in Category.values) {
      for (final mode in PracticeMode.values) {
        for (final difficulty in Difficulty.values) {
          final record = await loadBest(
            category: category,
            mode: mode,
            difficulty: difficulty,
          );
          bestRecords.add(
            BestRecordEntry(
              category: category,
              mode: mode,
              difficulty: difficulty,
              record: record ?? const BestRecord(),
            ),
          );
        }
      }
    }

    return StatsSummary(
      todayAnswered: todayAnswered,
      todayCorrect: todayCorrect,
      last7DaysCorrect: last7Days,
      totalsAnswered: totalsAnswered,
      totalsCorrect: totalsCorrect,
      bestRecords: bestRecords,
    );
  }

  @override
  Future<DailyStats?> loadDailyStats({required DateTime date}) async {
    final dateKey = _formatDateKey(date);
    final statsKey = PrefsKeys.dailyStats(dateKey);
    final stats = _parseDailyStats(_prefs.getString(statsKey));
    if (stats.answered > 0 || stats.correct > 0) {
      return stats;
    }

    final legacyCorrect = _prefs.getInt(PrefsKeys.dailyCorrect(dateKey)) ?? 0;
    if (legacyCorrect == 0) {
      return null;
    }
    return _emptyDailyStats().copyWith(
      answered: legacyCorrect,
      correct: legacyCorrect,
    );
  }

  @override
  Future<Map<DateTime, DailyStats>> loadDailyStatsRange({
    required DateTime start,
    required DateTime end,
  }) async {
    final normalizedStart = DateTime(start.year, start.month, start.day);
    final normalizedEnd = DateTime(end.year, end.month, end.day);
    final days = normalizedEnd.difference(normalizedStart).inDays;
    if (days < 0) {
      return {};
    }

    final results = <DateTime, DailyStats>{};
    for (var i = 0; i <= days; i++) {
      final date = normalizedStart.add(Duration(days: i));
      final stats = await loadDailyStats(date: date);
      if (stats != null && stats.answered > 0) {
        results[date] = stats;
      }
    }
    return results;
  }

  @override
  Future<Map<DateTime, DailyStats>> loadMonthlyStats({
    required DateTime month,
  }) async {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    return loadDailyStatsRange(start: firstDay, end: lastDay);
  }

  String _formatDateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  DailyStats _parseDailyStats(String? value) {
    if (value == null || value.isEmpty) {
      return _emptyDailyStats();
    }
    final decoded = _safeJsonDecode(value);
    if (decoded is! Map<String, dynamic>) {
      return _emptyDailyStats();
    }

    final answered = _parseInt(decoded['answered']);
    final correct = _parseInt(decoded['correct']);
    final categoryMap = _parseCountMap(decoded['category']);
    final modeMap = _parseCountMap(decoded['mode']);

    return DailyStats(
      answered: answered,
      correct: correct,
      categoryCounts: _categoryCountsFrom(categoryMap),
      modeCounts: _modeCountsFrom(modeMap),
    );
  }

  dynamic _safeJsonDecode(String value) {
    try {
      return jsonDecode(value);
    } catch (_) {
      return null;
    }
  }

  String _encodeDailyStats(DailyStats stats) {
    final payload = {
      'answered': stats.answered,
      'correct': stats.correct,
      'category': {
        for (final entry in stats.categoryCounts.entries)
          entry.key.name: entry.value,
      },
      'mode': {
        for (final entry in stats.modeCounts.entries)
          entry.key.name: entry.value,
      },
    };
    return jsonEncode(payload);
  }

  DailyStats _emptyDailyStats() {
    return DailyStats(
      answered: 0,
      correct: 0,
      categoryCounts: {
        for (final category in Category.values) category: 0,
      },
      modeCounts: {
        for (final mode in PracticeMode.values) mode: 0,
      },
    );
  }

  int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  Map<String, int> _parseCountMap(dynamic value) {
    if (value is! Map) {
      return const {};
    }
    final result = <String, int>{};
    value.forEach((key, count) {
      if (key is String) {
        result[key] = _parseInt(count);
      }
    });
    return result;
  }

  Map<Category, int> _categoryCountsFrom(Map<String, int> raw) {
    return {
      for (final category in Category.values)
        category: raw[category.name] ?? 0,
    };
  }

  Map<PracticeMode, int> _modeCountsFrom(Map<String, int> raw) {
    return {
      for (final mode in PracticeMode.values) mode: raw[mode.name] ?? 0,
    };
  }

  BestRecord? _parseBest(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final parts = value.split('|');
    if (parts.length != 3) {
      return null;
    }
    return BestRecord(
      bestTimeMillis: _parseIntOrNull(parts[0]),
      bestCorrectCount: _parseIntOrNull(parts[1]),
      bestMaxStreak: _parseIntOrNull(parts[2]),
    );
  }

  String _encodeBest(BestRecord record) {
    final time = record.bestTimeMillis?.toString() ?? '';
    final correct = record.bestCorrectCount?.toString() ?? '';
    final streak = record.bestMaxStreak?.toString() ?? '';
    return '$time|$correct|$streak';
  }

  int? _parseIntOrNull(String value) {
    if (value.isEmpty) {
      return null;
    }
    return int.tryParse(value);
  }
}
