// Dashboard Screen:
// Main home screen showing active pacts slides as a carousel across top.
// Carousel scrolls every 4 seconds.
// set to (.88 <--> .12) so the preview of next slide peeks on screen before current scrolls away.
// Provides navigation to create new pacts and add friends.
// Shows weekly leaderboard (top 3).
// Features Pacty mascot helper with motivational messages

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/common/bottom_nav_bar.dart';
import '../widgets/common/pacty_helper.dart';
import '../widgets/common/pacty_animations.dart';
import '../utils/pacty_messages.dart';
import '../services/auth_service.dart';
import '../theme/colors.dart';

// data model

class TopGoal {
  final String ownerName;
  final String goalTitle;
  final String subtitle;
  final Color cardColor;

  const TopGoal({
    required this.ownerName,
    required this.goalTitle,
    required this.subtitle,
    required this.cardColor,
  });
}

// hardcoded data for now, will pull user info from profile/plaid once finalized.

final List<TopGoal> _sampleGoals = [
  const TopGoal(
    ownerName: "Katie's",
    goalTitle: 'Save \$100',
    subtitle: 'this week',
    cardColor: Color.fromARGB(255, 230, 212, 247),
  ),
  const TopGoal(
    ownerName: "Shriya's",
    goalTitle: 'Invest 10%',
    subtitle: 'of monthly pay',
    cardColor: Color.fromARGB(255, 230, 212, 247),
  ),
  const TopGoal(
    ownerName: "James's",
    goalTitle: 'No eating out',
    subtitle: 'for 7 days',
    cardColor: Color.fromARGB(255, 230, 212, 247),
  ),
  const TopGoal(
    ownerName: "John's",
    goalTitle: 'Cut subscriptions',
    subtitle: 'save \$40 / mo',
    cardColor: Color.fromARGB(255, 230, 212, 247),
  ),
];

// Leaderboard data model

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

// Hardcoded leaderboard data for now

final List<LeaderboardEntry> _sampleLeaderboard = [
  const LeaderboardEntry(rank: 1, name: 'John',  username: '@username', score: 2430),
  const LeaderboardEntry(rank: 2, name: 'Jack',  username: '@username', score: 1847),
  const LeaderboardEntry(rank: 3, name: 'Emma',  username: '@username', score: 1674),
];

// Dashboard Screen

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
            style: TextButton.styleFrom(foregroundColor: Colors.red),
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
    // Pick a random motivational message from Pacty
    final randomMessage = PactyMessages.dashboard[
      Random().nextInt(PactyMessages.dashboard.length)
    ];
    
    final currentUser = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'PocketPact',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black54),
            onPressed: () => _handleSignOut(context),
            tooltip: 'Sign Out',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryPurple.withOpacity(0.2),
                child: Text(
                  currentUser?.email?.substring(0, 1).toUpperCase() ?? 'U',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
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
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              // Pacty Mascot - Full Animated Helper with prominent display
              _BouncingPacty(message: randomMessage),
              const SizedBox(height: 16),
              
              // Link Bank Account Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _LinkBankAccountCard(),
              ),
              const SizedBox(height: 16),
              
              _DashboardTopSection(goals: _sampleGoals),
              const SizedBox(height: 24),
              _LeaderboardSection(entries: _sampleLeaderboard),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
}

// Top section: buttons + carousel

class _DashboardTopSection extends StatelessWidget {
  final List<TopGoal> goals;

  const _DashboardTopSection({required this.goals});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Action buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _PillButton(
                  label: 'Create Pact',
                  filled: true,
                  onTap: () => Navigator.pushNamed(context, '/create-pact'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PillButton(
                  label: 'Add Friends',
                  filled: false,
                  onTap: () => Navigator.pushNamed(context, '/add-friends'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Auto-sliding goal carousel
        _GoalCarousel(goals: goals),
        const SizedBox(height: 12),
      ],
    );
  }
}

// 1) create pact 2) add friend Buttons

class _PillButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF2D2D2D) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: filled ? const Color(0xFF2D2D2D) : Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: filled ? Colors.white : Colors.black,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

