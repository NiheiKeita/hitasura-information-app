import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/clock/clock.dart';
import '../../../core/ads/ad_service.dart';
import '../../../core/storage/stats_repository.dart';
import '../domain/answer_input.dart';
import '../domain/enums.dart';
import '../domain/generators/problem_generator.dart';
import '../domain/problem.dart';
import '../domain/scoring.dart';
import '../presentation/practice_presentation.dart';

class PracticeContainer extends StatefulWidget {
  const PracticeContainer({
    super.key,
    required this.category,
    required this.mode,
    required this.difficulty,
    required this.factorizationGenerator,
    required this.primeFactorizationGenerator,
    required this.statsRepository,
    required this.clock,
    required this.adService,
    required this.onFinish,
    required this.onExit,
  });

  final Category category;
  final PracticeMode mode;
  final Difficulty difficulty;
  final FactorizationGenerator factorizationGenerator;
  final PrimeFactorizationGenerator primeFactorizationGenerator;
  final StatsRepository statsRepository;
  final Clock clock;
  final AdService adService;
  final void Function(PracticeResult result) onFinish;
  final VoidCallback onExit;

  @override
  State<PracticeContainer> createState() => _PracticeContainerState();
}

class _PracticeContainerState extends State<PracticeContainer> {
  late final PracticeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PracticeController(
      category: widget.category,
      mode: widget.mode,
      difficulty: widget.difficulty,
      factorizationGenerator: widget.factorizationGenerator,
      primeFactorizationGenerator: widget.primeFactorizationGenerator,
      statsRepository: widget.statsRepository,
      clock: widget.clock,
      adService: widget.adService,
      onFinish: widget.onFinish,
    );
    _controller.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return PracticePresentation(
          sessionInfo: _controller.sessionInfo,
          questionText: _controller.questionText,
          progressText: _controller.progressText,
          elapsedText: _controller.elapsedText,
          feedback: _controller.feedback,
          countdownText: _controller.countdownText,
          quadraticCoefficients: _controller.quadraticCoefficients,
          canSubmit: _controller.canSubmit,
          onDigit: _controller.onDigit,
          onBackspace: _controller.onBackspace,
          onClear: _controller.onClear,
          onSubmit: _controller.onSubmit,
          onFinish: _controller.finishManually,
          onSelectFactorField: _controller.selectFactorField,
          onSelectPrimeField: _controller.selectPrimeIndex,
          onToggleSign: _controller.allowSignToggle && _controller.canToggleSign
              ? _controller.onToggleSign
              : null,
          factorizationInput: _controller.factorizationInput,
          primeInput: _controller.primeInput,
        );
      },
    );
  }
}

class PracticeController extends ChangeNotifier {
  PracticeController({
    required Category category,
    required PracticeMode mode,
    required Difficulty difficulty,
    required FactorizationGenerator factorizationGenerator,
    required PrimeFactorizationGenerator primeFactorizationGenerator,
    required StatsRepository statsRepository,
    required Clock clock,
    required AdService adService,
    required void Function(PracticeResult result) onFinish,
  })  : sessionInfo = PracticeSessionInfo(
          category: category,
          mode: mode,
          difficulty: difficulty,
        ),
        _factorizationGenerator = factorizationGenerator,
        _primeFactorizationGenerator = primeFactorizationGenerator,
        _statsRepository = statsRepository,
        _clock = clock,
        _adService = adService,
        _onFinish = onFinish;

  final PracticeSessionInfo sessionInfo;
  final FactorizationGenerator _factorizationGenerator;
  final PrimeFactorizationGenerator _primeFactorizationGenerator;
  final StatsRepository _statsRepository;
  final Clock _clock;
  final AdService _adService;
  final void Function(PracticeResult result) _onFinish;

  FactorizationProblem? _factorProblem;
  PrimeFactorizationProblem? _primeProblem;
  AnswerFeedback? _feedback;
  String? _countdownText;
  bool _readyToStart = false;
  bool _disposed = false;

  int? _a;
  int? _c;
  int? _bAbs;
  int? _dAbs;
  bool _signBIsNegative = false;
  bool _signDIsNegative = false;
  FactorField _activeField = FactorField.b;
  bool _lockA = false;
  bool _lockC = false;

  List<int> _primeFactors = const [];
  List<int> _primeExponents = const [];
  int _activePrimeIndex = 0;

