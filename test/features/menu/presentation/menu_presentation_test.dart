import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_example_app/features/menu/presentation/menu_presentation.dart';
import 'package:flutter_example_app/widgets/bubbly_background.dart';

void main() {
  testWidgets('MenuPresentation triggers intro callbacks', (tester) async {
    var openedFactor = false;
    var openedPrime = false;
    var openedLicenses = false;

    await tester.pumpWidget(
      MaterialApp(
        home: MenuPresentation(
          onOpenFactorIntro: () => openedFactor = true,
          onOpenPrimeIntro: () => openedPrime = true,
          onOpenLicenses: () => openedLicenses = true,
        ),
      ),
    );

    expect(find.byType(BubblyBackground), findsOneWidget);

    await tester.tap(find.text('因数分解の遊び方'));
    await tester.pump();
    expect(openedFactor, isTrue);

    await tester.tap(find.text('素因数分解の遊び方'));
    await tester.pump();
    expect(openedPrime, isTrue);

    await tester.tap(find.text('ライセンス'));
    await tester.pump();
    expect(openedLicenses, isTrue);
  });
}
