// lib/features/splash/splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';

import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _subtitleOpacity;

  bool _fadeOut = false;
  static const String _tagline = "Remember what matters.";
  String _animatedTagline = "";
  bool _showCursor = true;

  Timer? _cursorTimer;
  Timer? _typewriterTimer;

  /// Track and cancel the loop gracefully on dispose

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
    );

    _logoScale = Tween<double>(begin: .85, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOutBack),
      ),
    );

    _titleOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.05, 0.25, curve: Curves.easeOut),
    );

    _subtitleOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.35, curve: Curves.easeOut),
    );

    /// Post-frame callback ensures layout bounds are ready before animations start
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _startInitializationPipeline(),
    );
  }

  @override
  void dispose() {
    _cursorTimer?.cancel();
    _typewriterTimer
        ?.cancel(); // Terminate background typography loops instantly
    _controller.dispose();
    super.dispose();
  }

  void _startInitializationPipeline() async {
    if (!mounted) return;
    _controller.forward();
    _startCursorBlink();

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    await _runTypewriterEffect();

    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    setState(() {
      _fadeOut = true;
    });

    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;

    _cursorTimer?.cancel();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, _, _) => const HomeScreen(),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// Runs the typewriter animation cleanly without using manual nested awaits
  Future<void> _runTypewriterEffect() {
    final completer = Completer<void>();
    int characterIndex = 1;

    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 35), (
      timer,
    ) {
      if (!mounted) {
        timer.cancel();
        completer.complete();
        return;
      }

      setState(() {
        _animatedTagline = _tagline.substring(0, characterIndex);
      });

      if (characterIndex >= _tagline.length) {
        timer.cancel();
        completer.complete();
      } else {
        characterIndex++;
      }
    });

    return completer.future;
  }

  void _startCursorBlink() {
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted) return;
      setState(() {
        _showCursor = !_showCursor;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedOpacity(
      opacity: _fadeOut ? 0 : 1,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _logoOpacity,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Image.asset("assets/images/logo.png", width: 130),
                ),
              ),
              const SizedBox(height: 28),
              FadeTransition(
                opacity: _titleOpacity,
                child: Text("Memento", style: theme.textTheme.headlineLarge),
              ),
              const SizedBox(height: 10),
              FadeTransition(
                opacity: _subtitleOpacity,
                child: Text(
                  _animatedTagline == _tagline
                      ? _animatedTagline
                      : "$_animatedTagline${_showCursor ? '|' : ''}",
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
