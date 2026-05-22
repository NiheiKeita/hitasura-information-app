import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../widgets/pressable_surface.dart';
import '../../../widgets/wavy_background.dart';
import '../../practice/domain/enums.dart';
import '../../practice/domain/problem.dart';
import '../../records/domain/record_comparison.dart';

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
    final l10n = context.l10n;
    final totalSeconds = (result.elapsedMillis / 1000).toStringAsFixed(1);
    final comparison = result.recordComparison;
    return Scaffold(
      backgroundColor: _cBg,
      appBar: AppBar(
        title: Text(
          l10n.resultTitle,
          style: const TextStyle(
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
          const Positioned.fill(
            child: WavyBackground(),
          ),
          ListView(
            padding: EdgeInsets.fromLTRB(
              24,
              20,
              24,
              banner != null ? 110 : 24,
            ),
            children: [
              Text(
                result.category.label(l10n),
                style: const TextStyle(
                  color: _cMain,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.resultMessage,
                style: const TextStyle(color: _cGrayText),
              ),
              const SizedBox(height: 20),
              _SoftCard(
                child: Column(
                  children: [
                    if (result.mode == PracticeMode.infinite) ...[
                      _ResultHero(
                        label: l10n.resultCorrectCount,
                        value: '${result.correctCount}',
                      ),
                      const SizedBox(height: 12),
                      _ResultRow(
                        label: l10n.resultMaxStreak,
                        value: '${result.maxStreak}',
                      ),
                      _ResultRow(
                        label: l10n.resultElapsedTime,
                        value: l10n.resultSecondsShort(totalSeconds),
                      ),
                    ] else ...[
                      _ResultHero(
                        label: l10n.resultTotalTime,
                        value: l10n.resultSecondsShort(totalSeconds),
                      ),
                      const SizedBox(height: 12),
                      _ResultRow(
                        label: l10n.resultCorrectCount,
                        value: '${result.correctCount}',
                      ),
                      _ResultRow(
                        label: l10n.resultAverageTime,
                        value: _averageTime(context, result),
                      ),
                    ],
                  ],
                ),
              ),
              if (comparison != null) ...[
                const SizedBox(height: 16),
                _SelfBestCard(comparison: comparison),
              ],
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Center(
                          child: Text(
                            l10n.resultHomeButton,
                            style: const TextStyle(
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Center(
                          child: Text(
                            l10n.resultRetryButton,
                            style: const TextStyle(
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

  String _averageTime(BuildContext context, PracticeResult result) {
    if (result.answeredCount == 0) {
      return '-';
    }
    final averageMillis = result.elapsedMillis / result.answeredCount;
    return context.l10n
        .resultSecondsShort((averageMillis / 1000).toStringAsFixed(1));
  }
}

class _SelfBestCard extends StatelessWidget {
  const _SelfBestCard({required this.comparison});

  final RecordComparison comparison;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final celebrate = comparison.isAllTimeBest
        ? l10n.resultAllTimeBestUpdated
        : (comparison.isTodayBest ? l10n.resultTodayBestUpdated : null);
    final celebrateColor =
        comparison.isAllTimeBest ? _cAccent : _cMain.withValues(alpha: 0.85);

    String fmt(int millis) =>
        l10n.resultSecondsShort((millis / 1000).toStringAsFixed(1));

    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (celebrate != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: celebrateColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: celebrateColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    comparison.isAllTimeBest ? Icons.star : Icons.flash_on,
                    color: celebrateColor,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    celebrate,
                    style: TextStyle(
                      color: celebrateColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
          Text(
            l10n.resultSelfBestTitle,
            style: const TextStyle(
              color: _cMain,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          _ResultRow(
            label: l10n.resultBestToday,
            value: fmt(comparison.displayedTodayBestMillis),
          ),
          _ResultRow(
            label: l10n.resultBestThisWeek,
            value: fmt(comparison.displayedWeekBestMillis),
          ),
          _ResultRow(
            label: l10n.resultBestAllTime,
            value: fmt(comparison.displayedAllTimeBestMillis),
          ),
          const SizedBox(height: 8),
          _GapMessage(comparison: comparison),
        ],
      ),
    );
  }
}

class _GapMessage extends StatelessWidget {
  const _GapMessage({required this.comparison});

  final RecordComparison comparison;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String message;
    if (comparison.isAllTimeBest) {
      message = l10n.resultEncourageAllTimeBest;
    } else {
      final allTimeGap = comparison.gapToAllTimeBestMillis;
      final todayGap = comparison.gapToTodayBestMillis;
      if (allTimeGap != null && allTimeGap > 0) {
        message = l10n.resultEncourageGapAllTime(_seconds(allTimeGap));
      } else if (todayGap != null && todayGap > 0) {
        message = l10n.resultEncourageGapToday(_seconds(todayGap));
      } else {
        message = l10n.resultEncourageKeepGoing;
      }
    }
    return Text(
      message,
      style: TextStyle(
        color: _cMain.withValues(alpha: 0.75),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  String _seconds(int millis) => (millis / 1000).toStringAsFixed(1);
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
