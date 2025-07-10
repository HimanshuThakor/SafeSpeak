import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//User model
class User {
  final String name;
  final String email;
  final String avatarUrl;
  final bool isOnline;

  const User({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.isOnline,
  });
}

// Profile menu item model
class ProfileMenuItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    required this.icon,
    required this.title,
    this.onTap,
  });
}

// User provider
final userProvider = StateProvider<User>((ref) {
  return const User(
    name: 'Olivia Rhye',
    email: 'olivia@untitledui.com',
    avatarUrl: 'https://randomuser.me/api/portraits/men/78.jpg',
    isOnline: true,
  );
});
