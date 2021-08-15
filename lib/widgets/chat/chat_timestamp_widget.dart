import 'package:flutter/material.dart';
import 'package:flutter_messaging_ui/utils/time.dart';
import 'package:flutter_messaging_ui/utils/extensions.dart';

class ChatTimestampWidget extends StatelessWidget {
  const ChatTimestampWidget({
    Key? key,
    required this.dateTime,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  final DateTime dateTime;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final String label;

    if (isSameDay(dateTime, DateTime.now())) {
      label = 'Today';
    } else if (isSameYear(dateTime, DateTime.now())) {
      label = MaterialLocalizations.of(context).formatShortMonthDay(dateTime);
    } else {
      label = MaterialLocalizations.of(context).formatShortDate(dateTime);
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ),
      child: Text(
        label,
        style: context.textTheme.caption,
      ),
    );
  }
}
