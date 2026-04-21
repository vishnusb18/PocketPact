import 'package:flutter/material.dart';
import '../theme/app_design.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/pacty_widgets.dart';

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

  static const String pactName = 'Summer Vacation Fund';
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
      note: 'Bonus from work',
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
      note: "Let's do this",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final progress = (currentAmount / goalAmount).clamp(0.0, 1.0);
    final remaining = goalAmount - currentAmount;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Pact Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              112,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SummaryCard(
                  progress: progress,
                  remaining: remaining,
                ),
                const SizedBox(height: AppSpacing.lg),
                _ProgressCard(
                  progress: progress,
                  remaining: remaining,
                ),
                const SizedBox(height: AppSpacing.lg),
                const _MembersSection(),
                const SizedBox(height: AppSpacing.lg),
                const _ContributionHistorySection(),
              ],
            ),
          ),
          _AddContributionButton(onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Add Contribution feature coming soon.'),
                duration: Duration(seconds: 2),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double progress;
  final double remaining;

  const _SummaryCard({
    required this.progress,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACTIVE PACT',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withOpacity(0.72),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      PactDetailScreen.pactName,
                      style: AppTextStyles.h2.copyWith(
                        color: Colors.white,
                        height: 1.12,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _StatusPill(text: '${PactDetailScreen.daysRemaining} days left'),
                  ],
                ),
              ),
              PactyReactionWidget.forProgress(
                progress: progress,
                size: 112,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Saved',
                  value: '\$${PactDetailScreen.currentAmount.toStringAsFixed(0)}',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _SummaryMetric(
                  label: 'Goal',
                  value: '\$${PactDetailScreen.goalAmount.toStringAsFixed(0)}',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _SummaryMetric(
                  label: 'To go',
                  value: '\$${remaining.toStringAsFixed(0)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String text;

  const _StatusPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryMetric({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.72),
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final double progress;
  final double remaining;

  const _ProgressCard({
    required this.progress,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = progress * 100;

    return Container(
      padding: AppInsets.cardLarge,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progress', style: AppTextStyles.h3),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.pill),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 14,
              backgroundColor: AppColors.grey100,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.accentGoldDark,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _AmountTile(
                  label: 'Saved so far',
                  value: '\$${PactDetailScreen.currentAmount.toStringAsFixed(2)}',
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _AmountTile(
                  label: 'Remaining',
                  value: '\$${remaining.toStringAsFixed(2)}',
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmountTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _AmountTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _MembersSection extends StatelessWidget {
  const _MembersSection();

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      title: 'Members',
      trailing: '${PactDetailScreen.members.length} people',
      child: Column(
        children: PactDetailScreen.members
            .map((member) => _MemberItem(member: member))
            .toList(),
      ),
    );
  }
}

class _MemberItem extends StatelessWidget {
  final PactMember member;

  const _MemberItem({required this.member});

  @override
  Widget build(BuildContext context) {
    final memberProgress = member.contribution / PactDetailScreen.goalAmount;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          _InitialAvatar(name: member.name),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                  child: LinearProgressIndicator(
                    value: memberProgress,
                    minHeight: 7,
                    backgroundColor: AppColors.grey100,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primaryPurpleLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            '\$${member.contribution.toStringAsFixed(0)}',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.primaryPurple,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContributionHistorySection extends StatelessWidget {
  const _ContributionHistorySection();

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      title: 'Recent Activity',
      child: Column(
        children: PactDetailScreen.contributions
            .map((item) => _ContributionHistoryItem(contribution: item))
            .toList(),
      ),
    );
  }
}

class _ContributionHistoryItem extends StatelessWidget {
  final ContributionItem contribution;

  const _ContributionHistoryItem({required this.contribution});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InitialAvatar(name: contribution.memberName, size: 40),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        contribution.memberName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      '+\$${contribution.amount.toStringAsFixed(2)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  _formatDate(contribution.date),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (contribution.note != null &&
                    contribution.note!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(AppRadii.sm),
                    ),
                    child: Text(
                      contribution.note!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final difference = DateTime.now().difference(date).inDays;
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '$difference days ago';
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _SectionShell extends StatelessWidget {
  final String title;
  final String? trailing;
  final Widget child;

  const _SectionShell({
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppInsets.cardLarge,
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
            children: [
              Expanded(child: Text(title, style: AppTextStyles.h3)),
              if (trailing != null)
                Text(
                  trailing!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _InitialAvatar extends StatelessWidget {
  final String name;
  final double size;

  const _InitialAvatar({
    required this.name,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.purpleGradient,
      ),
      child: Text(
        name.substring(0, 1).toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.42,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _AddContributionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddContributionButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.96),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: CustomButton(
          label: 'Add Contribution',
          icon: Icons.add_circle_outline_rounded,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
