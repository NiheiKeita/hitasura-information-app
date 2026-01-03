import 'dart:math';

import '../enums.dart';
import '../problem.dart';
import 'problem_generator.dart';

class FixedInfoProblemGenerator implements InfoProblemGenerator {
  FixedInfoProblemGenerator({Random? random})
      : _random = random ?? Random();

  final Random _random;

  @override
  InfoProblem generate({
    required Category category,
    required Difficulty difficulty,
  }) {
    final candidates = _problems.where((problem) {
      final matchesCategory = category == Category.binaryMixed
          ? problem.category == Category.binaryToDecimal ||
              problem.category == Category.decimalToBinary
          : problem.category == category;
      return matchesCategory && problem.difficulty == difficulty;
    }).toList();
    if (candidates.isEmpty) {
      final fallback = _problems.where((problem) {
        if (category == Category.binaryMixed) {
          return problem.category == Category.binaryToDecimal ||
              problem.category == Category.decimalToBinary;
        }
        return problem.category == category;
      }).toList();
      return _decorateForMixed(category, fallback[_random.nextInt(fallback.length)]);
    }
    return _decorateForMixed(category, candidates[_random.nextInt(candidates.length)]);
  }
}

InfoProblem _decorateForMixed(Category category, InfoProblem base) {
  if (category != Category.binaryMixed) {
    return base;
  }
  final header = base.category == Category.decimalToBinary
      ? '10進数→2進数'
      : '2進数→10進数';
  return InfoProblem(
    category: Category.binaryMixed,
    difficulty: base.difficulty,
    question: '$header\n${base.question}',
    answer: base.answer,
    answerFormat: base.answerFormat,
    answerHint: base.answerHint,
  );
}

