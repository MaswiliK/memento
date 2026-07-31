// lib/app/app.dart
import 'package:flutter/material.dart';

import 'theme.dart';
import '../features/splash/splash_screen.dart';

class MementoApp extends StatelessWidget {
  const MementoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memento',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const SplashScreen(),
    );
  }
}
