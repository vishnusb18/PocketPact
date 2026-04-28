import 'package:flutter/material.dart';
import '../models/financial_allocation.dart';
import '../services/financial_allocation_service.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../widgets/common/bottom_nav_bar.dart';

class FinancialAllocationScreen extends StatefulWidget {
  const FinancialAllocationScreen({super.key});

  @override
  State<FinancialAllocationScreen> createState() =>
      _FinancialAllocationScreenState();
}

class _FinancialAllocationScreenState extends State<FinancialAllocationScreen>
    with SingleTickerProviderStateMixin {
  AllocationScore? _score;
  bool _isLoading = true;
  late AnimationController _animController;
  late Animation<double> _fillAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _fillAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _loadData();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _loadData() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _score = FinancialAllocationService.getMockAllocationScore();
        _isLoading = false;
      });
      _animController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        title: const Text('Budget Allocation', style: AppTextStyles.h3),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryPurple,
              ),
            )
          : _buildBody(),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildBody() {
    final score = _score!;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ScoreCard(score: score, animation: _fillAnim),
          const SizedBox(height: 28),
          const _SectionHeader(
            title: 'Allocation Breakdown',
            subtitle: 'Ideal (grey) vs your actual (coloured)',
          ),
          const SizedBox(height: 12),
          ...score.categories.map(
            (c) => _CategoryCard(
              category: c,
              amount: score.categoryAmounts[c.name] ?? 0,
              animation: _fillAnim,
            ),
          ),
          const SizedBox(height: 28),
          const _SectionHeader(
            title: 'Gap Analysis',
            subtitle: 'Where you are over or under your targets',
          ),
          const SizedBox(height: 12),
          _GapAnalysisCard(categories: score.categories),
          const SizedBox(height: 28),
          const _SectionHeader(title: 'Key Insights', subtitle: null),
          const SizedBox(height: 12),
          ...score.insights.map((i) => _InsightTile(text: i)),
          const SizedBox(height: 28),
          const _SectionHeader(title: 'Recommendations', subtitle: null),
          const SizedBox(height: 12),
          ...score.recommendations.map((r) => _RecommendationTile(text: r)),
        ],
      ),
    );
  }
}

// Score Card

class _ScoreCard extends StatelessWidget {
  final AllocationScore score;
  final Animation<double> animation;

  const _ScoreCard({required this.score, required this.animation});

  String get _label {
    if (score.score >= 80) return 'Excellent';
    if (score.score >= 60) return 'Good';
    if (score.score >= 40) return 'Fair';
    return 'Needs Work';
  }

  Color get _labelColor {
    if (score.score >= 80) return AppColors.success;
    if (score.score >= 60) return AppColors.accentGold;
    if (score.score >= 40) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryPurpleDark, AppColors.primaryPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              final animated = (score.score * animation.value).toInt();
              return SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: (score.score / 100) * animation.value,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(_labelColor),
                      strokeWidth: 8,
                      strokeCap: StrokeCap.round,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$animated',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        Text(
                          '/ 100',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.65),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Financial Health',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _label,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _labelColor,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.25)),
                  ),
                  child: Text(
                    '${score.riskProfile.capitalize()} Risk',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Monthly income  \$${score.totalIncome.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
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

// Section Header

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h4),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!, style: AppTextStyles.caption),
        ],
      ],
    );
  }
}

// Category Card

const _kCategoryColors = {
  'earning': AppColors.primaryPurple,
  'spending': AppColors.error,
  'saving': AppColors.success,
  'investing': AppColors.info,
};

const _kCategoryIcons = {
  'earning': Icons.trending_up_rounded,
  'spending': Icons.shopping_bag_outlined,
  'saving': Icons.savings_outlined,
  'investing': Icons.bar_chart_rounded,
};

class _CategoryCard extends StatelessWidget {
  final AllocationCategory category;
  final double amount;
  final Animation<double> animation;

