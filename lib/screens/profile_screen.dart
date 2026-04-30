import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../theme/app_design.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../widgets/common/bank_setup_prompt.dart';
import '../widgets/common/bottom_nav_bar.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/pacty_widgets.dart';
import '../utils/pacty_messages.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _userService = UserService();
  AppUser? _userProfile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      _isLoading = true;
      _loadUserProfile();
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await _userService.getCurrentUserProfile();
      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    }
  }

  Future<void> _handleSignOut() async {
    final confirm = await showDialog<bool>(
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
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/auth');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Center(child: CircularProgressIndicator()),
        bottomNavigationBar: AppBottomNavBar(currentIndex: 2),
      );
    }

    final mockUser = currentUser == null
        ? AppUser(
            uid: 'mock',
            email: 'jane.doe@example.com',
            displayName: 'Jane Doe',
            totalContributed: 340.0,
            activePacts: 3,
            completedPacts: 2,
            createdAt: DateTime(2025, 1, 15),
          )
        : null;
    final effectiveProfile = _userProfile ?? mockUser;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: BankConnectionAware(
        builder: (context, hasLinkedAccount) {
          final profileForDisplay = !hasLinkedAccount && effectiveProfile != null
              ? effectiveProfile.copyWith(
                  totalContributed: 0,
                  activePacts: 0,
                  completedPacts: 0,
                )
              : effectiveProfile;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.xs,
                AppSpacing.md,
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileHeader(
                    currentUser: currentUser,
                    userProfile: profileForDisplay,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _PactyProfileNote(
                    userProfile: profileForDisplay,
                    hasLinkedAccount: hasLinkedAccount,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _ProgressSection(userProfile: profileForDisplay),
                  const SizedBox(height: AppSpacing.lg),
                  _AchievementsSection(userProfile: profileForDisplay),
                  if (hasLinkedAccount) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _MyPactsPreview(),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  CustomButton(
                    label: 'Sign Out',
                    icon: Icons.logout_rounded,
                    variant: CustomButtonVariant.outline,
                    onPressed: _handleSignOut,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final User? currentUser;
  final AppUser? userProfile;

  const _ProfileHeader({
    required this.currentUser,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    final displayName =
        userProfile?.displayName ?? currentUser?.displayName ?? 'PocketPact User';
    final isMockJane = userProfile?.uid == 'mock';
    final email = currentUser?.email ?? userProfile?.email ?? 'No email connected';
    final activePacts = userProfile?.activePacts ?? 0;
    final initial = displayName.isNotEmpty ? displayName.substring(0, 1) : 'U';

    return Container(
      width: double.infinity,
      padding: AppInsets.cardLarge,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryPurpleDark,
            AppColors.primaryPurple,
            AppColors.primaryPurpleLight,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadii.xl),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accentGold.withOpacity(0.82),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.14),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: isMockJane
                ? const _MockJaneAnimatedAvatar()
                : Text(
                    initial.toUpperCase(),
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.78),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    border: Border.all(color: Colors.white.withOpacity(0.16)),
                  ),
                  child: Text(
                    activePacts > 0
                        ? 'Saving with $activePacts active ${activePacts == 1 ? "pact" : "pacts"}'
                        : 'Ready to start saving',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PactyProfileNote extends StatelessWidget {
  final AppUser? userProfile;
  final bool hasLinkedAccount;

  const _PactyProfileNote({
    required this.userProfile,
    required this.hasLinkedAccount,
  });

  @override
  Widget build(BuildContext context) {
    final totalContributed = userProfile?.totalContributed ?? 0.0;
    final message = !hasLinkedAccount
      ? PactyMessages.bankLinking.first.message
      : totalContributed > 0
        ? 'You have contributed \$${totalContributed.toStringAsFixed(0)} so far. Nice momentum.'
        : PactyMessages.profile.first.message;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: AppSpacing.xxs),
          child: PactyReactionWidget(
            emotion: PactyEmotion.happy,
            size: 96,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: PactyMessageBubble(message: message)),
      ],
    );
  }
}

class _MockJaneAnimatedAvatar extends StatelessWidget {
  const _MockJaneAnimatedAvatar();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        'assets/jane_avatar.png',
        width: 64,
        height: 64,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final AppUser? userProfile;

  const _ProgressSection({required this.userProfile});

  @override
  Widget build(BuildContext context) {
    final totalContributed = userProfile?.totalContributed ?? 0.0;
    final activePacts = userProfile?.activePacts ?? 0;
    final completedPacts = userProfile?.completedPacts ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'Your Progress',
          subtitle: 'A quick snapshot of your saving activity',
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _ProfileStatCard(
                icon: Icons.savings_outlined,
                value: '\$${totalContributed.toStringAsFixed(0)}',
                label: 'Contributed',
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ProfileStatCard(
                icon: Icons.group_outlined,
                value: '$activePacts',
                label: 'Active pacts',
                color: AppColors.info,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ProfileStatCard(
                icon: Icons.check_circle_outline_rounded,
                value: '$completedPacts',
                label: 'Completed',
                color: AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _SavingsSummary(
          activePacts: activePacts,
          completedPacts: completedPacts,
        ),
      ],
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _ProfileStatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 132),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.grey200),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: AppSpacing.md),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.h3.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SavingsSummary extends StatelessWidget {
  final int activePacts;
  final int completedPacts;

  const _SavingsSummary({
    required this.activePacts,
    required this.completedPacts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.card,
      decoration: BoxDecoration(
        color: AppColors.lavenderMist,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.primaryPurple.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: const Icon(
              Icons.local_fire_department_outlined,
              color: AppColors.primaryPurple,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activePacts > 0 ? 'Contribution streak building' : 'Start your first streak',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '$activePacts active, $completedPacts completed pacts',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementsSection extends StatelessWidget {
  final AppUser? userProfile;

  const _AchievementsSection({required this.userProfile});

  @override
  Widget build(BuildContext context) {
    final completedPacts = userProfile?.completedPacts ?? 0;
    final totalContributed = userProfile?.totalContributed ?? 0;
    final activePacts = userProfile?.activePacts ?? 0;

    final achievements = [
      _Achievement(
        icon: Icons.flag_outlined,
        title: 'First Pact',
        description: 'Joined your first savings pact',
        isUnlocked: activePacts > 0 || completedPacts > 0,
      ),
      _Achievement(
        icon: Icons.trending_up_rounded,
        title: 'Consistent Contributor',
        description: 'Contributed more than \$1,000',
        isUnlocked: totalContributed > 1000,
      ),
      _Achievement(
        icon: Icons.workspace_premium_outlined,
        title: 'Goal Crusher',
        description: 'Completed 5 pacts successfully',
        isUnlocked: completedPacts >= 5,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'Achievements',
          subtitle: 'Milestones that mark your savings journey',
        ),
        const SizedBox(height: AppSpacing.sm),
        ...achievements.map(
          (achievement) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _AchievementTile(achievement: achievement),
          ),
        ),
      ],
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final _Achievement achievement;

  const _AchievementTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final color =
        achievement.isUnlocked ? AppColors.accentGoldDark : AppColors.grey400;

    return Container(
      padding: AppInsets.card,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(
          color: achievement.isUnlocked
              ? AppColors.accentGold.withOpacity(0.24)
              : AppColors.grey200,
        ),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Icon(achievement.icon, color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  achievement.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            achievement.isUnlocked
                ? Icons.check_circle_rounded
                : Icons.lock_outline_rounded,
            color: color,
            size: 22,
          ),
        ],
      ),
    );
  }
}

class _MyPactsPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const pacts = [
      _PactPreview('Summer Vacation Fund', 0.75, AppColors.primaryPurple),
      _PactPreview('New Laptop Savings', 0.45, AppColors.accentGoldDark),
      _PactPreview('Emergency Fund', 0.60, AppColors.info),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: _SectionTitle(
                title: 'My Pacts',
                subtitle: 'Recent goals you are tracking',
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...pacts.map(
          (pact) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _PactPreviewTile(pact: pact),
          ),
        ),
      ],
    );
  }
}

class _PactPreviewTile extends StatelessWidget {
  final _PactPreview pact;

  const _PactPreviewTile({required this.pact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.card,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  pact.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${(pact.progress * 100).toStringAsFixed(0)}%',
                style: AppTextStyles.caption.copyWith(
                  color: pact.color,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.pill),
            child: LinearProgressIndicator(
              value: pact.progress,
              minHeight: 8,
              backgroundColor: AppColors.grey100,
              valueColor: AlwaysStoppedAnimation<Color>(pact.color),
            ),
          ),
        ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h3),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _Achievement {
  final IconData icon;
  final String title;
  final String description;
  final bool isUnlocked;

  const _Achievement({
    required this.icon,
    required this.title,
    required this.description,
    required this.isUnlocked,
  });
}

class _PactPreview {
  final String name;
  final double progress;
  final Color color;

  const _PactPreview(this.name, this.progress, this.color);
}
