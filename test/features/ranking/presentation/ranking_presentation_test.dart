import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_example_app/features/practice/domain/enums.dart';
import 'package:flutter_example_app/features/ranking/presentation/ranking_presentation.dart';
import 'package:flutter_example_app/widgets/wavy_background.dart';

import '../../../helpers/localized_test_app.dart';

void main() {
  testWidgets('RankingPresentation shows self ranking controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      LocalizedTestApp(
        home: RankingPresentation(
          category: Category.pseudocodeExecution,
          difficulty: Difficulty.normal,
          range: RankingRange.today,
          records: const [],
          onCategoryChanged: (_) {},
          onDifficultyChanged: (_) {},
          onRangeChanged: (_) {},
          onOpenWorldRanking: () {},
        ),
      ),
    );

    expect(find.byType(WavyBackground), findsOneWidget);
    expect(find.text('自分ランキング'), findsOneWidget);
    expect(find.text('世界ランキング'), findsOneWidget);
    expect(find.text('まだ記録がありません'), findsOneWidget);
  });

  testWidgets('WorldRankingComingSoonPresentation shows coming soon', (
    tester,
  ) async {
    await tester.pumpWidget(
      const LocalizedTestApp(home: WorldRankingComingSoonPresentation()),
    );

    expect(find.text('ランキング機能は近日公開予定です'), findsOneWidget);
    expect(find.text('COMING SOON'), findsOneWidget);
  });
}
