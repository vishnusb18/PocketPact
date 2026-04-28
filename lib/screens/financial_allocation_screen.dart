import 'package:flutter/material.dart';
import '../models/financial_allocation.dart';
import '../services/financial_allocation_service.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class FinancialAllocationScreen extends StatefulWidget {
  const FinancialAllocationScreen({Key? key}) : super(key: key);

  @override
  State<FinancialAllocationScreen> createState() =>
      _FinancialAllocationScreenState();
}

class _FinancialAllocationScreenState extends State<FinancialAllocationScreen> {
  AllocationScore? _allocationScore;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllocationData();
  }

  void _loadAllocationData() {
    // Simulate loading data
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _allocationScore = FinancialAllocationService.getMockAllocationScore();
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        title: const Text(
          'Financial Allocation',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_allocationScore == null) {
      return const Center(child: Text('Failed to load allocation data'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScoreCard(),
          const SizedBox(height: 24),
          _buildAllocationBreakdown(),
          const SizedBox(height: 24),
          _buildInsights(),
          const SizedBox(height: 24),
          _buildRecommendations(),
        ],
      ),
    );
  }

  Widget _buildScoreCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryPurple,
            AppColors.primaryPurple.withOpacity(0.8)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Financial Health Score',
            style: AppTextStyles.h4.copyWith(color: AppColors.textWhite),
          ),
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: _allocationScore!.score / 100,
                  backgroundColor: AppColors.textWhite.withOpacity(0.3),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.accentGold),
                  strokeWidth: 8,
                ),
              ),
              Text(
                '${_allocationScore!.score}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textWhite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${_allocationScore!.riskProfile} Risk Profile',
            style:
                AppTextStyles.bodyMedium.copyWith(color: AppColors.textWhite),
          ),
          const SizedBox(height: 8),
          Text(
            'Monthly Income: \${_allocationScore!.totalIncome.toStringAsFixed(0)}',
            style: AppTextStyles.caption.copyWith(color: AppColors.textWhite),
          ),
        ],
      ),
    );
  }

  Widget _buildAllocationBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Allocation Breakdown',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: 16),
        ..._allocationScore!.categories
            .map((category) => _buildCategoryCard(category)),
      ],
    );
  }

  Widget _buildCategoryCard(AllocationCategory category) {
    Color statusColor =
        category.status == 'overspending' ? AppColors.error : AppColors.success;
    IconData statusIcon = category.status == 'overspending'
        ? Icons.trending_up
        : Icons.trending_down;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.name.capitalize(),
                style: AppTextStyles.h4,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(statusIcon, size: 16, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      category.status,
                      style: TextStyle(
                        fontSize: 12,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ideal: ${category.ideal.toStringAsFixed(1)}%',
                      style: AppTextStyles.caption,
                    ),
                    Text(
                      'Actual: ${category.actual.toStringAsFixed(1)}%',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Text(
                'Gap: ${category.gap > 0 ? '+' : ''}${category.gap.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: category.actual / 100,
              backgroundColor: AppColors.grey200,
              valueColor: AlwaysStoppedAnimation<Color>(
                category.status == 'overspending'
                    ? AppColors.error
                    : AppColors.success,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '\$${_allocationScore!.categoryAmounts[category.name]?.toStringAsFixed(0) ?? "0"}',
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.primaryPurple),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Insights',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: 16),
        ..._allocationScore!.insights
            .map((insight) => _buildInsightCard(insight)),
      ],
    );
  }

  Widget _buildInsightCard(String insight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: AppColors.primaryPurple,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              insight,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: 16),
        ..._allocationScore!.recommendations
            .map((recommendation) => _buildRecommendationCard(recommendation)),
      ],
    );
  }

  Widget _buildRecommendationCard(String recommendation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentGold, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.thumb_up_outlined,
            color: AppColors.accentGoldDark,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              recommendation,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
