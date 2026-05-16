import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../practice/domain/enums.dart';
import '../domain/practice_record.dart';
import 'record_repository.dart';

class RecordRepositoryPrefs implements RecordRepository {
  RecordRepositoryPrefs({
    required SharedPreferences prefs,
    int maxPerKey = 100,
  })  : _prefs = prefs,
        _maxPerKey = maxPerKey;

  static const String _keyPrefix = 'practice_records:';

  final SharedPreferences _prefs;
  final int _maxPerKey;

  String _keyFor(Category category, PracticeMode mode) =>
      '$_keyPrefix${category.name}:${mode.name}';

  @override
  Future<List<PracticeRecord>> loadRecords({
    required Category category,
    required PracticeMode mode,
  }) async {
    return _readKey(_keyFor(category, mode));
  }

  @override
  Future<List<PracticeRecord>> loadAllRecordsForMode({
    required PracticeMode mode,
  }) async {
    final result = <PracticeRecord>[];
    for (final category in Category.values) {
      result.addAll(await loadRecords(category: category, mode: mode));
    }
    result.sort((a, b) => b.playedAt.compareTo(a.playedAt));
    return result;
  }

  @override
  Future<void> addRecord(PracticeRecord record) async {
    if (record.clearTimeMillis <= 0) return;
    try {
      final existing = await loadRecords(
        category: record.category,
        mode: record.mode,
      );
      final next = [...existing, record]
        ..sort((a, b) => b.playedAt.compareTo(a.playedAt));
      final trimmed =
          next.length > _maxPerKey ? next.sublist(0, _maxPerKey) : next;
      final encoded = jsonEncode(
        trimmed.map((r) => r.toJson()).toList(growable: false),
      );
      await _prefs.setString(_keyFor(record.category, record.mode), encoded);
    } catch (_) {
      // best-effort persistence: never crash the result flow.
    }
  }

  @override
  Future<void> clear({
    required Category category,
    required PracticeMode mode,
  }) async {
    await _prefs.remove(_keyFor(category, mode));
  }

  Future<List<PracticeRecord>> _readKey(String key) async {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      final result = <PracticeRecord>[];
      for (final entry in decoded) {
        if (entry is! Map) continue;
        final json = entry.map(
          (key, value) => MapEntry(key.toString(), value),
        );
        final record = PracticeRecord.tryFromJson(json);
        if (record != null) result.add(record);
      }
      return result;
    } catch (_) {
      return const [];
    }
  }
}
