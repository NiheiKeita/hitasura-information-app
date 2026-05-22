import 'package:flutter/material.dart';
import 'package:flutter_example_app/l10n/app_localizations.dart';

import '../../features/practice/domain/enums.dart';

extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension CategoryL10n on Category {
  String label(AppLocalizations l10n) {
    switch (this) {
      case Category.pseudocodeExecution:
        return l10n.categoryPseudocodeExecution;
      case Category.controlFlowTrace:
        return l10n.categoryControlFlowTrace;
      case Category.binaryToDecimal:
        return l10n.categoryBinaryToDecimal;
      case Category.decimalToBinary:
        return l10n.categoryDecimalToBinary;
      case Category.binaryMixed:
        return l10n.categoryBinaryMixed;
    }
  }
}

extension PracticeModeL10n on PracticeMode {
  String label(AppLocalizations l10n) {
    switch (this) {
      case PracticeMode.infinite:
        return l10n.modePracticeModeInfinite;
      case PracticeMode.timeAttack10:
        return l10n.modePracticeMode10;
    }
  }
}