// Auto-sliding carousel

class _GoalCarousel extends StatefulWidget {
  final List<TopGoal> goals;

  const _GoalCarousel({required this.goals});

  @override
  State<_GoalCarousel> createState() => _GoalCarouselState();
}

class _GoalCarouselState extends State<_GoalCarousel> {
  late final PageController _pageController;
  late Timer _timer;
  int _currentPage = 500; // large offset for infinite scroll feel

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.88,
    );
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage + 1,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
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
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemBuilder: (context, index) {
              final goal = widget.goals[index % widget.goals.length];
              final bool isActive =
                  (index % widget.goals.length) == _realIndex;
              return _GoalCard(goal: goal, isActive: isActive);
            },
          ),
        ),
        const SizedBox(height: 12),

        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.goals.length, (i) {
            final bool active = i == _realIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: active ? 20 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: active
                    ? const Color(0xFF2D2D2D)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// Goal card

class _GoalCard extends StatelessWidget {
  final TopGoal goal;
  final bool isActive;

  const _GoalCard({required this.goal, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to Pact Detail Screen when card is tapped
        Navigator.pushNamed(context, '/pact-detail');
      },
      child: AnimatedScale(
        scale: isActive ? 1.0 : 0.95,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Container(
            decoration: BoxDecoration(
              color: goal.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${goal.ownerName} Top Goal',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  goal.goalTitle,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111111),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  goal.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Leaderboard

class _LeaderboardSection extends StatelessWidget {
  final List<LeaderboardEntry> entries;

  const _LeaderboardSection({required this.entries});

  // Bar color per rank
  Color _barColor(int rank) {
    switch (rank) {
      case 1: return const Color(0xFF9D4EDD); // purple for 1st
      case 2: return const Color(0xFF7B2CBF); // darker purple for 2nd
      case 3: return const Color(0xFFB388EB); // lighter purple for 3rd
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort entries by rank
    final sortedEntries = List<LeaderboardEntry>.from(entries)
      ..sort((a, b) => a.rank.compareTo(b.rank));
    
    // Find max score for scaling
    final maxScore = sortedEntries.map((e) => e.score).reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Leaderboard',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 2),

          // Bar Graph
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Bar chart
                SizedBox(
                  height: 220,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: sortedEntries.map((entry) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: _BarChartItem(
                            entry: entry,
                            maxScore: maxScore,
                            barColor: _barColor(entry.rank),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                // Legend
                ...sortedEntries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _barColor(entry.rank),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${entry.rank}. ${entry.name} - ${entry.score} pts',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BarChartItem extends StatelessWidget {
  final LeaderboardEntry entry;
  final int maxScore;
  final Color barColor;

  const _BarChartItem({
    required this.entry,
    required this.maxScore,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate bar height as percentage of max score
    final double barHeightRatio = entry.score / maxScore;
    final double barHeight = 150 * barHeightRatio;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Score on top of bar
        Text(
          '${entry.score}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: barColor,
          ),
        ),
        const SizedBox(height: 4),
        // The bar itself
        Container(
          width: double.infinity,
          height: barHeight,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ),
        const SizedBox(height: 6),
        // Name label at bottom
        Text(
          entry.name,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// Continuously bouncing Pacty mascot for dashboard
class _BouncingPacty extends StatefulWidget {
  final PactyMessage message;

  const _BouncingPacty({required this.message});

  @override
  State<_BouncingPacty> createState() => _BouncingPactyState();
}

class _BouncingPactyState extends State<_BouncingPacty>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -15.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -15.0, end: 0.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryPurple.withOpacity(0.05),
              AppColors.accentGold.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: PactyHelper(
          message: widget.message,
          mascotSize: 150,
          animate: true,
          showBubble: true,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

// Link Bank Account Card
class _LinkBankAccountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/link-bank-account'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryPurple.withOpacity(0.1),
              AppColors.accentGold.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryPurple.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.account_balance,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Link Your Bank Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Connect via Plaid to track savings',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: AppColors.primaryPurple,
            ),
          ],
        ),
      ),
    );
  }
}
