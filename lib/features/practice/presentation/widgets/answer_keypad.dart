import 'package:flutter/material.dart';

import '../../../../widgets/pressable_surface.dart';

const _cBg = Color(0xFFFFFFFF);
const _cMain = Color(0xFF1E3A8A);
const _cAccent = Color(0xFF2DD4BF);
const _cGrayText = Color(0xFF64748B);
const _cGrayBorder = Color(0xFFE5E7EB);

class AnswerKeypad extends StatelessWidget {
  const AnswerKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    required this.onClear,
    required this.onSubmit,
    required this.canSubmit,
    this.onToggleSign,
  });

  final void Function(int digit) onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final VoidCallback onSubmit;
  final bool canSubmit;
  final VoidCallback? onToggleSign;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _digitRow(context, [1, 2, 3]),
            const SizedBox(height: 4),
            _digitRow(context, [4, 5, 6]),
            const SizedBox(height: 4),
            _digitRow(context, [7, 8, 9]),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: _actionButton('⌫', onBackspace)),
                const SizedBox(width: 8),
                Expanded(child: _digitButton(context, 0)),
                const SizedBox(width: 8),
                Expanded(child: _actionButton('クリア', onClear)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    '+/-',
                    onToggleSign,
                    isEnabled: onToggleSign != null,
                    isEmphasis: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: PressableSurface(
                    onTap: onSubmit,
                    enabled: canSubmit,
                    borderRadius: BorderRadius.circular(16),
                    pressedOffset: const Offset(0, 0.05),
                    decorationBuilder: (pressed) => BoxDecoration(
                      color: canSubmit ? _cAccent : _cGrayBorder,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: canSubmit
                          ? [
                              BoxShadow(
                                color: const Color(0x22000000),
                                blurRadius: pressed ? 4 : 10,
                                offset: Offset(0, pressed ? 2 : 5),
                              ),
                            ]
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: Center(
                        child: Text(
                          '回答する',
                          style: TextStyle(
                            color: canSubmit ? Colors.white : _cGrayText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _digitRow(BuildContext context, List<int> digits) {
    return Row(
      children: [
        for (var i = 0; i < digits.length; i++) ...[
          Expanded(child: _digitButton(context, digits[i])),
          if (i != digits.length - 1) const SizedBox(width: 8),
        ]
      ],
    );
  }

  Widget _digitButton(BuildContext context, int digit) {
    return PressableSurface(
      onTap: () => onDigit(digit),
      borderRadius: BorderRadius.circular(16),
      pressedOffset: const Offset(0, 0.05),
      decorationBuilder: (pressed) => BoxDecoration(
        color: _cBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cGrayBorder),
        boxShadow: [
          BoxShadow(
            color: const Color(0x12000000),
            blurRadius: pressed ? 2 : 6,
            offset: Offset(0, pressed ? 1 : 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Center(
          child: Text(
            digit.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: _cMain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton(
    String label,
    VoidCallback? onPressed, {
    bool isEnabled = true,
    bool isEmphasis = false,
  }) {
    return PressableSurface(
      onTap: onPressed ?? () {},
      enabled: isEnabled,
      borderRadius: BorderRadius.circular(16),
      pressedOffset: const Offset(0, 0.05),
      decorationBuilder: (pressed) => BoxDecoration(
        color: _cBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cGrayBorder),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: const Color(0x12000000),
                  blurRadius: pressed ? 2 : 6,
                  offset: Offset(0, pressed ? 1 : 3),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isEmphasis ? 16 : 13,
              fontWeight: isEmphasis ? FontWeight.w800 : FontWeight.w600,
              color: isEmphasis ? _cMain : _cGrayText,
            ),
          ),
        ),
      ),
    );
  }
}
