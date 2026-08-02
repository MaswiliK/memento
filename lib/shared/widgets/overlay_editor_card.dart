// lib/shared/widgets/overlay_editor_card.dart
import 'package:flutter/material.dart';

class OverlayEditorCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final bool actionsEnabled;

  const OverlayEditorCard({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    required this.actionsEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: false,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.2,
              ),
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: 'Write something...',
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
          ),

          const SizedBox(height: 4),

          SizedBox(
            height: 36,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: actionsEnabled ? onCancel : null,
                  child: const Text('Cancel'),
                ),

                const SizedBox(width: 4),

                FilledButton(
                  onPressed: actionsEnabled ? onSave : null,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
