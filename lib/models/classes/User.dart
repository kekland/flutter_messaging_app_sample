class User {
  final String id;
  final String username;

  // -1 means that the user is online
  final int? lastSeen;
  final String? avatarUrl;

  User({
    required this.id,
    required this.username,
    this.lastSeen,
    this.avatarUrl,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.username == username &&
        other.lastSeen == lastSeen &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        lastSeen.hashCode ^
        avatarUrl.hashCode;
  }
}
