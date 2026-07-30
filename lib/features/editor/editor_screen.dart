import 'package:flutter/material.dart';

import '../../core/services/storage_service.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: StorageService.getNote());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> save() async {
    await StorageService.saveNote(controller.text.trim());

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Note")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: controller,

                autofocus: true,

                maxLines: null,

                expands: true,

                textAlignVertical: TextAlignVertical.top,

                decoration: const InputDecoration(
                  hintText: "Write something worth remembering...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            FilledButton(onPressed: save, child: const Text("Save")),
          ],
        ),
      ),
    );
  }
}
