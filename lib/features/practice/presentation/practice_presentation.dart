import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../domain/answer_input.dart';
import '../domain/scoring.dart';
import '../domain/enums.dart';
import 'widgets/answer_fields.dart';
import 'widgets/answer_keypad.dart';

const _cBg = Color(0xFFFFFFFF);
const _cMain = Color(0xFF1E3A8A);
const _cAccent = Color(0xFF2DD4BF);
const _cGrayText = Color(0xFF64748B);
const _cGrayBorder = Color(0xFFE5E7EB);

class PracticePresentation extends StatefulWidget {
  const PracticePresentation({
    super.key,
    required this.sessionInfo,
    required this.questionText,
    required this.progressText,
    required this.elapsedText,
    required this.feedback,
    required this.countdownText,
    required this.quadraticCoefficients,
    required this.canSubmit,
    required this.onDigit,
    required this.onBackspace,
    required this.onClear,
    required this.onSubmit,
    required this.onFinish,
    required this.onSelectFactorField,
    required this.onSelectPrimeField,
    required this.onToggleSign,
    this.factorizationInput,
    this.primeInput,
  });

  final PracticeSessionInfo sessionInfo;
  final String questionText;
  final String progressText;
  final String elapsedText;
  final AnswerFeedback? feedback;
  final String? countdownText;
  final ExpandedCoefficients? quadraticCoefficients;
  final bool canSubmit;
  final void Function(int digit) onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final VoidCallback onSubmit;
  final VoidCallback onFinish;
  final void Function(FactorField field) onSelectFactorField;
  final void Function(int index) onSelectPrimeField;
  final VoidCallback? onToggleSign;
  final FactorizationInputState? factorizationInput;
  final PrimeInputState? primeInput;

  @override
  State<PracticePresentation> createState() => _PracticePresentationState();
}

