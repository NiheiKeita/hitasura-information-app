import '../../features/practice/domain/enums.dart';

class ModeSelectArgs {
  const ModeSelectArgs({required this.category});
  final Category category;
}

class PracticeArgs {
  const PracticeArgs({
    required this.category,
    required this.mode,
    required this.difficulty,
  });
  final Category category;
  final PracticeMode mode;
  final Difficulty difficulty;
}
