// Import the test package and Counter class
import 'package:flutter_messaging_ui/api/LocalApi.dart';
import 'package:test/test.dart';

void main() {
  group('Backend', () {
    final backend = MockBackend();
    test('should initialize without errors', () async {
      await backend.initialize();
    });

    test('should have 50 contacts', () {
      expect(backend.contacts.length, equals(50));
    });

    test('should have 25 chats', () {
      expect(backend.chats.length, equals(25));
    });

    test('chats should be non-empty', () {
      for (final chat in backend.chats) {
        expect(chat.members, isNotEmpty);
        expect(backend.messages[chat.id], isNotEmpty);
      }
    });
  });
}
