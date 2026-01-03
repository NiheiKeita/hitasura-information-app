class ExpandedCoefficients {
  const ExpandedCoefficients(this.A, this.B, this.C);
  final int A;
  final int B;
  final int C;
}

ExpandedCoefficients expandFactors(int a, int b, int c, int d) {
  final A = a * c;
  final B = a * d + b * c;
  final C = b * d;
  return ExpandedCoefficients(A, B, C);
}

bool isCorrectFactorization({
  required int problemA,
  required int problemB,
  required int problemC,
  required int inputA,
  required int inputB,
  required int inputC,
  required int inputD,
}) {
  final first = expandFactors(inputA, inputB, inputC, inputD);
  if (first.A == problemA &&
      first.B == problemB &&
      first.C == problemC) {
    return true;
  }

  final swapped = expandFactors(inputC, inputD, inputA, inputB);
  return swapped.A == problemA &&
      swapped.B == problemB &&
      swapped.C == problemC;
}

List<int> primeFactors(int n) {
  final factors = <int>[];
  var value = n;
  var p = 2;
  while (p * p <= value) {
    if (value % p == 0) {
      factors.add(p);
      while (value % p == 0) {
        value ~/= p;
      }
    }
    p = p == 2 ? 3 : p + 2;
  }
  if (value > 1) {
    factors.add(value);
  }
  return factors;
}

bool isCorrectPrimeFactorization({
  required int n,
  required List<int> primes,
  required List<int> exponents,
}) {
  if (primes.length != exponents.length) {
    return false;
  }
  var product = 1;
  for (var i = 0; i < primes.length; i++) {
    final prime = primes[i];
    final exponent = exponents[i];
    if (exponent < 0) {
      return false;
    }
    var factor = 1;
    for (var j = 0; j < exponent; j++) {
      factor *= prime;
    }
    product *= factor;
  }
  return product == n;
}

String formatQuadratic(int A, int B, int C) {
  final buffer = StringBuffer();
  _appendTerm(buffer, A, 'x^2', isFirst: true);
  _appendTerm(buffer, B, 'x');
  _appendTerm(buffer, C, '');
  return buffer.toString();
}

void _appendTerm(
  StringBuffer buffer,
  int coefficient,
  String variable, {
  bool isFirst = false,
}) {
  if (coefficient == 0) {
    return;
  }
  final absValue = coefficient.abs();
  final sign = coefficient < 0 ? '-' : '+';

  if (isFirst) {
    if (coefficient < 0) {
      buffer.write('-');
    }
  } else {
    buffer.write(' $sign ');
  }

  if (absValue != 1 || variable.isEmpty) {
    buffer.write(absValue);
  }
  buffer.write(variable);
}
