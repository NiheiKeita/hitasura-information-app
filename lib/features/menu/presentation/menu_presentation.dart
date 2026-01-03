import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/bubbly_background.dart';
import '../../../widgets/pressable_surface.dart';

const _cBg = Color(0xFFFFFFFF);
const _cMain = Color(0xFF0284C7);
const _cGrayText = Color(0xFF64748B);
const _cGrayBorder = Color(0xFFE5E7EB);

class MenuPresentation extends StatelessWidget {
  const MenuPresentation({
    super.key,
    required this.onOpenPseudocodeIntro,
    required this.onOpenControlFlowIntro,
    required this.onOpenBinaryToDecimalIntro,
    required this.onOpenDecimalToBinaryIntro,
    required this.onOpenBinaryMixedIntro,
    required this.onOpenLicenses,
  });

  final VoidCallback onOpenPseudocodeIntro;
  final VoidCallback onOpenControlFlowIntro;
  final VoidCallback onOpenBinaryToDecimalIntro;
  final VoidCallback onOpenDecimalToBinaryIntro;
  final VoidCallback onOpenBinaryMixedIntro;
  final VoidCallback onOpenLicenses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cBg,
      appBar: AppBar(
        title: const Text(
          'メニュー',
          style: TextStyle(color: _cMain, fontWeight: FontWeight.w800),
        ),
        backgroundColor: _cBg,
        elevation: 0,
        surfaceTintColor: _cBg,
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: BubblyBackground(),
          ),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            children: [
              const Text(
                'はじめに',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _cMain,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  _MenuButton(
                    label: '疑似コードの実行結果',
                    description: '変数と出力を追う',
                    onTap: onOpenPseudocodeIntro,
                  ),
                  const SizedBox(height: 10),
                  _MenuButton(
                    label: 'if / for / while の処理追跡',
                    description: '分岐とループの流れ',
                    onTap: onOpenControlFlowIntro,
                  ),
                  const SizedBox(height: 10),
                  _MenuButton(
                    label: '2進数→10進数',
                    description: '2進数を10進数へ',
                    onTap: onOpenBinaryToDecimalIntro,
                  ),
                  const SizedBox(height: 10),
                  _MenuButton(
                    label: '10進数→2進数',
                    description: '10進数を2進数へ',
                    onTap: onOpenDecimalToBinaryIntro,
                  ),
                  const SizedBox(height: 10),
                  _MenuButton(
                    label: '2進数/10進数ミックス',
                    description: 'ランダム出題',
                    onTap: onOpenBinaryMixedIntro,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'リンク',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _cMain,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  _MenuButton(
                    label: '公式WEBサイト',
                    description: '最新情報はこちら',
                    onTap: () => _launchUri(
                      context,
                      Uri.parse('https://hitasura-info.qboad.com/'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _MenuButton(
                    label: '他のアプリ一覧',
                    description: 'シリーズをチェック',
                    onTap: () => _launchUri(
                      context,
                      Uri.parse('https://keitamax.qboad.com/apps/'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'このアプリについて',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _cMain,
                ),
              ),
              const SizedBox(height: 10),
              _MenuButton(
                label: 'ライセンス',
                description: '使用しているライブラリ',
                onTap: onOpenLicenses,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _launchUri(BuildContext context, Uri uri) async {
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!context.mounted || ok) {
    return;
  }
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('リンクを開けませんでした')));
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.description,
    required this.onTap,
  });

  final String label;
  final String description;
  final VoidCallback? onTap;
  final bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    final textColor = isEnabled ? _cMain : _cGrayText.withValues(alpha: 0.6);
    final descColor = isEnabled
        ? _cGrayText
        : _cGrayText.withValues(alpha: 0.5);
    return PressableSurface(
      onTap: onTap ?? () {},
      enabled: isEnabled && onTap != null,
      borderRadius: BorderRadius.circular(16),
      pressedOffset: const Offset(0, 0.05),
      decorationBuilder: (pressed) => BoxDecoration(
        color: _cBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEnabled
              ? _cGrayBorder
              : _cGrayBorder.withValues(alpha: 0.6),
        ),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: const Color(0x14000000),
                  blurRadius: pressed ? 2 : 6,
                  offset: Offset(0, pressed ? 1 : 3),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(color: descColor)),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isEnabled ? _cGrayText : _cGrayText.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}
