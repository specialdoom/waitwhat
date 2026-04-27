import 'package:flutter/material.dart';

enum NotificationType { success, error, info }

class NotificationData {
  final String message;
  final NotificationType type;
  const NotificationData(this.message, this.type);
}

class AppNotification extends StatelessWidget {
  final NotificationData data;
  final VoidCallback onClose;

  const AppNotification({super.key, required this.data, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final colors = switch (data.type) {
      NotificationType.success => (
          bg: Theme.of(context).colorScheme.primaryContainer,
          fg: Theme.of(context).colorScheme.onPrimaryContainer,
          icon: Icons.check_circle_outline,
        ),
      NotificationType.error => (
          bg: Theme.of(context).colorScheme.errorContainer,
          fg: Theme.of(context).colorScheme.onErrorContainer,
          icon: Icons.error_outline,
        ),
      NotificationType.info => (
          bg: Theme.of(context).colorScheme.secondaryContainer,
          fg: Theme.of(context).colorScheme.onSecondaryContainer,
          icon: Icons.info_outline,
        ),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: colors.bg,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(colors.icon, color: colors.fg, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  data.message,
                  style: TextStyle(color: colors.fg, fontSize: 13),
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: Icon(Icons.close, color: colors.fg, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}