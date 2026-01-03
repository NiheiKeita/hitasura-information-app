import 'package:flutter/material.dart';

import '../../../core/clock/clock.dart';
import '../../../core/storage/stats_repository.dart';
import '../controller/calendar_controller.dart';
import '../presentation/calendar_presentation.dart';

class CalendarContainer extends StatefulWidget {
  const CalendarContainer({
    super.key,
    required this.statsRepository,
    required this.clock,
  });

  final StatsRepository statsRepository;
  final Clock clock;

  @override
  State<CalendarContainer> createState() => _CalendarContainerState();
}

class _CalendarContainerState extends State<CalendarContainer> {
  late final CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController(
      statsRepository: widget.statsRepository,
      clock: widget.clock,
    );
    _controller.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openDayDetail(DateTime date) {
    final stats = _controller.statsFor(date);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return CalendarDayDetailSheet(date: date, stats: stats);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CalendarPresentation(
          focusedMonth: _controller.focusedMonth,
          today: _controller.today,
          monthlyStats: _controller.monthlyStats,
          isLoading: _controller.isLoading,
          onPrevMonth: _controller.goToPreviousMonth,
          onNextMonth: _controller.goToNextMonth,
          onSelectDate: _openDayDetail,
        );
      },
    );
  }
}
