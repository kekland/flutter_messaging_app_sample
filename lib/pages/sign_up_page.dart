import 'package:flutter/material.dart';
import 'package:flutter_messaging_ui/utils/extensions.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign up',
                  style: context.textTheme.headline6,
                ),
                SizedBox(height: 24.0),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintText: 'E-mail',
                    isDense: true,
                    prefixIcon: Icon(Icons.alternate_email_rounded),
                  ),
                ),
                SizedBox(height: 12.0),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintText: 'Password',
                    isDense: true,
                    prefixIcon: Icon(Icons.lock_rounded),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 12.0),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    label: Text('Continue'),
                    icon: Icon(Icons.chevron_right_rounded),
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: context.theme.accentColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
