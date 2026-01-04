import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/pressable_surface.dart';
import '../../../widgets/wavy_background.dart';
import '../../practice/domain/enums.dart';

const _cBg = Color(0xFFFFFFFF);
const _cMain = Color(0xFF0284C7);
const _cGrayText = Color(0xFF64748B);
const _cGrayBorder = Color(0xFFE5E7EB);

class HomePresentation extends StatelessWidget {
  const HomePresentation({
    super.key,
    required this.todayAnswered,
    required this.onSelectCategory,
    required this.onOpenStats,
    required this.onOpenRanking,
    required this.onOpenMenu,
  });

  final int todayAnswered;
  final void Function(Category category) onSelectCategory;
  final VoidCallback onOpenStats;
  final VoidCallback onOpenRanking;
  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cBg,
      appBar: AppBar(
        title: const Text(
          'ひたすら情報',
          style: TextStyle(
            color: _cMain,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        backgroundColor: _cBg,
        elevation: 0,
        surfaceTintColor: _cBg,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onOpenMenu();
            },
            icon: const Icon(Icons.menu, color: _cMain),
            tooltip: 'メニュー',
          ),
        ],
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
          const Positioned.fill(
            child: WavyBackground(),
          ),
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: _cMain.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: _cMain.withValues(alpha: 0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: _cGrayBorder.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            children: [
              _InfoBanner(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '考えずに、慣れろ。',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: _cMain,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '今日の正解: $todayAnswered',
                            style: const TextStyle(
                              color: _cGrayText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '単元をえらぶ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _cMain,
                ),
              ),
              const SizedBox(height: 14),
              _CategoryCard(
                title: '疑似コードの実行結果',
                description: '変数の最終値・出力を追う',
                imagePath: 'assets/images/code.png',
                onTap: () => onSelectCategory(Category.pseudocodeExecution),
                backgroundImagePath: 'assets/images/sand_bk.jpg',
              ),
              const SizedBox(height: 12),
              _CategoryCard(
                title: 'if / for / while の処理追跡',
                description: '分岐とループを読み解く',
                imagePath: 'assets/images/loop.png',
                onTap: () => onSelectCategory(Category.controlFlowTrace),
                backgroundImagePath: 'assets/images/sand_bk.jpg',
              ),
              const SizedBox(height: 12),
              _CategoryCard(
                title: '2進数→10進数',
                description: '2進数を10進数に変換',
                imagePath: 'assets/images/2_to_10.png',
                onTap: () => onSelectCategory(Category.binaryToDecimal),
                backgroundImagePath: 'assets/images/sand_bk.jpg',
              ),
              const SizedBox(height: 12),
              _CategoryCard(
                title: '10進数→2進数',
                description: '10進数を2進数に変換',
                imagePath: 'assets/images/10_to_2.png',
                onTap: () => onSelectCategory(Category.decimalToBinary),
                backgroundImagePath: 'assets/images/sand_bk.jpg',
              ),
              const SizedBox(height: 12),
              _CategoryCard(
                title: '2進数/10進数ミックス',
                description: '変換がランダムに出題',
                imagePath: 'assets/images/2_and_10.png',
                onTap: () => onSelectCategory(Category.binaryMixed),
                backgroundImagePath: 'assets/images/sand_bk.jpg',
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _SubActionCard(
                      icon: Icons.bar_chart,
                      label: 'Stats',
                      onTap: onOpenStats,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SubActionCard(
                      icon: Icons.emoji_events,
                      label: 'Ranking',
                      onTap: onOpenRanking,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.title,
    required this.description,
    this.imagePath,
    this.backgroundImagePath,
    required this.onTap,
  });

  final String title;
  final String description;
  final String? imagePath;
  final String? backgroundImagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableSurface(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      pressedOffset: const Offset(0, 0.05),
      decorationBuilder: (pressed) => BoxDecoration(
        color: _cBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cGrayBorder),
        image: backgroundImagePath != null
            ? DecorationImage(
                image: AssetImage(backgroundImagePath!),
                fit: BoxFit.cover,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: const Color(0x14000000),
            blurRadius: pressed ? 4 : 10,
            offset: Offset(0, pressed ? 2 : 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 92,
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: imagePath != null
                    ? Padding(
                        padding: const EdgeInsets.all(2),
                        child: Image.asset(imagePath!, fit: BoxFit.contain),
                      )
                    : const Icon(Icons.calculate, color: _cMain),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _cMain,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(color: _cGrayText),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: _cGrayText),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cGrayBorder),
      ),
      child: child,
    );
  }
}

class _SubActionCard extends StatelessWidget {
  const _SubActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableSurface(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      pressedOffset: const Offset(0, 0.05),
      decorationBuilder: (pressed) => BoxDecoration(
        color: _cBg,
        borderRadius: BorderRadius.circular(16),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _cGrayText, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: _cGrayText,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
