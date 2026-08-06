// lib/main.dart
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/services/storage_service.dart';
import 'features/overlay/overlay_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Main app engine initialization
  await StorageService.init(isOverlayIsolate: false);

  runApp(const MementoApp());
}

@pragma("vm:entry-point")
Future<void> overlayMain() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Overlay engine initialization
  await StorageService.init(isOverlayIsolate: true);

  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: OverlayScreen()),
  );
}
