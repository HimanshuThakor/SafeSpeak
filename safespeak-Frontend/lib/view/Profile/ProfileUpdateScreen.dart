import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safespeak/Providers/ProfileProvider.dart';
import 'package:safespeak/models/UserProfile.dart';

class ProfileUpdateScreen extends ConsumerWidget {
  const ProfileUpdateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileUpdateProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Avatar and Info
            _buildProfileHeader(profileState.profile),
            const SizedBox(height: 40),

            // Account Information Section
            _buildAccountSection(context, ref, profileState),
            const SizedBox(height: 40),

            // Edit Profile Button
            _buildEditProfileButton(context, ref, profileState),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserProfile profile) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFFFFD4B3),
            borderRadius: BorderRadius.circular(60),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: profile.avatarUrl != null
                ? Image.network(
                    profile.avatarUrl!,
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.brown,
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          profile.name,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          profile.email,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSection(
      BuildContext context, WidgetRef ref, ProfileUpdateState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),

        // Phone Number
        _buildInfoTile(
          icon: Icons.phone,
          title: 'Phone Number',
          value: state.profile.phoneNumber,
          isEditable: state.isEditing,
          onChanged: (value) {
            ref
                .read(profileUpdateProvider.notifier)
                .updateProfile(phoneNumber: value);
          },
        ),
        const SizedBox(height: 16),

        // FCM Token Status
        _buildInfoTile(
          icon: Icons.notifications,
          title: 'FCM Token Status',
          value: state.profile.fcmTokenStatus,
          isEditable: false,
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    bool isEditable = false,
    Function(String)? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.grey[700]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                isEditable
                    ? TextFormField(
                        initialValue: value,
                        onChanged: onChanged,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                    : Text(
                        value,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileButton(
      BuildContext context, WidgetRef ref, ProfileUpdateState state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: state.isLoading
            ? null
            : () {
                if (state.isEditing) {
                  ref.read(profileUpdateProvider.notifier).saveProfile();
                } else {
                  ref.read(profileUpdateProvider.notifier).toggleEditMode();
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE53E3E),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: state.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                state.isEditing ? 'Save Profile' : 'Edit Profile',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(profileUpdateProvider.notifier).logout();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, 'Home', false),
          _buildNavItem(Icons.shield, 'Report', false),
          _buildNavItem(Icons.person, 'Profile', true),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.black : Colors.grey,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
