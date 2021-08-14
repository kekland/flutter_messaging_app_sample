import 'package:flutter/foundation.dart';
import 'package:flutter_messaging_ui/api/mock_api.dart';
import 'package:flutter_messaging_ui/models/classes/message.dart';

class MessageListProvider extends ChangeNotifier {
  MessageListProvider({
    required this.chatId,
  });

  final String chatId;

  List<Message>? value;
  bool _isLoading = false;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      value = await api.getPaginatedMessagesForChat(
        chatId: chatId,
        lastSeq: 0,
      );
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
}
