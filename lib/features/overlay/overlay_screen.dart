import 'package:flutter/material.dart';

import '../../core/services/storage_service.dart';
import '../../shared/widgets/note_card.dart';
import '../../shared/widgets/overlay_note_card.dart';

class OverlayScreen extends StatelessWidget {
  const OverlayScreen({super.key});

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
