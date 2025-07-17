import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safespeak/models/UserProfile.dart';

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
final profileUpdateProvider =
    StateNotifierProvider<ProfileUpdateNotifier, ProfileUpdateState>((ref) {
  return ProfileUpdateNotifier();
});

class ProfileUpdateNotifier extends StateNotifier<ProfileUpdateState> {
  ProfileUpdateNotifier()
      : super(ProfileUpdateState(
          profile: UserProfile(
            name: 'Sophia Bennett',
            email: 'sophia.bennett@email.com',
            phoneNumber: '',
            fcmTokenStatus: 'Active',
          ),
        ));

  void toggleEditMode() {
    state = state.copyWith(isEditing: !state.isEditing);
  }

  void updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
  }) {
    state = state.copyWith(
      profile: state.profile.copyWith(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
      ),
    );
  }

  Future<void> saveProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Here you would typically make an API call to update the profile
      // For demo purposes, we'll just simulate success

      state = state.copyWith(
        isLoading: false,
        isEditing: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update profile. Please try again.',
      );
    }
  }

  void logout() {
    // Handle logout logic here
    print('User logged out');
  }
}
