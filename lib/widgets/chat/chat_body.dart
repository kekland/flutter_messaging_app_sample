import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_messaging_ui/models/classes/chat.dart';
import 'package:flutter_messaging_ui/models/classes/message.dart';
import 'package:flutter_messaging_ui/models/providers/message_list_provider.dart';
import 'package:flutter_messaging_ui/models/providers/user_provider.dart';
import 'package:flutter_messaging_ui/utils/time.dart';
import 'package:flutter_messaging_ui/widgets/avatar_widget.dart';
import 'package:flutter_messaging_ui/widgets/chat/chat_timestamp_widget.dart';
import 'package:flutter_messaging_ui/widgets/message/message_body_widget.dart';
import 'package:flutter_messaging_ui/widgets/message/message_bubble.dart';
import 'package:provider/provider.dart';
import 'package:flutter_messaging_ui/utils/extensions.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({
    Key? key,
    required this.chat,
    required this.scaffoldBackgroundColor,
  }) : super(key: key);

  final Chat chat;
  final Color scaffoldBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MessageListProvider>();
    final messages = provider.value?.reversed.toList();

    if (provider.isLoading || messages == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return _ChatScrollable(
      chat: chat,
      messages: messages,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
    );
  }
}

class _ChatScrollable extends StatefulWidget {
  const _ChatScrollable({
    Key? key,
    required this.chat,
    required this.messages,
    required this.scaffoldBackgroundColor,
  }) : super(key: key);

  final Chat chat;
  final List<Message> messages;
  final Color scaffoldBackgroundColor;

  @override
  _ChatScrollableState createState() => _ChatScrollableState();
}

class _ChatScrollableState extends State<_ChatScrollable> {
  // Items can be either [Message] or [DateTime] for the date divider
  List<dynamic> _items = [];
  List<int> _dateTimeIndices = [];

  late ScrollController _controller;

  Map<int, double> _itemHeights = {};
  List<double> _itemPositions = [];

  final _currentDateTimeIndexNotifier = ValueNotifier<int?>(null);
  final _currentDateTimeVisibilityNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();

    _controller.addListener(() {
      _calculateCurrentDateTimeIndex();

      _currentDateTimeVisibilityNotifier.value = true;
      _hideCurrentDateTime();
    });

