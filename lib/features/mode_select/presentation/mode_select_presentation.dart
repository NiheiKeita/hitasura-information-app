import 'package:flutter/material.dart';

import '../../practice/domain/enums.dart';
import '../../../widgets/pressable_surface.dart';

const _cBg = Color(0xFFFFFFFF);
const _cMain = Color(0xFF0284C7);
const _cAccent = Color(0xFF38BDF8);
const _cGrayText = Color(0xFF64748B);
const _cGrayBorder = Color(0xFFE5E7EB);

class ModeSelectPresentation extends StatelessWidget {
  const ModeSelectPresentation({
    super.key,
    required this.category,
    required this.mode,
    required this.difficulty,
    required this.onModeChanged,
    required this.onDifficultyChanged,
    required this.onStart,
  });

  final Category category;
  final PracticeMode mode;
  final Difficulty difficulty;
  final void Function(PracticeMode mode) onModeChanged;
  final void Function(Difficulty difficulty) onDifficultyChanged;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cBg,
      appBar: AppBar(
        title: const Text(
          'モード選択',
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          Text(
            _categoryLabel(category),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _cMain,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'モードと難易度を選ぶ',
            style: TextStyle(color: _cGrayText),
          ),
          const SizedBox(height: 20),
          _SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'モード',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _cMain,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ModeOptionCard(
                        label: '10問TA',
                        description: 'テンポ重視',
                        selected: mode == PracticeMode.timeAttack10,
                        onTap: () => onModeChanged(PracticeMode.timeAttack10),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ModeOptionCard(
                        label: '無限',
                        description: 'ずっと解く',
                        selected: mode == PracticeMode.infinite,
                        onTap: () => onModeChanged(PracticeMode.infinite),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '難易度',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _cMain,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _OptionButton(
                        label: 'Easy',
                        selected: difficulty == Difficulty.easy,
                        onTap: () => onDifficultyChanged(Difficulty.easy),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _OptionButton(
                        label: 'Normal',
                        selected: difficulty == Difficulty.normal,
                        onTap: () => onDifficultyChanged(Difficulty.normal),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _OptionButton(
                        label: 'Hard',
                        selected: difficulty == Difficulty.hard,
                        onTap: () => onDifficultyChanged(Difficulty.hard),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: PressableSurface(
              onTap: onStart,
              borderRadius: BorderRadius.circular(20),
              pressedOffset: const Offset(0, 0.04),
              decorationBuilder: (pressed) => BoxDecoration(
                color: _cAccent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x22000000),
                    blurRadius: pressed ? 4 : 10,
                    offset: Offset(0, pressed ? 2 : 6),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'スタート',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _categoryLabel(Category category) {
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

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: PressableSurface(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        pressedOffset: const Offset(0, 0.05),
        decorationBuilder: (pressed) => BoxDecoration(
          color: selected ? _cMain.withValues(alpha: 0.08) : _cBg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? _cMain : _cGrayBorder,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x14000000),
              blurRadius: pressed ? 2 : 6,
              offset: Offset(0, pressed ? 1 : 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? _cMain : _cGrayText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ModeOptionCard extends StatelessWidget {
  const _ModeOptionCard({
    required this.label,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableSurface(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      pressedOffset: const Offset(0, 0.06),
      decorationBuilder: (pressed) => BoxDecoration(
        color: selected ? _cMain.withValues(alpha: 0.08) : _cBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? _cMain : _cGrayBorder,
          width: 2,
        ),
        boxShadow: selected
            ? null
            : [
                BoxShadow(
                  color: const Color(0x22000000),
                  blurRadius: pressed ? 6 : 12,
                  offset: Offset(0, pressed ? 2 : 6),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: _cMain,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(color: _cGrayText, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
