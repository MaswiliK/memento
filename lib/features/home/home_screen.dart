// lib/features/home/home_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/storage_service.dart';
import '../../shared/widgets/note_card.dart';
import '../../shared/widgets/primary_button.dart';
import '../editor/editor_screen.dart';
import '../../core/services/overlay_service.dart';
import '../../shared/widgets/glass_toggle_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// AppLifecycleListener mixin to capture when the user resumes the application
class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool _overlayVisible = false;
  bool _isTogglingOverlay = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAndSyncOverlayState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  ///This lifecycle trigger runs whenever the app comes back to the foreground
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndSyncOverlayState();
    }
  }

  /// Queries the native Android window service to verify if the overlay is actually running
  Future<void> _checkAndSyncOverlayState() async {
    final activeOnSystem = await OverlayService.isActive();

    if (!mounted) return;
    setState(() {
      _overlayVisible = activeOnSystem;
    });
  }

  Future<void> _openEditor(BuildContext context) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, _) => const EditorScreen(),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 220),
      ),
    );

    //When returning from the EditorScreen back to the HomeScreen,
    // force a re-check to make sure the toggle switch state is still accurate.
    _checkAndSyncOverlayState();
  }

  Future<void> _toggleOverlay(bool value) async {
    if (_isTogglingOverlay) return;

    setState(() {
      _isTogglingOverlay = true;
    });

    try {
      if (value) {
        bool granted = await OverlayService.hasPermission();
        if (!granted) {
          granted = await OverlayService.requestPermission();
        }

        if (!granted) {
          if (mounted) {
            setState(() {
              _overlayVisible = false;
            });
          }
          return;
        }

        await OverlayService.show();
        await Future.delayed(const Duration(milliseconds: 600));

        final currentNote = StorageService.getNote();
        await OverlayService.sendData(currentNote);

        if (mounted) {
          setState(() {
            _overlayVisible = true;
          });
        }
      } else {
        await OverlayService.close();
        if (mounted) {
          setState(() {
            _overlayVisible = false;
          });
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTogglingOverlay = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D1117), Color(0xFF111827), Color(0xFF161B22)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.appName, style: theme.textTheme.headlineLarge),
                const SizedBox(height: AppSpacing.sm),
                Text(AppStrings.subtitle, style: theme.textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.xl),
                Expanded(
                  child: ValueListenableBuilder<String>(
                    valueListenable: StorageService.noteNotifier,
                    builder: (context, note, _) {
                      return NoteCard(note: note);
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  text: AppStrings.edit,
                  onPressed: () => _openEditor(context),
                ),
                const SizedBox(height: AppSpacing.md),
                GlassToggleCard(
                  title: 'Show Overlay',
                  subtitle: _overlayVisible
                      ? 'Memento is floating above your apps'
                      : 'Memento overlay is hidden',
                  value: _overlayVisible,
                  enabled: !_isTogglingOverlay,
                  onChanged: _toggleOverlay,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
