import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_example_app/features/mode_select/presentation/mode_select_presentation.dart';
import 'package:flutter_example_app/features/practice/domain/enums.dart';

void main() {
  testWidgets('ModeSelectPresentation updates selections and starts',
      (tester) async {
    PracticeMode? selectedMode;
    Difficulty? selectedDifficulty;
    var started = false;

    await tester.pumpWidget(
      MaterialApp(
        home: ModeSelectPresentation(
          category: Category.pseudocodeExecution,
          mode: PracticeMode.infinite,
          difficulty: Difficulty.normal,
          onModeChanged: (mode) => selectedMode = mode,
          onDifficultyChanged: (difficulty) =>
              selectedDifficulty = difficulty,
          onStart: () => started = true,
        ),
      ),
    );

    await tester.tap(find.text('10問TA'));
    await tester.pump();
    expect(selectedMode, PracticeMode.timeAttack10);

    await tester.tap(find.text('Hard'));
    await tester.pump();
    expect(selectedDifficulty, Difficulty.hard);

    await tester.tap(find.text('スタート'));
    await tester.pump();
    expect(started, isTrue);
  });
}
