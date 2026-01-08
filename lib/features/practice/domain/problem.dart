import 'enums.dart';

enum AnswerFormat {
  decimal,
  binary,
}

class InfoProblem {
  const InfoProblem({
    required this.category,
    required this.difficulty,
    required this.question,
    required this.answer,
    required this.answerFormat,
    this.answerHint,
  });

  final Category category;
  final Difficulty difficulty;
  final String question;
  final String answer;
  final AnswerFormat answerFormat;
  final String? answerHint;

  String get questionText => question;

  String get hintText {
    if (answerHint != null && answerHint!.isNotEmpty) {
      return answerHint!;
    }
    switch (answerFormat) {
      case AnswerFormat.decimal:
        return '10進数で答える';
      case AnswerFormat.binary:
        return '2進数で答える';
    }
  }
}

class PracticeResult {
  const PracticeResult({
    required this.category,
    required this.mode,
    required this.difficulty,
    required this.answeredCount,
    required this.correctCount,
    required this.maxStreak,
    required this.elapsedMillis,
  });

  final Category category;
  final PracticeMode mode;
  final Difficulty difficulty;
  final int answeredCount;
  final int correctCount;
  final int maxStreak;
  final int elapsedMillis;

  int get missCount => answeredCount - correctCount;

  double get accuracy =>
      answeredCount == 0 ? 0 : correctCount / answeredCount;
}
