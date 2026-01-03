import 'package:flutter/material.dart';

import '../../domain/answer_input.dart';

const _cMain = Color(0xFF0284C7);
const _cGrayText = Color(0xFF64748B);

class AnswerInputField extends StatelessWidget {
  const AnswerInputField({
    super.key,
    required this.state,
  });

  final AnswerInputState state;

  @override
  Widget build(BuildContext context) {
    final displayText = state.text.isEmpty ? state.placeholder : state.text;
    final textColor = state.text.isEmpty
        ? _cGrayText.withValues(alpha: 0.7)
        : _cMain;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      alignment: Alignment.center,
      child: Text(
        displayText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
