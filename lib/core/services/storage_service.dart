import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const _boxName = 'memento';
  static const _noteKey = 'note';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  static Box get _box => Hive.box(_boxName);

  static Future<void> saveNote(String note) async {
    await _box.put(_noteKey, note);
  }

  static String getNote() {
    return _box.get(_noteKey, defaultValue: '');
  }

  static Future<void> clearNote() async {
    await _box.delete(_noteKey);
  }
}
