import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_example_app/core/storage/prefs_keys.dart';
import 'package:flutter_example_app/features/practice/domain/enums.dart';
import 'package:flutter_example_app/features/records/data/record_repository_prefs.dart';
import 'package:flutter_example_app/features/records/domain/practice_record.dart';

void main() {
  test('stores time attack records separately by difficulty', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repo = RecordRepositoryPrefs(prefs: prefs);

    await repo.addRecord(
      PracticeRecord(
        id: 'easy',
        category: Category.binaryToDecimal,
        mode: PracticeMode.timeAttack10,
        difficulty: Difficulty.easy,
        clearTimeMillis: 12000,
        playedAt: DateTime(2024, 1, 2, 12),
      ),
    );
    await repo.addRecord(
      PracticeRecord(
        id: 'hard',
        category: Category.binaryToDecimal,
        mode: PracticeMode.timeAttack10,
        difficulty: Difficulty.hard,
        clearTimeMillis: 9000,
        playedAt: DateTime(2024, 1, 2, 13),
      ),
    );

    final easy = await repo.loadRecords(
      category: Category.binaryToDecimal,
      mode: PracticeMode.timeAttack10,
      difficulty: Difficulty.easy,
    );
    final hard = await repo.loadRecords(
      category: Category.binaryToDecimal,
      mode: PracticeMode.timeAttack10,
      difficulty: Difficulty.hard,
    );

    expect(easy.map((r) => r.id), ['easy']);
    expect(hard.map((r) => r.id), ['hard']);
  });

  test('keeps only the newest records up to maxPerKey', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repo = RecordRepositoryPrefs(prefs: prefs, maxPerKey: 2);

    for (var i = 0; i < 3; i++) {
      await repo.addRecord(
        PracticeRecord(
          id: '$i',
          category: Category.decimalToBinary,
          mode: PracticeMode.timeAttack10,
          difficulty: Difficulty.normal,
          clearTimeMillis: 10000 + i,
          playedAt: DateTime(2024, 1, 1 + i),
        ),
      );
    }

    final records = await repo.loadRecords(
      category: Category.decimalToBinary,
      mode: PracticeMode.timeAttack10,
      difficulty: Difficulty.normal,
    );

    expect(records.map((r) => r.id), ['2', '1']);
  });

  test('migrates an existing best time into a first history record', () async {
    SharedPreferences.setMockInitialValues({
      PrefsKeys.best(
        Category.controlFlowTrace.name,
        PracticeMode.timeAttack10.name,
        Difficulty.hard.name,
      ): '8500||',
    });
    final prefs = await SharedPreferences.getInstance();
    final repo = RecordRepositoryPrefs(prefs: prefs);

    final records = await repo.loadRecords(
      category: Category.controlFlowTrace,
      mode: PracticeMode.timeAttack10,
      difficulty: Difficulty.hard,
    );

    expect(records, hasLength(1));
    expect(records.single.clearTimeMillis, 8500);
    expect(records.single.category, Category.controlFlowTrace);
    expect(records.single.difficulty, Difficulty.hard);
  });
}
