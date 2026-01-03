import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_example_app/features/practice/domain/enums.dart';
import 'package:flutter_example_app/features/practice/domain/generators/prime_factorization_generator.dart';
import 'package:flutter_example_app/features/practice/domain/scoring.dart';

void main() {
  test('easy generator stays in range', () {
    final generator = RandomPrimeFactorizationGenerator(random: Random(3));
    for (var i = 0; i < 50; i++) {
      final problem = generator.generate(Difficulty.easy);
      expect(problem.n, inInclusiveRange(2, 200));
      expect(problem.primes, primeFactors(problem.n));
      expect(problem.primes.every((p) => p <= 7), isTrue);
    }
  });

  test('normal generator stays in range', () {
    final generator = RandomPrimeFactorizationGenerator(random: Random(4));
    for (var i = 0; i < 50; i++) {
      final problem = generator.generate(Difficulty.normal);
      expect(problem.n, inInclusiveRange(2, 2000));
      expect(problem.primes.every((p) => p <= 13), isTrue);
    }
  });

  test('hard generator avoids too many primes', () {
    final generator = RandomPrimeFactorizationGenerator(random: Random(5));
    for (var i = 0; i < 50; i++) {
      final problem = generator.generate(Difficulty.hard);
      expect(problem.n, inInclusiveRange(2, 20000));
      expect(problem.primes.length, lessThan(5));
      expect(problem.primes.every((p) => p <= 19), isTrue);
    }
  });
}
