import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class SettingsService {
  static const _geminiKeyPref = 'gemini_api_key';
  static const _geminiQuotaExhaustedPref = 'gemini_quota_exhausted';

  static final quotaExhaustedNotifier = ValueNotifier<bool>(false);

  static Future<void> loadQuotaState() async {
    quotaExhaustedNotifier.value = await isGeminiQuotaExhausted();
  }

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
      await prefs.remove(_geminiQuotaExhaustedPref);
      quotaExhaustedNotifier.value = false;
    }
  }

  static Future<bool> isGeminiQuotaExhausted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_geminiQuotaExhaustedPref) ?? false;
  }

  static Future<void> setGeminiQuotaExhausted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_geminiQuotaExhaustedPref, true);
    quotaExhaustedNotifier.value = true;
  }
}