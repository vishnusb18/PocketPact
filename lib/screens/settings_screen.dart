// Settings Screen
// App preferences and configuration options
// Includes notification settings, privacy controls, and account management
// Provides logout and app information
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  final Color purple = const Color(0xFF7B1FA2);
  final Color yellow = const Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          sectionTitle("Account"),

          settingsCard([
            settingItem(Icons.person_outline, "My Profile"),
            settingItem(Icons.shield_outlined, "App Information"),
            settingItem(Icons.notifications_none, "Notifications"),
            settingItem(Icons.lock_outline, "Privacy"),
          ]),

          const SizedBox(height: 20),

          sectionTitle("Support & About"),

          settingsCard([
            settingItem(Icons.workspace_premium_outlined, "My Achievements"),
            settingItem(Icons.help_outline, "Help & Support"),
            settingItem(Icons.info_outline, "Terms and Policies"),
          ]),

          const SizedBox(height: 20),

          sectionTitle("Customization"),

          settingsCard([
            settingItem(Icons.dark_mode_outlined, "Dark Mode"),
            settingItem(Icons.bolt_outlined, "Energy Saver"),
          ]),

          const SizedBox(height: 20),

          sectionTitle("Actions"),

          settingsCard([
            settingItem(Icons.flag_outlined, "Report a problem"),
            settingItem(Icons.person_add_alt_outlined, "Add account"),
            settingItem(Icons.logout, "Log out"),
          ]),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget settingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8E24AA), Color(0xFF6A1B9A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  Widget settingItem(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFFFC107)),
      title: Text(
        text,
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      ),
      onTap: () {},
    );
  }
}