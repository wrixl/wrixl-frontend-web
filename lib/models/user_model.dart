// lib\models\user_model.dart

class User {
  final int id;
  final String username;
  final String email;
  final String? telegramHandle;
  final bool isActive;
  final bool subscriptionActive;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.telegramHandle,
    required this.isActive,
    required this.subscriptionActive,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      telegramHandle: json['telegram_handle'] as String?,
      isActive: json['is_active'] as bool,
      subscriptionActive: json['subscription_active'] as bool,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'telegram_handle': telegramHandle,
      'is_active': isActive,
      'subscription_active': subscriptionActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
