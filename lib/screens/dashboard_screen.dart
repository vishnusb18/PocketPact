import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_design.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../utils/pacty_messages.dart';
import '../widgets/common/bottom_nav_bar.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/pacty_widgets.dart';

class TopGoal {
  final String ownerName;
  final String goalTitle;
  final String subtitle;
  final double progress;

  const TopGoal({
    required this.ownerName,
    required this.goalTitle,
    required this.subtitle,
    required this.progress,
  });
}

final List<TopGoal> _sampleGoals = [
  const TopGoal(
    ownerName: "Katie's",
    goalTitle: 'Save \$100',
    subtitle: 'this week',
    progress: 0.72,
  ),
  const TopGoal(
    ownerName: "Shriya's",
    goalTitle: 'Invest 10%',
    subtitle: 'of monthly pay',
    progress: 0.46,
  ),
  const TopGoal(
    ownerName: "James's",
    goalTitle: 'No eating out',
    subtitle: 'for 7 days',
    progress: 0.58,
  ),
  const TopGoal(
    ownerName: "John's",
    goalTitle: 'Cut subscriptions',
    subtitle: 'save \$40 / mo',
    progress: 0.34,
  ),
];

class LeaderboardEntry {
  final int rank;
  final String name;
  final String username;
  final int score;

  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.username,
    required this.score,
  });
}

final List<LeaderboardEntry> _sampleLeaderboard = [
  const LeaderboardEntry(rank: 1, name: 'John', username: '@john', score: 2430),
  const LeaderboardEntry(rank: 2, name: 'Jack', username: '@jack', score: 1847),
  const LeaderboardEntry(rank: 3, name: 'Emma', username: '@emma', score: 1674),
  const LeaderboardEntry(rank: 4, name: 'You', username: '@you', score: 1420),
  const LeaderboardEntry(rank: 5, name: 'Maya', username: '@maya', score: 1185),
];

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late final PactyMessage _message;

  @override
  void initState() {
    super.initState();
    _message = PactyMessages.dashboard[
        Random().nextInt(PactyMessages.dashboard.length)];
  }

  Future<void> _handleSignOut(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService().signOut();
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/auth');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final initial = _userInitial(currentUser?.email);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundLight,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primaryPurple),
              child: Text(
                'PocketPact',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_rounded),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_rounded),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline_rounded),
              title: const Text('Create Pact'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/create-pact');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt_1_rounded),
              title: const Text('Add Friends'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/add-friends');
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_rounded),
              title: const Text('Link Bank Account'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/link-bank-account');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Sign Out'),
              onTap: () {
                Navigator.pop(context);
                _handleSignOut(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('PocketPact'),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.textSecondary),
            onPressed: () => _handleSignOut(context),
            tooltip: 'Sign Out',
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryPurple.withOpacity(0.12),
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
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
              PactyHeroCard(
                eyebrow: 'TODAY WITH PACTY',
                title: 'Your money goals are moving.',
                message: _message,
                mascotSize: 132,
                trailing: _DashboardActions(),
              ),
              const SizedBox(height: AppSpacing.md),
              const _LinkBankAccountCard(),
              const SizedBox(height: AppSpacing.lg),
              const _SectionHeader(
                title: 'Top pacts',
                subtitle: 'A quick read on where everyone stands',
              ),
              const SizedBox(height: AppSpacing.sm),
              _GoalCarousel(goals: _sampleGoals),
              const SizedBox(height: AppSpacing.lg),
              _LeaderboardSection(entries: _sampleLeaderboard),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }

  String _userInitial(String? email) {
    if (email == null || email.isEmpty) return 'U';
    return email.substring(0, 1).toUpperCase();
  }
}

