import 'enums.dart';
import 'scoring.dart';

class FactorizationProblem {
  FactorizationProblem({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.difficulty,
  })  : A = expandFactors(a, b, c, d).A,
        B = expandFactors(a, b, c, d).B,
        C = expandFactors(a, b, c, d).C;

  final int a;
  final int b;
  final int c;
  final int d;
  final int A;
  final int B;
  final int C;
  final Difficulty difficulty;

  String get questionText => formatQuadratic(A, B, C);
}

class PrimeFactorizationProblem {
  PrimeFactorizationProblem({
    required this.n,
    required this.primes,
    required this.difficulty,
  });

  final int n;
  final List<int> primes;
  final Difficulty difficulty;

  String get questionText => n.toString();
}

class PracticeResult {
  const PracticeResult({
    required this.category,
    required this.mode,
    required this.difficulty,
    required this.answeredCount,
    required this.correctCount,
    required this.maxStreak,
    required this.elapsedMillis,
  });

  final Category category;
  final PracticeMode mode;
  final Difficulty difficulty;
  final int answeredCount;
  final int correctCount;
  final int maxStreak;
  final int elapsedMillis;

  int get missCount => answeredCount - correctCount;

  double get accuracy =>
      answeredCount == 0 ? 0 : correctCount / answeredCount;
}
