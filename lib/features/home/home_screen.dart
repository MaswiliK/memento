import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/storage_service.dart';
import '../../shared/widgets/note_card.dart';
import '../../shared/widgets/primary_button.dart';
import '../editor/editor_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _openEditor(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditorScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
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
            ],
          ),
        ),
      ),
    );
  }
}
