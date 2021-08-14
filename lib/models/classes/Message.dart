abstract class MessageBody {
  String get text;
}

class TextMessageBody extends MessageBody {
  final String text;

  TextMessageBody({required this.text});
}

class FileMessageBody extends MessageBody {
  final String url;
  final String? mime;
  final String? fileName;
  final int? fileSize;

  FileMessageBody({
    required this.url,
    this.mime,
    this.fileName,
    this.fileSize,
  });

  String get text => fileName != null ? 'File: $fileName' : '[File]';
}

class ImageMessageBody extends MessageBody {
  final String url;
  final String thumbnailUrl;
  final int width;
  final int height;

  ImageMessageBody({
    required this.url,
    required this.thumbnailUrl,
    required this.width,
    required this.height,
  });

  String get text => '[Image]';
}

abstract class ActionMessageBody extends MessageBody {}

class ChatCreatedActionMessageBody implements ActionMessageBody {
  String get text => 'Chat created';
}

class MessageExtras {
  // A [seq] of a message to which this message is a reply
  final int? refSeq;

  MessageExtras({
    this.refSeq,
  });
}

class Message {
  // Messages are ordered by incrementing [seq] value, starting from 1.
  final int seq;
  final String senderId;
  final MessageBody body;
  final int sentAt;
  MessageExtras? extra;

  Message({
    required this.seq,
    required this.senderId,
    required this.body,
    required this.sentAt,
    this.extra,
  });

  DateTime get sentAtDate => DateTime.fromMillisecondsSinceEpoch(sentAt);
}

enum MessageStatus {
  sent,
  read,
}