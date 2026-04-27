// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WhatsAppMessagesTable extends WhatsAppMessages
    with TableInfo<$WhatsAppMessagesTable, WhatsAppMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WhatsAppMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isConvertedToTodoMeta = const VerificationMeta(
    'isConvertedToTodo',
  );
  @override
  late final GeneratedColumn<bool> isConvertedToTodo = GeneratedColumn<bool>(
    'is_converted_to_todo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_converted_to_todo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sender,
    body,
    timestamp,
    isConvertedToTodo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'whats_app_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<WhatsAppMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sender')) {
      context.handle(
        _senderMeta,
        sender.isAcceptableOrUnknown(data['sender']!, _senderMeta),
      );
    } else if (isInserting) {
      context.missing(_senderMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('is_converted_to_todo')) {
      context.handle(
        _isConvertedToTodoMeta,
        isConvertedToTodo.isAcceptableOrUnknown(
          data['is_converted_to_todo']!,
          _isConvertedToTodoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WhatsAppMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WhatsAppMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      isConvertedToTodo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_converted_to_todo'],
      )!,
    );
  }

  @override
  $WhatsAppMessagesTable createAlias(String alias) {
    return $WhatsAppMessagesTable(attachedDatabase, alias);
  }
}

class WhatsAppMessage extends DataClass implements Insertable<WhatsAppMessage> {
  final int id;
  final String sender;
  final String body;
  final DateTime timestamp;
  final bool isConvertedToTodo;
  const WhatsAppMessage({
    required this.id,
    required this.sender,
    required this.body,
    required this.timestamp,
    required this.isConvertedToTodo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sender'] = Variable<String>(sender);
    map['body'] = Variable<String>(body);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['is_converted_to_todo'] = Variable<bool>(isConvertedToTodo);
    return map;
  }

  WhatsAppMessagesCompanion toCompanion(bool nullToAbsent) {
    return WhatsAppMessagesCompanion(
      id: Value(id),
      sender: Value(sender),
      body: Value(body),
      timestamp: Value(timestamp),
      isConvertedToTodo: Value(isConvertedToTodo),
    );
  }

  factory WhatsAppMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WhatsAppMessage(
      id: serializer.fromJson<int>(json['id']),
      sender: serializer.fromJson<String>(json['sender']),
      body: serializer.fromJson<String>(json['body']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      isConvertedToTodo: serializer.fromJson<bool>(json['isConvertedToTodo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sender': serializer.toJson<String>(sender),
      'body': serializer.toJson<String>(body),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'isConvertedToTodo': serializer.toJson<bool>(isConvertedToTodo),
    };
  }

  WhatsAppMessage copyWith({
    int? id,
    String? sender,
    String? body,
    DateTime? timestamp,
    bool? isConvertedToTodo,
  }) => WhatsAppMessage(
    id: id ?? this.id,
    sender: sender ?? this.sender,
    body: body ?? this.body,
    timestamp: timestamp ?? this.timestamp,
    isConvertedToTodo: isConvertedToTodo ?? this.isConvertedToTodo,
  );
  WhatsAppMessage copyWithCompanion(WhatsAppMessagesCompanion data) {
    return WhatsAppMessage(
      id: data.id.present ? data.id.value : this.id,
      sender: data.sender.present ? data.sender.value : this.sender,
      body: data.body.present ? data.body.value : this.body,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      isConvertedToTodo: data.isConvertedToTodo.present
          ? data.isConvertedToTodo.value
          : this.isConvertedToTodo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WhatsAppMessage(')
          ..write('id: $id, ')
          ..write('sender: $sender, ')
          ..write('body: $body, ')
          ..write('timestamp: $timestamp, ')
          ..write('isConvertedToTodo: $isConvertedToTodo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sender, body, timestamp, isConvertedToTodo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WhatsAppMessage &&
          other.id == this.id &&
          other.sender == this.sender &&
          other.body == this.body &&
          other.timestamp == this.timestamp &&
          other.isConvertedToTodo == this.isConvertedToTodo);
}

class WhatsAppMessagesCompanion extends UpdateCompanion<WhatsAppMessage> {
  final Value<int> id;
  final Value<String> sender;
  final Value<String> body;
  final Value<DateTime> timestamp;
  final Value<bool> isConvertedToTodo;
  const WhatsAppMessagesCompanion({
    this.id = const Value.absent(),
    this.sender = const Value.absent(),
    this.body = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.isConvertedToTodo = const Value.absent(),
  });
  WhatsAppMessagesCompanion.insert({
    this.id = const Value.absent(),
    required String sender,
    required String body,
    required DateTime timestamp,
    this.isConvertedToTodo = const Value.absent(),
  }) : sender = Value(sender),
       body = Value(body),
       timestamp = Value(timestamp);
  static Insertable<WhatsAppMessage> custom({
    Expression<int>? id,
    Expression<String>? sender,
    Expression<String>? body,
    Expression<DateTime>? timestamp,
    Expression<bool>? isConvertedToTodo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sender != null) 'sender': sender,
      if (body != null) 'body': body,
      if (timestamp != null) 'timestamp': timestamp,
      if (isConvertedToTodo != null) 'is_converted_to_todo': isConvertedToTodo,
    });
  }

  WhatsAppMessagesCompanion copyWith({
    Value<int>? id,
    Value<String>? sender,
    Value<String>? body,
    Value<DateTime>? timestamp,
    Value<bool>? isConvertedToTodo,
  }) {
    return WhatsAppMessagesCompanion(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isConvertedToTodo: isConvertedToTodo ?? this.isConvertedToTodo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (isConvertedToTodo.present) {
      map['is_converted_to_todo'] = Variable<bool>(isConvertedToTodo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WhatsAppMessagesCompanion(')
          ..write('id: $id, ')
          ..write('sender: $sender, ')
          ..write('body: $body, ')
          ..write('timestamp: $timestamp, ')
          ..write('isConvertedToTodo: $isConvertedToTodo')
          ..write(')'))
        .toString();
  }
}

class $TodosTable extends Todos with TableInfo<$TodosTable, Todo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Priority, int> priority =
      GeneratedColumn<int>(
        'priority',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Priority>($TodosTable.$converterpriority);
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sourceMessageIdMeta = const VerificationMeta(
    'sourceMessageId',
  );
  @override
  late final GeneratedColumn<int> sourceMessageId = GeneratedColumn<int>(
    'source_message_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    notes,
    dueDate,
    priority,
    isCompleted,
    sourceMessageId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Todo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('source_message_id')) {
      context.handle(
        _sourceMessageIdMeta,
        sourceMessageId.isAcceptableOrUnknown(
          data['source_message_id']!,
          _sourceMessageIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Todo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Todo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      priority: $TodosTable.$converterpriority.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}priority'],
        )!,
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      sourceMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_message_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TodosTable createAlias(String alias) {
    return $TodosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Priority, int, int> $converterpriority =
      const EnumIndexConverter<Priority>(Priority.values);
}

class Todo extends DataClass implements Insertable<Todo> {
  final int id;
  final String title;
  final String? notes;
  final DateTime? dueDate;
  final Priority priority;
  final bool isCompleted;
  final int? sourceMessageId;
  final DateTime createdAt;
  const Todo({
    required this.id,
    required this.title,
    this.notes,
    this.dueDate,
    required this.priority,
    required this.isCompleted,
    this.sourceMessageId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    {
      map['priority'] = Variable<int>(
        $TodosTable.$converterpriority.toSql(priority),
      );
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || sourceMessageId != null) {
      map['source_message_id'] = Variable<int>(sourceMessageId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TodosCompanion toCompanion(bool nullToAbsent) {
    return TodosCompanion(
      id: Value(id),
      title: Value(title),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      priority: Value(priority),
      isCompleted: Value(isCompleted),
      sourceMessageId: sourceMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceMessageId),
      createdAt: Value(createdAt),
    );
  }

  factory Todo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Todo(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      priority: $TodosTable.$converterpriority.fromJson(
        serializer.fromJson<int>(json['priority']),
      ),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      sourceMessageId: serializer.fromJson<int?>(json['sourceMessageId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String?>(notes),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'priority': serializer.toJson<int>(
        $TodosTable.$converterpriority.toJson(priority),
      ),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'sourceMessageId': serializer.toJson<int?>(sourceMessageId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Todo copyWith({
    int? id,
    String? title,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> dueDate = const Value.absent(),
    Priority? priority,
    bool? isCompleted,
    Value<int?> sourceMessageId = const Value.absent(),
    DateTime? createdAt,
  }) => Todo(
    id: id ?? this.id,
    title: title ?? this.title,
    notes: notes.present ? notes.value : this.notes,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    priority: priority ?? this.priority,
    isCompleted: isCompleted ?? this.isCompleted,
    sourceMessageId: sourceMessageId.present
        ? sourceMessageId.value
        : this.sourceMessageId,
    createdAt: createdAt ?? this.createdAt,
  );
  Todo copyWithCompanion(TodosCompanion data) {
    return Todo(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      priority: data.priority.present ? data.priority.value : this.priority,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      sourceMessageId: data.sourceMessageId.present
          ? data.sourceMessageId.value
          : this.sourceMessageId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Todo(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('dueDate: $dueDate, ')
          ..write('priority: $priority, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('sourceMessageId: $sourceMessageId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    notes,
    dueDate,
    priority,
    isCompleted,
    sourceMessageId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Todo &&
          other.id == this.id &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.dueDate == this.dueDate &&
          other.priority == this.priority &&
          other.isCompleted == this.isCompleted &&
          other.sourceMessageId == this.sourceMessageId &&
          other.createdAt == this.createdAt);
}

class TodosCompanion extends UpdateCompanion<Todo> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> notes;
  final Value<DateTime?> dueDate;
  final Value<Priority> priority;
  final Value<bool> isCompleted;
  final Value<int?> sourceMessageId;
  final Value<DateTime> createdAt;
  const TodosCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.priority = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.sourceMessageId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TodosCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.notes = const Value.absent(),
    this.dueDate = const Value.absent(),
    required Priority priority,
    this.isCompleted = const Value.absent(),
    this.sourceMessageId = const Value.absent(),
    required DateTime createdAt,
  }) : title = Value(title),
       priority = Value(priority),
       createdAt = Value(createdAt);
  static Insertable<Todo> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<DateTime>? dueDate,
    Expression<int>? priority,
    Expression<bool>? isCompleted,
    Expression<int>? sourceMessageId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (dueDate != null) 'due_date': dueDate,
      if (priority != null) 'priority': priority,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (sourceMessageId != null) 'source_message_id': sourceMessageId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TodosCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? notes,
    Value<DateTime?>? dueDate,
    Value<Priority>? priority,
    Value<bool>? isCompleted,
    Value<int?>? sourceMessageId,
    Value<DateTime>? createdAt,
  }) {
    return TodosCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      sourceMessageId: sourceMessageId ?? this.sourceMessageId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(
        $TodosTable.$converterpriority.toSql(priority.value),
      );
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (sourceMessageId.present) {
      map['source_message_id'] = Variable<int>(sourceMessageId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('dueDate: $dueDate, ')
          ..write('priority: $priority, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('sourceMessageId: $sourceMessageId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FilteredSendersTable extends FilteredSenders
    with TableInfo<$FilteredSendersTable, FilteredSender> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FilteredSendersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'filtered_senders';
  @override
  VerificationContext validateIntegrity(
    Insertable<FilteredSender> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FilteredSender map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FilteredSender(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $FilteredSendersTable createAlias(String alias) {
    return $FilteredSendersTable(attachedDatabase, alias);
  }
}

class FilteredSender extends DataClass implements Insertable<FilteredSender> {
  final int id;
  final String name;
  const FilteredSender({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  FilteredSendersCompanion toCompanion(bool nullToAbsent) {
    return FilteredSendersCompanion(id: Value(id), name: Value(name));
  }

  factory FilteredSender.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FilteredSender(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  FilteredSender copyWith({int? id, String? name}) =>
      FilteredSender(id: id ?? this.id, name: name ?? this.name);
  FilteredSender copyWithCompanion(FilteredSendersCompanion data) {
    return FilteredSender(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FilteredSender(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FilteredSender &&
          other.id == this.id &&
          other.name == this.name);
}

class FilteredSendersCompanion extends UpdateCompanion<FilteredSender> {
  final Value<int> id;
  final Value<String> name;
  const FilteredSendersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  FilteredSendersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<FilteredSender> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  FilteredSendersCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return FilteredSendersCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FilteredSendersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WhatsAppMessagesTable whatsAppMessages = $WhatsAppMessagesTable(
    this,
  );
  late final $TodosTable todos = $TodosTable(this);
  late final $FilteredSendersTable filteredSenders = $FilteredSendersTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    whatsAppMessages,
    todos,
    filteredSenders,
  ];
}

typedef $$WhatsAppMessagesTableCreateCompanionBuilder =
    WhatsAppMessagesCompanion Function({
      Value<int> id,
      required String sender,
      required String body,
      required DateTime timestamp,
      Value<bool> isConvertedToTodo,
    });
typedef $$WhatsAppMessagesTableUpdateCompanionBuilder =
    WhatsAppMessagesCompanion Function({
      Value<int> id,
      Value<String> sender,
      Value<String> body,
      Value<DateTime> timestamp,
      Value<bool> isConvertedToTodo,
    });

class $$WhatsAppMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $WhatsAppMessagesTable> {
  $$WhatsAppMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isConvertedToTodo => $composableBuilder(
    column: $table.isConvertedToTodo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WhatsAppMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $WhatsAppMessagesTable> {
  $$WhatsAppMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isConvertedToTodo => $composableBuilder(
    column: $table.isConvertedToTodo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WhatsAppMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WhatsAppMessagesTable> {
  $$WhatsAppMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<bool> get isConvertedToTodo => $composableBuilder(
    column: $table.isConvertedToTodo,
    builder: (column) => column,
  );
}

class $$WhatsAppMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WhatsAppMessagesTable,
          WhatsAppMessage,
          $$WhatsAppMessagesTableFilterComposer,
          $$WhatsAppMessagesTableOrderingComposer,
          $$WhatsAppMessagesTableAnnotationComposer,
          $$WhatsAppMessagesTableCreateCompanionBuilder,
          $$WhatsAppMessagesTableUpdateCompanionBuilder,
          (
            WhatsAppMessage,
            BaseReferences<
              _$AppDatabase,
              $WhatsAppMessagesTable,
              WhatsAppMessage
            >,
          ),
          WhatsAppMessage,
          PrefetchHooks Function()
        > {
  $$WhatsAppMessagesTableTableManager(
    _$AppDatabase db,
    $WhatsAppMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WhatsAppMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WhatsAppMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WhatsAppMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sender = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<bool> isConvertedToTodo = const Value.absent(),
              }) => WhatsAppMessagesCompanion(
                id: id,
                sender: sender,
                body: body,
                timestamp: timestamp,
                isConvertedToTodo: isConvertedToTodo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sender,
                required String body,
                required DateTime timestamp,
                Value<bool> isConvertedToTodo = const Value.absent(),
              }) => WhatsAppMessagesCompanion.insert(
                id: id,
                sender: sender,
                body: body,
                timestamp: timestamp,
                isConvertedToTodo: isConvertedToTodo,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WhatsAppMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WhatsAppMessagesTable,
      WhatsAppMessage,
      $$WhatsAppMessagesTableFilterComposer,
      $$WhatsAppMessagesTableOrderingComposer,
      $$WhatsAppMessagesTableAnnotationComposer,
      $$WhatsAppMessagesTableCreateCompanionBuilder,
      $$WhatsAppMessagesTableUpdateCompanionBuilder,
      (
        WhatsAppMessage,
        BaseReferences<_$AppDatabase, $WhatsAppMessagesTable, WhatsAppMessage>,
      ),
      WhatsAppMessage,
      PrefetchHooks Function()
    >;
typedef $$TodosTableCreateCompanionBuilder =
    TodosCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> notes,
      Value<DateTime?> dueDate,
      required Priority priority,
      Value<bool> isCompleted,
      Value<int?> sourceMessageId,
      required DateTime createdAt,
    });
typedef $$TodosTableUpdateCompanionBuilder =
    TodosCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> notes,
      Value<DateTime?> dueDate,
      Value<Priority> priority,
      Value<bool> isCompleted,
      Value<int?> sourceMessageId,
      Value<DateTime> createdAt,
    });

class $$TodosTableFilterComposer extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Priority, Priority, int> get priority =>
      $composableBuilder(
        column: $table.priority,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceMessageId => $composableBuilder(
    column: $table.sourceMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TodosTableOrderingComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceMessageId => $composableBuilder(
    column: $table.sourceMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TodosTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Priority, int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sourceMessageId => $composableBuilder(
    column: $table.sourceMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TodosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodosTable,
          Todo,
          $$TodosTableFilterComposer,
          $$TodosTableOrderingComposer,
          $$TodosTableAnnotationComposer,
          $$TodosTableCreateCompanionBuilder,
          $$TodosTableUpdateCompanionBuilder,
          (Todo, BaseReferences<_$AppDatabase, $TodosTable, Todo>),
          Todo,
          PrefetchHooks Function()
        > {
  $$TodosTableTableManager(_$AppDatabase db, $TodosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<Priority> priority = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int?> sourceMessageId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TodosCompanion(
                id: id,
                title: title,
                notes: notes,
                dueDate: dueDate,
                priority: priority,
                isCompleted: isCompleted,
                sourceMessageId: sourceMessageId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                required Priority priority,
                Value<bool> isCompleted = const Value.absent(),
                Value<int?> sourceMessageId = const Value.absent(),
                required DateTime createdAt,
              }) => TodosCompanion.insert(
                id: id,
                title: title,
                notes: notes,
                dueDate: dueDate,
                priority: priority,
                isCompleted: isCompleted,
                sourceMessageId: sourceMessageId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TodosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodosTable,
      Todo,
      $$TodosTableFilterComposer,
      $$TodosTableOrderingComposer,
      $$TodosTableAnnotationComposer,
      $$TodosTableCreateCompanionBuilder,
      $$TodosTableUpdateCompanionBuilder,
      (Todo, BaseReferences<_$AppDatabase, $TodosTable, Todo>),
      Todo,
      PrefetchHooks Function()
    >;
typedef $$FilteredSendersTableCreateCompanionBuilder =
    FilteredSendersCompanion Function({Value<int> id, required String name});
typedef $$FilteredSendersTableUpdateCompanionBuilder =
    FilteredSendersCompanion Function({Value<int> id, Value<String> name});

class $$FilteredSendersTableFilterComposer
    extends Composer<_$AppDatabase, $FilteredSendersTable> {
  $$FilteredSendersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FilteredSendersTableOrderingComposer
    extends Composer<_$AppDatabase, $FilteredSendersTable> {
  $$FilteredSendersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FilteredSendersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FilteredSendersTable> {
  $$FilteredSendersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$FilteredSendersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FilteredSendersTable,
          FilteredSender,
          $$FilteredSendersTableFilterComposer,
          $$FilteredSendersTableOrderingComposer,
          $$FilteredSendersTableAnnotationComposer,
          $$FilteredSendersTableCreateCompanionBuilder,
          $$FilteredSendersTableUpdateCompanionBuilder,
          (
            FilteredSender,
            BaseReferences<
              _$AppDatabase,
              $FilteredSendersTable,
              FilteredSender
            >,
          ),
          FilteredSender,
          PrefetchHooks Function()
        > {
  $$FilteredSendersTableTableManager(
    _$AppDatabase db,
    $FilteredSendersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FilteredSendersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FilteredSendersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FilteredSendersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => FilteredSendersCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  FilteredSendersCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FilteredSendersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FilteredSendersTable,
      FilteredSender,
      $$FilteredSendersTableFilterComposer,
      $$FilteredSendersTableOrderingComposer,
      $$FilteredSendersTableAnnotationComposer,
      $$FilteredSendersTableCreateCompanionBuilder,
      $$FilteredSendersTableUpdateCompanionBuilder,
      (
        FilteredSender,
        BaseReferences<_$AppDatabase, $FilteredSendersTable, FilteredSender>,
      ),
      FilteredSender,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WhatsAppMessagesTableTableManager get whatsAppMessages =>
      $$WhatsAppMessagesTableTableManager(_db, _db.whatsAppMessages);
  $$TodosTableTableManager get todos =>
      $$TodosTableTableManager(_db, _db.todos);
  $$FilteredSendersTableTableManager get filteredSenders =>
      $$FilteredSendersTableTableManager(_db, _db.filteredSenders);
}
