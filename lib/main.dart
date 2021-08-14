import 'package:flutter/material.dart';
import 'package:flutter_messaging_ui/models/providers/ChatListProvider.dart';
import 'package:flutter_messaging_ui/pages/ChatListPage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  ThemeData get lightThemeData => ThemeData(
        accentColor: Colors.blue,
        primaryColor: Colors.blue,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          brightness: Brightness.light,
          elevation: 0.0,
        ),
      );

  ThemeData get darkThemeData => ThemeData(
        accentColor: Colors.blue,
        primaryColor: Colors.blue,
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF151515),
          foregroundColor: Colors.white,
          brightness: Brightness.dark,
          elevation: 0.0,
        ),
        scaffoldBackgroundColor: Color(0xFF101010),
      );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider = ChatListProvider();
            provider.initialize();
            return provider;
          },
          lazy: false,
        ),
      ],
      builder: (context, _) => MaterialApp(
        title: 'Messenger',
        theme: darkThemeData,
        home: ChatListPage(),
      ),
    );
  }
}