const _problems = <InfoProblem>[
  // 1. 疑似コードの実行結果
  InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.easy,
    question: 'x = 3\ny = 2\nx = x + y\ny = x - 1\n出力: y',
    answer: '4',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.easy,
    question: 'a = 5\nb = 1\nb = b + a\na = a - 2\n出力: a + b',
    answer: '9',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.easy,
    question: '配列Aは0番目から\nA = [2, 4, 6]\nA[1] = A[1] + A[0]\n出力: A[1]',
    answer: '6',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.normal,
    question: 'sum = 0\nfor i = 1 to 4\n  sum = sum + i\n出力: sum',
    answer: '10',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.normal,
    question: 'x = 7\nif x % 2 == 0 then\n  x = x + 3\nelse\n  x = x - 2\n出力: x',
    answer: '5',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.normal,
    question:
        'n = 10\ncount = 0\nwhile n > 1\n  n = n / 2 (切り捨て)\n  count = count + 1\n出力: count',
    answer: '3',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.hard,
    question:
        'x = 0\nfor i = 1 to 3\n  for j = 1 to 2\n    x = x + i * j\n出力: x',
    answer: '39',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.hard,
    question:
        '配列Aは0番目から\nA = [3, 1, 4, 1]\ntmp = A[0]\nA[0] = A[2]\nA[2] = tmp\n出力: A[0] + A[2]',
    answer: '7',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.hard,
    question:
        'x = 0\nfor i = 1 to 5\n  if i % 2 == 1 then\n    x = x + i\n  else\n    x = x - 1\n出力: x',
    answer: '7',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.normal,
    question:
        'a = 2\nb = 3\nfor i = 1 to 2\n  a = a * b\n  b = b - 1\n出力: a',
    answer: '12',
    answerFormat: AnswerFormat.decimal,
  ),

  // 2. if / for / while の処理追跡
  InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.easy,
    question: 'x = 0\nwhile x < 5\n  x = x + 2\n繰り返し回数',
    answer: '3',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.easy,
    question: 'for i = 1 to 6\n  x = i\n繰り返し回数',
    answer: '6',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.easy,
    question: 'x = 4\nif x > 2 then\n  x = x * 2\nelse\n  x = x + 5\n出力: x',
    answer: '8',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.normal,
    question:
        'x = 1\nfor i = 1 to 3\n  if i == 2 then\n    x = x + 4\n  else\n    x = x + 1\n出力: x',
    answer: '7',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.normal,
    question:
        'count = 0\nfor i = 1 to 5\n  if i % 2 == 0 then\n    count = count + 1\n繰り返し後のcount',
    answer: '2',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.normal,
    question:
        'x = 12\nwhile x > 1\n  if x % 3 == 0 then\n    x = x / 3\n  else\n    x = x - 1\n出力: x',
    answer: '1',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.hard,
    question:
        'x = 0\nfor i = 1 to 4\n  for j = 1 to i\n    x = x + 1\n繰り返し回数(内側の合計)',
    answer: '10',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.hard,
    question:
        'x = 2\nwhile x < 20\n  if x % 4 == 0 then\n    x = x + 6\n  else\n    x = x + 3\n出力: x',
    answer: '20',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.hard,
    question:
        'sum = 0\nfor i = 1 to 5\n  if i <= 3 then\n    sum = sum + i\n  else\n    sum = sum + 2 * i\n出力: sum',
    answer: '22',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.normal,
    question:
        'x = 0\nfor i = 1 to 4\n  if i % 2 == 0 then\n    x = x + i\n出力: x',
    answer: '6',
    answerFormat: AnswerFormat.decimal,
  ),

  // 3. 2進数 -> 10進数
  InfoProblem(
    category: Category.binaryToDecimal,
    difficulty: Difficulty.easy,
    question: '1011',
    answer: '11',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.binaryToDecimal,
    difficulty: Difficulty.easy,
    question: '1101',
    answer: '13',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.binaryToDecimal,
    difficulty: Difficulty.easy,
    question: '10010',
    answer: '18',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.binaryToDecimal,
    difficulty: Difficulty.normal,
    question: '10101',
    answer: '21',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.binaryToDecimal,
    difficulty: Difficulty.normal,
    question: '11100',
    answer: '28',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.binaryToDecimal,
    difficulty: Difficulty.normal,
    question: '100101',
    answer: '37',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.binaryToDecimal,
    difficulty: Difficulty.normal,
    question: '100000',
    answer: '32',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.binaryToDecimal,
    difficulty: Difficulty.hard,
    question: '111001',
    answer: '57',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.binaryToDecimal,
    difficulty: Difficulty.hard,
    question: '110111',
    answer: '55',
    answerFormat: AnswerFormat.decimal,
  ),
  InfoProblem(
    category: Category.binaryToDecimal,
    difficulty: Difficulty.hard,
    question: '1010101',
    answer: '85',
    answerFormat: AnswerFormat.decimal,
  ),

  // 4. 10進数 -> 2進数
  InfoProblem(
    category: Category.decimalToBinary,
    difficulty: Difficulty.easy,
    question: '13',
    answer: '1101',
    answerFormat: AnswerFormat.binary,
  ),
  InfoProblem(
    category: Category.decimalToBinary,
    difficulty: Difficulty.easy,
    question: '9',
    answer: '1001',
    answerFormat: AnswerFormat.binary,
  ),
  InfoProblem(
    category: Category.decimalToBinary,
    difficulty: Difficulty.easy,
    question: '6',
    answer: '110',
    answerFormat: AnswerFormat.binary,
  ),
  InfoProblem(
    category: Category.decimalToBinary,
    difficulty: Difficulty.normal,
    question: '18',
    answer: '10010',
    answerFormat: AnswerFormat.binary,
  ),
  InfoProblem(
    category: Category.decimalToBinary,
    difficulty: Difficulty.normal,
    question: '21',
    answer: '10101',
    answerFormat: AnswerFormat.binary,
  ),
  InfoProblem(
    category: Category.decimalToBinary,
    difficulty: Difficulty.normal,
    question: '28',
    answer: '11100',
    answerFormat: AnswerFormat.binary,
  ),
  InfoProblem(
    category: Category.decimalToBinary,
    difficulty: Difficulty.normal,
    question: '37',
    answer: '100101',
    answerFormat: AnswerFormat.binary,
  ),
  InfoProblem(
    category: Category.decimalToBinary,
    difficulty: Difficulty.hard,
    question: '57',
    answer: '111001',
    answerFormat: AnswerFormat.binary,
  ),
  InfoProblem(
    category: Category.decimalToBinary,
    difficulty: Difficulty.hard,
    question: '55',
    answer: '110111',
    answerFormat: AnswerFormat.binary,
  ),
  InfoProblem(
    category: Category.decimalToBinary,
    difficulty: Difficulty.hard,
    question: '85',
    answer: '1010101',
    answerFormat: AnswerFormat.binary,
  ),
];
