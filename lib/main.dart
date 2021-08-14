import 'package:flutter/material.dart';
import 'package:flutter_messaging_ui/models/providers/chat_list_provider.dart';
import 'package:flutter_messaging_ui/models/providers/theme_provider.dart';
import 'package:flutter_messaging_ui/models/providers/user_provider.dart';
import 'package:flutter_messaging_ui/pages/chat_list_page.dart';
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
        scaffoldBackgroundColor: Colors.white,
        dividerColor: Colors.black12,
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
        dividerColor: Colors.black54,
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
        ChangeNotifierProvider(
          create: (_) {
            final provider = UserProvider();
            provider.initialize();
            return provider;
          },
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          lazy: false,
        ),
      ],
      builder: (context, _) => MaterialApp(
        title: 'Messenger',
        theme: lightThemeData,
        darkTheme: darkThemeData,
        themeMode: context.watch<ThemeProvider>().themeMode,
        home: ChatListPage(),
      ),
    );
  }
}
