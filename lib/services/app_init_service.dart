import 'dart:async';
import 'database_service.dart';
import 'push_notification_service.dart';
import 'settings_service.dart';
import 'widget_service.dart';

class AppInitService {
  static StreamSubscription? _todosSubscription;

  static Future<void> initialize() async {
    DatabaseService.initialize();
    await SettingsService.loadQuotaState();
    await PushNotificationService.initialize();
    await PushNotificationService.requestPermission();
    _todosSubscription = DatabaseService.instance.watchTodos().listen((_) => WidgetService.update());

    final reminderEnabled = await SettingsService.getDailyReminderEnabled();
    if (reminderEnabled) {
      final time = await SettingsService.getDailyReminderTime();
      await PushNotificationService.scheduleDailyReminder(
        hour: time.hour,
        minute: time.minute,
      );
    }
  }

  static void dispose() {
    _todosSubscription?.cancel();
    _todosSubscription = null;
  }
}
