import 'dart:convert';
import 'dart:math';

import 'package:flutter_messaging_ui/models/classes/Chat.dart';
import 'package:flutter_messaging_ui/models/classes/Message.dart';
import 'package:flutter_messaging_ui/models/classes/User.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

String _capitalizeFirstLetter(String word) {
  return word.substring(0, 1).toUpperCase() + word.substring(1);
}

// Imagine this class as being a mock API for the app
class MockApi {
  final Map<String, User> contacts;
  final Map<String, Chat> chats;
  final Map<String, List<Message>> messages;
  final Duration delay;

  /// [delay] is the delay for requests. See [_requestWrapper] for more info.
  MockApi({this.delay = const Duration(milliseconds: 500)})
      : contacts = {},
        chats = {},
        messages = {};

  User get _self => User(
        id: '_',
        username: 'kekland',
      );

  Future<void> initialize() async {
    await _populateContents();
  }

  final _random = Random();
  Future<List<User>> _generateRandomUsers() async {
    final response = await http.get(
      Uri.parse('https://random-data-api.com/api/users/random_user?size=50'),
    );

    final json = jsonDecode(response.body) as List<dynamic>;

    return json
        .map<User>(
          (v) => User(
            id: Uuid().v4(),
            username: v['first_name'],
            // 50% chance that the user will have an avatar
            avatarUrl: _random.nextDouble() > 0.5 ? v['avatar'] : null,
            // 15% chance that the user is online
            lastSeen: _random.nextDouble() > 0.15
                ? DateTime.now().millisecondsSinceEpoch -
                    _random.nextInt(100000)
                : -1,
          ),
        )
        .toList();
  }

  Future<List<Chat>> _generateRandomChats({
    required List<User> contacts,
  }) async {
    final response = await http.get(
      Uri.parse(
        'https://random-data-api.com/api/lorem_ipsum/random_lorem_ipsum?size=25',
      ),
    );

    final json = jsonDecode(response.body) as List<dynamic>;
    final tempContacts = List.of(contacts);

    return json.map<Chat>((v) {
      // 10% chance of being a group chat
      final isGroupChat = _random.nextDouble() < 0.1;

      if (isGroupChat) {
        // From 2 to 7 members, excluding self
        final memberCount = 2 + _random.nextInt(5);
        tempContacts.shuffle();
        final members = tempContacts.sublist(0, memberCount);

        return GroupChat(
          id: Uuid().v4(),
          name: _capitalizeFirstLetter(v['word']),
          members: Set.from([...members, _self]),
          lastMessage: null, // Will be populated later
        );
      } else {
        final member = tempContacts[_random.nextInt(tempContacts.length)];

        return DirectChat(
          self: _self,
          peer: member,
          lastMessage: null, // Will be populated later
        );
      }
    }).toList();
  }

  Future<Map<Chat, List<Message>>> _generateRandomMessagesForChats({
    required List<Chat> chats,
  }) async {
    // Get random 'Lorem Ipsum' style texts
    final textResponse = await http.get(
      Uri.parse(
        'https://random-data-api.com/api/lorem_ipsum/random_lorem_ipsum?size=100',
      ),
    );

    final textJson = jsonDecode(textResponse.body) as List<dynamic>;
    final messageBodies = textJson
        .map<List<String>>(
          (v) => [
            v['short_sentence'],
            v['long_sentence'],
            v['very_long_sentence'],
            v['question'],
            ...v['paragraphs'],
            ...v['questions'],
          ],
        )
        .expand((v) => v)
        .toList();

    // Get random images
    final imageResponse = await http.get(
      Uri.parse(
        'https://random-data-api.com/api/lorem_pixel/random_lorem_pixel?size=100',
      ),
    );

    final imageJson = jsonDecode(imageResponse.body) as List<dynamic>;
    final imageBodies = imageJson
        .map<ImageMessageBody>(
          (v) => ImageMessageBody(
            url: v['image_500_500'],
            thumbnailUrl: v['image'],
            width: 500,
            height: 500,
          ),
        )
        .toList();

    final result = <Chat, List<Message>>{};

    for (final chat in chats) {
      // 20 <= n < 50, where n is the number of messages
      final messageCount = 20 + _random.nextInt(30);

      final messages = <Message>[];
      for (var i = 0; i < messageCount; i++) {
        // 10% chance of being an image
        final isImage = _random.nextDouble() < 0.1;

        final body = isImage
            ? imageBodies[_random.nextInt(imageBodies.length)]
            : TextMessageBody(
                text: messageBodies[_random.nextInt(messageBodies.length)],
              );

        // 10% chance of being a reply, given that i > 0
        final refSeq =
            i > 0 && _random.nextDouble() < 0.1 ? _random.nextInt(i) : null;

        final sender = chat.members.elementAt(
          _random.nextInt(chat.members.length - 1),
        );

        // [sentAt] value is in range [now - 1e6, now] seconds for the first message,
        // and is randomly generated to be always increasing for the consecutive messages.
        final lastMessageSentAt =
            messages.isNotEmpty ? messages.last.sentAt : null;

        final sentAt = lastMessageSentAt != null
            ? lastMessageSentAt +
                _random.nextInt(
                  DateTime.now().millisecondsSinceEpoch - lastMessageSentAt,
                )
            : DateTime.now().millisecondsSinceEpoch -
                _random.nextInt(1000000000);

        messages.add(
          Message(
            seq: messages.length + 2,
            body: body,
            senderId: sender.id,
            sentAt: sentAt,
            extra: MessageExtras(
              refSeq: refSeq,
            ),
          ),
        );
      }

      final newChat = Chat.withLastMessage(
        chat: chat,
        lastMessage: messages.last,
      );

      result[newChat] = [
        Message(
          seq: 1,
          body: ChatCreatedActionMessageBody(),
          sentAt: messages.first.sentAt,
          senderId: 'bot',
        ),
        ...messages,
      ];
    }

    return result;
  }