  int _answeredCount = 0;
  int _correctCount = 0;
  int _currentStreak = 0;
  int _maxStreak = 0;
  int _questionIndex = 1;
  DateTime? _startTime;
  Timer? _ticker;
  Duration _elapsed = Duration.zero;

  void start() {
    _generateProblem();
    _startCountdown();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateElapsed();
    });
  }

  void _updateElapsed() {
    if (_startTime == null) {
      return;
    }
    _elapsed = _clock.now().difference(_startTime!);
    notifyListeners();
  }

  String get questionText {
    if (sessionInfo.category == Category.factorization) {
      return _factorProblem?.questionText ?? '';
    }
    return _primeProblem?.questionText ?? '';
  }

  String get progressText {
    if (sessionInfo.mode == PracticeMode.timeAttack10) {
      return '$_questionIndex/10';
    }
    return '正解 $_correctCount (連続 $_currentStreak)';
  }

  String get elapsedText {
    final minutes = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  FactorizationInputState? get factorizationInput {
    if (sessionInfo.category != Category.factorization) {
      return null;
    }
    return FactorizationInputState(
      a: _a,
      b: _bAbs,
      c: _c,
      d: _dAbs,
      signBIsNegative: _signBIsNegative,
      signDIsNegative: _signDIsNegative,
      activeField: _activeField,
      lockA: _lockA,
      lockC: _lockC,
    );
  }

  PrimeInputState? get primeInput {
    if (sessionInfo.category != Category.primeFactorization) {
      return null;
    }
    return PrimeInputState(
      primes: _primeFactors,
      exponents: _primeExponents,
      activeIndex: _activePrimeIndex,
    );
  }

  String? get countdownText => _countdownText;

  AnswerFeedback? get feedback => _feedback;

  ExpandedCoefficients? get quadraticCoefficients {
    final problem = _factorProblem;
    if (problem == null) {
      return null;
    }
    return ExpandedCoefficients(problem.A, problem.B, problem.C);
  }

  bool get allowSignToggle => sessionInfo.category == Category.factorization;

  bool get canToggleSign {
    return _activeField == FactorField.signB ||
        _activeField == FactorField.signD ||
        _activeField == FactorField.b ||
        _activeField == FactorField.d;
  }

  bool get canSubmit {
    if (!_readyToStart) {
      return false;
    }
    if (sessionInfo.category == Category.factorization) {
      if (_lockA == false && _a == null) {
        return false;
      }
      if (_bAbs == null || _dAbs == null) {
        return false;
      }
      if (_lockC == false && _c == null) {
        return false;
      }
      if ((_a ?? 0) == 0 || (_c ?? 0) == 0) {
        return false;
      }
      return true;
    }
    return true;
  }

  void selectFactorField(FactorField field) {
    if (!_readyToStart) {
      return;
    }
    _activeField = field;
    notifyListeners();
  }

  void selectPrimeIndex(int index) {
    if (!_readyToStart) {
      return;
    }
    _activePrimeIndex = index;
    notifyListeners();
  }

  void onDigit(int digit) {
    if (!_readyToStart) {
      return;
    }
    if (sessionInfo.category == Category.factorization) {
      if (_activeField == FactorField.signB) {
        _activeField = FactorField.b;
      } else if (_activeField == FactorField.signD) {
        _activeField = FactorField.d;
      }
      _setFactorDigit(digit);
    } else {
      _setPrimeDigit(digit);
    }
  }

  void onBackspace() {
    if (!_readyToStart) {
      return;
    }
    if (sessionInfo.category == Category.factorization) {
      _updateFactorValue(
        _activeField,
        _backspaceValue(_valueFor(_activeField)),
      );
    } else {
      _primeExponents[_activePrimeIndex] =
          _backspaceExponent(_primeExponents[_activePrimeIndex]);
      notifyListeners();
    }
  }

  void onClear() {
    if (!_readyToStart) {
      return;
    }
    if (sessionInfo.category == Category.factorization) {
      if ((_activeField == FactorField.a && _lockA) ||
          (_activeField == FactorField.c && _lockC)) {
        return;
      }
      if (_activeField == FactorField.a) {
        _updateFactorValue(FactorField.a, 1);
        return;
      }
      if (_activeField == FactorField.signB ||
          _activeField == FactorField.signD) {
        if (_activeField == FactorField.signB) {
          _signBIsNegative = false;
        } else {
          _signDIsNegative = false;
        }
        notifyListeners();
        return;
      }
      _updateFactorValue(_activeField, null);
    } else {
      _primeExponents[_activePrimeIndex] = 0;
      notifyListeners();
    }
  }

  void onToggleSign() {
    if (!_readyToStart) {
      return;
    }
    if (sessionInfo.category != Category.factorization) {
      return;
    }
    if (_activeField == FactorField.signB) {
      _signBIsNegative = !_signBIsNegative;
      notifyListeners();
      return;
    }
    if (_activeField == FactorField.signD) {
      _signDIsNegative = !_signDIsNegative;
      notifyListeners();
      return;
    }
    if (_activeField == FactorField.b) {
      _signBIsNegative = !_signBIsNegative;
      notifyListeners();
      return;
    }
    if (_activeField == FactorField.d) {
      _signDIsNegative = !_signDIsNegative;
      notifyListeners();
      return;
    }
  }

  Future<void> onSubmit() async {
    if (!_readyToStart) {
      return;
    }
    if (!canSubmit) {
      return;
    }
    final correct = _isAnswerCorrect();
    _answeredCount += 1;
    if (correct) {
      _correctCount += 1;
      _currentStreak += 1;
      if (_currentStreak > _maxStreak) {
        _maxStreak = _currentStreak;
      }
    } else {
      _currentStreak = 0;
    }

    await _statsRepository.recordAnswer(
      date: _clock.now(),
      category: sessionInfo.category,
      mode: sessionInfo.mode,
      correct: correct,
    );

    _feedback = correct ? AnswerFeedback.correct : AnswerFeedback.incorrect;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 350));
    _feedback = null;
    notifyListeners();

    if (!correct) {
      return;
    }

    if (sessionInfo.mode == PracticeMode.infinite &&
        _correctCount % 10 == 0) {
      await _adService.maybeShowInterstitial('infinite_10');
    }

    if (sessionInfo.mode == PracticeMode.timeAttack10 &&
        _questionIndex >= 10) {
      finish();
      return;
    }

    _questionIndex += 1;
    _generateProblem();
  }

  void finish({bool isManual = false}) {
    _ticker?.cancel();
    _updateElapsed();
    final result = PracticeResult(
      category: sessionInfo.category,
      mode: sessionInfo.mode,
      difficulty: sessionInfo.difficulty,
      answeredCount: _answeredCount,
      correctCount: _correctCount,
      maxStreak: _maxStreak,
      elapsedMillis: _elapsed.inMilliseconds,
    );

    if (!(isManual && sessionInfo.mode == PracticeMode.timeAttack10)) {
      _statsRepository.recordBest(
        category: sessionInfo.category,
        mode: sessionInfo.mode,
        difficulty: sessionInfo.difficulty,
        correctCount: _correctCount,
        maxStreak: _maxStreak,
        timeMillis: sessionInfo.mode == PracticeMode.timeAttack10
            ? _elapsed.inMilliseconds
            : null,
      );
    }

    _onFinish(result);
  }

  void finishManually() {
    finish(isManual: true);
  }

  void _generateProblem() {
    if (sessionInfo.category == Category.factorization) {
      _factorProblem = _factorizationGenerator.generate(sessionInfo.difficulty);
      _initFactorInputs();
    } else {
      _primeProblem =
          _primeFactorizationGenerator.generate(sessionInfo.difficulty);
      _initPrimeInputs();
    }
    notifyListeners();
  }

  Future<void> _startCountdown() async {
    _countdownText = 'よーい';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1000));
    if (_disposed) {
      return;
    }
    _countdownText = 'スタート！';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    if (_disposed) {
      return;
    }
    _countdownText = null;
    _readyToStart = true;
    _startTime = _clock.now();
    _startTicker();
    notifyListeners();
  }

  void _initFactorInputs() {
    if (sessionInfo.difficulty == Difficulty.easy) {
      _a = 1;
      _c = 1;
      _bAbs = null;
      _dAbs = null;
      _signBIsNegative = false;
      _signDIsNegative = false;
      _lockA = true;
      _lockC = true;
      _activeField = FactorField.b;
    } else {
      _a = sessionInfo.difficulty == Difficulty.hard ? null : 1;
      _bAbs = null;
      _c = null;
      _dAbs = null;
      _signBIsNegative = false;
      _signDIsNegative = false;
      _lockA = false;
      _lockC = false;
      _activeField = FactorField.b;
    }
  }

  void _initPrimeInputs() {
    _primeFactors = _allowedPrimesFor(sessionInfo.difficulty);
    _primeExponents = List<int>.filled(_primeFactors.length, 0);
    _activePrimeIndex = 0;
  }

  bool _isAnswerCorrect() {
    if (sessionInfo.category == Category.factorization) {
      final problem = _factorProblem;
      if (problem == null) {
        return false;
      }
      final inputA = _a ?? 0;
      final inputB = _applySign(_bAbs ?? 0, _signBIsNegative);
      final inputC = _c ?? 0;
      final inputD = _applySign(_dAbs ?? 0, _signDIsNegative);
      return isCorrectFactorization(
        problemA: problem.A,
        problemB: problem.B,
        problemC: problem.C,
        inputA: inputA,
        inputB: inputB,
        inputC: inputC,
        inputD: inputD,
      );
    }
    final problem = _primeProblem;
    if (problem == null) {
      return false;
    }
    return isCorrectPrimeFactorization(
      n: problem.n,
      primes: _primeFactors,
      exponents: _primeExponents,
    );
  }

  void _setFactorDigit(int digit) {
    final isLocked =
        (_activeField == FactorField.a && _lockA) ||
            (_activeField == FactorField.c && _lockC);
    if (isLocked) {
      return;
    }
    final allowZero =
        _activeField != FactorField.a && _activeField != FactorField.c;
    if (!allowZero && digit == 0) {
      return;
    }
    _updateFactorValue(_activeField, digit, notify: false);
    _advanceFactorField();
    notifyListeners();
  }

  void _setPrimeDigit(int digit) {
    _primeExponents[_activePrimeIndex] = digit;
    if (_activePrimeIndex < _primeExponents.length - 1) {
      _activePrimeIndex += 1;
    }
    notifyListeners();
  }

  void _updateFactorValue(
    FactorField field,
    int? value, {
    bool notify = true,
  }) {
    switch (field) {
      case FactorField.a:
        _a = value;
        break;
      case FactorField.b:
        _bAbs = value;
        break;
      case FactorField.c:
        _c = value;
        break;
      case FactorField.d:
        _dAbs = value;
        break;
      case FactorField.signB:
      case FactorField.signD:
        break;
    }
    if (notify) {
      notifyListeners();
    }
  }

  void _advanceFactorField() {
    final order = [
      FactorField.a,
      FactorField.b,
      FactorField.c,
      FactorField.d,
    ];
    final available = order.where((field) {
      if (field == FactorField.a && _lockA) {
        return false;
      }
      if (field == FactorField.c && _lockC) {
        return false;
      }
      return true;
    }).toList();
    final index = available.indexOf(_activeField);
    if (index == -1 || index >= available.length - 1) {
      return;
    }
    _activeField = available[index + 1];
  }

  int? _valueFor(FactorField field) {
    switch (field) {
      case FactorField.a:
        return _a;
      case FactorField.b:
        return _bAbs;
      case FactorField.c:
        return _c;
      case FactorField.d:
        return _dAbs;
      case FactorField.signB:
      case FactorField.signD:
        return null;
    }
  }

  int? _backspaceValue(int? current) {
    if (current == null) {
      return null;
    }
    final isNegative = current < 0;
    final absCurrent = current.abs();
    if (absCurrent < 10) {
      return null;
    }
    final nextAbs = absCurrent ~/ 10;
    return isNegative ? -nextAbs : nextAbs;
  }

  int _backspaceExponent(int current) {
    if (current < 10) {
      return 0;
    }
    return current ~/ 10;
  }

  int _applySign(int value, bool isNegative) {
    return isNegative ? -value : value;
  }

  List<int> _allowedPrimesFor(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return const [2, 3, 5, 7];
      case Difficulty.normal:
        return const [2, 3, 5, 7, 11, 13];
      case Difficulty.hard:
        return const [2, 3, 5, 7, 11, 13, 17, 19];
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _ticker?.cancel();
    super.dispose();
  }
}
