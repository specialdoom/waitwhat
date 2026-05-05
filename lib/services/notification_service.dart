import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'ai_service.dart';
import 'database_service.dart';
import 'push_notification_service.dart';
import 'settings_service.dart';

const _settingsChannel = MethodChannel('com.example.waitwhat/settings');

class NotificationService {
  static const _whatsAppPackages = {'com.whatsapp', 'com.whatsapp.w4b'};

  static StreamSubscription<ServiceNotificationEvent>? _subscription;

  static bool isRunning = false;

  // Tracks recently seen (sender, body) keys to deduplicate WhatsApp's
  // duplicate notification events for the same message.
  static final _recentKeys = <String, DateTime>{};

  // All senders seen in WhatsApp notifications this session (pre-filter).
  static final seenSenders = <String>{};

  @visibleForTesting
  static void trackSender(String sender, String? body) {
    if (body == null || body.trim().isEmpty) return;
    seenSenders.add(sender);
  }

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

  // Matches WhatsApp bundle summaries like "5 new messages" or
  // "3 new messages from John" that carry no actionable content.
  static final _summaryPattern = RegExp(r'^\d+ new messages', caseSensitive: false);

  static Future<void> _onWhatsAppNotification(
    ServiceNotificationEvent event,
  ) async {
    final body = event.content;
    if (body == null || body.trim().isEmpty) return;

    final sender = event.title ?? 'Unknown';
    final trimmedBody = body.trim();

    trackSender(sender, body);

    if (_summaryPattern.hasMatch(trimmedBody)) return;

    final now = DateTime.now();
    final key = '$sender\x00$trimmedBody';

    final last = _recentKeys[key];
    if (last != null && now.difference(last).inSeconds < 2) return;
    _recentKeys[key] = now;
    _recentKeys.removeWhere((_, t) => now.difference(t).inSeconds > 10);

    final allowedSenders = await DatabaseService.instance.getAllSenders();
    if (!allowedSenders.any((s) => s.name == sender)) return;

    final messageId = await DatabaseService.instance.saveMessage(
      sender: sender,
      body: trimmedBody,
      timestamp: now,
    );

    final autoCreate = await SettingsService.getAutoCreateTodos();
    if (!autoCreate) return;
    if (SettingsService.quotaExhaustedNotifier.value) return;

    final apiKey = await SettingsService.getGroqApiKey();
    if (apiKey == null) return;

    try {
      final suggestion = await AiService.suggestTodo(
        sender: sender,
        body: trimmedBody,
        apiKey: apiKey,
      );
      if (suggestion == null) return;
      await DatabaseService.instance.saveTodo(
        title: sender,
        notes: trimmedBody,
        dueDate: suggestion.dueDate,
        priority: suggestion.priority,
        sourceMessageId: messageId,
      );
      await DatabaseService.instance.markMessageConverted(messageId);
      await PushNotificationService.notifyTodoCreated(sender);
    } on AiQuotaExceededException {
      await SettingsService.setGroqQuotaExhausted();
    } catch (_) {}
  }
}