import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/l10n/l10n.dart';
import '../../../widgets/pressable_surface.dart';
import '../../../widgets/wavy_background.dart';

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
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: _cBg,
      appBar: AppBar(
        title: Text(
          l10n.menuTitle,
          style: const TextStyle(color: _cMain, fontWeight: FontWeight.w800),
        ),
        backgroundColor: _cBg,
        elevation: 0,
        surfaceTintColor: _cBg,
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: WavyBackground(),
          ),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            children: [
              Text(
                l10n.menuGetStarted,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _cMain,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  _MenuButton(
                    label: l10n.categoryPseudocodeExecution,
                    description: l10n.menuPseudocodeDesc,
                    onTap: onOpenPseudocodeIntro,
                  ),
                  const SizedBox(height: 10),
                  _MenuButton(
                    label: l10n.categoryControlFlowTrace,
                    description: l10n.menuControlFlowDesc,
                    onTap: onOpenControlFlowIntro,
                  ),
                  const SizedBox(height: 10),
                  _MenuButton(
                    label: l10n.categoryBinaryToDecimal,
                    description: l10n.menuBinaryToDecimalDesc,
                    onTap: onOpenBinaryToDecimalIntro,
                  ),
                  const SizedBox(height: 10),
                  _MenuButton(
                    label: l10n.categoryDecimalToBinary,
                    description: l10n.menuDecimalToBinaryDesc,
                    onTap: onOpenDecimalToBinaryIntro,
                  ),
                  const SizedBox(height: 10),
                  _MenuButton(
                    label: l10n.categoryBinaryMixed,
                    description: l10n.menuBinaryMixedDesc,
                    onTap: onOpenBinaryMixedIntro,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                l10n.menuLinks,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _cMain,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  _MenuButton(
                    label: l10n.menuOfficialWebsite,
                    description: l10n.menuOfficialWebsiteDesc,
                    onTap: () => _launchUri(
                      context,
                      Uri.parse('https://hitasura-info.qboad.com/'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _MenuButton(
                    label: l10n.menuOtherApps,
                    description: l10n.menuOtherAppsDesc,
                    onTap: () => _launchUri(
                      context,
                      Uri.parse('https://keitamax.qboad.com/apps/'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                l10n.menuAbout,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _cMain,
                ),
              ),
              const SizedBox(height: 10),
              _MenuButton(
                label: l10n.menuLicenses,
                description: l10n.menuLicensesDesc,
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
  ).showSnackBar(SnackBar(content: Text(context.l10n.menuOpenLinkError)));
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
