import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import 'sender_filter_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  bool _permissionGranted = false;
  bool _listening = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
    _listening = NotificationService.isRunning;
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
    if (mounted) {
      setState(() {
        _permissionGranted = granted;
        if (!granted) _listening = false;
      });
    }
  }

  void _toggleListening(bool value) {
    if (value) {
      NotificationService.start();
    } else {
      NotificationService.stop();
    }
    setState(() => _listening = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _SectionHeader('Permissions'),
          ListTile(
            leading: Icon(
              _permissionGranted
                  ? Icons.notifications_active
                  : Icons.notifications_off,
              color: _permissionGranted
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.error,
            ),
            title: const Text('Notification Access'),
            subtitle: Text(_permissionGranted ? 'Granted' : 'Not granted'),
            trailing: _permissionGranted
                ? null
                : FilledButton.tonal(
                    onPressed: NotificationService.requestPermission,
                    child: const Text('Grant'),
                  ),
          ),
          if (_permissionGranted)
            SwitchListTile(
              secondary: Icon(
                _listening ? Icons.hearing : Icons.hearing_disabled,
                color: _listening
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
              ),
              title: const Text('Listen for Messages'),
              subtitle: Text(
                _listening ? 'Capturing WhatsApp messages' : 'Paused',
              ),
              value: _listening,
              onChanged: _permissionGranted ? _toggleListening : null,
            ),
          _SectionHeader('Filters'),
          StreamBuilder<List>(
            stream: DatabaseService.instance.watchSenders(),
            builder: (context, snapshot) {
              final count = snapshot.data?.length ?? 0;
              return ListTile(
                leading: const Icon(Icons.contacts_outlined),
                title: const Text('Monitored Contacts'),
                subtitle: Text(
                  count == 0 ? 'All messages captured' : '$count contact${count == 1 ? '' : 's'}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SenderFilterScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}