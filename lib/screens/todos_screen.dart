import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../services/database_service.dart';
import '../services/settings_service.dart';
import '../utils/date_formatter.dart';
import '../utils/todo_sorter.dart';
import '../widgets/create_todo_sheet.dart';
import 'sender_filter_screen.dart';
import 'settings_screen.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateTodoSheet(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          StreamBuilder<List<FilteredSender>>(
            stream: DatabaseService.instance.watchSenders(),
            builder: (context, snapshot) {
              final senders = snapshot.data;
              if (senders == null || senders.isNotEmpty) {
                return const SizedBox.shrink();
              }
              return MaterialBanner(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                leading: const Icon(Icons.contacts_outlined),
                content: const Text(
                  'No monitored contacts added. Messages will not be captured until you add at least one.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SenderFilterScreen(),
                      ),
                    ),
                    child: const Text('Add contacts'),
                  ),
                ],
              );
            },
          ),
          ListenableBuilder(
            listenable: SettingsService.quotaExhaustedNotifier,
            builder: (context, _) {
              if (!SettingsService.quotaExhaustedNotifier.value) {
                return const SizedBox.shrink();
              }
              return MaterialBanner(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                leading: const Icon(Icons.warning_amber_rounded),
                content: const Text(
                  'Gemini quota exhausted. Update your API key in Settings to re-enable AI suggestions.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    ),
                    child: const Text('Settings'),
                  ),
                ],
              );
            },
          ),
          Expanded(
            child: StreamBuilder<List<Todo>>(
              stream: DatabaseService.instance.watchTodos(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final todos = snapshot.data!;
                if (todos.isEmpty) return const _EmptyState();

                final sorted = TodoSorter.byDueDate(todos);

                return ListView.builder(
                  itemCount: sorted.length + 1,
                  itemBuilder: (context, i) {
                    if (i == sorted.length) return const SizedBox(height: 80);
                    return _TodoItem(todo: sorted[i]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}

class _TodoItem extends StatelessWidget {
  final Todo todo;
  const _TodoItem({required this.todo});

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService.instance;
    return Dismissible(
      key: ValueKey(todo.id),
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
      onDismissed: (_) => db.deleteTodo(todo.id),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => db.toggleTodoCompleted(todo.id),
        ),
        title: Text(
          todo.title,
          style: todo.isCompleted
              ? TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Theme.of(context).colorScheme.outline,
                )
              : null,
        ),
        subtitle: todo.notes != null
            ? Text(
                todo.notes!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (todo.dueDate != null)
              Text(
                DateFormatter.dueDate(todo.dueDate!),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _dueDateColor(
                    context,
                    todo.dueDate!,
                    todo.isCompleted,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _priorityColor(todo.priority),
              ),
            ),
          ],
        ),
        onTap: () => showCreateTodoSheet(context, existingTodo: todo),
      ),
    );
  }

  Color _priorityColor(Priority priority) => switch (priority) {
    Priority.low => Colors.green,
    Priority.medium => Colors.orange,
    Priority.high => Colors.red,
  };

  Color _dueDateColor(BuildContext context, DateTime dueDate, bool completed) {
    if (completed) return Theme.of(context).colorScheme.outline;
    final now = DateTime.now();
    if (dueDate.isBefore(now)) return Theme.of(context).colorScheme.error;
    final tomorrow = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 1));
    if (dueDate.isBefore(tomorrow)) return Colors.orange;
    return Theme.of(context).colorScheme.outline;
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
            Icons.check_circle_outline,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text('No todos yet', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Tap + to create one',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
