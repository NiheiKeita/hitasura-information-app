import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_example_app/features/intro/presentation/intro_presentation.dart';

void main() {
  testWidgets('FactorIntroPresentation shows sections', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FactorIntroPresentation(),
      ),
    );

    expect(find.text('因数分解とは'), findsOneWidget);
    expect(find.text('因数分解の遊び方'), findsWidgets);
  });

  testWidgets('PrimeIntroPresentation shows sections', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PrimeIntroPresentation(),
      ),
    );

    expect(find.text('素因数分解とは'), findsOneWidget);
    expect(find.text('素因数分解の遊び方'), findsWidgets);
  });
}
