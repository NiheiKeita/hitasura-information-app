import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_example_app/core/clock/clock.dart';
import 'package:flutter_example_app/core/ads/noop_ad_service.dart';
import 'package:flutter_example_app/core/storage/stats_repository.dart';
import 'package:flutter_example_app/widgets/pressable_surface.dart';
import 'package:flutter_example_app/features/practice/container/practice_container.dart';
import 'package:flutter_example_app/features/practice/domain/enums.dart';
import 'package:flutter_example_app/features/practice/domain/generators/problem_generator.dart';
import 'package:flutter_example_app/features/practice/domain/problem.dart';
import 'package:flutter_example_app/features/practice/presentation/widgets/answer_keypad.dart';

class FakeClock implements Clock {
  FakeClock(this._now);
  final DateTime _now;

  @override
  DateTime now() => _now;
}

class FakeStatsRepository implements StatsRepository {
  int recordAnswerCalls = 0;
  int recordBestCalls = 0;

  @override
  Future<void> recordAnswer({
    required DateTime date,
    required Category category,
    required PracticeMode mode,
    required bool correct,
  }) async {
    recordAnswerCalls += 1;
  }

  @override
  Future<void> recordBest({
    required Category category,
    required PracticeMode mode,
    required Difficulty difficulty,
    required int correctCount,
    required int maxStreak,
    required int? timeMillis,
  }) async {
    recordBestCalls += 1;
  }

  @override
  Future<StatsSummary> loadSummary({required DateTime now}) async {
    return const StatsSummary(
      todayAnswered: 0,
      todayCorrect: 0,
      last7DaysAnswered: 0,
      totalsAnswered: 0,
      totalsCorrect: 0,
      bestRecords: [],
    );
  }

  @override
  Future<DailyStats?> loadDailyStats({required DateTime date}) async {
    return null;
  }

  @override
  Future<Map<DateTime, DailyStats>> loadDailyStatsRange({
    required DateTime start,
    required DateTime end,
  }) async {
    return {};
  }

  @override
  Future<Map<DateTime, DailyStats>> loadMonthlyStats({
    required DateTime month,
  }) async {
    return {};
  }

  @override
  Future<BestRecord?> loadBest({
    required Category category,
    required PracticeMode mode,
    required Difficulty difficulty,
  }) async {
    return null;
  }
}

class FakeFactorizationGenerator implements FactorizationGenerator {
  FakeFactorizationGenerator(this.problem);
  final FactorizationProblem problem;

  @override
  FactorizationProblem generate(Difficulty difficulty) => problem;
}

class FakePrimeGenerator implements PrimeFactorizationGenerator {
  @override
  PrimeFactorizationProblem generate(Difficulty difficulty) {
    return PrimeFactorizationProblem(n: 2, primes: [2], difficulty: difficulty);
  }
}

