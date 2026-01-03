import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env', isOptional: true);
  final app = await App.bootstrap();
  runApp(app);
}
