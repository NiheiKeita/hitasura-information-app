import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_example_app/core/storage/stats_repository.dart';
import 'package:flutter_example_app/features/practice/domain/enums.dart';
import 'package:flutter_example_app/features/stats/presentation/stats_presentation.dart';
import 'package:flutter_example_app/widgets/wavy_background.dart';

void main() {
  testWidgets('StatsPresentation shows summary values', (tester) async {
    final summary = StatsSummary(
      todayAnswered: 0,
      todayCorrect: 5,
      last7DaysCorrect: 42,
      totalsAnswered: 0,
      totalsCorrect: 123,
      bestRecords: [
        BestRecordEntry(
          category: Category.pseudocodeExecution,
          mode: PracticeMode.infinite,
          difficulty: Difficulty.easy,
          record: const BestRecord(bestCorrectCount: 12, bestMaxStreak: 7),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: StatsPresentation(
          summary: summary,
          heatmapStats: const {},
          heatmapEndDate: DateTime(2024, 1, 1),
          onOpenCalendar: () {},
        ),
      ),
    );

    expect(find.byType(WavyBackground), findsOneWidget);

    expect(find.text('今日の正解数'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('7日間の正解数'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
    expect(find.text('総正解数'), findsOneWidget);
    expect(find.text('123'), findsOneWidget);
  });
}
