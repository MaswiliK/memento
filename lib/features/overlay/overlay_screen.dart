// lib/features/overlay/overlay_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../../core/services/storage_service.dart';
import '../../shared/widgets/overlay_note_card.dart';
import '../../shared/widgets/overlay_editor_card.dart';
import '../../core/services/overlay_service.dart';
import '../../shared/widgets/overlay_bubble.dart';

class OverlayScreen extends StatefulWidget {
  const OverlayScreen({super.key});

  @override
  State<OverlayScreen> createState() => _OverlayScreenState();
}

enum OverlayMode { view, editing, bubble }

class _OverlayScreenState extends State<OverlayScreen>
    with WidgetsBindingObserver {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  OverlayMode _mode = OverlayMode.view;
  bool _editorActionsEnabled = false;

  StreamSubscription<dynamic>? _overlaySubscription;

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

        if (_mode != OverlayMode.editing) {
          _controller.text = event;
        }
      }
    });
  }

  @override
  void didChangeMetrics() {
    if (mounted) {
      setState(() {});
    }
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

  bool _hasValidViewport(BuildContext context) {
    final size = View.of(context).physicalSize;
    return size.width > 0 && size.height > 0;
  }

  Future<void> _enterEditing(String note) async {
    _controller.text = note;
    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length,
    );

    await OverlayService.enterEditMode();

    await Future.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;

    setState(() {
      _mode = OverlayMode.editing;
      _editorActionsEnabled = false;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      _editorActionsEnabled = true;
    });
  }

  Future<void> _minimize() async {
    await OverlayService.minimizeToBubble();

    if (!mounted) return;

    setState(() {
      _mode = OverlayMode.bubble;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasValidViewport(context)) {
      return const SizedBox.shrink();
    }

    // ─────────────────────────────────────────────
    // EDITING MODE
    // ─────────────────────────────────────────────
    if (_mode == OverlayMode.editing) {
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
              _mode = OverlayMode.view;
              _editorActionsEnabled = false;
            });
          },

          onSave: () async {
            if (!_editorActionsEnabled) return;

            await StorageService.saveNote(_controller.text);

            if (!mounted) return;

            setState(() {
              _mode = OverlayMode.view;
              _editorActionsEnabled = false;
            });
          },

          actionsEnabled: _editorActionsEnabled,
        ),
      );
    }

    // ─────────────────────────────────────────────
    // BUBBLE MODE
    // ─────────────────────────────────────────────
    if (_mode == OverlayMode.bubble) {
      return OverlayBubble(
        onTap: () async {
          await OverlayService.restoreFromBubble();

          if (!mounted) return;

          setState(() {
            _mode = OverlayMode.view;
          });
        },
      );
    }

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ValueListenableBuilder<String>(
          key: const ValueKey('viewer'),
          valueListenable: StorageService.noteNotifier,
          builder: (_, note, _) {
            return SizedBox.expand(
              child: GestureDetector(
                onTap: () => _enterEditing(note),
                child: OverlayNoteCard(note: note, onMinimize: _minimize),
              ),
            );
          },
        ),
      ),
    );
  }
}
