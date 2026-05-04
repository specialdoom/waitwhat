import 'database_service.dart';
import 'push_notification_service.dart';
import 'settings_service.dart';
import 'widget_service.dart';

class AppInitService {
  static Future<void> initialize() async {
    DatabaseService.initialize();
    await SettingsService.loadQuotaState();
    await PushNotificationService.initialize();
    await PushNotificationService.requestPermission();
    DatabaseService.instance.watchTodos().listen((_) => WidgetService.update());

    final reminderEnabled = await SettingsService.getDailyReminderEnabled();
    if (reminderEnabled) {
      final time = await SettingsService.getDailyReminderTime();
      await PushNotificationService.scheduleDailyReminder(
        hour: time.hour,
        minute: time.minute,
      );
    }
  }
}
