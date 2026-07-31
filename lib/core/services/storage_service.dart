// lib/core/services/storage_service.dart
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const _boxName = 'memento';
  static const _noteKey = 'note';

  static final ValueNotifier<String> noteNotifier = ValueNotifier<String>('');

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);

    noteNotifier.value = getNote();
  }

  static Box get _box => Hive.box(_boxName);

  static Future<void> saveNote(String note) async {
    await _box.put(_noteKey, note);

    noteNotifier.value = note;
  }

  static String getNote() {
    return _box.get(_noteKey, defaultValue: '');
  }

  static Future<void> clearNote() async {
    await _box.delete(_noteKey);

    noteNotifier.value = '';
  }
}
