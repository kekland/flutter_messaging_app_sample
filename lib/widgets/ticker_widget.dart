import 'package:flutter/material.dart';
import 'package:flutter_messaging_ui/utils/extensions.dart';

class TickerWidget extends StatelessWidget {
  const TickerWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.0,
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        color: context.theme.accentColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: DefaultTextStyle(
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12.0,
          ),
          child: child,
        ),
      ),
    );
  }
}
