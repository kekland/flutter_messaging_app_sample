import 'package:flutter_messaging_ui/models/classes/Message.dart';
import 'package:flutter_messaging_ui/models/classes/User.dart';

abstract class Chat {
  final String id;
  final String name;
  final Set<User> members;
  final Message? lastMessage;
  final int? lastReadSeq;

  Chat({
    required this.id,
    required this.name,
    required this.members,
    required this.lastMessage,
    this.lastReadSeq,
  });

  static copyWith({
    required Chat chat,
    Message? lastMessage,
    int? lastReadSeq,
  }) {
    if (chat is DirectChat) {
      return chat.copyWith(
        lastMessage: lastMessage,
        lastReadSeq: lastReadSeq,
      );
    } else if (chat is GroupChat) {
      return chat.copyWith(
        lastMessage: lastMessage,
        lastReadSeq: lastReadSeq,
      );
    }

    return null;
  }
}

/// [DirectChat]'s [id] field is equal to peer's [id].
class DirectChat implements Chat {
  DirectChat({
    required this.self,
    required this.peer,
    this.status,
    this.lastMessage,
    this.lastReadSeq,
  }) : super();

  final User self;
  final User peer;
  final MessageStatus? status;
  final Message? lastMessage;
  final int? lastReadSeq;

  @override
  String get id => peer.id;

  @override
  Set<User> get members => {self, peer};

  @override
  String get name => peer.username;

  DirectChat copyWith({
    Message? lastMessage,
    int? lastReadSeq,
  }) {
    return DirectChat(
      self: self,
      peer: peer,
      lastMessage: lastMessage ?? this.lastMessage,
      lastReadSeq: lastReadSeq ?? this.lastReadSeq,
    );
  }
}

/// [GroupChat]'s [id] field is a generated [UUID] string.
class GroupChat extends Chat {
  GroupChat({
    required String id,
    required String name,
    required Set<User> members,
    Message? lastMessage,
    int? lastReadSeq,
  }) : super(
          id: id,
          name: name,
          members: members,
          lastMessage: lastMessage,
          lastReadSeq: lastReadSeq,
        );

  GroupChat copyWith({
    Message? lastMessage,
    int? lastReadSeq,
  }) {
    return GroupChat(
      id: id,
      name: name,
      members: members,
      lastMessage: lastMessage ?? this.lastMessage,
      lastReadSeq: lastReadSeq ?? this.lastReadSeq,
    );
  }
}
