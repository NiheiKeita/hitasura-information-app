import 'dart:math';

import '../enums.dart';
import '../problem.dart';
import 'problem_generator.dart';

class RandomFactorizationGenerator implements FactorizationGenerator {
  RandomFactorizationGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;

  @override
  FactorizationProblem generate(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return _generateEasy();
      case Difficulty.normal:
        return _generateNormal();
      case Difficulty.hard:
        return _generateHard();
    }
  }

  FactorizationProblem _generateEasy() {
    final p = _randomInt(-9, 9);
    final q = _randomInt(-9, 9);
    return FactorizationProblem(
      a: 1,
      b: p,
      c: 1,
      d: q,
      difficulty: Difficulty.easy,
    );
  }

  FactorizationProblem _generateNormal() {
    final useTwo = _random.nextBool();
    if (useTwo) {
      final p = _randomInt(-12, 12);
      final q = _randomInt(-12, 12);
      return FactorizationProblem(
        a: 2,
        b: p,
        c: 1,
        d: q,
        difficulty: Difficulty.normal,
      );
    }
    final p = _randomInt(-15, 15);
    final q = _randomInt(-15, 15);
    return FactorizationProblem(
      a: 1,
      b: p,
      c: 1,
      d: q,
      difficulty: Difficulty.normal,
    );
  }

  FactorizationProblem _generateHard() {
    while (true) {
      final a = _randomInt(1, 6);
      final c = _randomInt(1, 6);
      final p = _randomInt(-30, 30);
      final q = _randomInt(-30, 30);
      final problem = FactorizationProblem(
        a: a,
        b: p,
        c: c,
        d: q,
        difficulty: Difficulty.hard,
      );
      if (problem.B.abs() > 200 || problem.C.abs() > 900) {
        continue;
      }
      return problem;
    }
  }

  int _randomInt(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }
}
