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
    final candidates = _templates.where((template) {
      final matchesCategory = category == Category.binaryMixed
          ? template.category == Category.binaryToDecimal ||
              template.category == Category.decimalToBinary
          : template.category == category;
      return matchesCategory && template.difficulty == difficulty;
    }).toList();

    final pool = candidates.isEmpty
        ? _templates.where((template) {
            if (category == Category.binaryMixed) {
              return template.category == Category.binaryToDecimal ||
                  template.category == Category.decimalToBinary;
            }
            return template.category == category;
          }).toList()
        : candidates;

    final selected = pool[_random.nextInt(pool.length)].build(_random);
    return _decorateForMixed(category, selected);
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

int _randIn(Random random, int min, int max) {
  return min + random.nextInt(max - min + 1);
}

InfoProblem _pseudocodeEasyAdd(Random random) {
  final x = _randIn(random, 1, 8);
  final y = _randIn(random, 1, 8);
  final result = x + y - 1;
  return InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.easy,
    question: 'x = $x\ny = $y\nx = x + y\ny = x - 1\n出力: y',
    answer: '$result',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _pseudocodeEasySum(Random random) {
  final a = _randIn(random, 3, 9);
  final b = _randIn(random, 1, 4);
  final result = (a - 2) + (b + a);
  return InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.easy,
    question: 'a = $a\nb = $b\nb = b + a\na = a - 2\n出力: a + b',
    answer: '$result',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _pseudocodeEasyArray(Random random) {
  final a0 = _randIn(random, 1, 8);
  final a1 = _randIn(random, 1, 8);
  final a2 = _randIn(random, 1, 8);
  final result = a0 + a1;
  return InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.easy,
    question:
        '配列Aは0番目から\nA = [$a0, $a1, $a2]\nA[1] = A[1] + A[0]\n出力: A[1]',
    answer: '$result',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _pseudocodeNormalSum(Random random) {
  final n = _randIn(random, 4, 7);
  final sum = n * (n + 1) ~/ 2;
  return InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.normal,
    question: 'sum = 0\nfor i = 1 to $n\n  sum = sum + i\n出力: sum',
    answer: '$sum',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _pseudocodeNormalIf(Random random) {
  final x = _randIn(random, 3, 12);
  final result = x % 2 == 0 ? x + 3 : x - 2;
  return InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.normal,
    question: 'x = $x\nif x % 2 == 0 then\n  x = x + 3\nelse\n  x = x - 2\n出力: x',
    answer: '$result',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _pseudocodeNormalWhile(Random random) {
  var n = _randIn(random, 6, 20);
  final startN = n;
  var count = 0;
  while (n > 1) {
    n ~/= 2;
    count += 1;
  }
  return InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.normal,
    question:
        'n = $startN\ncount = 0\nwhile n > 1\n  n = n / 2 (切り捨て)\n  count = count + 1\n出力: count',
    answer: '$count',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _pseudocodeNormalMultiply(Random random) {
  var a = _randIn(random, 2, 4);
  var b = _randIn(random, 3, 6);
  final startA = a;
  final startB = b;
  final loops = _randIn(random, 2, 3);
  for (var i = 0; i < loops; i++) {
    a = a * b;
    b -= 1;
  }
  return InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.normal,
    question:
        'a = $startA\nb = $startB\nfor i = 1 to $loops\n  a = a * b\n  b = b - 1\n出力: a',
    answer: '$a',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _pseudocodeHardNested(Random random) {
  final m = _randIn(random, 3, 4);
  final n = _randIn(random, 2, 3);
  var total = 0;
  for (var i = 1; i <= m; i++) {
    for (var j = 1; j <= n; j++) {
      total += i * j;
    }
  }
  return InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.hard,
    question:
        'x = 0\nfor i = 1 to $m\n  for j = 1 to $n\n    x = x + i * j\n出力: x',
    answer: '$total',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _pseudocodeHardSwap(Random random) {
  final a0 = _randIn(random, 1, 9);
  final a1 = _randIn(random, 1, 9);
  final a2 = _randIn(random, 1, 9);
  final a3 = _randIn(random, 1, 9);
  final result = a2 + a0;
  return InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.hard,
    question:
        '配列Aは0番目から\nA = [$a0, $a1, $a2, $a3]\ntmp = A[0]\nA[0] = A[2]\nA[2] = tmp\n出力: A[0] + A[2]',
    answer: '$result',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _pseudocodeHardOdd(Random random) {
  final n = _randIn(random, 5, 7);
  var x = 0;
  for (var i = 1; i <= n; i++) {
    if (i % 2 == 1) {
      x += i;
    } else {
      x -= 1;
    }
  }
  return InfoProblem(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.hard,
    question:
        'x = 0\nfor i = 1 to $n\n  if i % 2 == 1 then\n    x = x + i\n  else\n    x = x - 1\n出力: x',
    answer: '$x',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _flowEasyWhile(Random random) {
  final limit = _randIn(random, 5, 10);
  var x = 0;
  var count = 0;
  while (x < limit) {
    x += 2;
    count += 1;
  }
  return InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.easy,
    question: 'x = 0\nwhile x < $limit\n  x = x + 2\n繰り返し回数',
    answer: '$count',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _flowEasyFor(Random random) {
  final n = _randIn(random, 4, 8);
  return InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.easy,
    question: 'for i = 1 to $n\n  x = i\n繰り返し回数',
    answer: '$n',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _flowEasyIf(Random random) {
  final x = _randIn(random, 1, 9);
  final threshold = _randIn(random, 2, 6);
  final result = x > threshold ? x * 2 : x + 5;
  return InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.easy,
    question:
        'x = $x\nif x > $threshold then\n  x = x * 2\nelse\n  x = x + 5\n出力: x',
    answer: '$result',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _flowNormalBranch(Random random) {
  final n = _randIn(random, 3, 5);
  final k = _randIn(random, 2, n - 1);
  var x = 1;
  for (var i = 1; i <= n; i++) {
    if (i == k) {
      x += 4;
    } else {
      x += 1;
    }
  }
  return InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.normal,
    question:
        'x = 1\nfor i = 1 to $n\n  if i == $k then\n    x = x + 4\n  else\n    x = x + 1\n出力: x',
    answer: '$x',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _flowNormalEvenCount(Random random) {
  final n = _randIn(random, 5, 10);
  var count = 0;
  for (var i = 1; i <= n; i++) {
    if (i % 2 == 0) {
      count += 1;
    }
  }
  return InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.normal,
    question:
        'count = 0\nfor i = 1 to $n\n  if i % 2 == 0 then\n    count = count + 1\n繰り返し後のcount',
    answer: '$count',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _flowNormalReduce(Random random) {
  var x = _randIn(random, 8, 20);
  final startX = x;
  while (x > 1) {
    if (x % 3 == 0) {
      x ~/= 3;
    } else {
      x -= 1;
    }
  }
  return InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.normal,
    question:
        'x = $startX\nwhile x > 1\n  if x % 3 == 0 then\n    x = x / 3\n  else\n    x = x - 1\n出力: x',
    answer: '$x',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _flowNormalEvenSum(Random random) {
  final n = _randIn(random, 4, 8);
  var x = 0;
  for (var i = 1; i <= n; i++) {
    if (i % 2 == 0) {
      x += i;
    }
  }
  return InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.normal,
    question:
        'x = 0\nfor i = 1 to $n\n  if i % 2 == 0 then\n    x = x + i\n出力: x',
    answer: '$x',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _flowHardNested(Random random) {
  final n = _randIn(random, 4, 6);
  var count = 0;
  for (var i = 1; i <= n; i++) {
    for (var j = 1; j <= i; j++) {
      count += 1;
    }
  }
  return InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.hard,
    question:
        'x = 0\nfor i = 1 to $n\n  for j = 1 to i\n    x = x + 1\n繰り返し回数(内側の合計)',
    answer: '$count',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _flowHardWhile(Random random) {
  var x = _randIn(random, 2, 6);
  final startX = x;
  final limit = _randIn(random, 20, 26);
  while (x < limit) {
    if (x % 4 == 0) {
      x += 6;
    } else {
      x += 3;
    }
  }
  return InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.hard,
    question:
        'x = $startX\nwhile x < $limit\n  if x % 4 == 0 then\n    x = x + 6\n  else\n    x = x + 3\n出力: x',
    answer: '$x',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _flowHardSum(Random random) {
  final n = _randIn(random, 5, 7);
  final k = _randIn(random, 3, 4);
  var sum = 0;
  for (var i = 1; i <= n; i++) {
    if (i <= k) {
      sum += i;
    } else {
      sum += 2 * i;
    }
  }
  return InfoProblem(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.hard,
    question:
        'sum = 0\nfor i = 1 to $n\n  if i <= $k then\n    sum = sum + i\n  else\n    sum = sum + 2 * i\n出力: sum',
    answer: '$sum',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _binaryToDecimal(Random random, Difficulty difficulty) {
  final range = _binaryRangeFor(difficulty);
  final value = _randIn(random, range.$1, range.$2);
  final binary = value.toRadixString(2);
  return InfoProblem(
    category: Category.binaryToDecimal,
    difficulty: difficulty,
    question: binary,
    answer: '$value',
    answerFormat: AnswerFormat.decimal,
  );
}

InfoProblem _decimalToBinary(Random random, Difficulty difficulty) {
  final range = _binaryRangeFor(difficulty);
  final value = _randIn(random, range.$1, range.$2);
  final binary = value.toRadixString(2);
  return InfoProblem(
    category: Category.decimalToBinary,
    difficulty: difficulty,
    question: '$value',
    answer: binary,
    answerFormat: AnswerFormat.binary,
  );
}

(int, int) _binaryRangeFor(Difficulty difficulty) {
  switch (difficulty) {
    case Difficulty.easy:
      return (4, 15); // 3-4 bits
    case Difficulty.normal:
      return (16, 63); // 5-6 bits
    case Difficulty.hard:
      return (64, 255); // 7-8 bits
  }
}

class _Template {
  const _Template({
    required this.category,
    required this.difficulty,
    required this.build,
  });

  final Category category;
  final Difficulty difficulty;
  final InfoProblem Function(Random random) build;
}

final List<_Template> _templates = [
  _Template(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.easy,
    build: _pseudocodeEasyAdd,
  ),
  _Template(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.easy,
    build: _pseudocodeEasySum,
  ),
  _Template(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.easy,
    build: _pseudocodeEasyArray,
  ),
  _Template(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.normal,
    build: _pseudocodeNormalSum,
  ),
  _Template(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.normal,
    build: _pseudocodeNormalIf,
  ),
  _Template(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.normal,
    build: _pseudocodeNormalWhile,
  ),
  _Template(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.normal,
    build: _pseudocodeNormalMultiply,
  ),
  _Template(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.hard,
    build: _pseudocodeHardNested,
  ),
  _Template(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.hard,
    build: _pseudocodeHardSwap,
  ),
  _Template(
    category: Category.pseudocodeExecution,
    difficulty: Difficulty.hard,
    build: _pseudocodeHardOdd,
  ),
  _Template(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.easy,
    build: _flowEasyWhile,
  ),
  _Template(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.easy,
    build: _flowEasyFor,
  ),
  _Template(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.easy,
    build: _flowEasyIf,
  ),
  _Template(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.normal,
    build: _flowNormalBranch,
  ),
  _Template(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.normal,
    build: _flowNormalEvenCount,
  ),
  _Template(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.normal,
    build: _flowNormalReduce,
  ),
  _Template(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.normal,
    build: _flowNormalEvenSum,
  ),
  _Template(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.hard,
    build: _flowHardNested,
  ),
  _Template(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.hard,
    build: _flowHardWhile,
  ),
  _Template(
    category: Category.controlFlowTrace,
    difficulty: Difficulty.hard,
    build: _flowHardSum,
  ),
  _Template(
    category: Category.binaryToDecimal,
    difficulty: Difficulty.easy,
    build: (random) => _binaryToDecimal(random, Difficulty.easy),
  ),
  _Template(
    category: Category.binaryToDecimal,
    difficulty: Difficulty.normal,
    build: (random) => _binaryToDecimal(random, Difficulty.normal),
  ),
  _Template(
    category: Category.binaryToDecimal,
    difficulty: Difficulty.hard,
    build: (random) => _binaryToDecimal(random, Difficulty.hard),
  ),
  _Template(
    category: Category.decimalToBinary,
    difficulty: Difficulty.easy,
    build: (random) => _decimalToBinary(random, Difficulty.easy),
  ),
  _Template(
    category: Category.decimalToBinary,
    difficulty: Difficulty.normal,
    build: (random) => _decimalToBinary(random, Difficulty.normal),
  ),
  _Template(
    category: Category.decimalToBinary,
    difficulty: Difficulty.hard,
    build: (random) => _decimalToBinary(random, Difficulty.hard),
  ),
];
