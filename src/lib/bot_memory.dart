import 'package:hive_flutter/hive_flutter.dart';

class BotMemory {
  static const String boxName = 'bot_memory';
  static late Box _box;

  static Future<void> init() async {
    _box = await Hive.openBox(boxName);
  }

  static void store(String userText, String reply) {
    _box.put(userText.toLowerCase(), reply);
  }

  static String? getSimilar(String userText) {
    return _box.get(userText.toLowerCase());
  }
}
