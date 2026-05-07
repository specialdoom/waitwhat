import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import '../services/push_notification_service.dart';
import '../services/settings_service.dart';
import '../widgets/app_notification.dart';
import 'feedback_screen.dart';
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
  bool _checkingQuota = false;
  DateTime? _lastQuotaCheck;
  bool _autoCreateTodos = false;
  bool _apiKeyVisible = false;
  bool _dailyReminderEnabled = false;
  TimeOfDay _dailyReminderTime = const TimeOfDay(hour: 9, minute: 0);
  final _apiKeyController = TextEditingController();
  NotificationData? _notification;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
    _listening = NotificationService.isRunning;
    _loadApiKey();
    _loadAutoCreate();
    _loadDailyReminder();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadAutoCreate() async {
    final v = await SettingsService.getAutoCreateTodos();
    if (mounted) setState(() => _autoCreateTodos = v);
  }

  Future<void> _toggleAutoCreate(bool value) async {
    try {
      await SettingsService.setAutoCreateTodos(value);
      if (mounted) setState(() => _autoCreateTodos = value);
    } catch (_) {
      if (mounted) _showNotification('Failed to save setting', NotificationType.error);
    }
  }

  Future<void> _loadDailyReminder() async {
    final enabled = await SettingsService.getDailyReminderEnabled();
    final time = await SettingsService.getDailyReminderTime();
    if (mounted) {
      setState(() {
        _dailyReminderEnabled = enabled;
        _dailyReminderTime = TimeOfDay(hour: time.hour, minute: time.minute);
      });
    }
  }

  Future<void> _toggleDailyReminder(bool value) async {
    try {
      await SettingsService.setDailyReminderEnabled(value);
      if (value) {
        await PushNotificationService.scheduleDailyReminder(
          hour: _dailyReminderTime.hour,
          minute: _dailyReminderTime.minute,
        );
      } else {
        await PushNotificationService.cancelDailyReminder();
      }
      if (mounted) setState(() => _dailyReminderEnabled = value);
    } catch (_) {
      if (mounted) _showNotification('Failed to save setting', NotificationType.error);
    }
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dailyReminderTime,
    );
    if (picked == null || !mounted) return;
    await SettingsService.setDailyReminderTime(picked.hour, picked.minute);
    if (_dailyReminderEnabled) {
      await PushNotificationService.scheduleDailyReminder(
        hour: picked.hour,
        minute: picked.minute,
      );
    }
    if (mounted) setState(() => _dailyReminderTime = picked);
  }

  void _showNotification(String message, NotificationType type) {
    setState(() => _notification = NotificationData(message, type));
  }

  Future<void> _loadApiKey() async {
    final key = await SettingsService.getGroqApiKey();
    if (mounted && key != null) _apiKeyController.text = key;
  }

  Future<void> _saveApiKey() async {
    await SettingsService.saveGroqApiKey(_apiKeyController.text);
    if (mounted) _showNotification('API key saved', NotificationType.success);
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

  Future<void> _recheckQuota() async {
    final now = DateTime.now();
    if (_lastQuotaCheck != null && now.difference(_lastQuotaCheck!).inSeconds < 5) return;
    _lastQuotaCheck = now;
    final apiKey = await SettingsService.getGroqApiKey();
    if (!mounted) return;
    if (apiKey == null) return;
    setState(() => _checkingQuota = true);
    final status = await AiService.checkQuota(apiKey: apiKey);
    if (!mounted) return;
    setState(() => _checkingQuota = false);
    switch (status) {
      case QuotaStatus.ok:
        await SettingsService.clearGroqQuotaExhausted();
        if (mounted) _showNotification('Connected — AI suggestions enabled', NotificationType.success);
      case QuotaStatus.exhausted:
        await SettingsService.setGroqQuotaExhausted();
        if (mounted) _showNotification('Quota exhausted — try again later or use a different key', NotificationType.error);
      case QuotaStatus.error:
        if (mounted) _showNotification('Connection failed — check your API key and internet connection', NotificationType.error);
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
          _SectionHeader('AI'),
          SwitchListTile(
            secondary: Icon(
              Icons.auto_awesome,
              color: _autoCreateTodos
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
            ),
            title: const Text('Auto-create todos'),
            subtitle: const Text('Automatically create a todo from each new message'),
            value: _autoCreateTodos,
            onChanged: _toggleAutoCreate,
          ),
          if (_notification != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: AppNotification(
                data: _notification!,
                onClose: () => setState(() => _notification = null),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _apiKeyController,
                    obscureText: !_apiKeyVisible,
                    decoration: InputDecoration(
                      labelText: 'Groq API Key',
                      hintText: 'gsk_...',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_apiKeyVisible ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _apiKeyVisible = !_apiKeyVisible),
                      ),
                    ),
                    onSubmitted: (_) => _saveApiKey(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _saveApiKey,
                  icon: const Icon(Icons.check),
                  tooltip: 'Save',
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: _checkingQuota ? null : _recheckQuota,
                  icon: _checkingQuota
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.network_check),
                  tooltip: 'Test connection',
                ),
              ],
            ),
          ),
          _SectionHeader('Notifications'),
          SwitchListTile(
            secondary: Icon(
              Icons.notifications_outlined,
              color: _dailyReminderEnabled
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
            ),
            title: const Text('Daily reminder'),
            subtitle: const Text('Remind me about pending todos each day'),
            value: _dailyReminderEnabled,
            onChanged: _toggleDailyReminder,
          ),
          if (_dailyReminderEnabled)
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Reminder time'),
              trailing: Text(
                _dailyReminderTime.format(context),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: _pickReminderTime,
            ),
          _SectionHeader('Support'),
          ListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: const Text('Send Feedback'),
            subtitle: const Text('Report a bug or request a feature'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FeedbackScreen()),
            ),
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
                  count == 0 ? 'No contacts — messages not captured' : '$count contact${count == 1 ? '' : 's'}',
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