import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_example_app/features/home/presentation/home_presentation.dart';
import 'package:flutter_example_app/features/practice/domain/enums.dart';
import 'package:flutter_example_app/widgets/wavy_background.dart';

import '../../../helpers/localized_test_app.dart';

void main() {
  testWidgets('HomePresentation triggers menu and category callbacks',
      (tester) async {
    Category? selected;
    var openedMenu = false;
    var openedStats = false;
    var openedRanking = false;

    await tester.pumpWidget(
      LocalizedTestApp(
        home: HomePresentation(
          todayCorrect: 3,
          onSelectCategory: (category) => selected = category,
          onOpenStats: () => openedStats = true,
          onOpenRanking: () => openedRanking = true,
          onOpenMenu: () => openedMenu = true,
        ),
      ),
    );

    expect(find.byType(WavyBackground), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump();
    expect(openedMenu, isTrue);

    expect(find.text('今日の正解: 3'), findsOneWidget);

    await tester.tap(find.text('疑似コードの実行結果'));
    await tester.pump();
    expect(selected, Category.pseudocodeExecution);

    expect(find.textContaining('日連続'), findsNothing);

    final statsFinder = find.text('Stats');
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(statsFinder);
    await tester.pump();
    expect(openedStats, isTrue);

    final rankingFinder = find.text('Ranking');
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(rankingFinder);
    await tester.pump();
    expect(openedRanking, isTrue);
  });

  testWidgets('HomePresentation shows streak when currentStreak > 0',
      (tester) async {
    await tester.pumpWidget(
      LocalizedTestApp(
        home: HomePresentation(
          todayCorrect: 1,
          currentStreak: 5,
          onSelectCategory: (_) {},
          onOpenStats: () {},
          onOpenRanking: () {},
          onOpenMenu: () {},
        ),
      ),
    );

    expect(find.text('5日連続！'), findsOneWidget);
  });

  testWidgets('HomePresentation hides streak when currentStreak is 0',
      (tester) async {
    await tester.pumpWidget(
      LocalizedTestApp(
        home: HomePresentation(
          todayCorrect: 0,
          currentStreak: 0,
          onSelectCategory: (_) {},
          onOpenStats: () {},
          onOpenRanking: () {},
          onOpenMenu: () {},
        ),
      ),
    );

    expect(find.textContaining('日連続'), findsNothing);
  });
}