class _PracticePresentationState extends State<PracticePresentation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 160),
    );
    _scale = Tween(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant PracticePresentation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.feedback != widget.feedback &&
        widget.feedback == AnswerFeedback.correct) {
      _playCorrectFeedback();
    }
  }

  Future<void> _playCorrectFeedback() async {
    HapticFeedback.lightImpact();
    await _controller.forward();
    await _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cBg,
      appBar: AppBar(
        title: Text(
          _title(widget.sessionInfo.category),
          style: const TextStyle(
            color: _cMain,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: _cBg,
        elevation: 0,
        surfaceTintColor: _cBg,
        centerTitle: false,
        actions: [
          if (widget.sessionInfo.mode == PracticeMode.infinite ||
              widget.sessionInfo.mode == PracticeMode.timeAttack10)
            TextButton(
              onPressed: widget.onFinish,
              style: TextButton.styleFrom(
                foregroundColor: _cMain,
              ),
              child: const Text(
                'Finish',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatusTile(
                        icon: Icons.check_circle_outline,
                        value: widget.progressText,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatusTile(
                        icon: Icons.timer_outlined,
                        value: widget.elapsedText,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SoftCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              '問題',
                              style: TextStyle(
                                color: _cGrayText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (widget.quadraticCoefficients != null)
                              _QuadraticText(
                                coefficients: widget.quadraticCoefficients!,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                  color: _cMain,
                                ),
                              )
                            else
                              Text(
                                widget.questionText,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                  color: _cMain,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '答え',
                        style: TextStyle(
                          color: _cMain,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ScaleTransition(
                        scale: _scale,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _cBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _cGrayBorder,
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Builder(
                            builder: (context) {
                              if (widget.factorizationInput != null) {
                                return FactorizationAnswerFields(
                                  state: widget.factorizationInput!,
                                  onSelect: widget.onSelectFactorField,
                                );
                              }
                              if (widget.primeInput != null) {
                                return PrimeFactorAnswerFields(
                                  state: widget.primeInput!,
                                  onSelect: widget.onSelectPrimeField,
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '下のキーパッドで入力',
                        style: TextStyle(color: _cGrayText),
                      ),
                    ],
                  ),
                ),
              ),
              AnswerKeypad(
                onDigit: widget.onDigit,
                onBackspace: widget.onBackspace,
                onClear: widget.onClear,
                onSubmit: widget.onSubmit,
                onToggleSign: widget.onToggleSign,
                canSubmit: widget.canSubmit,
              ),
            ],
          ),
          if (widget.feedback != null)
            _FeedbackOverlay(feedback: widget.feedback!),
          if (widget.countdownText != null)
            _CountdownOverlay(text: widget.countdownText!),
        ],
      ),
    );
  }

  String _title(Category category) {
    switch (category) {
      case Category.factorization:
        return '因数分解';
      case Category.primeFactorization:
        return '素因数分解';
    }
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({
    required this.icon,
    required this.value,
  });

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: _cBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: _cGrayText, size: 18),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: _cMain,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackOverlay extends StatelessWidget {
  const _FeedbackOverlay({required this.feedback});

  final AnswerFeedback feedback;

  @override
  Widget build(BuildContext context) {
    final asset = feedback == AnswerFeedback.correct
        ? 'assets/images/maru.png'
        : 'assets/images/batu.png';
    final overlay = feedback == AnswerFeedback.correct
        ? _cAccent.withValues(alpha: 0.12)
        : Colors.black.withValues(alpha: 0.08);
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 150),
          child: Container(
            color: overlay,
            alignment: Alignment.center,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(asset),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CountdownOverlay extends StatelessWidget {
  const _CountdownOverlay({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final asset = _assetForText(text);
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          color: Colors.black.withValues(alpha: 0.2),
          alignment: Alignment.center,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxSide =
                  constraints.biggest.shortestSide * (asset.isReady ? 0.75 : 0.8);
              return SizedBox(
                width: maxSide,
                height: maxSide,
                child: asset.path != null
                    ? Image.asset(asset.path!, fit: BoxFit.contain)
                    : Text(
                        text,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  _CountdownAsset _assetForText(String text) {
    if (text == 'よーい') {
      return const _CountdownAsset(
        path: 'assets/images/ready.png',
        isReady: true,
      );
    }
    if (text == 'スタート！') {
      return const _CountdownAsset(
        path: 'assets/images/go.png',
        isReady: false,
      );
    }
    return const _CountdownAsset(path: null, isReady: false);
  }
}

class _CountdownAsset {
  const _CountdownAsset({required this.path, required this.isReady});

  final String? path;
  final bool isReady;
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _cBg,
      elevation: 1.5,
      shadowColor: const Color(0x14000000),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _cGrayBorder),
        ),
        child: child,
      ),
    );
  }
}

class _QuadraticText extends StatelessWidget {
  const _QuadraticText({
    required this.coefficients,
    required this.style,
  });

  final ExpandedCoefficients coefficients;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    _appendTerm(spans, coefficients.A, variable: 'x', power: '2', isFirst: true);
    _appendTerm(spans, coefficients.B, variable: 'x');
    _appendTerm(spans, coefficients.C, variable: '');

    return RichText(
      text: TextSpan(
        style: style,
        children: spans,
      ),
    );
  }

  void _appendTerm(
    List<InlineSpan> spans,
    int coefficient, {
    required String variable,
    String? power,
    bool isFirst = false,
  }) {
    if (coefficient == 0) {
      return;
    }
    final absValue = coefficient.abs();
    final sign = coefficient < 0 ? '-' : '+';

    if (isFirst) {
      if (coefficient < 0) {
        spans.add(TextSpan(text: '-'));
      }
    } else {
      spans.add(TextSpan(text: ' $sign '));
    }

    if (absValue != 1 || variable.isEmpty) {
      spans.add(TextSpan(text: absValue.toString()));
    }
    if (variable.isNotEmpty) {
      spans.add(TextSpan(text: variable));
      if (power != null) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.top,
            child: Transform.translate(
              offset: const Offset(0, -6),
              child: Text(
                power,
                style: style?.copyWith(fontSize: (style?.fontSize ?? 20) * 0.65),
              ),
            ),
          ),
        );
      }
    }
  }
}
