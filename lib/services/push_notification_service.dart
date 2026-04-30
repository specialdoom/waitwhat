import 'package:flutter/services.dart';

class PushNotificationService {
  static const _channel = MethodChannel('com.example.waitwhat/notifications');

  static Future<void> initialize() async {}

  static Future<void> requestPermission() async {
    await _channel.invokeMethod('requestPermission');
  }

  static Future<void> notifyTodoCreated(String title) async {
    final id = DateTime.now().millisecondsSinceEpoch % 100000;
    await _channel.invokeMethod('showNotification', {
      'id': id,
      'title': 'New todo created',
      'body': title,
    });
  }

  static Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    await _channel.invokeMethod('scheduleDailyReminder', {
      'hour': hour,
      'minute': minute,
    });
  }

  static Future<void> cancelDailyReminder() async {
    await _channel.invokeMethod('cancelDailyReminder');
  }
}
