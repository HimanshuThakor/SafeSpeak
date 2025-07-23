import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safespeak/Providers/ProfileProvider.dart';
import 'package:safespeak/Services/SessionManagement.dart';
import 'package:safespeak/Utils/LoginHelper.dart';
import 'package:safespeak/view/Family/FamilyMembersListScreen.dart';
import 'package:safespeak/view/Profile/ProfileUpdateScreen.dart';
import 'package:safespeak/view/Profile/blog_screen.dart';
import 'package:safespeak/view/Profile/rag_chat_screen.dart';
import 'package:safespeak/view/bottom_navigation/SafeSpeakBottomNav.dart';
import 'package:safespeak/view/onboarding/splash_Screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    final List<ProfileMenuItem> menuItems = [
      ProfileMenuItem(
        icon: Icons.person_outline,
        title: 'View profile',
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileUpdateScreen(),
            )),
      ),
      ProfileMenuItem(
        icon: Icons.shield_outlined,
        title: 'Safety Guidelines',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogScreen(),
          ),
        ),
      ),
      ProfileMenuItem(
        icon: Icons.chat,
        title: 'Chat With Ai Agent',
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RAGChatScreen(),
            )),
      ),
      ProfileMenuItem(
        icon: Icons.people_outline,
        title: 'Create Team',
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FamilyMembersListScreen(),
            )),
      ),
      ProfileMenuItem(
        icon: Icons.person_add_outlined,
        title: 'Invite colleagues',
        onTap: () => _showSnackBar(context, 'Invite colleagues tapped'),
      ),
      ProfileMenuItem(
        icon: Icons.sos_outlined,
        title: 'SOS',
        onTap: () {
          ref.read(bottomNavigationProvider.notifier).state = 1;
        },
      ),
      ProfileMenuItem(
        icon: Icons.logout_outlined,
        title: 'Log out',
        onTap: () => _showLogoutDialog(context),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile header
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Avatar with online indicator
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(user.avatarUrl),
                        ),
                        if (user.isOnline)
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // User info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
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
              ),

              const SizedBox(height: 8),

              // Menu items
              Container(
                color: Colors.white,
                child: Column(
                  children: menuItems.map((item) {
                    return _buildMenuItem(item);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(ProfileMenuItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 22,
                color: Colors.grey[700],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => _signOut(context),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut(BuildContext context) async {
    LoginHelper loginHelper = LoginHelper();
    loginHelper.clearToken();
    SessionManagement sessionManagement = SessionManagement();
    await sessionManagement.clearLocalStorage();
    await sessionManagement.destroyMap();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const AnimatedSplashScreen(),
      ),
    );
  }
}
