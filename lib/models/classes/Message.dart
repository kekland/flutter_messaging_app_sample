class MessageBody {}

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
}

class MessageExtras {
  // A [seq] of a message to which this message is a reply
  final int? refSeq;

  MessageExtras({
    this.refSeq,
  });
}

class Message {
  // Messages are ordered by incrementing [seq] value, starting from 0.
  final int seq;
  final String senderId;
  final MessageBody body;
  final int sentAt;
  final MessageExtras extra;

  Message({
    required this.seq,
    required this.senderId,
    required this.body,
    required this.extra,
    required this.sentAt,
  });
}