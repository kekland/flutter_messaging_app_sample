import 'package:flutter/material.dart';
import 'package:flutter_messaging_ui/utils/extensions.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({Key? key}) : super(key: key);

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.appBarTheme.backgroundColor,
      ),
      child: AnimatedSize(
        vsync: this,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        alignment: Alignment.bottomCenter,
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
            top: false,
            bottom: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 56.0,
                  height: 56.0,
                  child: IconButton(
                    icon: Icon(Icons.sentiment_satisfied_rounded),
                    color: context.theme.iconTheme.color!.withOpacity(0.3),
                    onPressed: () {},
                  ),
                ),
                Expanded(
                  child: TextField(
                    minLines: 1,
                    maxLines: 6,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Message',
                      contentPadding: const EdgeInsets.only(
                        bottom: 8.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 56.0,
                  height: 56.0,
                  child: IconButton(
                    icon: Icon(Icons.attach_file_rounded),
                    color: context.theme.iconTheme.color!.withOpacity(0.3),
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  width: 56.0,
                  height: 56.0,
                  child: IconButton(
                    icon: Icon(Icons.send_rounded),
                    color: context.theme.accentColor,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
