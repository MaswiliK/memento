// lib/main.dart
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/services/storage_service.dart';
import 'features/overlay/overlay_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.init();

  runApp(const MementoApp());
}

/// Entry point used by the Android overlay service.
@pragma("vm:entry-point")
Future<void> overlayMain() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive in the overlay engine
  await StorageService.init();

  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: OverlayScreen()),
  );
}