void main() {
  testWidgets('PracticeContainer starts with a=1 in normal mode',
      (tester) async {
    final statsRepository = FakeStatsRepository();
    final generator = FakeFactorizationGenerator(
      FactorizationProblem(
        a: 1,
        b: 2,
        c: 1,
        d: 3,
        difficulty: Difficulty.normal,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: PracticeContainer(
          category: Category.factorization,
          mode: PracticeMode.infinite,
          difficulty: Difficulty.normal,
          factorizationGenerator: generator,
          primeFactorizationGenerator: FakePrimeGenerator(),
          statsRepository: statsRepository,
          clock: FakeClock(DateTime(2024, 1, 1)),
          adService: NoopAdService(),
          onFinish: (_) {},
          onExit: () {},
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 2200));

    final firstField = find.byKey(const ValueKey('field_a'));
    expect(
      find.descendant(of: firstField, matching: find.text('1')),
      findsOneWidget,
    );
  });

  testWidgets('Input updates values and enables submit', (tester) async {
    final statsRepository = FakeStatsRepository();
    final generator = FakeFactorizationGenerator(
      FactorizationProblem(
        a: 1,
        b: 2,
        c: 1,
        d: 3,
        difficulty: Difficulty.normal,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: PracticeContainer(
          category: Category.factorization,
          mode: PracticeMode.infinite,
          difficulty: Difficulty.normal,
          factorizationGenerator: generator,
          primeFactorizationGenerator: FakePrimeGenerator(),
          statsRepository: statsRepository,
          clock: FakeClock(DateTime(2024, 1, 1)),
          adService: NoopAdService(),
          onFinish: (_) {},
          onExit: () {},
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 2200));

    final submitFinder = find.widgetWithText(PressableSurface, '回答する');
    PressableSurface button = tester.widget(submitFinder);
    expect(button.enabled, isFalse);

    final keypadFinder = find.byType(AnswerKeypad);
    final fieldB = find.byKey(const ValueKey('field_b'));
    final fieldC = find.byKey(const ValueKey('field_c'));
    final fieldD = find.byKey(const ValueKey('field_d'));

    await tester.ensureVisible(fieldB);
    await tester.tap(fieldB);
    await tester.tap(
      find.descendant(of: keypadFinder, matching: find.text('2')),
    );
    await tester.pump();

    await tester.ensureVisible(fieldC);
    await tester.tap(fieldC);
    await tester.tap(
      find.descendant(of: keypadFinder, matching: find.text('1')),
    );
    await tester.pump();

    await tester.ensureVisible(fieldD);
    await tester.tap(fieldD);
    await tester.tap(
      find.descendant(of: keypadFinder, matching: find.text('3')),
    );
    await tester.pump();

    button = tester.widget(submitFinder);
    expect(button.enabled, isTrue);

    await tester.tap(
      find.descendant(of: keypadFinder, matching: find.text('回答する')),
    );
    await tester.pump(const Duration(milliseconds: 400));

    expect(statsRepository.recordAnswerCalls, 1);
  });

  testWidgets('Time attack finishes after 10 submissions', (tester) async {
    final statsRepository = FakeStatsRepository();
    final generator = FakeFactorizationGenerator(
      FactorizationProblem(
        a: 1,
        b: 2,
        c: 1,
        d: 3,
        difficulty: Difficulty.easy,
      ),
    );
    var finished = false;

    await tester.pumpWidget(
      MaterialApp(
        home: PracticeContainer(
          category: Category.factorization,
          mode: PracticeMode.timeAttack10,
          difficulty: Difficulty.easy,
          factorizationGenerator: generator,
          primeFactorizationGenerator: FakePrimeGenerator(),
          statsRepository: statsRepository,
          clock: FakeClock(DateTime(2024, 1, 1)),
          adService: NoopAdService(),
          onFinish: (_) {
            finished = true;
          },
          onExit: () {},
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 2200));

    final keypadFinder = find.byType(AnswerKeypad);
    final fieldB = find.byKey(const ValueKey('field_b'));
    final fieldD = find.byKey(const ValueKey('field_d'));

    for (var i = 0; i < 10; i++) {
      await tester.ensureVisible(fieldB);
      await tester.tap(fieldB);
      await tester.tap(
        find.descendant(of: keypadFinder, matching: find.text('2')),
      );
      await tester.pump();
      await tester.ensureVisible(fieldD);
      await tester.tap(fieldD);
      await tester.tap(
        find.descendant(of: keypadFinder, matching: find.text('3')),
      );
      await tester.pump();
      await tester.tap(
        find.descendant(of: keypadFinder, matching: find.text('回答する')),
      );
      await tester.pump(const Duration(milliseconds: 400));
    }

    expect(finished, isTrue);
    expect(statsRepository.recordBestCalls, 1);
  });

  testWidgets('Manual finish in time attack skips best record',
      (tester) async {
    final statsRepository = FakeStatsRepository();
    final generator = FakeFactorizationGenerator(
      FactorizationProblem(
        a: 1,
        b: 2,
        c: 1,
        d: 3,
        difficulty: Difficulty.easy,
      ),
    );
    var finished = false;

    await tester.pumpWidget(
      MaterialApp(
        home: PracticeContainer(
          category: Category.factorization,
          mode: PracticeMode.timeAttack10,
          difficulty: Difficulty.easy,
          factorizationGenerator: generator,
          primeFactorizationGenerator: FakePrimeGenerator(),
          statsRepository: statsRepository,
          clock: FakeClock(DateTime(2024, 1, 1)),
          adService: NoopAdService(),
          onFinish: (_) {
            finished = true;
          },
          onExit: () {},
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 2200));

    await tester.tap(find.text('Finish'));
    await tester.pump();

    expect(finished, isTrue);
    expect(statsRepository.recordBestCalls, 0);
  });
}
