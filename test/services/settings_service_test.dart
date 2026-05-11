import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waitwhat/services/settings_service.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SettingsService.initialize();
    SettingsService.quotaExhaustedNotifier.value = false;
  });

  group('SettingsService - Groq API key', () {
    test('saveGroqApiKey persists the key', () async {
      await SettingsService.saveGroqApiKey('gsk_testkey');
      expect(await SettingsService.getGroqApiKey(), 'gsk_testkey');
    });

    test('saveGroqApiKey trims surrounding whitespace', () async {
      await SettingsService.saveGroqApiKey('  gsk_test  ');
      expect(await SettingsService.getGroqApiKey(), 'gsk_test');
    });

    test('saveGroqApiKey resets quota when a new key is saved', () async {
      await SettingsService.setGroqQuotaExhausted();
      await SettingsService.saveGroqApiKey('gsk_newkey');
      expect(await SettingsService.isGroqQuotaExhausted(), isFalse);
      expect(SettingsService.quotaExhaustedNotifier.value, isFalse);
    });

    test('saved key takes priority over any hardcoded fallback', () async {
      await SettingsService.saveGroqApiKey('gsk_override');
      expect(await SettingsService.getGroqApiKey(), 'gsk_override');
    });
  });

  group('SettingsService - quota state', () {
    test('quota is false by default', () async {
      expect(await SettingsService.isGroqQuotaExhausted(), isFalse);
    });

    test('setGroqQuotaExhausted sets flag and updates notifier', () async {
      await SettingsService.setGroqQuotaExhausted();
      expect(await SettingsService.isGroqQuotaExhausted(), isTrue);
      expect(SettingsService.quotaExhaustedNotifier.value, isTrue);
    });

    test('clearGroqQuotaExhausted clears flag and updates notifier', () async {
      await SettingsService.setGroqQuotaExhausted();
      await SettingsService.clearGroqQuotaExhausted();
      expect(await SettingsService.isGroqQuotaExhausted(), isFalse);
      expect(SettingsService.quotaExhaustedNotifier.value, isFalse);
    });

    test('loadQuotaState syncs notifier from persisted prefs', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('groq_quota_exhausted', true);

      await SettingsService.loadQuotaState();

      expect(SettingsService.quotaExhaustedNotifier.value, isTrue);
    });
  });

  group('SettingsService - auto-create todos', () {
    test('defaults to false', () async {
      expect(await SettingsService.getAutoCreateTodos(), isFalse);
    });

    test('persists true', () async {
      await SettingsService.setAutoCreateTodos(true);
      expect(await SettingsService.getAutoCreateTodos(), isTrue);
    });

    test('persists false after being true', () async {
      await SettingsService.setAutoCreateTodos(true);
      await SettingsService.setAutoCreateTodos(false);
      expect(await SettingsService.getAutoCreateTodos(), isFalse);
    });
  });

  group('SettingsService - daily reminder', () {
    test('enabled defaults to false', () async {
      expect(await SettingsService.getDailyReminderEnabled(), isFalse);
    });

    test('time defaults to 9:00', () async {
      final time = await SettingsService.getDailyReminderTime();
      expect(time.hour, 9);
      expect(time.minute, 0);
    });

    test('setDailyReminderEnabled persists value', () async {
      await SettingsService.setDailyReminderEnabled(true);
      expect(await SettingsService.getDailyReminderEnabled(), isTrue);
    });

    test('setDailyReminderTime persists hour and minute independently', () async {
      await SettingsService.setDailyReminderTime(10, 30);
      final time = await SettingsService.getDailyReminderTime();
      expect(time.hour, 10);
      expect(time.minute, 30);
    });

    test('setDailyReminderTime handles edge values (midnight)', () async {
      await SettingsService.setDailyReminderTime(0, 0);
      final time = await SettingsService.getDailyReminderTime();
      expect(time.hour, 0);
      expect(time.minute, 0);
    });
  });

}
