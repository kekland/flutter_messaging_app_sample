import 'package:flutter/material.dart';
import 'package:flutter_messaging_ui/models/classes/chat.dart';
import 'package:flutter_messaging_ui/models/providers/message_list_provider.dart';
import 'package:flutter_messaging_ui/widgets/avatar_widget.dart';
import 'package:flutter_messaging_ui/utils/extensions.dart';
import 'package:flutter_messaging_ui/widgets/chat/chat_body.dart';
import 'package:flutter_messaging_ui/widgets/chat/chat_input.dart';
import 'package:flutter_messaging_ui/widgets/message/message_bubble.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.chat,
  }) : super(key: key);

  final Chat chat;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.theme.brightness == Brightness.light
            ? Color(0xFFEAEFFA)
            : context.theme.scaffoldBackgroundColor;

    return ChangeNotifierProvider(
      create: (_) => MessageListProvider(chatId: widget.chat.id)..initialize(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Row(
            children: [
              ChatAvatar(
                chat: widget.chat,
                size: 36.0,
              ),
              SizedBox(width: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat.name,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    'last seen at 20:35',
                    style: context.textTheme.caption,
                  ),
                ],
              ),
            ],
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
          backwardsCompatibility: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatBody(
                chat: widget.chat,
                scaffoldBackgroundColor: backgroundColor,
              ),
            ),
            ChatInput(),
          ],
        ),
      ),
    );
  }
}
