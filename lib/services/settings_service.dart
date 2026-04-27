import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class SettingsService {
  static const _geminiKeyPref = 'gemini_api_key';

  static Future<String?> getGeminiApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_geminiKeyPref);
    if (saved != null && saved.isNotEmpty) return saved;
    return kGeminiApiKey.isNotEmpty ? kGeminiApiKey : null;
  }

  static Future<void> saveGeminiApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (key.trim().isEmpty) {
      await prefs.remove(_geminiKeyPref);
    } else {
      await prefs.setString(_geminiKeyPref, key.trim());
    }
  }
}