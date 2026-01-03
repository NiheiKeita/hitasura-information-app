import 'package:flutter/material.dart';

import '../../../core/storage/stats_repository.dart';
import '../../practice/domain/enums.dart';

const _cBg = Color(0xFFFFFFFF);
const _cMain = Color(0xFF1E3A8A);
const _cAccent = Color(0xFF2DD4BF);
const _cGrayText = Color(0xFF64748B);
const _cGrayBorder = Color(0xFFE5E7EB);

class CalendarPresentation extends StatelessWidget {
  const CalendarPresentation({
    super.key,
    required this.focusedMonth,
    required this.today,
    required this.monthlyStats,
    required this.isLoading,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onSelectDate,
  });

  final DateTime focusedMonth;
  final DateTime today;
  final Map<DateTime, DailyStats> monthlyStats;
  final bool isLoading;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final void Function(DateTime date) onSelectDate;

  @override
  Widget build(BuildContext context) {
    final dates = _buildCalendarDates(focusedMonth);
    return Scaffold(
      backgroundColor: _cBg,
      appBar: AppBar(
        title: const Text(
          '学習カレンダー',
          style: TextStyle(color: _cMain, fontWeight: FontWeight.w800),
        ),
        backgroundColor: _cBg,
        elevation: 0,
        surfaceTintColor: _cBg,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_cBg, _cMain.withValues(alpha: 0.03), _cBg],
                ),
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              _MonthHeader(
                label: _formatMonth(focusedMonth),
                onPrev: onPrevMonth,
                onNext: onNextMonth,
              ),
              const SizedBox(height: 12),
              _WeekdayRow(),
              const SizedBox(height: 6),
              _CalendarGrid(
                dates: dates,
                today: today,
                monthlyStats: monthlyStats,
                onSelectDate: onSelectDate,
              ),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatMonth(DateTime month) {
    return '${month.year}年${month.month}月';
  }

  List<DateTime?> _buildCalendarDates(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final totalDays = DateTime(month.year, month.month + 1, 0).day;
    final startOffset = firstDay.weekday % 7;
    final dates = List<DateTime?>.filled(42, null);
    for (var day = 1; day <= totalDays; day++) {
      final index = startOffset + (day - 1);
      dates[index] = DateTime(month.year, month.month, day);
    }
    return dates;
  }
}

class CalendarDayDetailSheet extends StatelessWidget {
  const CalendarDayDetailSheet({
    super.key,
    required this.date,
    required this.stats,
  });

  final DateTime date;
  final DailyStats? stats;

  @override
  Widget build(BuildContext context) {
    final dateText = _formatDate(date);
    final data = stats;
    final hasStudy = data != null && data.answered > 0;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          32 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: _cGrayBorder,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              dateText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _cMain,
              ),
            ),
            const SizedBox(height: 12),
            if (!hasStudy)
              const Text(
                'この日はまだ解いていません',
                style: TextStyle(
                  color: _cGrayText,
                  fontWeight: FontWeight.w600,
                ),
              )
            else ...[
              _SummaryRow(label: '合計', value: '解いた数 ${data.answered}問'),
              _SummaryRow(label: '正解数', value: '${data.correct}問'),
              const SizedBox(height: 12),
              const Text(
                '内訳',
                style: TextStyle(color: _cMain, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              _SummaryRow(
                label: '因数分解',
                value: '${data.categoryCounts[Category.factorization] ?? 0}問',
              ),
              _SummaryRow(
                label: '素因数分解',
                value:
                    '${data.categoryCounts[Category.primeFactorization] ?? 0}問',
              ),
              const SizedBox(height: 12),
              const Text(
                'モード内訳',
                style: TextStyle(color: _cMain, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              _SummaryRow(
                label: '無限',
                value: '${data.modeCounts[PracticeMode.infinite] ?? 0}問',
              ),
              _SummaryRow(
                label: '10問タイムアタック',
                value: '${data.modeCounts[PracticeMode.timeAttack10] ?? 0}問',
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year/$month/$day';
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: const TextStyle(color: _cGrayText)),
          ),
          Text(
            value,
            style: const TextStyle(color: _cMain, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.label,
    required this.onPrev,
    required this.onNext,
  });

  final String label;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left, color: _cMain, size: 30),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: _cMain,
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right, color: _cMain, size: 30),
        ),
      ],
    );
  }
}

class _WeekdayRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const labels = ['日', '月', '火', '水', '木', '金', '土'];
    return Row(
      children: [
        for (final label in labels)
          Expanded(
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: _cGrayText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.dates,
    required this.today,
    required this.monthlyStats,
    required this.onSelectDate,
  });

  final List<DateTime?> dates;
  final DateTime today;
  final Map<DateTime, DailyStats> monthlyStats;
  final void Function(DateTime date) onSelectDate;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dates.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        final date = dates[index];
        if (date == null) {
          return const SizedBox.shrink();
        }
        final stats = monthlyStats[DateTime(date.year, date.month, date.day)];
        final answered = stats?.answered ?? 0;
        final isToday = _isSameDay(today, date);
        final color = _heatColor(answered);
        return GestureDetector(
          onTap: () => onSelectDate(date),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: isToday
                  ? Border.all(color: _cMain, width: 2)
                  : Border.all(color: _cGrayBorder),
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: _dateTextColor(answered),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Color _heatColor(int answered) {
    if (answered == 0) {
      return _cBg;
    }
    if (answered <= 20) {
      return _tint(_cAccent, 0.55);
    }
    if (answered <= 50) {
      return _tint(_cAccent, 0.3);
    }
    if (answered <= 100) {
      return _cAccent;
    }
    return _shade(_cAccent, 0.22);
  }

  Color _dateTextColor(int answered) {
    if (answered == 0) {
      return _tint(_cAccent, 0.5);
    }
    if (answered <= 20) {
      return _tint(_cAccent, 0.25);
    }
    if (answered <= 50) {
      return _cAccent;
    }
    return Colors.white;
  }

  Color _tint(Color color, double amount) {
    return Color.lerp(color, Colors.white, amount) ?? color;
  }

  Color _shade(Color color, double amount) {
    return Color.lerp(color, Colors.black, amount) ?? color;
  }
}
