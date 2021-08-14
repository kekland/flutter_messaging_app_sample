import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_messaging_ui/models/providers/ChatListProvider.dart';
import 'package:flutter_messaging_ui/widgets/ChatListItem.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fabAnimationController;
  late final Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();

    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _fabAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _fabAnimationController,
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _animateFabReverse() {
    if (_fabAnimationController.status == AnimationStatus.completed ||
        _fabAnimationController.status == AnimationStatus.forward) {
      _fabAnimationController.reverse();
    }
  }

  void _animateFabForward() {
    if (_fabAnimationController.status == AnimationStatus.dismissed ||
        _fabAnimationController.status == AnimationStatus.reverse) {
      _fabAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.of(context).viewPadding;
    final chatListProvider = context.watch<ChatListProvider>();
    final value = chatListProvider.value;

    Widget body;

    if (value != null) {
      body = ListView.builder(
        itemCount: value.length,
        itemBuilder: (context, i) => ChatListItem(chat: value[i]),
      );
    } else {
      body = Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messenger',
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        backwardsCompatibility: false,
      ),
      drawer: Drawer(
        child: Container(),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        child: FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: () {},
        ),
        builder: (context, child) => Transform.translate(
          offset: Offset(
            0.0,
            _fabAnimation.value * (viewPadding.bottom + 72.0),
          ),
          child: child,
        ),
      ),
      body: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            if (notification.dragDetails == null) return false;

            if (notification.dragDetails!.delta.dy > 0) {
              _animateFabReverse();
            } else {
              _animateFabForward();
            }
          }
          return false;
        },
        child: body,
      ),
    );
  }
}
