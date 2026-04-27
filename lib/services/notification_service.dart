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

  // Tracks recently seen (sender, body) keys to deduplicate WhatsApp's
  // duplicate notification events for the same message.
  static final _recentKeys = <String, DateTime>{};

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
    final trimmedBody = body.trim();
    final now = DateTime.now();
    final key = '$sender\x00$trimmedBody';

    final last = _recentKeys[key];
    if (last != null && now.difference(last).inSeconds < 2) return;
    _recentKeys[key] = now;
    _recentKeys.removeWhere((_, t) => now.difference(t).inSeconds > 10);

    final allowedSenders = await DatabaseService.instance.getAllSenders();
    if (!allowedSenders.any((s) => s.name == sender)) return;

    await DatabaseService.instance.saveMessage(
      sender: sender,
      body: trimmedBody,
      timestamp: now,
    );
  }
}