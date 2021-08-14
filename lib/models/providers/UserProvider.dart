import 'package:flutter/foundation.dart';
import 'package:flutter_messaging_ui/api/MockApi.dart';
import 'package:flutter_messaging_ui/models/classes/User.dart';

class UserProvider extends ChangeNotifier {
  UserProvider();

  User? self;
  bool _isLoading = false;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      self = await api.getSelf();
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
}
