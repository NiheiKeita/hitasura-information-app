import 'enums.dart';

enum FactorField { a, b, c, d, signB, signD }

enum AnswerFeedback {
  correct,
  incorrect,
}

class FactorizationInputState {
  const FactorizationInputState({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.signBIsNegative,
    required this.signDIsNegative,
    required this.activeField,
    required this.lockA,
    required this.lockC,
  });

  final int? a;
  final int? b;
  final int? c;
  final int? d;
  final bool signBIsNegative;
  final bool signDIsNegative;
  final FactorField activeField;
  final bool lockA;
  final bool lockC;
}

class PrimeInputState {
  const PrimeInputState({
    required this.primes,
    required this.exponents,
    required this.activeIndex,
  });

  final List<int> primes;
  final List<int> exponents;
  final int activeIndex;
}

class PracticeSessionInfo {
  const PracticeSessionInfo({
    required this.category,
    required this.mode,
    required this.difficulty,
  });

  final Category category;
  final PracticeMode mode;
  final Difficulty difficulty;
}
