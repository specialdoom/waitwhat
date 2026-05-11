import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class SettingsService {
  static const _groqKeyPref = 'groq_api_key';
  static const _groqQuotaExhaustedPref = 'groq_quota_exhausted';
  static const _dailyReminderEnabledPref = 'daily_reminder_enabled';
  static const _dailyReminderHourPref = 'daily_reminder_hour';
  static const _dailyReminderMinutePref = 'daily_reminder_minute';
  static const _autoCreateTodosPref = 'auto_create_todos';

  static late SharedPreferences _prefs;

  static final quotaExhaustedNotifier = ValueNotifier<bool>(false);

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> loadQuotaState() async {
    quotaExhaustedNotifier.value = await isGroqQuotaExhausted();
  }

  static Future<String?> getGroqApiKey() async {
    final saved = _prefs.getString(_groqKeyPref);
    if (saved != null && saved.isNotEmpty) return saved;
    return kGroqApiKey.isNotEmpty ? kGroqApiKey : null;
  }

  static Future<void> saveGroqApiKey(String key) async {
    if (key.trim().isEmpty) {
      await _prefs.remove(_groqKeyPref);
    } else {
      await _prefs.setString(_groqKeyPref, key.trim());
      await _prefs.remove(_groqQuotaExhaustedPref);
      quotaExhaustedNotifier.value = false;
    }
  }

  static Future<bool> isGroqQuotaExhausted() async {
    return _prefs.getBool(_groqQuotaExhaustedPref) ?? false;
  }

  static Future<void> setGroqQuotaExhausted() async {
    await _prefs.setBool(_groqQuotaExhaustedPref, true);
    quotaExhaustedNotifier.value = true;
  }

  static Future<void> clearGroqQuotaExhausted() async {
    await _prefs.remove(_groqQuotaExhaustedPref);
    quotaExhaustedNotifier.value = false;
  }

  static Future<bool> getDailyReminderEnabled() async {
    return _prefs.getBool(_dailyReminderEnabledPref) ?? false;
  }

  static Future<void> setDailyReminderEnabled(bool value) async {
    await _prefs.setBool(_dailyReminderEnabledPref, value);
  }

  static Future<({int hour, int minute})> getDailyReminderTime() async {
    return (
      hour: _prefs.getInt(_dailyReminderHourPref) ?? 9,
      minute: _prefs.getInt(_dailyReminderMinutePref) ?? 0,
    );
  }

  static Future<void> setDailyReminderTime(int hour, int minute) async {
    await _prefs.setInt(_dailyReminderHourPref, hour);
    await _prefs.setInt(_dailyReminderMinutePref, minute);
  }

  static Future<bool> getAutoCreateTodos() async {
    return _prefs.getBool(_autoCreateTodosPref) ?? false;
  }

  static Future<void> setAutoCreateTodos(bool value) async {
    await _prefs.setBool(_autoCreateTodosPref, value);
  }
}
