import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_example_app/features/practice/domain/enums.dart';
import 'package:flutter_example_app/features/practice/domain/generators/info_problem_generator.dart';

void main() {
  test('generator returns matching category and difficulty', () {
    final generator = FixedInfoProblemGenerator(random: Random(0));
    final problem = generator.generate(
      category: Category.pseudocodeExecution,
      difficulty: Difficulty.easy,
    );
    expect(problem.category, Category.pseudocodeExecution);
    expect(problem.difficulty, Difficulty.easy);
    expect(problem.questionText, isNotEmpty);
    expect(problem.answer, isNotEmpty);
  });

  test('generator returns a problem for binary category', () {
    final generator = FixedInfoProblemGenerator(random: Random(1));
    final problem = generator.generate(
      category: Category.binaryMixed,
      difficulty: Difficulty.hard,
    );
    expect(problem.category, Category.binaryMixed);
    expect(problem.answerFormat, isNotNull);
  });
}
