import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../database/app_database.dart';

class AiQuotaExceededException implements Exception {}

class AiSuggestion {
  final String title;
  final String? notes;
  final DateTime? dueDate;
  final Priority priority;

  AiSuggestion({
    required this.title,
    this.notes,
    this.dueDate,
    required this.priority,
  });
}

class AiService {
  static String _prompt(String sender, String body) => '''
Analyze this WhatsApp message (which may be written in Romanian) and extract a single actionable todo item.
Keep the title and notes in the same language as the message.
Respond with ONLY a valid JSON object, no markdown, no explanation:
{
  "title": "brief action title",
  "notes": "additional context or null",
  "dueDate": "YYYY-MM-DD if a date is mentioned, otherwise null",
  "priority": "low, medium, or high based on urgency"
}

Message from $sender:
$body
''';

  static Future<AiSuggestion?> suggestTodo({
    required String sender,
    required String body,
    required String apiKey,
  }) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );

      final response = await model.generateContent(
        [Content.text(_prompt(sender, body))],
      );

      final text = response.text;
      if (text == null || text.trim().isEmpty) return null;

      final cleaned = text
          .replaceAll(RegExp(r'```json\s*'), '')
          .replaceAll(RegExp(r'```\s*'), '')
          .trim();

      final json = jsonDecode(cleaned) as Map<String, dynamic>;

      final dueDateStr = json['dueDate'];
      DateTime? dueDate;
      if (dueDateStr != null && dueDateStr != 'null') {
        dueDate = DateTime.tryParse(dueDateStr as String);
      }

      final priorityStr =
          ((json['priority'] as String?) ?? 'medium').toLowerCase();
      final priority = switch (priorityStr) {
        'low' => Priority.low,
        'high' => Priority.high,
        _ => Priority.medium,
      };

      final notes = json['notes'];
      return AiSuggestion(
        title: (json['title'] as String?) ?? body,
        notes: (notes == null || notes == 'null') ? null : notes as String,
        dueDate: dueDate,
        priority: priority,
      );
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('resource_exhausted') ||
          msg.contains('429') ||
          msg.contains('quota')) {
        throw AiQuotaExceededException();
      }
      return null;
    }
  }
}