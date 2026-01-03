import 'enums.dart';

enum AnswerFeedback {
  correct,
  incorrect,
}

class AnswerInputState {
  const AnswerInputState({
    required this.text,
    required this.placeholder,
  });

  final String text;
  final String placeholder;
}

class PracticeSessionInfo {
  const PracticeSessionInfo({
    required this.category,
    required this.mode,
    required this.difficulty,
  });

  final Category category;
  final PracticeMode mode;
  final Difficulty difficulty;
}
