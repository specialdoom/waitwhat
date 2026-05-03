import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class PermissionScreen extends StatefulWidget {
  final Widget child;

  const PermissionScreen({super.key, required this.child});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen>
    with WidgetsBindingObserver {
  bool _granted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkPermission();
  }

  Future<void> _checkPermission() async {
    final granted = await NotificationService.isPermissionGranted();
    if (!mounted) return;
    if (granted && !_granted) NotificationService.start();
    if (!granted && _granted) NotificationService.stop();
    setState(() => _granted = granted);
  }

  @override
  Widget build(BuildContext context) {
    if (_granted) return widget.child;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_off_outlined,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Notification Access Required',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'WaitWhat needs permission to read your WhatsApp notifications so it can turn messages into todos.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: NotificationService.requestPermission,
                icon: const Icon(Icons.settings_outlined),
                label: const Text('Open Notification Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}