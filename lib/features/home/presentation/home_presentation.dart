import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/bubbly_background.dart';
import '../../../widgets/pressable_surface.dart';
import '../../practice/domain/enums.dart';

const _cBg = Color(0xFFFFFFFF);
const _cMain = Color(0xFF1E3A8A);
const _cAccent = Color(0xFF2DD4BF);
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
        title: Image.asset(
          'assets/images/logo_full.png',
          height: 36,
          fit: BoxFit.contain,
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
          const Positioned.fill(child: BubblyBackground()),
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
                            'ひたすら解く。ただそれだけ。',
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
                'カテゴリをえらぶ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _cMain,
                ),
              ),
              const SizedBox(height: 14),
              _CategoryCard(
                title: '因数分解',
                description: '因数分解をする',
                imagePath: 'assets/images/category/innsuubunnkai.png',
                onTap: () => onSelectCategory(Category.factorization),
              ),
              const SizedBox(height: 12),
              _CategoryCard(
                title: '素因数分解',
                description: 'N を素因数のべきに分解',
                imagePath: 'assets/images/category/soinnsuubunkai.png',
                onTap: () => onSelectCategory(Category.primeFactorization),
              ),
              const SizedBox(height: 12),
              const _ComingSoonCard(
                title: '微分',
                description: 'COMING SOON',
                imagePath: 'assets/images/category/bibunn.png',
              ),
              const SizedBox(height: 12),
              const _ComingSoonCard(
                title: '積分',
                description: 'COMING SOON',
                imagePath: 'assets/images/category/sekibun.png',
              ),
              const SizedBox(height: 12),
              const _ComingSoonCard(
                title: '定積分',
                description: 'COMING SOON',
                imagePath: 'assets/images/category/teisekibun.png',
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
    required this.onTap,
  });

  final String title;
  final String description;
  final String? imagePath;
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
          height: 60,
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _cAccent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'START',
                      style: TextStyle(
                        color: _cBg,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right, color: _cBg, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComingSoonCard extends StatelessWidget {
  const _ComingSoonCard({
    required this.title,
    required this.description,
    this.imagePath,
  });

  final String title;
  final String description;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _cBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _cGrayBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: imagePath != null
                  ? Padding(
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(imagePath!, fit: BoxFit.contain),
                    )
                  : Icon(
                      Icons.show_chart,
                      color: _cMain.withValues(alpha: 0.4),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: _cMain.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(color: _cGrayText.withValues(alpha: 0.7)),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _cMain.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'COMING SOON',
                style: TextStyle(
                  color: _cMain.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
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
