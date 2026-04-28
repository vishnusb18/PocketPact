import 'package:flutter/material.dart';
import '../theme/app_design.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../widgets/common/bottom_nav_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                title: 'Preferences',
                subtitle: 'Customize your app experience',
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  border: Border.all(color: AppColors.grey200),
                  boxShadow: AppShadows.soft,
                ),
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() => _notificationsEnabled = value);
                      },
                      title: Text(
                        'Notifications',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        _notificationsEnabled
                            ? 'Get reminders and progress updates'
                            : 'Notification alerts are turned off',
                        style: AppTextStyles.bodySmall,
                      ),
                      secondary: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppRadii.md),
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                          color: AppColors.primaryPurple,
                          size: 20,
                        ),
                      ),
                      activeColor: AppColors.primaryPurple,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xxs,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const _SectionTitle(
                title: 'General & Legal',
                subtitle: 'Issue reporting and policy details',
              ),
              const SizedBox(height: AppSpacing.sm),
              _SettingsCard(
                children: [
                  _buildSettingItem(
                    context,
                    Icons.flag_outlined,
                    'Report a Problem',
                    () => _showInfoDialog(
                      context,
                      'Report a Problem',
                      'Please email support@pocketpact.app with steps to reproduce the issue.',
                    ),
                  ),
                  _buildSettingItem(
                    context,
                    Icons.article_outlined,
                    'Terms and Policies',
                    () => Navigator.pushNamed(context, '/terms-policies'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/pacty_happy.png',
                      width: 112,
                      height: 112,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Pacty is here to help.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
              child: Icon(icon, color: AppColors.primaryPurple, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.grey400,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.h3),
          const SizedBox(height: AppSpacing.xxs),
          Text(subtitle, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.grey200),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              const Divider(height: 1, color: AppColors.grey200),
          ],
        ],
      ),
    );
  }
}
