// Reusable Bottom Navigation Bar
// Used across main screens for consistent navigation
// Handles routing between Dashboard, Profile, and Settings

import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryPurple,
        unselectedItemColor: AppColors.grey400,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    // Prevent navigation if already on the selected screen
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        // Home/Dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        // Profile
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 2:
        // Settings
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }
}
