import 'package:flutter/material.dart';

import '../../../core/clock/clock.dart';
import '../../practice/domain/enums.dart';
import '../../records/data/record_repository.dart';
import '../../records/domain/practice_record.dart';
import '../../records/domain/record_aggregator.dart';
import '../presentation/ranking_presentation.dart';

class RankingContainer extends StatefulWidget {
  const RankingContainer({
    super.key,
    required this.recordRepository,
    required this.clock,
  });

  final RecordRepository recordRepository;
  final Clock clock;

  @override
  State<RankingContainer> createState() => _RankingContainerState();
}

class _RankingContainerState extends State<RankingContainer> {
  Category _category = Category.pseudocodeExecution;
  Difficulty _difficulty = Difficulty.normal;
  RankingRange _range = RankingRange.today;
  List<PracticeRecord> _records = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final records = await widget.recordRepository.loadRecords(
      category: _category,
      mode: PracticeMode.timeAttack10,
      difficulty: _difficulty,
    );
    final now = widget.clock.now();
    final filtered = switch (_range) {
      RankingRange.today => RecordAggregator.filterToday(records, now),
      RankingRange.thisWeek => RecordAggregator.filterThisWeek(records, now),
      RankingRange.all => records,
    }..sort((a, b) => a.clearTimeMillis.compareTo(b.clearTimeMillis));

    if (!mounted) return;
    setState(() {
      _records = filtered;
    });
  }

  void _setCategory(Category category) {
    setState(() {
      _category = category;
      _records = const [];
    });
    _load();
  }

  void _setDifficulty(Difficulty difficulty) {
    setState(() {
      _difficulty = difficulty;
      _records = const [];
    });
    _load();
  }

  void _setRange(RankingRange range) {
    setState(() {
      _range = range;
      _records = const [];
    });
    _load();
  }

  void _openWorldRanking() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WorldRankingComingSoonPresentation(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RankingPresentation(
      category: _category,
      difficulty: _difficulty,
      range: _range,
      records: _records,
      onCategoryChanged: _setCategory,
      onDifficultyChanged: _setDifficulty,
      onRangeChanged: _setRange,
      onOpenWorldRanking: _openWorldRanking,
    );
  }
}
