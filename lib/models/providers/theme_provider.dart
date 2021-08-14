import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider();

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode value) {
    _themeMode = value;
    notifyListeners();
  }

  void toggle(BuildContext context) {
    final Brightness _brightness;

    if (themeMode == ThemeMode.system) {
      _brightness = MediaQuery.of(context).platformBrightness;
    } else {
      _brightness =
          themeMode == ThemeMode.light ? Brightness.light : Brightness.dark;
    }

    themeMode =
        _brightness == Brightness.light ? ThemeMode.dark : ThemeMode.light;
  }
}
