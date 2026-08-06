// lib/features/editor/editor_screen.dart
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/storage_service.dart';
import '../../shared/widgets/primary_button.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen>
    with WidgetsBindingObserver {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: StorageService.getNote());

    // Listen for global application state changes (e.g., coming back from background)
    StorageService.noteNotifier.addListener(_onGlobalNoteChanged);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    StorageService.noteNotifier.removeListener(_onGlobalNoteChanged);
    controller.dispose();
    super.dispose();
  }

  /// This triggers whenever the app becomes active again, forcing a disk sync
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final freshNote = StorageService.getNote();
      if (controller.text != freshNote) {
        StorageService.noteNotifier.value = freshNote;
      }
    }
  }

  void _onGlobalNoteChanged() {
    final incomingText = StorageService.noteNotifier.value;
    if (controller.text != incomingText && mounted) {
      setState(() {
        controller.text = incomingText;
        controller.selection = TextSelection.collapsed(
          offset: incomingText.length,
        );
      });
    }
  }

  Future<void> save() async {
    final text = controller.text.trim();
    await StorageService.saveNote(text);
    await HapticFeedback.lightImpact();
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text(AppStrings.editTitle)),
      body: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  expands: true,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textAlignVertical: TextAlignVertical.top,
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: AppStrings.hint,
                    hintStyle: theme.textTheme.bodyMedium,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              PrimaryButton(text: AppStrings.save, onPressed: save),
            ],
          ),
        ),
      ),
    );
  }
}
