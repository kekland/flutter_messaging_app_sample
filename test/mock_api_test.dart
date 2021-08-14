// Import the test package and Counter class
import 'package:flutter_messaging_ui/api/mock_api.dart';
import 'package:flutter_messaging_ui/models/classes/chat.dart';
import 'package:flutter_messaging_ui/models/classes/message.dart';
import 'package:test/test.dart';

void main() {
  group('API', () {
    final api = MockApi(delay: Duration.zero);

    test('intiailizes', () async {
      await api.initialize();
    });

    test('returns correct contacts', () async {
      final contacts = await api.getContacts();
      expect(contacts.length, equals(api.contacts.length));
    });

    test('returns correct chats', () async {
      final chats = await api.getChats();
      expect(chats.length, equals(api.chats.length));
    });

    test('chats should be non-empty', () {
      for (final chat in api.chats.values) {
        expect(chat.members, isNotEmpty);
        expect(api.messages[chat.id], isNotEmpty);
      }
    });

    test('should return last 20 messages', () async {
      final chat = api.chats.values.first;
      final messages = await api.getPaginatedMessagesForChat(
        chatId: chat.id,
        lastSeq: 0,
      );
      expect(messages.length, equals(20));
    });

    test('lastMessage is correct', () async {
      for (final chat in api.chats.values) {
        expect(chat.lastMessage, equals(api.messages[chat.id]!.last));
      }
    });

    test('should return all messages with pagination', () async {
      final chat = api.chats.values.first;
      final collectedMessages = <Message>[];

      while (true) {
        final messages = await api.getPaginatedMessagesForChat(
          chatId: chat.id,
          lastSeq:
              collectedMessages.isNotEmpty ? collectedMessages.first.seq : 0,
        );

        collectedMessages.insertAll(0, messages);
        if (messages.length < 20) break;
      }

      expect(collectedMessages.length, equals(api.messages[chat.id]!.length));
    });

    group('direct chats', () {
      test('returns an existing chat', () async {
        final chat = api.chats.values.firstWhere(
          (v) => v is DirectChat,
        ) as DirectChat;

        final returnedChat = await api.createDirectChat(
          contactId: chat.peer.id,
        );

        expect(returnedChat, equals(chat));
      });

      // This test might fail in a rare case when
      // there are direct chats with all contacts
      test('creates a new chat', () async {
        final contact = api.contacts.values.firstWhere(
          (v) => api.chats[v.id] == null,
        );

        final newChat = await api.createDirectChat(contactId: contact.id);

        expect(api.chats.values, contains(newChat));
        expect(api.messages[newChat.id]!.length, equals(1));
      });
    });

    group('group chats', () {
      test('creates a new chat', () async {
        final name = 'test 1';
        final contact = api.contacts.values.take(5).toList();

        final newChat = await api.createGroupChat(
          name: name,
          contactIds: contact.map((v) => v.id).toList(),
        );

        expect(api.chats[newChat.id]!.name, equals(name));
        expect(api.chats[newChat.id]!.members.length, equals(6));
      });
    });

    group('messaging', () {
      test('can send', () async {
        final messageBody = 'Hello, world!';
        final chat = api.chats.values.first;

        final message = await api.sendMessage(
          chatId: chat.id,
          body: TextMessageBody(text: messageBody),
        );

        expect(message.seq, equals(api.messages[chat.id]!.length));
        expect(api.chats[chat.id]!.lastMessage, equals(message));

        final lastMessages = await api.getPaginatedMessagesForChat(
          chatId: chat.id,
          lastSeq: 0,
        );

        expect(lastMessages, contains(message));
      });
    });
  });
}
