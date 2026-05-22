import 'package:flutter/material.dart';
import 'package:flutter_example_app/l10n/app_localizations.dart';

class LocalizedTestApp extends StatelessWidget {
  const LocalizedTestApp({super.key, required this.home, this.locale});

  final Widget home;
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale ?? const Locale('ja'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );
  }
}
