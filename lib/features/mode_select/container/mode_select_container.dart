import 'package:flutter/material.dart';

import '../../practice/domain/enums.dart';
import '../presentation/mode_select_presentation.dart';

class ModeSelectContainer extends StatefulWidget {
  const ModeSelectContainer({
    super.key,
    required this.category,
    required this.onStart,
  });

  final Category category;
  final void Function(PracticeMode mode, Difficulty difficulty) onStart;

  @override
  State<ModeSelectContainer> createState() => _ModeSelectContainerState();
}

class _ModeSelectContainerState extends State<ModeSelectContainer> {
  PracticeMode _mode = PracticeMode.timeAttack10;
  Difficulty _difficulty = Difficulty.easy;

  @override
  Widget build(BuildContext context) {
    return ModeSelectPresentation(
      category: widget.category,
      mode: _mode,
      difficulty: _difficulty,
      onModeChanged: (mode) => setState(() => _mode = mode),
      onDifficultyChanged: (difficulty) =>
          setState(() => _difficulty = difficulty),
      onStart: () => widget.onStart(_mode, _difficulty),
    );
  }
}
