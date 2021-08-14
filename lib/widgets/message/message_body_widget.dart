import 'package:flutter/material.dart';
import 'package:flutter_messaging_ui/models/classes/message.dart';
import 'package:flutter_messaging_ui/models/classes/user.dart';
import 'package:flutter_messaging_ui/utils/extensions.dart';

import 'package:flutter_messaging_ui/utils/time.dart';

class MessageBodyWidget extends StatelessWidget {
  const MessageBodyWidget({
    Key? key,
    required this.message,
    required this.sender,
    required this.isAuthor,
    required this.hasMessageAbove,
    required this.isDirectChat,
  }) : super(key: key);

  final Message message;
  final User sender;
  final bool isAuthor;
  final bool hasMessageAbove;
  final bool isDirectChat;

  @override
  Widget build(BuildContext context) {
    final textSpan = TextSpan(
      text: message.body.text,
      style: TextStyle(
        fontSize: 16.0,
      ),
    );

    final timestampTextSpan = TextSpan(
      text: formatDateOfTime(
        context: context,
        dateTime: message.sentAtDate,
      ),
      style: context.textTheme.caption,
    );

    final timestampSize = _calculateTextBoxes(
      context: context,
      textSpan: timestampTextSpan,
      constraints: BoxConstraints(
        maxWidth: double.infinity,
        maxHeight: double.infinity,
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final timestampWidth = timestampSize.last.right + 8.0;

          final textBoxes = _calculateTextBoxes(
            context: context,
            constraints: constraints,
            textSpan: textSpan,
          );

          final lastLineEnd = textBoxes.last;

          final distanceToEnd = constraints.maxWidth - lastLineEnd.right;
          final fitsLastLine = distanceToEnd > timestampWidth;

          Widget child = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!hasMessageAbove && !isAuthor && !isDirectChat) ...[
                Text(
                  sender.username,
                  style: TextStyle(
                    color: context.theme.accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.0),
              ],
              Text.rich(
                textSpan,
              ),
              if (!fitsLastLine)
                SizedBox(
                  height: timestampSize.last.bottom + 2.0,
                ),
            ],
          );

          if (fitsLastLine && textBoxes.length == 1) {
            child = Padding(
              padding: EdgeInsets.only(right: timestampWidth),
              child: child,
            );
          }

          child = Stack(
            children: [
              child,
              Positioned(
                right: 0.0,
                bottom: 0.0,
                child: Text(
                  formatDateOfTime(
                    context: context,
                    dateTime: message.sentAtDate,
                  ),
                  style: context.textTheme.caption,
                ),
              ),
            ],
          );

          return child;
        },
      ),
    );
  }

  // https://stackoverflow.com/questions/52659759/how-can-i-get-the-size-of-the-text-widget-in-flutter
  List<TextBox> _calculateTextBoxes({
    required BuildContext context,
    required BoxConstraints constraints,
    required TextSpan textSpan,
  }) {
    final richTextWidget = Text.rich(textSpan).build(context) as RichText;

    final renderObject = richTextWidget.createRenderObject(context);
    renderObject.layout(constraints);

    return renderObject.getBoxesForSelection(
      TextSelection(
        baseOffset: 0,
        extentOffset: textSpan.toPlainText().length,
      ),
    );
  }
}
