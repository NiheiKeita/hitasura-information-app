import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/storage/prefs_keys.dart';
import '../../practice/domain/enums.dart';
import '../domain/practice_record.dart';
import 'record_repository.dart';

class RecordRepositoryPrefs implements RecordRepository {
  RecordRepositoryPrefs({required SharedPreferences prefs, int maxPerKey = 100})
    : _prefs = prefs,
      _maxPerKey = maxPerKey;

  static const String _keyPrefix = 'practice_records:';

  final SharedPreferences _prefs;
  final int _maxPerKey;

  String _keyFor(Category category, PracticeMode mode, Difficulty difficulty) =>
      '$_keyPrefix${category.name}:${mode.name}:${difficulty.name}';

  String _legacyKeyFor(Category category, PracticeMode mode) =>
      '$_keyPrefix${category.name}:${mode.name}';

  @override
  Future<List<PracticeRecord>> loadRecords({
    required Category category,
    required PracticeMode mode,
    required Difficulty difficulty,
  }) async {
    final key = _keyFor(category, mode, difficulty);
    final records = await _readKey(key);
    if (records.isNotEmpty) {
      return records;
    }
    final migrated = await _migrateLegacyRecords(
      category: category,
      mode: mode,
      difficulty: difficulty,
    );
    if (migrated.isNotEmpty) {
      return migrated;
    }
    return _migrateBestRecord(
      category: category,
      mode: mode,
      difficulty: difficulty,
    );
  }

  @override
  Future<List<PracticeRecord>> loadAllRecordsForMode({
    required PracticeMode mode,
  }) async {
    final result = <PracticeRecord>[];
    for (final category in Category.values) {
      for (final difficulty in Difficulty.values) {
        result.addAll(
          await loadRecords(
            category: category,
            mode: mode,
            difficulty: difficulty,
          ),
        );
      }
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
        difficulty: record.difficulty,
      );
      final next = [...existing, record]
        ..sort((a, b) => b.playedAt.compareTo(a.playedAt));
      final trimmed = next.length > _maxPerKey
          ? next.sublist(0, _maxPerKey)
          : next;
      final encoded = jsonEncode(
        trimmed.map((r) => r.toJson()).toList(growable: false),
      );
      await _prefs.setString(
        _keyFor(record.category, record.mode, record.difficulty),
        encoded,
      );
    } catch (_) {
      // best-effort persistence: never crash the result flow.
    }
  }

  @override
  Future<void> clear({
    required Category category,
    required PracticeMode mode,
  }) async {
    for (final difficulty in Difficulty.values) {
      await _prefs.remove(_keyFor(category, mode, difficulty));
    }
    await _prefs.remove(_legacyKeyFor(category, mode));
  }

  Future<List<PracticeRecord>> _migrateLegacyRecords({
    required Category category,
    required PracticeMode mode,
    required Difficulty difficulty,
  }) async {
    if (difficulty != Difficulty.normal) return const [];
    final legacy = await _readKey(_legacyKeyFor(category, mode));
    if (legacy.isEmpty) return const [];
    final migrated = legacy
        .map(
          (record) => PracticeRecord(
            id: record.id,
            category: record.category,
            mode: record.mode,
            difficulty: difficulty,
            clearTimeMillis: record.clearTimeMillis,
            playedAt: record.playedAt,
          ),
        )
        .toList();
    await _writeRecords(_keyFor(category, mode, difficulty), migrated);
    return migrated;
  }

  Future<List<PracticeRecord>> _migrateBestRecord({
    required Category category,
    required PracticeMode mode,
    required Difficulty difficulty,
  }) async {
    if (mode != PracticeMode.timeAttack10) return const [];
    final best = _parseBest(
      _prefs.getString(
        PrefsKeys.best(category.name, mode.name, difficulty.name),
      ),
    );
    if (best == null || best <= 0) return const [];
    final now = DateTime.now();
    final record = PracticeRecord(
      id: 'best-${category.name}-${mode.name}-${difficulty.name}',
      category: category,
      mode: mode,
      difficulty: difficulty,
      clearTimeMillis: best,
      playedAt: now,
    );
    await _writeRecords(_keyFor(category, mode, difficulty), [record]);
    return [record];
  }

  Future<void> _writeRecords(String key, List<PracticeRecord> records) async {
    final next = [...records]..sort((a, b) => b.playedAt.compareTo(a.playedAt));
    final trimmed = next.length > _maxPerKey
        ? next.sublist(0, _maxPerKey)
        : next;
    final encoded = jsonEncode(
      trimmed.map((r) => r.toJson()).toList(growable: false),
    );
    await _prefs.setString(key, encoded);
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
        final json = entry.map((key, value) => MapEntry(key.toString(), value));
        final record = PracticeRecord.tryFromJson(json);
        if (record != null) result.add(record);
      }
      return result;
    } catch (_) {
      return const [];
    }
  }

  int? _parseBest(String? value) {
    if (value == null || value.isEmpty) return null;
    final parts = value.split('|');
    if (parts.length != 3) return null;
    return int.tryParse(parts[0]);
  }
}
