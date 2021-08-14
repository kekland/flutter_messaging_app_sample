import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_messaging_ui/models/classes/Message.dart';
import 'package:flutter_messaging_ui/models/classes/User.dart';
import 'package:flutter_messaging_ui/models/providers/UserProvider.dart';
import 'package:flutter_messaging_ui/utils/extensions.dart';
import 'package:provider/provider.dart';

class MiniTextMessageWidget extends StatelessWidget {
  const MiniTextMessageWidget({
    Key? key,
    this.senderName,
    required this.body,
  }) : super(key: key);

  final String? senderName;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          if (senderName != null)
            TextSpan(
              text: '$senderName: ',
              style: TextStyle(
                color: context.textTheme.bodyText1!.color,
              ),
            ),
          TextSpan(
            text: body,
            style: TextStyle(
              color: context.textTheme.caption!.color,
            ),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class MiniImageMessageWidget extends StatelessWidget {
  const MiniImageMessageWidget({
    Key? key,
    this.senderName,
    required this.url,
  }) : super(key: key);

  final String? senderName;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          if (senderName != null)
            TextSpan(
              text: '$senderName: ',
              style: TextStyle(
                color: context.textTheme.bodyText1!.color,
              ),
            ),
          WidgetSpan(
            child: Container(
              width: 16.0,
              height: 16.0,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(4.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(url),
            ),
          ),
          TextSpan(
            text: ' Photo',
            style: TextStyle(
              color: context.theme.accentColor,
            ),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class MiniMessageWidget extends StatelessWidget {
  const MiniMessageWidget({
    Key? key,
    this.sender,
    required this.message,
  }) : super(key: key);

  final User? sender;
  final Message message;

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    final senderName =
        sender?.id == userProvider.self?.id ? 'You' : sender?.username;

    if (message.body is ImageMessageBody) {
      return MiniImageMessageWidget(
        url: (message.body as ImageMessageBody).thumbnailUrl,
        senderName: senderName,
      );
    }

    return MiniTextMessageWidget(
      body: message.body.text,
      senderName: senderName,
    );
  }
}
