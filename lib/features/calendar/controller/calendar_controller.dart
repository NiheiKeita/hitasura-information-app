import 'package:flutter/foundation.dart';

import '../../../core/clock/clock.dart';
import '../../../core/storage/stats_repository.dart';

class CalendarController extends ChangeNotifier {
  CalendarController({
    required StatsRepository statsRepository,
    required Clock clock,
  })  : _statsRepository = statsRepository,
        _clock = clock {
    final now = _clock.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
  }

  final StatsRepository _statsRepository;
  final Clock _clock;

  late DateTime _focusedMonth;
  Map<DateTime, DailyStats> _monthlyStats = {};
  bool _isLoading = true;
  bool _disposed = false;

  DateTime get focusedMonth => _focusedMonth;
  Map<DateTime, DailyStats> get monthlyStats => _monthlyStats;
  bool get isLoading => _isLoading;
  DateTime get today => _dateOnly(_clock.now());

  Future<void> start() async {
    await _loadMonth(_focusedMonth);
  }

  Future<void> goToPreviousMonth() async {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    await _loadMonth(_focusedMonth);
  }

  Future<void> goToNextMonth() async {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    await _loadMonth(_focusedMonth);
  }

  DailyStats? statsFor(DateTime date) {
    return _monthlyStats[_dateOnly(date)];
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> _loadMonth(DateTime month) async {
    _isLoading = true;
    notifyListeners();
    final stats = await _statsRepository.loadMonthlyStats(month: month);
    if (_disposed) {
      return;
    }
    _monthlyStats = stats;
    _isLoading = false;
    notifyListeners();
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
