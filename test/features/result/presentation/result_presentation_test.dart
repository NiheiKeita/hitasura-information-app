import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_example_app/features/practice/domain/enums.dart';
import 'package:flutter_example_app/features/practice/domain/problem.dart';
import 'package:flutter_example_app/features/result/presentation/result_presentation.dart';

void main() {
  testWidgets('ResultPresentation calls callbacks', (tester) async {
    var retried = false;
    var wentHome = false;
    final result = PracticeResult(
      category: Category.factorization,
      mode: PracticeMode.infinite,
      difficulty: Difficulty.easy,
      answeredCount: 10,
      correctCount: 8,
      maxStreak: 4,
      elapsedMillis: 30000,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ResultPresentation(
          result: result,
          onRetry: () => retried = true,
          onHome: () => wentHome = true,
        ),
      ),
    );

    await tester.tap(find.text('Homeへ'));
    await tester.pump();
    expect(wentHome, isTrue);

    await tester.tap(find.text('もう一回'));
    await tester.pump();
    expect(retried, isTrue);
  });
}
