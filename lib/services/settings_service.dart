import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class SettingsService {
  static const _groqKeyPref = 'groq_api_key';
  static const _groqQuotaExhaustedPref = 'groq_quota_exhausted';

  static final quotaExhaustedNotifier = ValueNotifier<bool>(false);

  static Future<void> loadQuotaState() async {
    quotaExhaustedNotifier.value = await isGroqQuotaExhausted();
  }

  static Future<String?> getGroqApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_groqKeyPref);
    if (saved != null && saved.isNotEmpty) return saved;
    return kGroqApiKey.isNotEmpty ? kGroqApiKey : null;
  }

  static Future<void> saveGroqApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (key.trim().isEmpty) {
      await prefs.remove(_groqKeyPref);
    } else {
      await prefs.setString(_groqKeyPref, key.trim());
      await prefs.remove(_groqQuotaExhaustedPref);
      quotaExhaustedNotifier.value = false;
    }
  }

  static Future<bool> isGroqQuotaExhausted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_groqQuotaExhaustedPref) ?? false;
  }

  static Future<void> setGroqQuotaExhausted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_groqQuotaExhaustedPref, true);
    quotaExhaustedNotifier.value = true;
  }

  static Future<void> clearGroqQuotaExhausted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_groqQuotaExhaustedPref);
    quotaExhaustedNotifier.value = false;
  }

  static const _dailyReminderEnabledPref = 'daily_reminder_enabled';
  static const _dailyReminderHourPref = 'daily_reminder_hour';
  static const _dailyReminderMinutePref = 'daily_reminder_minute';

  static Future<bool> getDailyReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_dailyReminderEnabledPref) ?? false;
  }

  static Future<void> setDailyReminderEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dailyReminderEnabledPref, value);
  }

  static Future<({int hour, int minute})> getDailyReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    return (
      hour: prefs.getInt(_dailyReminderHourPref) ?? 9,
      minute: prefs.getInt(_dailyReminderMinutePref) ?? 0,
    );
  }

  static Future<void> setDailyReminderTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyReminderHourPref, hour);
    await prefs.setInt(_dailyReminderMinutePref, minute);
  }

  static const _autoCreateTodosPref = 'auto_create_todos';

  static Future<bool> getAutoCreateTodos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoCreateTodosPref) ?? false;
  }

  static Future<void> setAutoCreateTodos(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoCreateTodosPref, value);
  }

  static const _customInstructionsPref = 'custom_instructions';

  static Future<String?> getCustomInstructions() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getString(_customInstructionsPref);
    return (v != null && v.isNotEmpty) ? v : null;
  }

  static Future<void> saveCustomInstructions(String value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value.trim().isEmpty) {
      await prefs.remove(_customInstructionsPref);
    } else {
      await prefs.setString(_customInstructionsPref, value.trim());
    }
  }
}