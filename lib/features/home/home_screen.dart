import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/storage_service.dart';
import '../../shared/widgets/note_card.dart';
import '../../shared/widgets/primary_button.dart';
import '../editor/editor_screen.dart';
import '../../core/services/overlay_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

                PrimaryButton(
                  text: "Show Overlay",
                  onPressed: () async {
                    final granted = await OverlayService.hasPermission();

                    if (!granted) {
                      await OverlayService.requestPermission();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
