class UserProfile {
  final String name;
  final String email;
  final String phoneNumber;
  final String fcmTokenStatus;
  final String? avatarUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.fcmTokenStatus,
    this.avatarUrl,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? fcmTokenStatus,
    String? avatarUrl,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fcmTokenStatus: fcmTokenStatus ?? this.fcmTokenStatus,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

class ProfileUpdateState {
  final UserProfile profile;
  final bool isLoading;
  final String? error;
  final bool isEditing;

  ProfileUpdateState({
    required this.profile,
    this.isLoading = false,
    this.error,
    this.isEditing = false,
  });

  ProfileUpdateState copyWith({
    UserProfile? profile,
    bool? isLoading,
    String? error,
    bool? isEditing,
  }) {
    return ProfileUpdateState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}