    _calculateItems();
  }

  void _calculateCurrentDateTimeIndex() {
    if (!_controller.hasClients) return;
    final topEdge =
        _controller.position.viewportDimension + _controller.position.pixels;

    if (_controller.position.maxScrollExtent - 500 < topEdge) {
      context.read<MessageListProvider>().loadMore();
    }

    int? _tempCurrentDateTimeIndex;
    for (var i = 0; i < _dateTimeIndices.length - 1; i++) {
      final dateTimeIndex = _dateTimeIndices[i];

      if (_itemPositions.length <= dateTimeIndex) continue;
      final position = _itemPositions[dateTimeIndex];

      if (position > topEdge) {
        _tempCurrentDateTimeIndex = dateTimeIndex;
        break;
      } else {
        _tempCurrentDateTimeIndex = _dateTimeIndices[i + 1];
      }
    }

    _tempCurrentDateTimeIndex ??= _dateTimeIndices.first;
    _currentDateTimeIndexNotifier.value = _tempCurrentDateTimeIndex;
  }

  Timer? _hideCurrentDateTimeTimer;
  void _hideCurrentDateTime() {
    _hideCurrentDateTimeTimer?.cancel();

    // Applies a 1s debouncing
    _hideCurrentDateTimeTimer = Timer(Duration(seconds: 1), () {
      _currentDateTimeVisibilityNotifier.value = false;
    });
  }

  void _reportHeight(int index, double height) {
    _itemHeights[index] = height;
    _itemPositions.clear();

    var i = 0;
    double _height = 0.0;
    while (true) {
      if (_itemHeights[i] == null) break;

      _height += _itemHeights[i]!;
      _itemPositions.add(_height);

      i++;
    }
  }

  @override
  void didUpdateWidget(covariant _ChatScrollable oldWidget) {
    if (!listEquals(oldWidget.messages, widget.messages)) {
      _calculateItems();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _calculateItems() {
    final length = widget.messages.length;
    _items.clear();
    _dateTimeIndices.clear();

    for (var i = 0; i < length; i++) {
      final message = widget.messages[i];
      final nextMessage = i != length - 1 ? widget.messages[i + 1] : null;

      _items.add(message);

      if (nextMessage == null ||
          !isSameDay(message.sentAtDate, nextMessage.sentAtDate)) {
        _items.add(message.sentAtDate);
        _dateTimeIndices.add(_items.length - 1);
      }
    }

    _calculateCurrentDateTimeIndex();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = context.watch<UserProvider>();

    Widget child = ListView.builder(
      controller: _controller,
      reverse: true,
      itemCount: _items.length,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      itemBuilder: (context, i) {
        Widget child;
        final item = _items[i];

        if (item is DateTime) {
          child = Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              top: 16.0,
            ),
            child: Center(
              child: ValueListenableBuilder<int?>(
                valueListenable: _currentDateTimeIndexNotifier,
                builder: (context, dateTimeIndex, _) => Opacity(
                  opacity: dateTimeIndex == i ? 0 : 1.0,
                  child: ChatTimestampWidget(dateTime: item),
                ),
              ),
            ),
          );
        } else {
          final message = item as Message;
          var nextItem = i != 0 ? _items[i - 1] : null;
          var previousItem = i != _items.length - 1 ? _items[i + 1] : null;

          if (nextItem is DateTime) {
            nextItem = null;
          }

          if (previousItem is DateTime) {
            previousItem = null;
          }

          final sender = widget.chat.members[message.senderId]!;
          final isAuthor = message.senderId == userProvider.self!.id;

          final hasMessageAbove = previousItem?.senderId == message.senderId;
          final hasMessageBelow = nextItem?.senderId == message.senderId;

          final Widget? leading;

          if (widget.chat is! DirectChat) {
            leading = !hasMessageBelow && !isAuthor
                ? UserAvatarWidget(
                    user: sender,
                    size: 28.0,
                  )
                : SizedBox(width: isAuthor ? 0.0 : 28.0);
          } else {
            leading = null;
          }

          child = Row(
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
                      sender: sender,
                      isAuthor: isAuthor,
                      hasMessageAbove: hasMessageAbove,
                      isDirectChat: widget.chat is DirectChat,
                    ),
                  ),
                ),
              ),
            ],
          );

          child = Padding(
            padding: EdgeInsets.only(
              top: hasMessageAbove ? 4.0 : 8.0,
            ),
            child: child,
          );
        }

        return _ChatBodyItemWrapper(
          index: i,
          child: child,
          onLayoutFinished: (size) {
            _reportHeight(i, size.height);
          },
        );
      },
    );

    return Stack(
      children: [
        child,
        ValueListenableBuilder<int?>(
          valueListenable: _currentDateTimeIndexNotifier,
          builder: (context, i, _) {
            if (i != null) {
              return Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _currentDateTimeVisibilityNotifier,
                    builder: (context, visible, _) => AnimatedOpacity(
                      duration: const Duration(milliseconds: 150),
                      opacity: visible ? 1.0 : 0.0,
                      child: ChatTimestampWidget(
                        dateTime: _items[i],
                        backgroundColor: widget.scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
              );
            }

            return SizedBox();
          },
        ),
      ],
    );
  }
}

class _ChatBodyItemWrapper extends StatefulWidget {
  const _ChatBodyItemWrapper({
    Key? key,
    required this.index,
    required this.child,
    required this.onLayoutFinished,
  }) : super(key: key);

  final int index;
  final Widget child;
  final void Function(Size) onLayoutFinished;

  @override
  _ChatBodyItemWrapperState createState() => _ChatBodyItemWrapperState();
}

class _ChatBodyItemWrapperState extends State<_ChatBodyItemWrapper> {
  @override
  void initState() {
    super.initState();
    _reportSizeAfterLayout();
  }

  @override
  void didUpdateWidget(covariant _ChatBodyItemWrapper oldWidget) {
    if (oldWidget.child != widget.child) {
      _reportSizeAfterLayout();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _reportSizeAfterLayout() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onLayoutFinished(context.size!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
