import 'problem.dart';

bool isCorrectInfoAnswer({
  required InfoProblem problem,
  required String input,
}) {
  final normalizedInput = _normalize(input, problem.answerFormat);
  final normalizedAnswer = _normalize(problem.answer, problem.answerFormat);
  if (normalizedInput == null || normalizedAnswer == null) {
    return false;
  }
  return normalizedInput == normalizedAnswer;
}

int? _normalize(String value, AnswerFormat format) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  switch (format) {
    case AnswerFormat.decimal:
      return int.tryParse(trimmed);
    case AnswerFormat.binary:
      if (!_isBinary(trimmed)) {
        return null;
      }
      return int.tryParse(trimmed, radix: 2);
  }
}

bool _isBinary(String value) {
  for (final rune in value.runes) {
    if (rune != 48 && rune != 49) {
      return false;
    }
  }
  return true;
}
