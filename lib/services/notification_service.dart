import 'dart:async';
import 'package:flutter/services.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'database_service.dart';

const _settingsChannel = MethodChannel('com.example.waitwhat/settings');

class NotificationService {
  static const _whatsAppPackages = {'com.whatsapp', 'com.whatsapp.w4b'};

  static StreamSubscription<ServiceNotificationEvent>? _subscription;

  static bool isRunning = false;

  static Future<bool> isPermissionGranted() =>
      NotificationListenerService.isPermissionGranted();

  static Future<void> requestPermission() =>
      _settingsChannel.invokeMethod('openNotificationListenerSettings');

  static void start() {
    _subscription?.cancel();
    _subscription = NotificationListenerService.notificationsStream
        .where((e) => _whatsAppPackages.contains(e.packageName))
        .where((e) => e.hasRemoved != true)
        .listen(_onWhatsAppNotification);
    isRunning = true;
  }

  static void stop() {
    _subscription?.cancel();
    _subscription = null;
    isRunning = false;
  }

  static Future<void> _onWhatsAppNotification(
    ServiceNotificationEvent event,
  ) async {
    final body = event.content;
    if (body == null || body.trim().isEmpty) return;

    final sender = event.title ?? 'Unknown';
    final allowedSenders = await DatabaseService.instance.getAllSenders();
    if (!allowedSenders.any((s) => s.name == sender)) return;

    await DatabaseService.instance.saveMessage(
      sender: sender,
      body: body.trim(),
      timestamp: DateTime.now(),
    );
  }
}