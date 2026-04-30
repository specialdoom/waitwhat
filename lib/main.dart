import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/permission_screen.dart';
import 'services/database_service.dart';
import 'services/push_notification_service.dart';
import 'services/settings_service.dart';
import 'services/widget_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaitWhat',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00A884)),
      ),
      home: const PermissionScreen(child: HomeScreen()),
    );
  }
}