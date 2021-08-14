import 'package:flutter/material.dart';
import 'package:flutter_messaging_ui/models/classes/User.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    Key? key,
    required this.size,
    required this.child,
  }) : super(key: key);

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black12,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class NetworkAvatarWidget extends StatelessWidget {
  const NetworkAvatarWidget({
    Key? key,
    required this.size,
    required this.url,
    this.placeholder,
  }) : super(key: key);

  final double size;
  final String url;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    return AvatarWidget(
      size: size,
      child: Image.network(
        url,
        loadingBuilder: placeholder != null
            ? (context, child, progress) {
                if (progress == null) return child;
                return placeholder!;
              }
            : null,
      ),
    );
  }
}

final _colors = [
  Colors.amber,
  Colors.blue,
  Colors.green,
  Colors.pink,
  Colors.indigo,
  Colors.red,
  Colors.teal,
];

class UsernameAvatarWidget extends StatelessWidget {
  const UsernameAvatarWidget({
    Key? key,
    required this.size,
    required this.username,
  }) : super(key: key);

  final double size;
  final String username;

  Color get color => _colors[username.hashCode % _colors.length];

  @override
  Widget build(BuildContext context) {
    return AvatarWidget(
      size: size,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        foregroundDecoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white38,
              Colors.white.withOpacity(0.0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        ),
        child: Center(
          child: Text(
            username.substring(0, 2).toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({
    Key? key,
    required this.size,
    required this.user,
  }) : super(key: key);

  final User user;
  final double size;

  @override
  Widget build(BuildContext context) {
    final placeholder = UsernameAvatarWidget(
      size: size,
      username: user.username,
    );

    if (user.avatarUrl != null) {
      return NetworkAvatarWidget(
        size: size,
        url: user.avatarUrl!,
        placeholder: placeholder,
      );
    } else {
      return placeholder;
    }
  }
}
