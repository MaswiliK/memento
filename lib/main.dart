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
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: OverlayScreen()),
  );
}
