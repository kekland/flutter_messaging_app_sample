import 'package:flutter/foundation.dart';
import 'package:flutter_messaging_ui/api/MockApi.dart';
import 'package:flutter_messaging_ui/models/classes/Chat.dart';

class ChatListProvider extends ChangeNotifier {
  ChatListProvider();

  List<Chat>? value;
  bool _isLoading = false;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await api.initialize();
      value = await api.getChats();
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
}
