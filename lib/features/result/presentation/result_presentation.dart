import 'package:flutter/material.dart';

import '../../practice/domain/enums.dart';
import '../../practice/domain/problem.dart';
import '../../../widgets/pressable_surface.dart';

const _cBg = Color(0xFFFFFFFF);
const _cMain = Color(0xFF0284C7);
const _cAccent = Color(0xFF38BDF8);
const _cGrayText = Color(0xFF64748B);
const _cGrayBorder = Color(0xFFE5E7EB);

class ResultPresentation extends StatelessWidget {
  const ResultPresentation({
    super.key,
    required this.result,
    this.banner,
    required this.onRetry,
    required this.onHome,
  });

  final PracticeResult result;
  final Widget? banner;
  final VoidCallback onRetry;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final totalSeconds = (result.elapsedMillis / 1000).toStringAsFixed(1);
    return Scaffold(
      backgroundColor: _cBg,
      appBar: AppBar(
        title: const Text(
          '結果',
          style: TextStyle(
            color: _cMain,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: _cBg,
        elevation: 0,
        surfaceTintColor: _cBg,
        centerTitle: false,
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(
              24,
              20,
              24,
              banner != null ? 110 : 24,
            ),
            children: [
              Text(
                _title(result.category),
                style: const TextStyle(
                  color: _cMain,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'おつかれさま！',
                style: TextStyle(color: _cGrayText),
              ),
              const SizedBox(height: 20),
              _SoftCard(
                child: Column(
                  children: [
                    if (result.mode == PracticeMode.infinite) ...[
                      _ResultHero(
                        label: '正解数',
                        value: '${result.correctCount}',
                      ),
                      const SizedBox(height: 12),
                      _ResultRow(
                        label: '最大連続正解',
                        value: '${result.maxStreak}',
                      ),
                      _ResultRow(label: '所要時間', value: '${totalSeconds}s'),
                    ] else ...[
                      _ResultHero(
                        label: '合計タイム',
                        value: '${totalSeconds}s',
                      ),
                      const SizedBox(height: 12),
                      _ResultRow(
                        label: '正解数',
                        value: '${result.correctCount}',
                      ),
                      _ResultRow(
                        label: '平均回答時間',
                        value: _averageTime(result),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: PressableSurface(
                      onTap: onHome,
                      borderRadius: BorderRadius.circular(20),
                      pressedOffset: const Offset(0, 0.05),
                      decorationBuilder: (pressed) => BoxDecoration(
                        color: _cBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _cGrayBorder),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x14000000),
                            blurRadius: pressed ? 2 : 6,
                            offset: Offset(0, pressed ? 1 : 3),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Center(
                          child: Text(
                            'Homeへ',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _cMain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PressableSurface(
                      onTap: onRetry,
                      borderRadius: BorderRadius.circular(20),
                      pressedOffset: const Offset(0, 0.05),
                      decorationBuilder: (pressed) => BoxDecoration(
                        color: _cAccent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x22000000),
                            blurRadius: pressed ? 4 : 10,
                            offset: Offset(0, pressed ? 2 : 5),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Center(
                          child: Text(
                            'もう一回',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (banner != null)
            SafeArea(
              top: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: banner!,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _averageTime(PracticeResult result) {
    if (result.answeredCount == 0) {
      return '-';
    }
    final averageMillis = result.elapsedMillis / result.answeredCount;
    return '${(averageMillis / 1000).toStringAsFixed(1)}s';
  }

  String _title(Category category) {
    switch (category) {
      case Category.pseudocodeExecution:
        return '疑似コードの実行結果';
      case Category.controlFlowTrace:
        return 'if / for / while の処理追跡';
      case Category.binaryToDecimal:
        return '2進数→10進数';
      case Category.decimalToBinary:
        return '10進数→2進数';
      case Category.binaryMixed:
        return '2進数/10進数ミックス';
    }
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: _cGrayText),
            ),
          ),
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

class _ResultHero extends StatelessWidget {
  const _ResultHero({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _cGrayText,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: _cMain,
            fontWeight: FontWeight.w800,
            fontSize: 36,
          ),
        ),
      ],
    );
  }
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
