import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_example_app/features/practice/domain/scoring.dart';

void main() {
  test('expandFactors expands correctly', () {
    final result = expandFactors(2, -3, 1, 4);
    expect(result.A, 2);
    expect(result.B, 5);
    expect(result.C, -12);
  });

  test('isCorrectFactorization allows swapping factors', () {
    final expanded = expandFactors(1, 2, 3, 4);
    final correct = isCorrectFactorization(
      problemA: expanded.A,
      problemB: expanded.B,
      problemC: expanded.C,
      inputA: 3,
      inputB: 4,
      inputC: 1,
      inputD: 2,
    );
    expect(correct, isTrue);
  });

  test('primeFactors extracts primes', () {
    final factors = primeFactors(360);
    expect(factors, [2, 3, 5]);
  });

  test('isCorrectPrimeFactorization checks product', () {
    final correct = isCorrectPrimeFactorization(
      n: 360,
      primes: [2, 3, 5],
      exponents: [3, 2, 1],
    );
    expect(correct, isTrue);

    final incorrect = isCorrectPrimeFactorization(
      n: 360,
      primes: [2, 3, 5],
      exponents: [2, 2, 1],
    );
    expect(incorrect, isFalse);
  });
}
