// Pact Detail Screen
// Shows detailed view of a specific pact
// Displays progress bar, member contributions, and activity history
// Provides options to add contributions or manage pact settings

import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

// Mock data models for UI demonstration
class PactMember {
  final String name;
  final String avatarUrl;
  final double contribution;

  const PactMember({
    required this.name,
    required this.avatarUrl,
    required this.contribution,
  });
}

class ContributionItem {
  final String memberName;
  final double amount;
  final DateTime date;
  final String? note;

  const ContributionItem({
    required this.memberName,
    required this.amount,
    required this.date,
    this.note,
  });
}

class PactDetailScreen extends StatelessWidget {
  const PactDetailScreen({super.key});

  // Mock data for demonstration
  static const String pactName = "Summer Vacation Fund";
  static const double goalAmount = 500.0;
  static const double currentAmount = 230.0;
  static const int daysRemaining = 45;

  static final List<PactMember> members = [
    const PactMember(name: 'Alex', avatarUrl: '', contribution: 80.0),
    const PactMember(name: 'Katie', avatarUrl: '', contribution: 75.0),
    const PactMember(name: 'James', avatarUrl: '', contribution: 50.0),
    const PactMember(name: 'Emma', avatarUrl: '', contribution: 25.0),
  ];

  static final List<ContributionItem> contributions = [
    ContributionItem(
      memberName: 'Alex',
      amount: 30.0,
      date: DateTime.now().subtract(const Duration(days: 1)),
      note: 'Weekly savings',
    ),
    ContributionItem(
      memberName: 'Katie',
      amount: 25.0,
      date: DateTime.now().subtract(const Duration(days: 2)),
      note: 'Bonus from work!',
    ),
    ContributionItem(
      memberName: 'James',
      amount: 20.0,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ContributionItem(
      memberName: 'Alex',
      amount: 50.0,
      date: DateTime.now().subtract(const Duration(days: 5)),
      note: 'Initial contribution',
    ),
    ContributionItem(
      memberName: 'Emma',
      amount: 25.0,
      date: DateTime.now().subtract(const Duration(days: 6)),
      note: 'Let\'s do this!',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double progressPercentage = (currentAmount / goalAmount * 100).clamp(0, 100);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pact Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 24),
                _buildProgressSection(progressPercentage),
                const SizedBox(height: 32),
                _buildMembersSection(),
                const SizedBox(height: 32),
                _buildContributionHistorySection(),
                const SizedBox(height: 24),
              ],
            ),
          ),
          _buildAddContributionButton(context),
        ],
      ),
    );
  }

  // 1. Header Section
  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.purpleGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          Text(
            pactName,
            style: AppTextStyles.h2.copyWith(
              color: Colors.white,
              fontSize: 28,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            '\$${goalAmount.toStringAsFixed(0)} Goal',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.accentGold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$daysRemaining days remaining',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Progress Section
  Widget _buildProgressSection(double progressPercentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: AppTextStyles.h3,
              ),
              Text(
                '${progressPercentage.toStringAsFixed(0)}%',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.accentGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar
          Container(
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: progressPercentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentGold.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Amount Display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${currentAmount.toStringAsFixed(2)} saved',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
              Text(
                '\$${(goalAmount - currentAmount).toStringAsFixed(2)} to go',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. Members Section
  Widget _buildMembersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Members',
                style: AppTextStyles.h3,
              ),
              Text(
                '${members.length} people',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...members.map((member) => _buildMemberItem(member)),
        ],
      ),
    );
  }

  Widget _buildMemberItem(PactMember member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.purpleGradient,
            ),
            child: Center(
              child: Text(
                member.name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Name
          Expanded(
            child: Text(
              member.name,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Contribution Amount
          Text(
            '\$${member.contribution.toStringAsFixed(0)}',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryPurple,
            ),
          ),
        ],
      ),
    );
  }

  // 4. Contribution History Section
  Widget _buildContributionHistorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: 16),
          ...contributions.map((contribution) => _buildContributionHistoryItem(contribution)),
        ],
      ),
    );
  }

  Widget _buildContributionHistoryItem(ContributionItem contribution) {
    final String dateText = _formatDate(contribution.date);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.grey200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Member Name
              Text(
                contribution.memberName,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Amount
              Text(
                '+\$${contribution.amount.toStringAsFixed(2)}',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Date
          Text(
            dateText,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          // Note (if present)
          if (contribution.note != null && contribution.note!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                contribution.note!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 5. Add Contribution Button
  Widget _buildAddContributionButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
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
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Navigate to AddContributionScreen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add Contribution feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_circle_outline, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Add Contribution',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to format date
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
