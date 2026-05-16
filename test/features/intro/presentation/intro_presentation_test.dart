import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_example_app/features/intro/presentation/intro_presentation.dart';

import '../../../helpers/localized_test_app.dart';

void main() {
  testWidgets('InfoIntroPresentation shows sections', (tester) async {
    await tester.pumpWidget(
      const LocalizedTestApp(
        home: InfoIntroPresentation(
          title: '疑似コードの実行結果',
          sections: [
            IntroSection(title: 'ポイント', body: 'テスト本文'),
            IntroSection(title: '解き方', body: 'テスト本文2'),
          ],
        ),
      ),
    );

    expect(find.text('疑似コードの実行結果'), findsOneWidget);
    expect(find.text('ポイント'), findsOneWidget);
    expect(find.text('解き方'), findsOneWidget);
  });
}
