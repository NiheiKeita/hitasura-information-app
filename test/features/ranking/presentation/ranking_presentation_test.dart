import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_example_app/features/ranking/presentation/ranking_presentation.dart';
import 'package:flutter_example_app/widgets/wavy_background.dart';

import '../../../helpers/localized_test_app.dart';

void main() {
  testWidgets('RankingPresentation shows coming soon', (tester) async {
    await tester.pumpWidget(
      const LocalizedTestApp(home: RankingPresentation()),
    );

    expect(find.byType(WavyBackground), findsOneWidget);
    expect(find.text('Ranking'), findsOneWidget);
    expect(find.text('ランキング機能は近日公開予定です'), findsOneWidget);
    expect(find.text('COMING SOON'), findsOneWidget);
  });
}
