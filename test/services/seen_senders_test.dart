import 'package:flutter_test/flutter_test.dart';
import 'package:waitwhat/services/notification_service.dart';

void main() {
  setUp(() => NotificationService.seenSenders.clear());

  group('NotificationService.trackSender', () {
    test('adds sender for a regular message', () {
      NotificationService.trackSender('John', 'Can you call me?');
      expect(NotificationService.seenSenders, contains('John'));
    });

    test('adds sender for a summary notification', () {
      NotificationService.trackSender('Alice', '5 new messages');
      expect(NotificationService.seenSenders, contains('Alice'));
    });

    test('adds sender for a group summary notification', () {
      NotificationService.trackSender('Family Group', '3 new messages');
      expect(NotificationService.seenSenders, contains('Family Group'));
    });

    test('does not add sender when body is null', () {
      NotificationService.trackSender('John', null);
      expect(NotificationService.seenSenders, isEmpty);
    });

    test('does not add sender when body is empty', () {
      NotificationService.trackSender('John', '');
      expect(NotificationService.seenSenders, isEmpty);
    });

    test('does not add sender when body is whitespace only', () {
      NotificationService.trackSender('John', '   ');
      expect(NotificationService.seenSenders, isEmpty);
    });

    test('deduplicates the same sender across multiple messages', () {
      NotificationService.trackSender('John', 'Message 1');
      NotificationService.trackSender('John', 'Message 2');
      NotificationService.trackSender('John', 'Message 3');
      expect(NotificationService.seenSenders.length, 1);
      expect(NotificationService.seenSenders, contains('John'));
    });

    test('tracks multiple distinct senders', () {
      NotificationService.trackSender('John', 'Hey');
      NotificationService.trackSender('Alice', 'Hi');
      NotificationService.trackSender('Bob', 'Hello');
      expect(NotificationService.seenSenders.length, 3);
    });

    test('adds sender from non-monitored contact', () {
      NotificationService.trackSender('Stranger', 'Random message');
      expect(NotificationService.seenSenders, contains('Stranger'));
    });
  });
}
