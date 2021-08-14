import 'package:flutter_messaging_ui/models/classes/Message.dart';
import 'package:flutter_messaging_ui/models/classes/User.dart';

abstract class Chat {
  final String id;
  final String name;
  final Set<User> members;
  final Message? lastMessage;

  Chat({
    required this.id,
    required this.name,
    required this.members,
    required this.lastMessage,
  });
}

class DirectChat implements Chat {
  DirectChat({
    required this.self,
    required this.peer,
    this.lastMessage,
  }) : super();

  final User self;
  final User peer;
  final Message? lastMessage;

  @override
  String get id => peer.id;

  @override
  Set<User> get members => {self, peer};

  @override
  String get name => peer.username;
}

class GroupChat extends Chat {
  GroupChat({
    required String id,
    required String name,
    required Set<User> members,
    Message? lastMessage,
  }) : super(
          id: id,
          name: name,
          members: members,
          lastMessage: lastMessage,
        );
}
