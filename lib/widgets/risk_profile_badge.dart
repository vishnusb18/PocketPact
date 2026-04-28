// Risk Profile Badge Widget
// Displays the user's risk profile category with emoji and color coding

import 'package:flutter/material.dart';
import '../models/risk_profile.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class RiskProfileBadge extends StatelessWidget {
  final RiskProfile profile;
  final double? fontSize;
  final EdgeInsets? padding;

  const RiskProfileBadge({
    super.key,
    required this.profile,
    this.fontSize,
    this.padding,
  });

  Color _getCategoryColor(RiskCategory category) {
    switch (category) {
      case RiskCategory.conservative:
        return const Color(0xFF2ECC71); // Green
      case RiskCategory.moderate:
        return const Color(0xFFF39C12); // Orange
      case RiskCategory.volatile:
        return const Color(0xFFE74C3C); // Red
    }
  }

  Color _getCategoryBackgroundColor(RiskCategory category) {
    switch (category) {
      case RiskCategory.conservative:
        return const Color(0xFF2ECC71).withOpacity(0.1);
      case RiskCategory.moderate:
        return const Color(0xFFF39C12).withOpacity(0.1);
      case RiskCategory.volatile:
        return const Color(0xFFE74C3C).withOpacity(0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = profile.riskCategory;
    final color = _getCategoryColor(category);
    final backgroundColor = _getCategoryBackgroundColor(category);

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            category.emoji,
            style: TextStyle(fontSize: fontSize ?? 16),
          ),
          const SizedBox(width: 6),
          Text(
            category.displayName,
            style: TextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: fontSize != null ? fontSize! * 0.75 : null,
            ),
          ),
        ],
      ),
    );
  }
}

// Risk Profile Card Widget
// Detailed display of risk profile with score and description

class RiskProfileCard extends StatelessWidget {
  final RiskProfile profile;
  final VoidCallback? onRetake;

  const RiskProfileCard({
    super.key,
    required this.profile,
    this.onRetake,
  });

  Color _getCategoryColor(RiskCategory category) {
    switch (category) {
      case RiskCategory.conservative:
        return const Color(0xFF2ECC71);
      case RiskCategory.moderate:
        return const Color(0xFFF39C12);
      case RiskCategory.volatile:
        return const Color(0xFFE74C3C);
    }
  }

  Color _getCategoryBackgroundColor(RiskCategory category) {
    switch (category) {
      case RiskCategory.conservative:
        return const Color(0xFF2ECC71).withOpacity(0.1);
      case RiskCategory.moderate:
        return const Color(0xFFF39C12).withOpacity(0.1);
      case RiskCategory.volatile:
        return const Color(0xFFE74C3C).withOpacity(0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = profile.riskCategory;
    final color = _getCategoryColor(category);
    final backgroundColor = _getCategoryBackgroundColor(category);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with category and score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        category.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        category.displayName,
                        style: TextStyles.heading3.copyWith(color: color),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.description,
                    style: TextStyles.bodySmall.copyWith(
                      color: AppColors.greyText,
                    ),
                  ),
                ],
              ),
              // Risk score circle
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.2),
                  border: Border.all(color: color, width: 2),
                ),
                child: Center(
                  child: Text(
                    '${profile.riskScore.toStringAsFixed(0)}%',
                    style: TextStyles.heading3.copyWith(color: color),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Risk score bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Risk Score',
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.greyText,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: profile.riskScore / 100,
                  minHeight: 8,
                  backgroundColor: color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
          if (onRetake != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRetake,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retake Assessment'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Risk Profile Score Indicator (small horizontal bar)
class RiskScoreIndicator extends StatelessWidget {
  final double score;
  final double height;

  const RiskScoreIndicator({
    super.key,
    required this.score,
    this.height = 4,
  });

  Color _getScoreColor(double score) {
    if (score < 33) {
      return const Color(0xFF2ECC71); // Conservative - Green
    } else if (score < 66) {
      return const Color(0xFFF39C12); // Moderate - Orange
    } else {
      return const Color(0xFFE74C3C); // Volatile - Red
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: score / 100,
        minHeight: height,
        backgroundColor: const Color(0xFFE8E8E8),
        valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor(score)),
      ),
    );
  }
}