class _DashboardActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            label: 'Create Pact',
            icon: Icons.add_circle_outline_rounded,
            onPressed: () => Navigator.pushNamed(context, '/create-pact'),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: CustomButton(
            label: 'Add Friends',
            icon: Icons.person_add_alt_1_rounded,
            variant: CustomButtonVariant.secondary,
            onPressed: () => Navigator.pushNamed(context, '/add-friends'),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
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
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalCarousel extends StatefulWidget {
  final List<TopGoal> goals;

  const _GoalCarousel({required this.goals});

  @override
  State<_GoalCarousel> createState() => _GoalCarouselState();
}

class _GoalCarouselState extends State<_GoalCarousel> {
  late final PageController _pageController;
  late final Timer _timer;
  int _currentPage = 500;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.9,
    );
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage + 1,
          duration: const Duration(milliseconds: 520),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  int get _realIndex => _currentPage % widget.goals.length;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemBuilder: (context, index) {
              final goal = widget.goals[index % widget.goals.length];
              final isActive = (index % widget.goals.length) == _realIndex;
              return _GoalCard(goal: goal, isActive: isActive);
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.goals.length, (i) {
            final active = i == _realIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 22 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primaryPurple
                    : AppColors.primaryPurple.withOpacity(0.16),
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final TopGoal goal;
  final bool isActive;

  const _GoalCard({
    required this.goal,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/pact-detail'),
      child: AnimatedScale(
        scale: isActive ? 1 : 0.96,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          padding: AppInsets.cardLarge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadii.xl),
            border: Border.all(color: AppColors.grey200),
            boxShadow: isActive ? AppShadows.card : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.lavenderMist,
                      borderRadius: BorderRadius.circular(AppRadii.md),
                    ),
                    child: const Icon(
                      Icons.savings_outlined,
                      color: AppColors.primaryPurple,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      '${goal.ownerName} top goal',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                goal.goalTitle,
                style: AppTextStyles.h2.copyWith(height: 1.05),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                goal.subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.pill),
                child: LinearProgressIndicator(
                  value: goal.progress,
                  minHeight: 8,
                  backgroundColor: AppColors.grey100,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeaderboardSection extends StatelessWidget {
  final List<LeaderboardEntry> entries;

  const _LeaderboardSection({required this.entries});

  @override
  Widget build(BuildContext context) {
    final sortedEntries = List<LeaderboardEntry>.from(entries)
      ..sort((a, b) => a.rank.compareTo(b.rank));
    final topThree = sortedEntries.take(3).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.grey200),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Leaderboard', style: AppTextStyles.h3),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Top savers this week',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lavenderMist,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
                child: Text(
                  'Weekly',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryPurpleDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (topThree.length > 1)
                Expanded(
                  child: _PodiumCard(
                    entry: topThree[1],
                    accent: _rankColor(topThree[1].rank),
                    compact: true,
                  ),
                ),
              if (topThree.length > 1) const SizedBox(width: AppSpacing.xs),
              if (topThree.isNotEmpty)
                Expanded(
                  flex: 2,
                  child: _PodiumCard(
                    entry: topThree[0],
                    accent: _rankColor(topThree[0].rank),
                    isWinner: true,
                  ),
                ),
              if (topThree.length > 2) const SizedBox(width: AppSpacing.xs),
              if (topThree.length > 2)
                Expanded(
                  child: _PodiumCard(
                    entry: topThree[2],
                    accent: _rankColor(topThree[2].rank),
                    compact: true,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...sortedEntries.map(
            (entry) => _LeaderboardRow(
              entry: entry,
              color: _rankColor(entry.rank),
              isCurrentUser: entry.name == 'You',
            ),
          ),
        ],
      ),
    );
  }

  Color _rankColor(int rank) {
    switch (rank) {
      case 1:
        return AppColors.accentGoldDark;
      case 2:
        return AppColors.grey400;
      case 3:
        return const Color(0xFFC08457);
      default:
        return AppColors.primaryPurple;
    }
  }
}

class _PodiumCard extends StatelessWidget {
  final LeaderboardEntry entry;
  final Color accent;
  final bool isWinner;
  final bool compact;

  const _PodiumCard({
    required this.entry,
    required this.accent,
    this.isWinner = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      padding: EdgeInsets.all(isWinner ? AppSpacing.md : AppSpacing.sm),
      decoration: BoxDecoration(
        color: isWinner ? AppColors.lavenderMist : AppColors.grey100,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(
          color: isWinner ? AppColors.primaryPurple.withOpacity(0.18) : AppColors.grey200,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: isWinner ? 54 : 42,
            height: isWinner ? 54 : 42,
            decoration: BoxDecoration(
              color: accent.withOpacity(isWinner ? 0.18 : 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                entry.name.substring(0, 1),
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w900,
                  fontSize: isWinner ? 22 : 17,
                ),
              ),
            ),
          ),
          SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isWinner ? Icons.workspace_premium_rounded : Icons.military_tech_rounded,
                color: accent,
                size: isWinner ? 18 : 15,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '#${entry.rank}',
                style: AppTextStyles.caption.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            entry.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            '${entry.score} pts',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
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

class _LeaderboardRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final Color color;
  final bool isCurrentUser;

  const _LeaderboardRow({
    required this.entry,
    required this.color,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.lavenderMist : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(
          color: isCurrentUser
              ? AppColors.primaryPurple.withOpacity(0.18)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadii.sm),
            ),
            child: Text(
              '${entry.rank}',
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.grey100,
            child: Text(
              entry.name.substring(0, 1),
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        entry.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple,
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                        ),
                        child: Text(
                          'You',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  entry.username,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${entry.score} pts',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkBankAccountCard extends StatelessWidget {
  const _LinkBankAccountCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        onTap: () => Navigator.pushNamed(context, '/link-bank-account'),
        child: Ink(
          padding: AppInsets.card,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: AppColors.primaryPurple.withOpacity(0.12)),
            boxShadow: AppShadows.soft,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  color: AppColors.primaryPurple,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Link your bank',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Track savings securely with Plaid',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.primaryPurple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
