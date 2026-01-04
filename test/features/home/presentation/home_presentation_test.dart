import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_example_app/features/home/presentation/home_presentation.dart';
import 'package:flutter_example_app/features/practice/domain/enums.dart';
import 'package:flutter_example_app/widgets/wavy_background.dart';

void main() {
  testWidgets('HomePresentation triggers menu and category callbacks',
      (tester) async {
    Category? selected;
    var openedMenu = false;
    var openedStats = false;
    var openedRanking = false;

    await tester.pumpWidget(
      MaterialApp(
        home: HomePresentation(
          todayAnswered: 3,
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

    await tester.tap(find.text('疑似コードの実行結果'));
    await tester.pump();
    expect(selected, Category.pseudocodeExecution);

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
}
