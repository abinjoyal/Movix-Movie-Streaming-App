/// Domain entity representing an authenticated user in Movix.
class AppUser {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final DateTime? createdAt;

  const AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
    this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}

