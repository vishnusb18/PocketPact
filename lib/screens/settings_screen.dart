import 'package:flutter/material.dart';
import '../widgets/common/bottom_nav_bar.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final authService = AuthService();
      await authService.signOut();
      
      // Navigate to auth screen and remove all previous routes
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // The back arrow from your mockup
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildSectionHeader("Account"),
              _buildSettingItem(
                context, 
                Icons.account_balance, 
                "Link Bank Account",
                () => Navigator.pushNamed(context, '/link-bank-account'),
              ),
              _buildSettingItem(context, Icons.person_outline, "My Profile"),
              _buildSettingItem(context, Icons.info_outline, "App Information"),
              _buildSettingItem(context, Icons.notifications_none, "Notifications"),
              _buildSettingItem(context, Icons.lock_outline, "Privacy"),
              
              const SizedBox(height: 30),
              _buildSectionHeader("Support & About"),
              _buildSettingItem(context, Icons.credit_card, "My Achievements"),
              _buildSettingItem(context, Icons.help_outline, "Help & Support"),
              _buildSettingItem(context, Icons.article_outlined, "Terms and Policies"),
              
              const SizedBox(height: 30),
              _buildSectionHeader("Customization"),
              _buildSettingItem(context, Icons.delete_outline, "Dark Mode"),
              _buildSettingItem(context, Icons.electric_bolt_outlined, "Energy Saver"),
              
              const SizedBox(height: 30),
              _buildSectionHeader("Actions"),
              _buildSettingItem(context, Icons.flag_outlined, "Report a problem"),
              _buildSettingItem(context, Icons.group_add_outlined, "Add account"),
              _buildSettingItem(
                context,
                Icons.logout,
                "Log out",
                () => _handleLogout(context),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, IconData icon, String title, [VoidCallback? onTap]) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontSize: 16, color: Colors.black)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}
