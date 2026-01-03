import 'package:flutter/material.dart';

import '../../domain/answer_input.dart';

const _cBg = Color(0xFFFFFFFF);
const _cMain = Color(0xFF1E3A8A);
const _cGrayText = Color(0xFF64748B);
const _cGrayBorder = Color(0xFFE5E7EB);

class FactorizationAnswerFields extends StatelessWidget {
  const FactorizationAnswerFields({
    super.key,
    required this.state,
    required this.onSelect,
  });

  final FactorizationInputState state;
  final void Function(FactorField field) onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 8,
      children: [
        const Text('('),
        if (!state.lockA)
          _field(
            context,
            FactorField.a,
            state.a,
            key: const ValueKey('field_a'),
          ),
        const _VariableX(),
        SignFieldBox(
          value: state.signBIsNegative ? '-' : '+',
          isActive: state.activeField == FactorField.signB,
          onTap: () => onSelect(FactorField.signB),
          key: const ValueKey('sign_b'),
        ),
        _field(
          context,
          FactorField.b,
          state.b,
          key: const ValueKey('field_b'),
        ),
        const Text(')'),
        const SizedBox(width: 8),
        const Text('('),
        if (!state.lockC)
          _field(
            context,
            FactorField.c,
            state.c,
            key: const ValueKey('field_c'),
          ),
        const _VariableX(),
        SignFieldBox(
          value: state.signDIsNegative ? '-' : '+',
          isActive: state.activeField == FactorField.signD,
          onTap: () => onSelect(FactorField.signD),
          key: const ValueKey('sign_d'),
        ),
        _field(
          context,
          FactorField.d,
          state.d,
          key: const ValueKey('field_d'),
        ),
        const Text(')'),
      ],
    );
  }

  Widget _field(
    BuildContext context,
    FactorField field,
    int? value, {
    Key? key,
    bool locked = false,
  }) {
    final isActive = state.activeField == field;
    final display = value?.toString() ?? '';
    return AnswerFieldBox(
      key: key,
      value: display,
      isActive: isActive,
      isLocked: locked,
      onTap: locked ? null : () => onSelect(field),
    );
  }
}

class PrimeFactorAnswerFields extends StatelessWidget {
  const PrimeFactorAnswerFields({
    super.key,
    required this.state,
    required this.onSelect,
  });

  final PrimeInputState state;
  final void Function(int index) onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 8,
      children: [
        for (var i = 0; i < state.primes.length; i++)
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              Text(state.primes[i].toString()),
              const Text('^'),
              AnswerFieldBox(
                value: state.exponents[i].toString(),
                isActive: state.activeIndex == i,
                isLocked: false,
                onTap: () => onSelect(i),
              ),
            ],
          ),
      ],
    );
  }
}

class AnswerFieldBox extends StatelessWidget {
  const AnswerFieldBox({
    super.key,
    required this.value,
    required this.isActive,
    required this.isLocked,
    required this.onTap,
  });

  final String value;
  final bool isActive;
  final bool isLocked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final background = isLocked ? _cGrayBorder.withValues(alpha: 0.3) : _cBg;
    final borderColor = isActive ? _cMain : _cGrayBorder;

    return SizedBox(
      width: 52,
      height: 44,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: isActive ? 2 : 1),
            boxShadow: [
              if (isActive)
                BoxShadow(
                  color: _cMain.withValues(alpha: 0.18),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            value.isEmpty ? ' ' : value,
            style: TextStyle(
              color: isLocked ? _cGrayText : _cMain,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _VariableX extends StatelessWidget {
  const _VariableX();

  @override
  Widget build(BuildContext context) {
    return Text(
      'x',
      style: const TextStyle(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w800,
        color: _cMain,
      ),
    );
  }
}

class SignFieldBox extends StatelessWidget {
  const SignFieldBox({
    super.key,
    required this.value,
    required this.isActive,
    required this.onTap,
  });

  final String value;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor =
        isActive ? theme.colorScheme.primary : const Color(0xFFD8E3D0);
    return SizedBox(
      width: 36,
      height: 36,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: isActive ? 2 : 1),
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
