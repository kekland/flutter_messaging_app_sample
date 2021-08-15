import 'package:flutter/material.dart';
import 'package:flutter_messaging_ui/pages/sign_up_page.dart';
import 'package:flutter_messaging_ui/utils/extensions.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: context.theme.accentColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              SizedBox(height: 12.0),
              Text(
                'Messenger',
                style: context.textTheme.headline6,
              ),
              SizedBox(height: 24.0),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintText: 'Your e-mail',
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
                  hintText: 'Your password',
                  isDense: true,
                  prefixIcon: Icon(Icons.lock_rounded),
                ),
                obscureText: true,
              ),
              SizedBox(height: 12.0),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  child: Text('Sign in'),
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
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: context.textTheme.caption?.color,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => SignUpPage()),
                    );
                  },
                  style: TextButton.styleFrom(
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
    );
  }
}
