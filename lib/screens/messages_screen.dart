import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../services/database_service.dart';
import '../widgets/create_todo_sheet.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: StreamBuilder<List<WhatsAppMessage>>(
        stream: DatabaseService.instance.watchMessages(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final messages = snapshot.data!;
          if (messages.isEmpty) return const _EmptyState();
          return ListView.separated(
            itemCount: messages.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, i) => _MessageItem(message: messages[i]),
          );
        },
      ),
    );
  }
}

class _MessageItem extends StatelessWidget {
  final WhatsAppMessage message;
  const _MessageItem({required this.message});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(message.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Theme.of(context).colorScheme.errorContainer,
        child: Icon(
          Icons.delete_outline,
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
      onDismissed: (_) => DatabaseService.instance.deleteMessage(message.id),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(message.sender[0].toUpperCase()),
        ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              message.sender,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            formatMessageTime(message.timestamp),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      subtitle: Text(
        message.body,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: message.isConvertedToTodo
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
              size: 18,
            )
          : null,
      onTap: () => showModalBottomSheet(
        context: context,
        useSafeArea: true,
        builder: (_) => _MessageDetailSheet(message: message),
      ),
      ),
    );
  }
}

class _MessageDetailSheet extends StatelessWidget {
  final WhatsAppMessage message;
  const _MessageDetailSheet({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(child: Text(message.sender[0].toUpperCase())),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.sender,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    formatMessageTime(message.timestamp),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(message.body),
          const SizedBox(height: 24),
          if (!message.isConvertedToTodo)
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                showCreateTodoSheet(context, sourceMessage: message);
              },
              icon: const Icon(Icons.add_task),
              label: const Text('Create Todo from Message'),
            )
          else
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Already converted to todo'),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text('No messages yet',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'WhatsApp messages will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}

String formatMessageTime(DateTime time) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final messageDay = DateTime(time.year, time.month, time.day);
  if (messageDay == today) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${time.hour < 12 ? 'AM' : 'PM'}';
  }
  final diff = today.difference(messageDay).inDays;
  if (diff < 7) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[time.weekday - 1];
  }
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${months[time.month - 1]} ${time.day}';
}