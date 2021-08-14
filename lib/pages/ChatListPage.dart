import 'package:flutter/material.dart';
import 'package:flutter_messaging_ui/models/providers/ChatListProvider.dart';
import 'package:flutter_messaging_ui/widgets/ChatListItem.dart';
import 'package:provider/provider.dart';
import 'package:flutter_messaging_ui/utils/extensions.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {},
      ),
      body: body,
    );
  }
}
