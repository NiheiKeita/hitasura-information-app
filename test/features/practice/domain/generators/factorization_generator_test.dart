import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_example_app/features/practice/domain/enums.dart';
import 'package:flutter_example_app/features/practice/domain/generators/factorization_generator.dart';

void main() {
  test('easy generator stays in range', () {
    final generator = RandomFactorizationGenerator(random: Random(0));
    for (var i = 0; i < 100; i++) {
      final problem = generator.generate(Difficulty.easy);
      expect(problem.a, 1);
      expect(problem.c, 1);
      expect(problem.b, inInclusiveRange(-9, 9));
      expect(problem.d, inInclusiveRange(-9, 9));
    }
  });

  test('normal generator uses expected ranges', () {
    final generator = RandomFactorizationGenerator(random: Random(1));
    for (var i = 0; i < 200; i++) {
      final problem = generator.generate(Difficulty.normal);
      expect(problem.a, anyOf(1, 2));
      if (problem.a == 2) {
        expect(problem.b, inInclusiveRange(-12, 12));
        expect(problem.d, inInclusiveRange(-12, 12));
      } else {
        expect(problem.b, inInclusiveRange(-15, 15));
        expect(problem.d, inInclusiveRange(-15, 15));
      }
    }
  });

  test('hard generator respects coefficient limits', () {
    final generator = RandomFactorizationGenerator(random: Random(2));
    for (var i = 0; i < 100; i++) {
      final problem = generator.generate(Difficulty.hard);
      expect(problem.a, inInclusiveRange(1, 6));
      expect(problem.c, inInclusiveRange(1, 6));
      expect(problem.b, inInclusiveRange(-30, 30));
      expect(problem.d, inInclusiveRange(-30, 30));
      expect(problem.B.abs(), lessThanOrEqualTo(200));
      expect(problem.C.abs(), lessThanOrEqualTo(900));
    }
  });
}
