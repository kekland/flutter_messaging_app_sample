import 'package:flutter/material.dart';
import 'package:flutter_messaging_ui/utils/extensions.dart';
import 'dart:math' as math;

class MessageBubbleTip extends CustomPainter {
  final Color color;
  final bool isFlipped;

  MessageBubbleTip({
    required this.color,
    this.isFlipped = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    if (isFlipped) {
      path.arcTo(
        Rect.fromLTWH(
            -size.width, -size.height, size.width * 2, size.height * 2),
        0.0,
        math.pi / 2.0,
        true,
      );
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0.0);
    } else {
      path.arcTo(
        Rect.fromLTWH(0.0, -size.height, size.width * 2, size.height * 2),
        math.pi / 2.0,
        math.pi / 2.0,
        true,
      );
      path.lineTo(0.0, size.height);
      path.lineTo(size.width, size.height);
    }

    final paint = Paint();
    paint.color = color;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant MessageBubbleTip oldDelegate) {
    return oldDelegate.color != color;
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.child,
    this.leading,
    this.edgeMargin = 4.0,
    this.isAccent = false,
    this.hasMessageAbove = false,
    this.hasMessageBelow = false,
  }) : super(key: key);

  final Widget? leading;
  final Widget child;
  final double edgeMargin;
  final bool isAccent;
  final bool hasMessageAbove;
  final bool hasMessageBelow;

  @override
  Widget build(BuildContext context) {
    final largeRadius = Radius.circular(16.0);
    final smallRadius = Radius.circular(4.0);

    final BorderRadius borderRadius;

    final color =
        isAccent ? context.theme.primaryColor : context.theme.cardColor;

    if (isAccent) {
      borderRadius = BorderRadius.only(
        topLeft: largeRadius,
        bottomLeft: largeRadius,
        topRight: hasMessageAbove ? smallRadius : largeRadius,
        bottomRight: hasMessageBelow ? smallRadius : Radius.zero,
      );
    } else {
      borderRadius = BorderRadius.only(
        topRight: largeRadius,
        bottomRight: largeRadius,
        topLeft: hasMessageAbove ? smallRadius : largeRadius,
        bottomLeft: hasMessageBelow ? smallRadius : Radius.zero,
      );
    }

    Widget _child = Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
      child: child,
    );

    if (!hasMessageBelow) {
      final tip = SizedBox(
        width: 4.0,
        height: 12.0,
        child: CustomPaint(
          painter: MessageBubbleTip(
            color: color,
            isFlipped: !isAccent,
          ),
        ),
      );

      _child = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isAccent) tip,
          Flexible(child: _child),
          if (isAccent) tip,
        ],
      );
    }

    if (leading != null) {
      final _children = [
        leading!,
        SizedBox(width: 8.0 - (!hasMessageBelow ? 4.0 : 0.0)),
        Flexible(child: _child),
      ];

      _child = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ...(isAccent ? _children.reversed : _children),
        ],
      );
    }

    _child = Padding(
      padding: !hasMessageBelow && leading == null
          ? EdgeInsets.only(
              left: !isAccent ? edgeMargin - 4.0 : 0.0,
              right: isAccent ? edgeMargin - 4.0 : 0.0,
            )
          : EdgeInsets.only(
              left: !isAccent ? edgeMargin : 0.0,
              right: isAccent ? edgeMargin : 0.0,
            ),
      child: _child,
    );

    return _child;
  }
}
