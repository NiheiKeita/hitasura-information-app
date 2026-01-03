import 'package:flutter/material.dart';
import '../../../core/clock/clock.dart';
import '../../../core/storage/stats_repository.dart';
import '../presentation/stats_presentation.dart';

class StatsContainer extends StatefulWidget {
  const StatsContainer({
    super.key,
    required this.statsRepository,
    required this.clock,
    required this.onOpenCalendar,
  });

  final StatsRepository statsRepository;
  final Clock clock;
  final VoidCallback onOpenCalendar;

  @override
  State<StatsContainer> createState() => _StatsContainerState();
}

class _StatsContainerState extends State<StatsContainer> {
  StatsSummary? _summary;
  Map<DateTime, DailyStats> _heatmapStats = {};
  DateTime? _heatmapEndDate;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final now = widget.clock.now();
    final endDate = DateTime(now.year, now.month, now.day);
    final startDate = endDate.subtract(const Duration(days: 30));
    final results = await Future.wait([
      widget.statsRepository.loadSummary(now: now),
      widget.statsRepository.loadDailyStatsRange(
        start: startDate,
        end: endDate,
      ),
    ]);
    final summary = results[0] as StatsSummary;
    final heatmapStats = results[1] as Map<DateTime, DailyStats>;
    if (!mounted) {
      return;
    }
    setState(() {
      _summary = summary;
      _heatmapStats = heatmapStats;
      _heatmapEndDate = endDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final summary = _summary;
    if (summary == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return StatsPresentation(
      summary: summary,
      heatmapStats: _heatmapStats,
      heatmapEndDate: _heatmapEndDate ?? widget.clock.now(),
      onOpenCalendar: widget.onOpenCalendar,
    );
  }
}
