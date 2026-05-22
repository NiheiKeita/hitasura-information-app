import '../../practice/domain/enums.dart';
import '../domain/practice_record.dart';

abstract class RecordRepository {
  Future<List<PracticeRecord>> loadRecords({
    required Category category,
    required PracticeMode mode,
    required Difficulty difficulty,
  });

  Future<List<PracticeRecord>> loadAllRecordsForMode({
    required PracticeMode mode,
  });

  Future<void> addRecord(PracticeRecord record);

  Future<void> clear({required Category category, required PracticeMode mode});
}
