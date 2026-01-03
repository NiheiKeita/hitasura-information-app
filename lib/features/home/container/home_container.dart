import 'package:flutter/material.dart';

import '../../../core/clock/clock.dart';
import '../../../core/storage/stats_repository.dart';
import '../../practice/domain/enums.dart';
import '../presentation/home_presentation.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({
    super.key,
    required this.statsRepository,
    required this.clock,
    required this.onSelectCategory,
    required this.onOpenStats,
    required this.onOpenRanking,
    required this.onOpenMenu,
  });

  final StatsRepository statsRepository;
  final Clock clock;
  final void Function(Category category) onSelectCategory;
  final VoidCallback onOpenStats;
  final VoidCallback onOpenRanking;
  final VoidCallback onOpenMenu;

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  int _todayAnswered = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final summary = await widget.statsRepository.loadSummary(
      now: widget.clock.now(),
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _todayAnswered = summary.todayAnswered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomePresentation(
      todayAnswered: _todayAnswered,
      onSelectCategory: widget.onSelectCategory,
      onOpenStats: widget.onOpenStats,
      onOpenRanking: widget.onOpenRanking,
      onOpenMenu: widget.onOpenMenu,
    );
  }
}