  Future<void> _populateContents() async {
    final _contacts = await _generateRandomUsers();
    final _tempChats = await _generateRandomChats(contacts: _contacts);
    final _chatsAndMessages = await _generateRandomMessagesForChats(
      chats: _tempChats,
    );

    for (final contact in _contacts) {
      contacts[contact.id] = contact;
    }

    for (final chat in _chatsAndMessages.keys) {
      chats[chat.id] = chat;
    }

    for (final entry in _chatsAndMessages.entries) {
      final id = entry.key.id;

      messages[id] ??= <Message>[];
      messages[id]!.addAll(entry.value);
    }
  }

  /// Adds an artificial delay to the API methods to simulate a real environment
  Future<T> _requestWrapper<T>(T response) async {
    if (delay.inMilliseconds > 0) {
      await Future.delayed(delay);
    }

    return response;
  }

  Future<List<User>> getContacts() async {
    return _requestWrapper(contacts.values.toList());
  }

  Future<List<Chat>> getChats() async {
    return _requestWrapper(chats.values.toList());
  }

  /// Returns [count] messages that are before [lastSeq]. Set [lastSeq] to `0` to get the latest messages.
  Future<List<Message>> getPaginatedMessagesForChat({
    required String chatId,
    required int lastSeq,
    int count = 20,
  }) async {
    final _messages = messages[chatId];

    if (_messages == null) throw Exception('No chat with id $chatId found.');

    if (lastSeq == 0) {
      return _messages.sublist(max(0, _messages.length - count));
    } else {
      return _messages.sublist(max(0, lastSeq - count - 1), lastSeq - 1);
    }
  }

  Future<DirectChat> createDirectChat({required String contactId}) async {
    final contact = contacts[contactId];
    final isExistingChat = chats[contactId] != null;

    if (contact == null) {
      throw Exception('No contact with id $contactId found.');
    }

    if (isExistingChat) {
      return chats[contactId] as DirectChat;
    } else {
      final _message = Message(
        seq: 1,
        body: ChatCreatedActionMessageBody(),
        sentAt: DateTime.now().millisecondsSinceEpoch,
        senderId: 'bot',
      );

      final chat = DirectChat(
        self: _self,
        peer: contact,
        lastMessage: _message,
      );

      messages[chat.id] = [_message];
      chats[chat.id] = chat;

      return _requestWrapper(chat);
    }
  }

  Future<GroupChat> createGroupChat({
    required String name,
    required List<String> contactIds,
  }) async {
    final _contacts = contactIds
        .map((id) => contacts[id])
        .where((v) => v != null)
        .cast<User>()
        .toList();

    _contacts.add(_self);

    final _message = Message(
      seq: 1,
      body: ChatCreatedActionMessageBody(),
      sentAt: DateTime.now().millisecondsSinceEpoch,
      senderId: 'bot',
    );

    final chat = GroupChat(
      id: Uuid().v4(),
      name: name,
      members: _contacts.toSet(),
      lastMessage: _message,
    );

    messages[chat.id] = [_message];
    chats[chat.id] = chat;

    return _requestWrapper(chat);
  }

  Future<Message> sendMessage({
    required String chatId,
    required MessageBody body,
    MessageExtras? extra,
  }) async {
    final chat = chats[chatId];

    if (chat == null) throw Exception('No chat with id $chatId found.');

    final message = Message(
      seq: messages[chatId]!.length + 1,
      body: body,
      extra: extra,
      senderId: _self.id,
      sentAt: DateTime.now().millisecondsSinceEpoch,
    );

    messages[chatId]!.add(message);
    chats[chatId] = Chat.withLastMessage(chat: chat, lastMessage: message);
    return _requestWrapper(message);
  }
}
