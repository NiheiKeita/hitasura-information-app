import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_example_app/features/practice/domain/enums.dart';
import 'package:flutter_example_app/features/practice/domain/problem.dart';
import 'package:flutter_example_app/features/practice/domain/scoring.dart';

void main() {
  test('isCorrectInfoAnswer accepts decimal answers', () {
    const problem = InfoProblem(
      category: Category.pseudocodeExecution,
      difficulty: Difficulty.easy,
      question: 'x <- 1',
      answer: '12',
      answerFormat: AnswerFormat.decimal,
    );
    expect(
      isCorrectInfoAnswer(problem: problem, input: '12'),
      isTrue,
    );
    expect(
      isCorrectInfoAnswer(problem: problem, input: '012'),
      isTrue,
    );
    expect(
      isCorrectInfoAnswer(problem: problem, input: '13'),
      isFalse,
    );
  });

  test('isCorrectInfoAnswer accepts binary answers', () {
    const problem = InfoProblem(
      category: Category.binaryToDecimal,
      difficulty: Difficulty.normal,
      question: '10進数 5 を 2進数に変換',
      answer: '101',
      answerFormat: AnswerFormat.binary,
    );
    expect(
      isCorrectInfoAnswer(problem: problem, input: '101'),
      isTrue,
    );
    expect(
      isCorrectInfoAnswer(problem: problem, input: '0101'),
      isTrue,
    );
    expect(
      isCorrectInfoAnswer(problem: problem, input: '102'),
      isFalse,
    );
  });
}
