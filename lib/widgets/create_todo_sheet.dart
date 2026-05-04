import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../services/ai_service.dart';
import '../services/database_service.dart';
import '../services/settings_service.dart';
import 'app_notification.dart';

void showCreateTodoSheet(
  BuildContext context, {
  WhatsAppMessage? sourceMessage,
  Todo? existingTodo,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _CreateTodoSheet(
      sourceMessage: sourceMessage,
      existingTodo: existingTodo,
    ),
  );
}

class _CreateTodoSheet extends StatefulWidget {
  final WhatsAppMessage? sourceMessage;
  final Todo? existingTodo;

  const _CreateTodoSheet({this.sourceMessage, this.existingTodo});

  @override
  State<_CreateTodoSheet> createState() => _CreateTodoSheetState();
}

class _CreateTodoSheetState extends State<_CreateTodoSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  DateTime? _dueDate;
  late Priority _priority;
  bool _aiLoading = false;
  bool _quotaExhausted = false;
  NotificationData? _notification;

  @override
  void initState() {
    super.initState();
    SettingsService.isGroqQuotaExhausted().then((v) {
      if (mounted) setState(() => _quotaExhausted = v);
    });
    final existing = widget.existingTodo;
    final msg = widget.sourceMessage;
    _titleController = TextEditingController(
      text: existing?.title ?? (msg != null ? '${msg.sender}: ' : ''),
    );
    _notesController = TextEditingController(
      text: existing?.notes ?? msg?.body ?? '',
    );
    _dueDate = existing?.dueDate;
    _priority = existing?.priority ?? Priority.medium;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showNotification(String message, NotificationType type) {
    setState(() => _notification = NotificationData(message, type));
  }

  Future<void> _suggestWithAi() async {
    if (_quotaExhausted) return;
    final apiKey = await SettingsService.getGroqApiKey();
    if (!mounted) return;
    if (apiKey == null) {
      _showNotification('Set your Groq API key in Settings first', NotificationType.error);
      return;
    }
    setState(() {
      _aiLoading = true;
      _notification = null;
    });
    try {
      final suggestion = await AiService.suggestTodo(
        sender: widget.sourceMessage!.sender,
        body: widget.sourceMessage!.body,
        apiKey: apiKey,
      );
      if (!mounted) return;
      setState(() => _aiLoading = false);
      if (suggestion == null) {
        _showNotification("This message doesn't seem to need a todo", NotificationType.info);
        return;
      }
      setState(() {
        _titleController.text = widget.sourceMessage!.sender;
        _notesController.text = widget.sourceMessage!.body;
        if (suggestion.dueDate != null) _dueDate = suggestion.dueDate;
        _priority = suggestion.priority;
      });
    } on AiQuotaExceededException {
      if (!mounted) return;
      setState(() {
        _aiLoading = false;
        _quotaExhausted = true;
      });
      await SettingsService.setGroqQuotaExhausted();
      if (mounted) {
        _showNotification(
          'Groq quota exhausted. Update your API key in Settings.',
          NotificationType.error,
        );
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    final notes =
        _notesController.text.trim().isEmpty ? null : _notesController.text.trim();
    final db = DatabaseService.instance;

    if (widget.existingTodo != null) {
      await db.updateTodo(
        widget.existingTodo!.id,
        TodosCompanion(
          title: Value(title),
          notes: Value(notes),
          dueDate: Value(_dueDate),
          priority: Value(_priority),
        ),
      );
    } else {
      await db.saveTodo(
        title: title,
        notes: notes,
        dueDate: _dueDate,
        priority: _priority,
        sourceMessageId: widget.sourceMessage?.id,
      );
      if (widget.sourceMessage != null) {
        await db.markMessageConverted(widget.sourceMessage!.id);
      }
    }
    if (mounted) Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff =
        DateTime(date.year, date.month, date.day).difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingTodo != null;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                isEditing ? 'Edit Todo' : 'New Todo',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_notification != null)
            AppNotification(
              data: _notification!,
              onClose: () => setState(() => _notification = null),
            ),
          if (widget.sourceMessage != null && !isEditing)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OutlinedButton.icon(
                onPressed: (_aiLoading || _quotaExhausted) ? null : _suggestWithAi,
                icon: _aiLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome, size: 18),
                label: Text(
                  _aiLoading
                      ? 'Analyzing…'
                      : _quotaExhausted
                          ? 'Quota exhausted'
                          : 'Suggest with AI',
                ),
              ),
            ),
          TextField(
            controller: _titleController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notes (optional)',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today_outlined, size: 18),
                  label: Text(
                    _dueDate == null ? 'Set due date' : _formatDate(_dueDate!),
                  ),
                ),
              ),
              if (_dueDate != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => _dueDate = null),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          SegmentedButton<Priority>(
            segments: const [
              ButtonSegment(
                value: Priority.low,
                label: Text('Low'),
                icon: Icon(Icons.arrow_downward, size: 16),
              ),
              ButtonSegment(
                value: Priority.medium,
                label: Text('Medium'),
                icon: Icon(Icons.remove, size: 16),
              ),
              ButtonSegment(
                value: Priority.high,
                label: Text('High'),
                icon: Icon(Icons.arrow_upward, size: 16),
              ),
            ],
            selected: {_priority},
            onSelectionChanged: (s) => setState(() => _priority = s.first),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _save,
            child: Text(isEditing ? 'Save Changes' : 'Create Todo'),
          ),
        ],
      ),
    );
  }
}