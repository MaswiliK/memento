// lib/core/services/storage_service.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/overlay_service.dart';

class StorageService {
  StorageService._();

  static const _prefKey = 'memento_note_key';

  // Single reactive source of truth for whichever isolate is rendering
  static final ValueNotifier<String> noteNotifier = ValueNotifier<String>('');
  static SharedPreferences? _prefs;

  /// Initializes atomic storage on both the main application and overlay windows safely
  static Future<void> init({required bool isOverlayIsolate}) async {
    _prefs = await SharedPreferences.getInstance();
    noteNotifier.value = getNote();
  }

  /// Writes directly to the process-safe disk array and signals the overlay
  static Future<void> saveNote(String note) async {
    _prefs ??= await SharedPreferences.getInstance();

    noteNotifier.value = note;
    await _prefs!.setString(_prefKey, note);

    // This broadcast is now purely a visual hint to force active UI rerenders
    await OverlayService.sendData(note);
  }

  /// Forces an atomic synchronization reload directly from disk storage
  static String getNote() {
    if (_prefs == null) return '';
    // Reload guarantees the runtime reads what the alternative engine wrote to the XML file
    _prefs!.reload();
    return _prefs!.getString(_prefKey) ?? '';
  }

  static Future<void> clearNote() async {
    _prefs ??= await SharedPreferences.getInstance();
    noteNotifier.value = '';
    await _prefs!.remove(_prefKey);
    await OverlayService.sendData('');
  }
}
