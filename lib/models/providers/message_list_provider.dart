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

  bool _isLoadingMore = false;
  Future<void> loadMore() async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;

    try {
      final values = await api.getPaginatedMessagesForChat(
        chatId: chatId,
        lastSeq: value?.first.seq ?? 0,
      );

      value = [...values, ...value!];
    } catch (e) {
      print(e);
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
}
