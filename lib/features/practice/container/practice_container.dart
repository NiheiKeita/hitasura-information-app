import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/ads/ad_service.dart';
import '../../../core/clock/clock.dart';
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
    required this.infoProblemGenerator,
    required this.statsRepository,
    required this.clock,
    required this.adService,
    required this.onFinish,
    required this.onExit,
  });

  final Category category;
  final PracticeMode mode;
  final Difficulty difficulty;
  final InfoProblemGenerator infoProblemGenerator;
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
          infoProblemGenerator: widget.infoProblemGenerator,
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
          canSubmit: _controller.canSubmit,
          onDigit: _controller.onDigit,
          onBackspace: _controller.onBackspace,
          onClear: _controller.onClear,
          onSubmit: _controller.onSubmit,
          onFinish: _controller.finishManually,
          allowedDigits: _controller.allowedDigits,
          inputState: _controller.inputState,
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
    required InfoProblemGenerator infoProblemGenerator,
    required StatsRepository statsRepository,
    required Clock clock,
    required AdService adService,
    required void Function(PracticeResult result) onFinish,
  })  : sessionInfo = PracticeSessionInfo(
          category: category,
          mode: mode,
          difficulty: difficulty,
        ),
        _infoProblemGenerator = infoProblemGenerator,
        _statsRepository = statsRepository,
        _clock = clock,
        _adService = adService,
        _onFinish = onFinish;

  final PracticeSessionInfo sessionInfo;
  final InfoProblemGenerator _infoProblemGenerator;
  final StatsRepository _statsRepository;
  final Clock _clock;
  final AdService _adService;
  final void Function(PracticeResult result) _onFinish;

  InfoProblem? _problem;
  AnswerFeedback? _feedback;
  String? _countdownText;
  bool _readyToStart = false;
  bool _disposed = false;

  String _inputBuffer = '';

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
    return _problem?.questionText ?? '';
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

  AnswerInputState get inputState {
    return AnswerInputState(
      text: _inputBuffer,
      placeholder: '入力',
    );
  }

  Set<int>? get allowedDigits {
    final problem = _problem;
    if (problem == null) {
      return null;
    }
    if (problem.answerFormat == AnswerFormat.binary) {
      return const {0, 1};
    }
    return null;
  }

  String? get countdownText => _countdownText;

  AnswerFeedback? get feedback => _feedback;

  bool get canSubmit {
    if (!_readyToStart) {
      return false;
    }
    return _inputBuffer.trim().isNotEmpty;
  }

  void onDigit(int digit) {
    if (!_readyToStart) {
      return;
    }
    final problem = _problem;
    if (problem == null) {
      return;
    }
    if (problem.answerFormat == AnswerFormat.binary && digit > 1) {
      return;
    }
    _inputBuffer = '$_inputBuffer$digit';
    notifyListeners();
  }

  void onBackspace() {
    if (!_readyToStart) {
      return;
    }
    if (_inputBuffer.isEmpty) {
      return;
    }
    _inputBuffer = _inputBuffer.substring(0, _inputBuffer.length - 1);
    notifyListeners();
  }

  void onClear() {
    if (!_readyToStart) {
      return;
    }
    _inputBuffer = '';
    notifyListeners();
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
    _problem = _infoProblemGenerator.generate(
      category: sessionInfo.category,
      difficulty: sessionInfo.difficulty,
    );
    _inputBuffer = '';
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

  bool _isAnswerCorrect() {
    final problem = _problem;
    if (problem == null) {
      return false;
    }
    return isCorrectInfoAnswer(
      problem: problem,
      input: _inputBuffer,
    );
  }

  @override
  void dispose() {
    _disposed = true;
    _ticker?.cancel();
    super.dispose();
  }
}
