// lib/features/overlay/overlay_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../../core/services/storage_service.dart';
import '../../shared/widgets/overlay_note_card.dart';
import '../../shared/widgets/overlay_editor_card.dart';
import '../../core/services/overlay_service.dart';

class OverlayScreen extends StatefulWidget {
  const OverlayScreen({super.key});

  @override
  State<OverlayScreen> createState() => _OverlayScreenState();
}

class _OverlayScreenState extends State<OverlayScreen>
    with WidgetsBindingObserver {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  StreamSubscription<dynamic>? _overlaySubscription;
  bool _isEditing = false;
  bool _editorActionsEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = TextEditingController(
      text: StorageService.noteNotifier.value,
    );

    _overlaySubscription = FlutterOverlayWindow.overlayListener.listen((event) {
      if (event is String) {
        StorageService.noteNotifier.value = event;
        if (!_isEditing) {
          _controller.text = event;
        }
      }
    });
  }

  @override
  void didChangeMetrics() {
    // Fires whenever the native overlay window's real surface size
    // arrives (or changes). Rebuild so we can re-check _hasValidViewport.
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _focusNode.dispose();
    _overlaySubscription?.cancel();
    FlutterOverlayWindow.disposeOverlayListener();
    super.dispose();
  }

  /// True only once the native FlutterView has reported a real,
  /// non-zero physical surface size. On cold start, the Android
  /// embedding attaches and renders the first several frames with
  /// physicalSize == Size.zero ("Width is zero. 0,0" in logcat)
  /// before the true 280x120 (or 340x220) surface is attached.
  /// Rendering into that zero-sized root clips/hides all content.
  bool _hasValidViewport(BuildContext context) {
    final size = View.of(context).physicalSize;
    final valid = size.width > 0 && size.height > 0;
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasValidViewport(context)) {
      // Don't paint into a degenerate 0x0 root — wait for the real frame.
      return const SizedBox.shrink();
    }

    if (_isEditing) {
      return Material(
        color: Colors.transparent,
        child: OverlayEditorCard(
          key: const ValueKey('editor'),
          controller: _controller,
          onCancel: () async {
            if (!_editorActionsEnabled) return;
            _controller.text = StorageService.noteNotifier.value;
            await OverlayService.exitEditMode();
            if (!mounted) return;
            setState(() {
              _isEditing = false;
              _editorActionsEnabled = false;
            });
          },
          onSave: () async {
            if (!_editorActionsEnabled) return;
            await StorageService.saveNote(_controller.text);
            await OverlayService.exitEditMode();
            if (!mounted) return;
            setState(() {
              _isEditing = false;
              _editorActionsEnabled = false;
            });
          },
          actionsEnabled: _editorActionsEnabled,
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ValueListenableBuilder<String>(
          key: const ValueKey('viewer'),
          valueListenable: StorageService.noteNotifier,
          builder: (_, note, __) {
            return GestureDetector(
              onTap: () async {
                _controller.text = note;
                _controller.selection = TextSelection.collapsed(
                  offset: _controller.text.length,
                );

                await OverlayService.enterEditMode();
                await Future.delayed(const Duration(milliseconds: 250));
                if (!mounted) return;
                setState(() {
                  _isEditing = true;
                  _editorActionsEnabled = false;
                });

                await Future.delayed(const Duration(milliseconds: 500));
                if (!mounted) return;
                setState(() {
                  _editorActionsEnabled = true;
                });
              },
              child: SizedBox.expand(child: OverlayNoteCard(note: note)),
            );
          },
        ),
      ),
    );
  }
}
