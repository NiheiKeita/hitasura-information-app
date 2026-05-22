import 'package:flutter/material.dart';

import 'app.dart';

Future<void> main() async {
  final app = await App.bootstrap();
  runApp(app);
}
