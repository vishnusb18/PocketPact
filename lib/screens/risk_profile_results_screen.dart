// Risk Profile Results Screen
// Displays assessment results, risk profile card, and recommendations

import 'package:flutter/material.dart';
import '../models/risk_profile.dart';
import '../screens/risk_profile_questionnaire_screen.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../widgets/risk_profile_badge.dart';
import '../widgets/financial_recommendations_widget.dart';

class RiskProfileResultsScreen extends StatefulWidget {
  final RiskProfile profile;

  const RiskProfileResultsScreen({
    super.key,
    required this.profile,
  });

  @override
  State<RiskProfileResultsScreen> createState() =>
      _RiskProfileResultsScreenState();
}

class _RiskProfileResultsScreenState extends State<RiskProfileResultsScreen> {
  bool _showRecommendations = false;

  Future<void> _retakeAssessment() async {
    final result = await Navigator.push<RiskProfile>(
      context,
      MaterialPageRoute(
        builder: (context) => const RiskProfileQuestionnaireScreen(),
      ),
    );

    if (result != null && mounted) {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk Profile Results'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Celebration message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎉 Assessment Complete!',
                    style: TextStyles.heading3.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'ve analyzed your financial situation and created a personalized profile to help guide your money decisions.',
                    style: TextStyles.body,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Risk profile card
            RiskProfileCard(
              profile: widget.profile,
              onRetake: _retakeAssessment,
            ),
            const SizedBox(height: 24),
            // Quick stats
            FinancialQuickStatsWidget(profile: widget.profile),
            const SizedBox(height: 24),
            // Recommendations toggle
            GestureDetector(
              onTap: () {
                setState(() => _showRecommendations = !_showRecommendations);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'View Recommendations',
                      style: TextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AnimatedRotation(
                      turns: _showRecommendations ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.expand_more,
                        color: AppColors.greyText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_showRecommendations) ...[
              const SizedBox(height: 16),
              FinancialRecommendationsWidget(profile: widget.profile),
            ],
            const SizedBox(height: 24),
            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, widget.profile),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Risk Profile Popup Dialog
class RiskProfilePopup extends StatelessWidget {
  final RiskProfile profile;
  final VoidCallback? onRetake;

  const RiskProfilePopup({
    super.key,
    required this.profile,
    this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Risk Profile',
                    style: TextStyles.heading3,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: AppColors.greyText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Badge
              RiskProfileCard(profile: profile),
              const SizedBox(height: 16),
              // Description
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What this means:',
                      style: TextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profile.riskCategory.description,
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.greyText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (onRetake != null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onRetake,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retake'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
