/// User model for the admin dashboard
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.role,
    required this.status,
    this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final String avatar;
  final UserRole role;
  final UserStatus status;
  final DateTime? createdAt;

  /// Create a copy with updated values
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    UserRole? role,
    UserStatus? status,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// User roles
enum UserRole {
  admin('Admin'),
  user('User'),
  moderator('Moderator');

  const UserRole(this.label);
  final String label;
}

/// User status
enum UserStatus {
  active('Active'),
  blocked('Blocked'),
  pending('Pending');

  const UserStatus(this.label);
  final String label;
}
