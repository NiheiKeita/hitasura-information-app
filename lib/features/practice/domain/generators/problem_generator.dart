import '../enums.dart';
import '../problem.dart';

abstract class InfoProblemGenerator {
  InfoProblem generate({
    required Category category,
    required Difficulty difficulty,
  });
}
