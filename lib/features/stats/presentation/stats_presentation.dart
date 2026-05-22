import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/storage/stats_repository.dart';
import '../../practice/domain/enums.dart';
import '../../../widgets/pressable_surface.dart';
import '../../../widgets/wavy_background.dart';

const _cBg = Color(0xFFFFFFFF);
const _cMain = Color(0xFF0284C7);
const _cAccent = Color(0xFF38BDF8);
const _cGrayText = Color(0xFF64748B);
const _cGrayBorder = Color(0xFFE5E7EB);

class StatsPresentation extends StatelessWidget {
  const StatsPresentation({
    super.key,
    required this.summary,
    required this.heatmapStats,
    required this.heatmapEndDate,
    required this.onOpenCalendar,
  });

  final StatsSummary summary;
  final Map<DateTime, DailyStats> heatmapStats;
  final DateTime heatmapEndDate;
  final VoidCallback onOpenCalendar;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: _cBg,
      appBar: AppBar(
        title: Text(
          l10n.tabStats,
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
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _cBg,
                    _cMain.withValues(alpha: 0.03),
                    _cBg,
                  ],
                ),
              ),
            ),
          ),
          const Positioned.fill(
            child: WavyBackground(),
          ),
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: _cMain.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            children: [
              _sectionTitle(context, l10n.statsTodayTitle),
              _HeroStatCard(
                label: l10n.statsTodayCorrect,
                value: summary.todayCorrect.toString(),
              ),
              const SizedBox(height: 20),
              _sectionTitle(context, l10n.statsLast7DaysTitle),
              _BigStatCard(
                label: l10n.statsLast7DaysCorrect,
                value: summary.last7DaysCorrect.toString(),
              ),
              const SizedBox(height: 20),
              _sectionTitle(context, l10n.statsTotalTitle),
              _SoftCard(
                child: Column(
                  children: [
                    _StatRow(
                      label: l10n.statsTotalCorrect,
                      value: '${summary.totalsCorrect}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _sectionTitle(context, l10n.statsCalendarTitle),
              _SoftCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.statsRecentPace,
                      style: const TextStyle(
                        color: _cGrayText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _MiniHeatmap(
                      stats: heatmapStats,
                      endDate: heatmapEndDate,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: PressableSurface(
                        onTap: onOpenCalendar,
                        borderRadius: BorderRadius.circular(14),
                        pressedOffset: const Offset(0, 0.04),
                        decorationBuilder: (pressed) => BoxDecoration(
                          color: _cMain,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x22000000),
                              blurRadius: pressed ? 4 : 10,
                              offset: Offset(0, pressed ? 2 : 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            l10n.statsOpenCalendar,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _sectionTitle(context, l10n.statsBestRecords),
              _BestRecordsGrid(records: summary.bestRecords),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: _cMain,
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

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
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStatCard extends StatelessWidget {
  const _HeroStatCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _cMain.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.bolt, color: _cMain),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  fontSize: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BigStatCard extends StatelessWidget {
  const _BigStatCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _cGrayText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: _cMain,
              fontWeight: FontWeight.w800,
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class _BestRecordsGrid extends StatelessWidget {
  const _BestRecordsGrid({required this.records});

  final List<BestRecordEntry> records;

  @override
  Widget build(BuildContext context) {
    final grouped = <Category, List<BestRecordEntry>>{};
    for (final entry in records) {
      grouped.putIfAbsent(entry.category, () => []).add(entry);
    }

    return Column(
      children: [
        for (final category in Category.values)
          if (grouped.containsKey(category))
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _BestCategorySection(
                category: category,
                records: grouped[category]!,
              ),
            ),
      ],
    );
  }
}

class _BestCategorySection extends StatelessWidget {
  const _BestCategorySection({
    required this.category,
    required this.records,
  });

  final Category category;
  final List<BestRecordEntry> records;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.label(l10n),
            style: const TextStyle(
              color: _cMain,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final record in records) _BestChip(record: record),
            ],
          ),
        ],
      ),
    );
  }
}

class _BestChip extends StatelessWidget {
  const _BestChip({required this.record});

  final BestRecordEntry record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final label = '${record.mode.label(l10n)} / ${_difficulty(record.difficulty)}';
    final value = _formatRecord(context, record);
    return Container(
      constraints: const BoxConstraints(minWidth: 140),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _cBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cGrayBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: _cGrayText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: _cMain,
            ),
          ),
        ],
      ),
    );
  }

  String _formatRecord(BuildContext context, BestRecordEntry entry) {
    final l10n = context.l10n;
    if (entry.mode == PracticeMode.timeAttack10) {
      final best = entry.record.bestTimeMillis;
      if (best == null || best == 0) {
        return l10n.statsBestTimeNone;
      }
      return l10n.statsBestTime((best / 1000).toStringAsFixed(1));
    }
    final correct = entry.record.bestCorrectCount;
    final streak = entry.record.bestMaxStreak;
    if (correct == null || correct == 0) {
      return l10n.statsBestScoreNone;
    }
    return l10n.statsBestScore(correct, streak ?? 0);
  }

  String _difficulty(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.normal:
        return 'Normal';
      case Difficulty.hard:
        return 'Hard';
    }
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

class _MiniHeatmap extends StatelessWidget {
  const _MiniHeatmap({
    required this.stats,
    required this.endDate,
  });

  final Map<DateTime, DailyStats> stats;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    final start = end.subtract(const Duration(days: 30));
    final days = List<DateTime>.generate(
      31,
      (index) => start.add(Duration(days: index)),
    );

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final day in days)
          _HeatmapCell(
            count: stats[day]?.correct ?? 0,
          ),
      ],
    );
  }
}

class _HeatmapCell extends StatelessWidget {
  const _HeatmapCell({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final color = _heatColor(count);
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _cGrayBorder),
      ),
    );
  }

  Color _heatColor(int answered) {
    if (answered == 0) {
      return _cBg;
    }
    if (answered < 5) {
      return _tint(_cAccent, 0.55);
    }
    if (answered < 10) {
      return _tint(_cAccent, 0.3);
    }
    if (answered < 20) {
      return _cAccent;
    }
    return _shade(_cAccent, 0.22);
  }

  Color _tint(Color color, double amount) {
    return Color.lerp(color, Colors.white, amount) ?? color;
  }

  Color _shade(Color color, double amount) {
    return Color.lerp(color, Colors.black, amount) ?? color;
  }
}
