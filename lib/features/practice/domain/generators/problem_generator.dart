import '../enums.dart';
import '../problem.dart';

abstract class ProblemGenerator<T> {
  T generate(Difficulty difficulty);
}

abstract class FactorizationGenerator extends ProblemGenerator<FactorizationProblem> {}

abstract class PrimeFactorizationGenerator
    extends ProblemGenerator<PrimeFactorizationProblem> {}
