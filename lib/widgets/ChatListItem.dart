import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_messaging_ui/models/classes/Message.dart';
import 'package:flutter_messaging_ui/utils/extensions.dart';
import 'package:flutter_messaging_ui/models/classes/Chat.dart';
import 'package:flutter_messaging_ui/utils/time.dart';
import 'package:flutter_messaging_ui/widgets/AvatarWidget.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({
    Key? key,
    required this.chat,
  }) : super(key: key);

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final unreadMessages = chat.lastMessage!.seq - chat.lastReadSeq!;

    return ListTile(
      leading: chat is DirectChat
          ? UserAvatarWidget(
              size: 48.0,
              user: (chat as DirectChat).peer,
            )
          : UsernameAvatarWidget(
              size: 48.0,
              username: chat.name,
            ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              chat.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (chat is DirectChat) ...[
            SizedBox(width: 8.0),
            Icon(
              (chat as DirectChat).status == MessageStatus.read
                  ? Icons.done_all
                  : Icons.done,
              size: 16.0,
              color: context.theme.accentColor,
            ),
          ],
          SizedBox(width: 8.0),
          Text(
            formatAbsoluteShortDateTime(
              context: context,
              dateTime: chat.lastMessage!.sentAtDate,
            ),
            style: context.textTheme.caption,
          ),
        ],
      ),
      subtitle: SizedBox(
        height: 32.0,
        child: Row(
          children: [
            Expanded(
              child: Text(
                chat.lastMessage!.body.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (unreadMessages > 0) ...[
              SizedBox(width: 8.0),
              Container(
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                  color: context.theme.accentColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    unreadMessages.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              )
            ],
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
