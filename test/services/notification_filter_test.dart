import 'package:flutter_test/flutter_test.dart';

// Mirrors the pattern in NotificationService._summaryPattern.
// Update both if the production regex changes.
final _summaryPattern = RegExp(r'^\d+ new messages', caseSensitive: false);

void main() {
  group('WhatsApp summary notification filter', () {
    final shouldFilter = [
      '5 new messages',
      '1 new messages',
      '10 new messages from John',
      '3 NEW MESSAGES',
      '2 new messages from Work Group',
    ];

    final shouldPass = [
      'Hey, are you coming tomorrow?',
      'Please send the report by Friday',
      'new messages are waiting',
      'I have 5 new messages for you',
      '',
    ];

    for (final msg in shouldFilter) {
      test('filters: "$msg"', () {
        expect(_summaryPattern.hasMatch(msg), isTrue);
      });
    }

    for (final msg in shouldPass) {
      test('passes:  "$msg"', () {
        expect(_summaryPattern.hasMatch(msg), isFalse);
      });
    }
  });
}