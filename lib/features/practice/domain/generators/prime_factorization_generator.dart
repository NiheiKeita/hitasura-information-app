import 'dart:math';

import '../enums.dart';
import '../problem.dart';
import '../scoring.dart';
import 'problem_generator.dart';

class RandomPrimeFactorizationGenerator
    implements PrimeFactorizationGenerator {
  RandomPrimeFactorizationGenerator({Random? random})
      : _random = random ?? Random();

  final Random _random;

  @override
  PrimeFactorizationProblem generate(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return _generateWithPrimes(
          min: 2,
          max: 200,
          difficulty: difficulty,
          primes: const [2, 3, 5, 7],
          maxDistinct: 2,
          maxExponent: 3,
        );
      case Difficulty.normal:
        return _generateWithPrimes(
          min: 2,
          max: 2000,
          difficulty: difficulty,
          primes: const [2, 3, 5, 7, 11, 13],
          maxDistinct: 3,
          maxExponent: 4,
        );
      case Difficulty.hard:
        return _generateWithPrimes(
          min: 2,
          max: 20000,
          difficulty: difficulty,
          primes: const [2, 3, 5, 7, 11, 13, 17, 19],
          maxDistinct: 4,
          maxExponent: 5,
        );
    }
  }

  PrimeFactorizationProblem _generateWithPrimes({
    required int min,
    required int max,
    required Difficulty difficulty,
    required List<int> primes,
    required int maxDistinct,
    required int maxExponent,
  }) {
    while (true) {
      final distinctCount = _randomInt(1, maxDistinct);
      final shuffled = List<int>.from(primes)..shuffle(_random);
      final selected = shuffled.take(distinctCount).toList();
      var n = 1;
      for (final prime in selected) {
        final exponent = _randomInt(1, maxExponent);
        for (var i = 0; i < exponent; i++) {
          n *= prime;
        }
      }
      if (n < min || n > max) {
        continue;
      }
      final factors = primeFactors(n);
      if (difficulty == Difficulty.hard && factors.length >= 5) {
        continue;
      }
      return PrimeFactorizationProblem(
        n: n,
        primes: factors,
        difficulty: difficulty,
      );
    }
  }

  int _randomInt(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }
}
