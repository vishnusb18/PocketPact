// Financial Recommendations Widget
// Displays personalized financial recommendations based on risk profile

import 'package:flutter/material.dart';
import '../models/risk_profile.dart';
import '../services/risk_profile_service.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class FinancialRecommendationsWidget extends StatefulWidget {
  final RiskProfile profile;

  const FinancialRecommendationsWidget({
    super.key,
    required this.profile,
  });

  @override
  State<FinancialRecommendationsWidget> createState() =>
      _FinancialRecommendationsWidgetState();
}

class _FinancialRecommendationsWidgetState
    extends State<FinancialRecommendationsWidget> {
  final _riskProfileService = RiskProfileService();
  late List<String> _recommendations;

  @override
  void initState() {
    super.initState();
    _recommendations = _riskProfileService.getRecommendations(widget.profile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Financial Tips for You',
          style: TextStyles.heading3,
        ),
        const SizedBox(height: 12),
        // Recommendations list
        ...List.generate(
          _recommendations.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _RecommendationTile(
              recommendation: _recommendations[index],
              index: index,
              priority: index == 0, // First recommendation is priority
            ),
          ),
        ),
      ],
    );
  }
}

class _RecommendationTile extends StatefulWidget {
  final String recommendation;
  final int index;
  final bool priority;

  const _RecommendationTile({
    required this.recommendation,
    required this.index,
    required this.priority,
  });

  @override
  State<_RecommendationTile> createState() => _RecommendationTileState();
}

class _RecommendationTileState extends State<_RecommendationTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  String _getDetailedTip(String recommendation) {
    // Parse emoji and remove from text
    String text = recommendation;
    String emoji = '';
    if (recommendation.contains(' ')) {
      emoji = recommendation.split(' ').first;
      text = recommendation.substring(emoji.length + 1);
    }

    // Provide detailed tips based on keywords
    if (text.contains('emergency fund')) {
      return 'An emergency fund covers 3-6 months of your essential expenses. Start by saving just \$25-50 per month. Keep it in a separate savings account you don\'t touch.';
    } else if (text.contains('high-yield savings')) {
      return 'High-yield savings accounts earn 4-5% APY (much better than regular savings). Popular options: Marcus, Ally, or American Express Personal Savings.';
    } else if (text.contains('budget')) {
      return 'Use apps like YNAB, Mint, or EveryDollar to track spending. Allocate 50% for needs, 30% for wants, 20% for savings/debt payoff.';
    } else if (text.contains('track expenses')) {
      return 'Spend just 5 minutes daily logging expenses. This helps identify spending leaks (subscriptions, food delivery, etc.) that add up fast.';
    } else if (text.contains('debt')) {
      return 'Use the avalanche method (pay highest interest first) or snowball method (pay smallest balance first). Minimum payments only keep you in debt longer.';
    } else if (text.contains('investment')) {
      return 'New to investing? Start with low-cost index funds (VOO, VTI) through Vanguard or Fidelity. Avoid individual stocks until you learn more.';
    } else if (text.contains('financial advisor')) {
      return 'Many colleges offer free financial counseling. NFCC also has low-cost services. Getting help early prevents costly mistakes.';
    } else if (text.contains('stable income')) {
      return 'Even part-time work (10-15 hrs/week) provides stability. Look for work-study, campus jobs, or gig work that fits your schedule.';
    } else if (text.contains('savings')) {
      return 'Even \$10-20/week adds up to \$520-1040/year. Automate transfers so you don\'t forget. This is a habit, not a burden.';
    }
    return recommendation;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleExpand,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.priority ? AppColors.primary : AppColors.lightGrey,
              width: widget.priority ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: widget.priority
                ? AppColors.primary.withOpacity(0.05)
                : Colors.transparent,
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.recommendation,
                      style: TextStyles.body.copyWith(
                        fontWeight: widget.priority
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.expand_more,
                      color: AppColors.greyText,
                    ),
                  ),
                ],
              ),
              // Expanded content
              if (_isExpanded) ...[
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _getDetailedTip(widget.recommendation),
                    style: TextStyles.bodySmall.copyWith(
                      color: AppColors.greyText,
                    ),
                  ),
                ),
              ],
              if (widget.priority && !_isExpanded) ...[
                const SizedBox(height: 4),
                Text(
                  'Priority for your situation',
                  style: TextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Quick Stats Widget
// Shows key financial stats related to risk profile

class FinancialQuickStatsWidget extends StatelessWidget {
  final RiskProfile profile;

  const FinancialQuickStatsWidget({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final answers = profile.questionAnswers;
    final incomeScore = answers['q1_income'] ?? 0;
    final expenseControl = answers['q2_expenses'] ?? 0;
    final debtLevel = answers['q3_debt'] ?? 0;
    final spendingVolatility = answers['q4_spending_volatility'] ?? 0;
    final savingsRate = answers['q5_savings'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Financial Profile',
          style: TextStyles.heading3,
        ),
        const SizedBox(height: 12),
        // Stats grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _StatCard(
              title: 'Income Stability',
              value: _getStatLabel(incomeScore, 5),
              emoji: '💼',
              score: incomeScore / 4,
            ),
            _StatCard(
              title: 'Expense Control',
              value: _getStatLabel(expenseControl, 5),
              emoji: '📊',
              score: expenseControl / 4,
            ),
            _StatCard(
              title: 'Debt Level',
              value: _getDebtLabel(debtLevel),
              emoji: '💳',
              score: (4 - debtLevel) / 4, // Inverse: lower is better
            ),
            _StatCard(
              title: 'Spending Stability',
              value: _getStatLabel(spendingVolatility, 5),
              emoji: '📈',
              score: spendingVolatility / 4,
            ),
            _StatCard(
              title: 'Savings Rate',
              value: _getSavingsLabel(savingsRate),
              emoji: '💰',
              score: savingsRate / 4,
            ),
            _StatCard(
              title: 'Overall Risk',
              value: profile.riskCategory.displayName,
              emoji: profile.riskCategory.emoji,
              score: profile.riskScore / 100,
            ),
          ],
        ),
      ],
    );
  }

  String _getStatLabel(int score, int maxScore) {
    if (score < maxScore / 2) {
      return 'Low';
    } else if (score < maxScore * 0.75) {
      return 'Moderate';
    } else {
      return 'High';
    }
  }

  String _getDebtLabel(int score) {
    switch (score) {
      case 0:
        return 'High';
      case 1:
        return 'Moderate';
      case 2:
        return 'Some';
      case 3:
        return 'Minimal';
      default:
        return 'None';
    }
  }

  String _getSavingsLabel(int score) {
    switch (score) {
      case 0:
        return 'None';
      case 1:
        return 'Very Low';
      case 2:
        return 'Some';
      case 3:
        return 'Regular';
      default:
        return 'Aggressive';
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String emoji;
  final double score; // 0-1

  const _StatCard({
    required this.title,
    required this.value,
    required this.emoji,
    required this.score,
  });

  Color _getScoreColor(double score) {
    if (score < 0.33) {
      return const Color(0xFFE74C3C); // Red
    } else if (score < 0.66) {
      return const Color(0xFFF39C12); // Orange
    } else {
      return const Color(0xFF2ECC71); // Green
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getScoreColor(score);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.caption.copyWith(
                  color: AppColors.greyText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: score,
                  minHeight: 3,
                  backgroundColor: AppColors.lightGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
