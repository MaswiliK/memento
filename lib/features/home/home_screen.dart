import 'package:flutter/material.dart';

import '../../core/services/storage_service.dart';
import '../editor/editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String note = "";

  @override
  void initState() {
    super.initState();
    loadNote();
  }

  void loadNote() {
    note = StorageService.getNote();
  }

  Future<void> openEditor() async {
    final updated = await Navigator.push(
      context,

      MaterialPageRoute(builder: (_) => const EditorScreen()),
    );

    if (updated == true) {
      setState(() {
        loadNote();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Memento")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            const Text(
              "Your Note",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 180),
                padding: const EdgeInsets.all(20),
                child: Text(note.isEmpty ? "Nothing here yet..." : note),
              ),
            ),

            const Spacer(),

            FilledButton(onPressed: openEditor, child: const Text("Edit Note")),
          ],
        ),
      ),
    );
  }
}
