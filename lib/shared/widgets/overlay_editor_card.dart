// lib/shared/widgets/overlay_editor_card.dart
import 'package:flutter/material.dart';

class OverlayEditorCard extends StatefulWidget {
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
  State<OverlayEditorCard> createState() => _OverlayEditorCardState();
}

class _OverlayEditorCardState extends State<OverlayEditorCard> {
  final FocusNode _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Automatically request soft input keyboard focus as soon as edit mode mounts.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _textFieldFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(24),
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
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (!_textFieldFocusNode.hasFocus) {
                  _textFieldFocusNode.requestFocus();
                }
              },
              child: TextField(
                controller: widget.controller,
                focusNode: _textFieldFocusNode,
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
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.actionsEnabled ? widget.onCancel : null,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 4),
                FilledButton(
                  onPressed: widget.actionsEnabled ? widget.onSave : null,
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
