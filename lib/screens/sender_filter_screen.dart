import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../services/database_service.dart';

class SenderFilterScreen extends StatelessWidget {
  const SenderFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitored Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddSheet(context),
          ),
        ],
      ),
      body: StreamBuilder<List<FilteredSender>>(
        stream: DatabaseService.instance.watchSenders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final senders = snapshot.data!;
          if (senders.isEmpty) return const _EmptyState();
          return ListView.separated(
            itemCount: senders.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, i) => _SenderItem(sender: senders[i]),
          );
        },
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _AddSenderSheet(),
    );
  }
}

class _SenderItem extends StatelessWidget {
  final FilteredSender sender;
  const _SenderItem({required this.sender});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(sender.name[0].toUpperCase())),
      title: Text(sender.name),
      trailing: IconButton(
        icon: Icon(Icons.delete_outline,
            color: Theme.of(context).colorScheme.error),
        onPressed: () => DatabaseService.instance.removeSender(sender.id),
      ),
    );
  }
}

class _AddSenderSheet extends StatefulWidget {
  const _AddSenderSheet();

  @override
  State<_AddSenderSheet> createState() => _AddSenderSheetState();
}

class _AddSenderSheetState extends State<_AddSenderSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _manualController = TextEditingController();
  List<String>? _messageSenders;
  Set<String> _existingSenders = {};

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _loadSenders();
  }

  @override
  void dispose() {
    _tabs.dispose();
    _manualController.dispose();
    super.dispose();
  }

  Future<void> _loadSenders() async {
    final db = DatabaseService.instance;
    final existing = await db.getAllSenders();
    final fromMessages = await db.getDistinctMessageSenders();
    if (!mounted) return;
    setState(() {
      _existingSenders = existing.map((s) => s.name).toSet();
      _messageSenders = fromMessages
          .where((name) => !_existingSenders.contains(name))
          .toList()
        ..sort();
    });
  }

  Future<void> _add(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    await DatabaseService.instance.addSender(trimmed);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        16,
        0,
        MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Add Contact',
                    style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabs,
            tabs: const [
              Tab(text: 'From Messages'),
              Tab(text: 'Manual'),
            ],
          ),
          SizedBox(
            height: 300,
            child: TabBarView(
              controller: _tabs,
              children: [
                _FromMessagesTab(
                  senders: _messageSenders,
                  onAdd: _add,
                ),
                _ManualTab(
                  controller: _manualController,
                  onAdd: () => _add(_manualController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FromMessagesTab extends StatelessWidget {
  final List<String>? senders;
  final Future<void> Function(String) onAdd;

  const _FromMessagesTab({required this.senders, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    if (senders == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (senders!.isEmpty) {
      return Center(
        child: Text(
          'No new senders found in captured messages',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
          textAlign: TextAlign.center,
        ),
      );
    }
    return ListView.builder(
      itemCount: senders!.length,
      itemBuilder: (_, i) {
        final name = senders![i];
        return ListTile(
          leading: CircleAvatar(child: Text(name[0].toUpperCase())),
          title: Text(name),
          trailing: const Icon(Icons.add),
          onTap: () => onAdd(name),
        );
      },
    );
  }
}

class _ManualTab extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const _ManualTab({required this.controller, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: controller,
            autofocus: false,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Contact or group name',
              hintText: 'Exactly as shown in WhatsApp',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => onAdd(),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onAdd,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.contacts_outlined,
                size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text('No contacts monitored',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'All WhatsApp messages are captured.\nTap + to limit to specific contacts.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}