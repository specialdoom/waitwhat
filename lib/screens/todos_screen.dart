import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../services/database_service.dart';
import '../widgets/create_todo_sheet.dart';

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
      body: StreamBuilder<List<Todo>>(
        stream: DatabaseService.instance.watchTodos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final todos = snapshot.data!;
          if (todos.isEmpty) return const _EmptyState();

          final groups = _groupTodos(todos);
          return ListView(
            children: [
              for (final entry in groups.entries) ...[
                _SectionHeader(title: entry.key),
                for (final todo in entry.value) _TodoItem(todo: todo),
              ],
              const SizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }

  Map<String, List<Todo>> _groupTodos(List<Todo> todos) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final pending = todos.where((t) => !t.isCompleted).toList();
    final done = todos.where((t) => t.isCompleted).toList();

    final todayList = pending
        .where((t) =>
            t.dueDate != null &&
            !t.dueDate!.isBefore(today) &&
            t.dueDate!.isBefore(tomorrow))
        .toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    final upcomingList = pending
        .where((t) => t.dueDate != null && !t.dueDate!.isBefore(tomorrow))
        .toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    final noDueDateList =
        pending.where((t) => t.dueDate == null).toList();

    return {
      if (todayList.isNotEmpty) 'Today': todayList,
      if (upcomingList.isNotEmpty) 'Upcoming': upcomingList,
      if (noDueDateList.isNotEmpty) 'No due date': noDueDateList,
      if (done.isNotEmpty) 'Done': done,
    };
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

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
                _formatDate(todo.dueDate!),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _dueDateColor(context, todo.dueDate!, todo.isCompleted),
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
    final tomorrow =
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    if (dueDate.isBefore(tomorrow)) return Colors.orange;
    return Theme.of(context).colorScheme.outline;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff =
        DateTime(date.year, date.month, date.day).difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
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
          Text('No todos yet',
              style: Theme.of(context).textTheme.titleMedium),
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