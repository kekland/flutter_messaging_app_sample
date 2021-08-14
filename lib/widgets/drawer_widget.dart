import 'package:flutter/material.dart';
import 'package:flutter_messaging_ui/models/providers/theme_provider.dart';
import 'package:flutter_messaging_ui/models/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_messaging_ui/utils/extensions.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 180.0,
          color: context.theme.appBarTheme.backgroundColor,
          child: Material(
            type: MaterialType.transparency,
            child: SafeArea(
              top: true,
              bottom: false,
              minimum: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.light_mode),
                    onPressed: () {
                      context.read<ThemeProvider>().toggle(context);
                    },
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          userProvider.self?.username ?? 'Loading',
                          style: context.textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(height: 1.0),
      ],
    );
  }
}
