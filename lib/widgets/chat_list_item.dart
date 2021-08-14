import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_messaging_ui/models/classes/message.dart';
import 'package:flutter_messaging_ui/models/classes/user.dart';
import 'package:flutter_messaging_ui/models/providers/user_provider.dart';
import 'package:flutter_messaging_ui/pages/chat_page.dart';
import 'package:flutter_messaging_ui/utils/extensions.dart';
import 'package:flutter_messaging_ui/models/classes/chat.dart';
import 'package:flutter_messaging_ui/utils/time.dart';
import 'package:flutter_messaging_ui/widgets/avatar_widget.dart';
import 'package:flutter_messaging_ui/widgets/message/mini_message_widget.dart';
import 'package:flutter_messaging_ui/widgets/ticker_widget.dart';
import 'package:provider/provider.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({
    Key? key,
    required this.chat,
  }) : super(key: key);

  final Chat chat;

  void _openChat(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(chat: chat),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final unreadMessages = chat.lastMessage!.seq - chat.lastReadSeq!;

    User? sender;

    if (userProvider.self?.id == chat.lastMessage!.senderId) {
      sender = userProvider.self;
    } else if (chat is GroupChat) {
      sender = chat.members[chat.lastMessage!.senderId];
    }

    return ListTile(
      leading: ChatAvatar(chat: chat),
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
          if (chat is DirectChat &&
              chat.lastMessage?.senderId == userProvider.self?.id) ...[
            SizedBox(width: 8.0),
            Icon(
              (chat as DirectChat).lastMessageStatus == MessageStatus.read
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
              child: MiniMessageWidget(
                message: chat.lastMessage!,
                sender: sender,
              ),
            ),
            if (unreadMessages > 0) ...[
              SizedBox(width: 8.0),
              TickerWidget(
                child: Text(
                  unreadMessages.toString(),
                ),
              ),
            ],
          ],
        ),
      ),
      onTap: () => _openChat(context),
    );
  }
}
