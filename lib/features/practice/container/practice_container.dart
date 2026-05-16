import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/ads/ad_service.dart';
import '../../../core/clock/clock.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/storage/stats_repository.dart';
import '../../records/data/record_repository.dart';
import '../../records/domain/practice_record.dart';
import '../../records/domain/record_comparison.dart';
import '../domain/answer_input.dart';
import '../domain/countdown_phase.dart';
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
    required this.recordRepository,
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
  final RecordRepository recordRepository;
  final Clock clock;
  final AdService adService;
  final void Function(PracticeResult result) onFinish;
  final VoidCallback onExit;

  @override
  State<PracticeContainer> createState() => _PracticeContainerState();
}

class _PracticeContainerState extends State<PracticeContainer> {
  PracticeController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) return;
    final l10n = context.l10n;
    _controller = PracticeController(
      category: widget.category,
      mode: widget.mode,
      difficulty: widget.difficulty,
      infoProblemGenerator: widget.infoProblemGenerator,
      statsRepository: widget.statsRepository,
      recordRepository: widget.recordRepository,
      clock: widget.clock,
      adService: widget.adService,
      onFinish: widget.onFinish,
      inputPlaceholder: l10n.practiceInputPlaceholder,
      progressInfiniteBuilder: (correct, streak) =>
          l10n.practiceProgressInfinite(correct, streak),
    );
    _controller!.start();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) {
      return const SizedBox.shrink();
    }
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return PracticePresentation(
          sessionInfo: controller.sessionInfo,
          questionText: controller.questionText,
          progressText: controller.progressText,
          elapsedText: controller.elapsedText,
          feedback: controller.feedback,
          countdownPhase: controller.countdownPhase,
          canSubmit: controller.canSubmit,
          onDigit: controller.onDigit,
          onBackspace: controller.onBackspace,
          onClear: controller.onClear,
          onSubmit: controller.onSubmit,
          onFinish: controller.finishManually,
          allowedDigits: controller.allowedDigits,
          inputState: controller.inputState,
        );
      },
    );
  }
}

typedef ProgressInfiniteBuilder = String Function(int correct, int streak);

class PracticeController extends ChangeNotifier {
  PracticeController({
    required Category category,
    required PracticeMode mode,
    required Difficulty difficulty,
    required InfoProblemGenerator infoProblemGenerator,
    required StatsRepository statsRepository,
    required RecordRepository recordRepository,
    required Clock clock,
    required AdService adService,
    required void Function(PracticeResult result) onFinish,
    required String inputPlaceholder,
    required ProgressInfiniteBuilder progressInfiniteBuilder,
  })  : sessionInfo = PracticeSessionInfo(
          category: category,
          mode: mode,
          difficulty: difficulty,
        ),
        _infoProblemGenerator = infoProblemGenerator,
        _statsRepository = statsRepository,
        _recordRepository = recordRepository,
        _clock = clock,
        _adService = adService,
        _onFinish = onFinish,
        _inputPlaceholder = inputPlaceholder,
        _progressInfiniteBuilder = progressInfiniteBuilder;

  final PracticeSessionInfo sessionInfo;
  final InfoProblemGenerator _infoProblemGenerator;
  final StatsRepository _statsRepository;
  final RecordRepository _recordRepository;
  final Clock _clock;
  final AdService _adService;
  final void Function(PracticeResult result) _onFinish;
  final String _inputPlaceholder;
  final ProgressInfiniteBuilder _progressInfiniteBuilder;

  InfoProblem? _problem;
  AnswerFeedback? _feedback;
  CountdownPhase? _countdownPhase;
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
    return _progressInfiniteBuilder(_correctCount, _currentStreak);
  }

  String get elapsedText {
    final minutes = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  AnswerInputState get inputState {
    return AnswerInputState(
      text: _inputBuffer,
      placeholder: _inputPlaceholder,
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

  CountdownPhase? get countdownPhase => _countdownPhase;

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
    _finishAsync(isManual: isManual);
  }

  Future<void> _finishAsync({required bool isManual}) async {
    _ticker?.cancel();
    _updateElapsed();
    final elapsedMillis = _elapsed.inMilliseconds;

    if (!(isManual && sessionInfo.mode == PracticeMode.timeAttack10)) {
      await _statsRepository.recordBest(
        category: sessionInfo.category,
        mode: sessionInfo.mode,
        difficulty: sessionInfo.difficulty,
        correctCount: _correctCount,
        maxStreak: _maxStreak,
        timeMillis: sessionInfo.mode == PracticeMode.timeAttack10
            ? elapsedMillis
            : null,
      );
    }

    RecordComparison? comparison;
    final shouldSaveRecord = !isManual &&
        sessionInfo.mode == PracticeMode.timeAttack10 &&
        elapsedMillis > 0;
    if (shouldSaveRecord) {
      final now = _clock.now();
      final previous = await _recordRepository.loadRecords(
        category: sessionInfo.category,
        mode: sessionInfo.mode,
      );
      comparison = RecordComparison.build(
        mode: sessionInfo.mode,
        currentTimeMillis: elapsedMillis,
        previousRecords: previous,
        now: now,
      );
      final record = PracticeRecord(
        id: '${now.microsecondsSinceEpoch}',
        category: sessionInfo.category,
        mode: sessionInfo.mode,
        clearTimeMillis: elapsedMillis,
        playedAt: now,
      );
      await _recordRepository.addRecord(record);
    }

    final result = PracticeResult(
      category: sessionInfo.category,
      mode: sessionInfo.mode,
      difficulty: sessionInfo.difficulty,
      answeredCount: _answeredCount,
      correctCount: _correctCount,
      maxStreak: _maxStreak,
      elapsedMillis: elapsedMillis,
      recordComparison: comparison,
    );

    if (_disposed) {
      return;
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
    _countdownPhase = CountdownPhase.ready;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1000));
    if (_disposed) {
      return;
    }
    _countdownPhase = CountdownPhase.go;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    if (_disposed) {
      return;
    }
    _countdownPhase = null;
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
