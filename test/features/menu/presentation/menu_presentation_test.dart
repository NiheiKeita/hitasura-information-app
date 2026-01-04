import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_example_app/features/menu/presentation/menu_presentation.dart';
import 'package:flutter_example_app/widgets/wavy_background.dart';

void main() {
  testWidgets('MenuPresentation triggers intro callbacks', (tester) async {
    var openedPseudocode = false;
    var openedControl = false;
    var openedBinaryToDecimal = false;
    var openedDecimalToBinary = false;
    var openedBinaryMixed = false;
    var openedLicenses = false;

    await tester.pumpWidget(
      MaterialApp(
        home: MenuPresentation(
          onOpenPseudocodeIntro: () => openedPseudocode = true,
          onOpenControlFlowIntro: () => openedControl = true,
          onOpenBinaryToDecimalIntro: () => openedBinaryToDecimal = true,
          onOpenDecimalToBinaryIntro: () => openedDecimalToBinary = true,
          onOpenBinaryMixedIntro: () => openedBinaryMixed = true,
          onOpenLicenses: () => openedLicenses = true,
        ),
      ),
    );

    expect(find.byType(WavyBackground), findsOneWidget);

    await tester.tap(find.text('疑似コードの実行結果'));
    await tester.pump();
    expect(openedPseudocode, isTrue);

    await tester.tap(find.text('if / for / while の処理追跡'));
    await tester.pump();
    expect(openedControl, isTrue);

    await tester.tap(find.text('2進数→10進数'));
    await tester.pump();
    expect(openedBinaryToDecimal, isTrue);

    await tester.tap(find.text('10進数→2進数'));
    await tester.pump();
    expect(openedDecimalToBinary, isTrue);

    await tester.tap(find.text('2進数/10進数ミックス'));
    await tester.pump();
    expect(openedBinaryMixed, isTrue);

    await tester.scrollUntilVisible(
      find.text('ライセンス'),
      300,
      scrollable: find.byType(Scrollable),
    );
    await tester.tap(find.text('ライセンス'));
    await tester.pump();
    expect(openedLicenses, isTrue);
  });
}
