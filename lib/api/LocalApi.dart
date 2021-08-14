import 'dart:convert';
import 'dart:math';

import 'package:flutter_messaging_ui/models/classes/Chat.dart';
import 'package:flutter_messaging_ui/models/classes/Message.dart';
import 'package:flutter_messaging_ui/models/classes/User.dart';
import 'package:http/http.dart' as http;

String _capitalizeFirstLetter(String word) {
  return word.substring(0, 1).toUpperCase() + word.substring(1);
}

// Imagine this class as being a mock backend for the app
class MockBackend {
  final List<User> contacts;
  final List<Chat> chats;
  final Map<String, List<Message>> messages;

  MockBackend()
      : contacts = [],
        chats = [],
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
            id: v['uid'],
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
          id: v['uid'],
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
            seq: messages.length,
            body: body,
            senderId: sender.id,
            sentAt: sentAt,
            extra: MessageExtras(
              refSeq: refSeq,
            ),
          ),
        );
      }

      final newChat = chat is DirectChat
          ? DirectChat(
              self: _self,
              peer: chat.peer,
              lastMessage: messages.last,
            )
          : GroupChat(
              id: chat.id,
              name: chat.name,
              members: chat.members,
              lastMessage: messages.last,
            );

      result[newChat] = messages;
    }

    return result;
  }

  Future<void> _populateContents() async {
    final _contacts = await _generateRandomUsers();
    final _tempChats = await _generateRandomChats(contacts: _contacts);
    final _chatsAndMessages = await _generateRandomMessagesForChats(
      chats: _tempChats,
    );

    contacts.addAll(_contacts);
    chats.addAll(_chatsAndMessages.keys);

    for (final entry in _chatsAndMessages.entries) {
      final id = entry.key.id;

      messages[id] ??= <Message>[];
      messages[id]!.addAll(entry.value);
    }
  }
}
