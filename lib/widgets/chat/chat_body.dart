import 'package:flutter/material.dart';
import 'package:flutter_messaging_ui/models/classes/chat.dart';
import 'package:flutter_messaging_ui/models/classes/message.dart';
import 'package:flutter_messaging_ui/models/providers/message_list_provider.dart';
import 'package:flutter_messaging_ui/models/providers/user_provider.dart';
import 'package:flutter_messaging_ui/widgets/avatar_widget.dart';
import 'package:flutter_messaging_ui/widgets/message/message_body_widget.dart';
import 'package:flutter_messaging_ui/widgets/message/message_bubble.dart';
import 'package:provider/provider.dart';
import 'package:flutter_messaging_ui/utils/extensions.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({
    Key? key,
    required this.chat,
  }) : super(key: key);

  final Chat chat;

  @override
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = context.watch<UserProvider>();
    final provider = context.watch<MessageListProvider>();
    final messages = provider.value?.reversed.toList();

    if (provider.isLoading || messages == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.separated(
      reverse: true,
      itemCount: messages.length,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      itemBuilder: (context, i) {
        final message = messages[i];
        final nextMessage = i != 0 ? messages[i - 1] : null;
        final previousMessage =
            i != messages.length - 1 ? messages[i + 1] : null;

        final user = widget.chat.members[message.senderId]!;
        final isAuthor = message.senderId == userProvider.self!.id;

        final hasMessageAbove = previousMessage?.senderId == message.senderId;
        final hasMessageBelow = nextMessage?.senderId == message.senderId;

        final Widget? leading;

        if (widget.chat is! DirectChat) {
          leading = !hasMessageBelow && !isAuthor
              ? UserAvatarWidget(
                  user: user,
                  size: 28.0,
                )
              : SizedBox(width: isAuthor ? 0.0 : 28.0);
        } else {
          leading = null;
        }

        return Row(
          mainAxisAlignment:
              isAuthor ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.8,
                ),
                child: MessageBubble(
                  edgeMargin: 12.0,
                  hasMessageAbove: hasMessageAbove,
                  hasMessageBelow: hasMessageBelow,
                  isAccent: isAuthor,
                  leading: leading,
                  child: MessageBodyWidget(
                    message: message,
                    sender: user,
                    isAuthor: isAuthor,
                    hasMessageAbove: hasMessageAbove,
                    isDirectChat: widget.chat is DirectChat,
                  ),
                ),
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, i) {
        return SizedBox(height: 8.0);
      },
    );
  }
}
