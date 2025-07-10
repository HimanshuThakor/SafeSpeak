import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safespeak/view/Home/HomeScreen.dart';
import 'package:safespeak/view/Profile/ProfileScreen.dart';
import 'package:safespeak/view/Report/ReportIncidentScreen.dart';
import 'package:safespeak/view/Sos/SosScreen.dart';
import 'package:safespeak/view/Support/SupportScreen.dart';
import 'package:safespeak/view/Toxic/ToxicityScreen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

final bottomNavigationProvider = StateProvider<int>((ref) => 0);

class SafeSpeakApp extends ConsumerWidget {
  const SafeSpeakApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavigationProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _getBodyContent(currentIndex),
      bottomNavigationBar: StylishBottomBar(
        items: [
          BottomBarItem(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            title: const Text('Home'),
            selectedColor: const Color(0xFF4A90E2),
            unSelectedColor: const Color(0xFF8E8E93),
          ),
          BottomBarItem(
            icon: const Icon(Icons.sos_outlined),
            selectedIcon: const Icon(Icons.favorite),
            title: const Text('SOS'),
            selectedColor: const Color(0xFF4A90E2),
            unSelectedColor: const Color(0xFF8E8E93),
          ),
          BottomBarItem(
            icon: const Icon(Icons.warning_amber_outlined),
            selectedIcon: const Icon(Icons.warning),
            title: const Text('Report'),
            selectedColor: const Color(0xFF4A90E2),
            unSelectedColor: const Color(0xFF8E8E93),
          ),
          BottomBarItem(
            icon: Icon(Icons.message_outlined),
            title: Text("Check Toxicity"),
            selectedIcon: Icon(Icons.message),
            selectedColor: const Color(0xFF4A90E2),
            unSelectedColor: const Color(0xFF8E8E93),
          ),
          BottomBarItem(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            title: const Text('Profile'),
            selectedColor: const Color(0xFF4A90E2),
            unSelectedColor: const Color(0xFF8E8E93),
          ),
        ],
        currentIndex: currentIndex,
        backgroundColor: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        elevation: 8,
        option: AnimatedBarOptions(
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.animated,
        ),
        onTap: (index) {
          ref.read(bottomNavigationProvider.notifier).state = index;
        },
      ),
    );
  }

  Widget _getBodyContent(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SOSScreen();
      case 2:
        return const ReportIncidentScreen();
      case 3:
        return const ToxicityScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }
}

// Custom Bottom Navigation Bar Widget
class SafeSpeakBottomNav extends ConsumerWidget {
  const SafeSpeakBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavigationProvider);

    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            context: context,
            ref: ref,
            index: 0,
            icon: Icons.home,
            label: 'Home',
            isSelected: currentIndex == 0,
          ),
          _buildNavItem(
            context: context,
            ref: ref,
            index: 1,
            icon: Icons.favorite,
            label: 'Support',
            isSelected: currentIndex == 1,
          ),
          _buildNavItem(
            context: context,
            ref: ref,
            index: 2,
            icon: Icons.warning,
            label: 'Report',
            isSelected: currentIndex == 2,
          ),
          _buildNavItem(
            context: context,
            ref: ref,
            index: 3,
            icon: Icons.person,
            label: 'Profile',
            isSelected: currentIndex == 3,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required WidgetRef ref,
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        ref.read(bottomNavigationProvider.notifier).state = index;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? const Color(0xFF4A90E2) // Blue color for selected
                  : const Color(0xFF8E8E93), // Gray color for unselected
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? const Color(0xFF4A90E2) // Blue color for selected
                    : const Color(0xFF8E8E93), // Gray color for unselected
              ),
            ),
          ],
        ),
      ),
    );
  }
}
