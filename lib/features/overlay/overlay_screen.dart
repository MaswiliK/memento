// lib/features/overlay/overlay_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../../core/services/storage_service.dart';
import '../../shared/widgets/overlay_note_card.dart';

class OverlayScreen extends StatefulWidget {
  const OverlayScreen({super.key});

  @override
  State<OverlayScreen> createState() => _OverlayScreenState();
}

class _OverlayScreenState extends State<OverlayScreen> {
  StreamSubscription<dynamic>? _overlaySubscription;

  @override
  void initState() {
    super.initState();

    _overlaySubscription = FlutterOverlayWindow.overlayListener.listen((event) {
      if (event is String) {
        StorageService.noteNotifier.value = event;
      }
    });
  }

  @override
  void dispose() {
    _overlaySubscription?.cancel();
    FlutterOverlayWindow.disposeOverlayListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ValueListenableBuilder<String>(
          valueListenable: StorageService.noteNotifier,
          builder: (_, note, _) {
            return OverlayNoteCard(note: note);
          },
        ),
      ),
    );
  }
}