  const _CategoryCard({
    required this.category,
    required this.amount,
    required this.animation,
  });

  Color get _color =>
      _kCategoryColors[category.name] ?? AppColors.primaryPurple;

  bool get _onTrack => category.gap.abs() <= 2;
  bool get _over => category.gap > 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _kCategoryIcons[category.name],
                  color: _color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name.capitalize(),
                      style: AppTextStyles.h4.copyWith(fontSize: 15),
                    ),
                    Text(
                      '\$${amount.toStringAsFixed(0)} / mo',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              _StatusChip(
                onTrack: _onTrack,
                over: _over,
                gap: category.gap,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: category.ideal / 100,
              minHeight: 4,
              backgroundColor: AppColors.grey100,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.grey300),
            ),
          ),
          const SizedBox(height: 5),
          AnimatedBuilder(
            animation: animation,
            builder: (context, _) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value:
                    ((category.actual / 100) * animation.value).clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: AppColors.grey100,
                valueColor: AlwaysStoppedAnimation<Color>(_color),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BarLabel(
                color: AppColors.grey300,
                label: 'Ideal ${category.ideal.toStringAsFixed(0)}%',
              ),
              _BarLabel(
                color: _color,
                label: 'Actual ${category.actual.toStringAsFixed(0)}%',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool onTrack;
  final bool over;
  final double gap;

  const _StatusChip(
      {required this.onTrack, required this.over, required this.gap});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final String label;
    if (onTrack) {
      bg = AppColors.success.withOpacity(0.1);
      fg = AppColors.success;
      label = 'On Track';
    } else if (over) {
      bg = AppColors.error.withOpacity(0.1);
      fg = AppColors.error;
      label = '+${gap.toStringAsFixed(1)}%';
    } else {
      bg = AppColors.warning.withOpacity(0.12);
      fg = AppColors.warning;
      label = '${gap.toStringAsFixed(1)}%';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _BarLabel extends StatelessWidget {
  final Color color;
  final String label;

  const _BarLabel({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style:
              const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// Gap Analysis Card

class _GapAnalysisCard extends StatelessWidget {
  final List<AllocationCategory> categories;

  const _GapAnalysisCard({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lavenderMist,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lavenderCard),
      ),
      child: Column(
        children: categories
            .map((c) => _GapRow(
                  category: c,
                  isLast: c == categories.last,
                ))
            .toList(),
      ),
    );
  }
}

class _GapRow extends StatelessWidget {
  final AllocationCategory category;
  final bool isLast;

  const _GapRow({required this.category, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final color = _kCategoryColors[category.name] ?? AppColors.primaryPurple;
    final gapAbs = category.gap.abs();
    final isOnTrack = gapAbs <= 2;
    final isOver = category.gap > 2;
    final barWidth = (gapAbs * 3.5).clamp(6.0, 90.0);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  category.name.capitalize(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: (!isOver && !isOnTrack)
                            ? Container(
                                height: 6,
                                width: barWidth,
                                decoration: BoxDecoration(
                                  color: AppColors.warning,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 18,
                      color: AppColors.grey300,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: isOver
                            ? Container(
                                height: 6,
                                width: barWidth,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 60,
                child: Text(
                  isOnTrack
                      ? 'OK'
                      : '${isOver ? '+' : ''}${category.gap.toStringAsFixed(1)}%',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isOnTrack
                        ? AppColors.success
                        : isOver
                            ? AppColors.error
                            : AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, color: AppColors.lavenderCard),
      ],
    );
  }
}

// Insight Tile

class _InsightTile extends StatelessWidget {
  final String text;

  const _InsightTile({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline_rounded,
              color: AppColors.primaryPurple, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// Recommendation Tile

class _RecommendationTile extends StatelessWidget {
  final String text;

  const _RecommendationTile({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accentGold.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentGold.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              color: AppColors.accentGoldDark, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

extension _StringExt on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
