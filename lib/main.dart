import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(
    fileName: '.env',
  );

  // Initialize Hive
  await Hive.initFlutter();

  // Start application
  runApp(
    const ProviderScope(
      child: NewsIntelligenceApp(),
    ),
  );
}