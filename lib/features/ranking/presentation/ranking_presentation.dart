import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../widgets/pressable_surface.dart';
import '../../../widgets/wavy_background.dart';
import '../../practice/domain/enums.dart';
import '../../records/domain/practice_record.dart';

const _cBg = Color(0xFFFFFFFF);
const _cMain = Color(0xFF0284C7);
const _cGrayText = Color(0xFF64748B);
const _cGrayBorder = Color(0xFFE5E7EB);

enum RankingRange { today, thisWeek, all }

class RankingPresentation extends StatelessWidget {
  const RankingPresentation({
    super.key,
    required this.category,
    required this.difficulty,
    required this.range,
    required this.records,
    required this.onCategoryChanged,
    required this.onDifficultyChanged,
    required this.onRangeChanged,
    required this.onOpenWorldRanking,
  });

  final Category category;
  final Difficulty difficulty;
  final RankingRange range;
  final List<PracticeRecord> records;
  final ValueChanged<Category> onCategoryChanged;
  final ValueChanged<Difficulty> onDifficultyChanged;
  final ValueChanged<RankingRange> onRangeChanged;
  final VoidCallback onOpenWorldRanking;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: _cBg,
      appBar: AppBar(
        title: Text(
          l10n.rankingSelfTitle,
          style: const TextStyle(color: _cMain, fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              onPressed: onOpenWorldRanking,
              icon: const Icon(Icons.public, size: 18),
              label: Text(l10n.rankingWorldButton),
            ),
          ),
        ],
        backgroundColor: _cBg,
        elevation: 0,
        surfaceTintColor: _cBg,
        centerTitle: false,
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: WavyBackground()),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              _FilterCard(
                category: category,
                difficulty: difficulty,
                range: range,
                onCategoryChanged: onCategoryChanged,
                onDifficultyChanged: onDifficultyChanged,
                onRangeChanged: onRangeChanged,
              ),
              const SizedBox(height: 16),
              _SoftCard(
                child: records.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            l10n.rankingNoRecords,
                            style: const TextStyle(
                              color: _cGrayText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          for (var i = 0; i < records.length; i++)
                            _RecordRow(rank: i + 1, record: records[i]),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WorldRankingComingSoonPresentation extends StatelessWidget {
  const WorldRankingComingSoonPresentation({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: _cBg,
      appBar: AppBar(
        title: Text(
          l10n.rankingWorldButton,
          style: const TextStyle(color: _cMain, fontWeight: FontWeight.w800),
        ),
        backgroundColor: _cBg,
        elevation: 0,
        surfaceTintColor: _cBg,
        centerTitle: false,
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: WavyBackground()),
          Center(
            child: _SoftCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: _cMain.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      size: 36,
                      color: _cMain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.rankingComingSoon,
                    style: const TextStyle(
                      color: _cMain,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'COMING SOON',
                    style: TextStyle(color: _cGrayText),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({
    required this.category,
    required this.difficulty,
    required this.range,
    required this.onCategoryChanged,
    required this.onDifficultyChanged,
    required this.onRangeChanged,
  });

  final Category category;
  final Difficulty difficulty;
  final RankingRange range;
  final ValueChanged<Category> onCategoryChanged;
  final ValueChanged<Difficulty> onDifficultyChanged;
  final ValueChanged<RankingRange> onRangeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _SoftCard(
      child: Column(
        children: [
          DropdownButtonFormField<Category>(
            initialValue: category,
            decoration: InputDecoration(
              labelText: l10n.homeChooseCategory,
              border: const OutlineInputBorder(),
            ),
            items: [
              for (final c in Category.values)
                DropdownMenuItem(value: c, child: Text(c.label(l10n))),
            ],
            onChanged: (value) {
              if (value != null) onCategoryChanged(value);
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<Difficulty>(
            initialValue: difficulty,
            decoration: InputDecoration(
              labelText: l10n.modeDifficultyLabel,
              border: const OutlineInputBorder(),
            ),
            items: [
              for (final d in Difficulty.values)
                DropdownMenuItem(value: d, child: Text(_difficultyLabel(d))),
            ],
            onChanged: (value) {
              if (value != null) onDifficultyChanged(value);
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _RangeButton(
                label: l10n.rankingRangeToday,
                selected: range == RankingRange.today,
                onTap: () => onRangeChanged(RankingRange.today),
              ),
              const SizedBox(width: 8),
              _RangeButton(
                label: l10n.rankingRangeThisWeek,
                selected: range == RankingRange.thisWeek,
                onTap: () => onRangeChanged(RankingRange.thisWeek),
              ),
              const SizedBox(width: 8),
              _RangeButton(
                label: l10n.rankingRangeAll,
                selected: range == RankingRange.all,
                onTap: () => onRangeChanged(RankingRange.all),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _difficultyLabel(Difficulty difficulty) {
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

class _RangeButton extends StatelessWidget {
  const _RangeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PressableSurface(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        pressedOffset: const Offset(0, 0.03),
        decorationBuilder: (_) => BoxDecoration(
          color: selected ? _cMain : _cBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? _cMain : _cGrayBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? Colors.white : _cMain,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecordRow extends StatelessWidget {
  const _RecordRow({required this.rank, required this.record});

  final int rank;
  final PracticeRecord record;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final date =
        '${record.playedAt.year}/${record.playedAt.month.toString().padLeft(2, '0')}/${record.playedAt.day.toString().padLeft(2, '0')}';
    final seconds = (record.clearTimeMillis / 1000).toStringAsFixed(1);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _cGrayBorder)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 42,
            child: Text(
              l10n.rankingRank(rank),
              style: const TextStyle(
                color: _cMain,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Text(
              l10n.resultSecondsShort(seconds),
              style: const TextStyle(
                color: _cMain,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
          Text(date, style: const TextStyle(color: _cGrayText)),
        ],
      ),
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
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _cGrayBorder),
        ),
        child: child,
      ),
    );
  }
}
