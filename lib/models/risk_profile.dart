// Risk Profile Model
// Represents a user's financial risk profile assessment
// Contains risk category, scores, and answers to assessment questions

import 'package:cloud_firestore/cloud_firestore.dart';

enum RiskCategory {
  conservative,
  moderate,
  volatile,
}

extension RiskCategoryExtension on RiskCategory {
  String get displayName {
    switch (this) {
      case RiskCategory.conservative:
        return 'Conservative';
      case RiskCategory.moderate:
        return 'Moderate';
      case RiskCategory.volatile:
        return 'Volatile';
    }
  }

  String get description {
    switch (this) {
      case RiskCategory.conservative:
        return 'Careful spender with stable income/expenses';
      case RiskCategory.moderate:
        return 'Balanced spending with some variability';
      case RiskCategory.volatile:
        return 'Unpredictable spending patterns';
    }
  }

  String get emoji {
    switch (this) {
      case RiskCategory.conservative:
        return '🛡️';
      case RiskCategory.moderate:
        return '⚖️';
      case RiskCategory.volatile:
        return '⚡';
    }
  }

  int get recommendation {
    switch (this) {
      case RiskCategory.conservative:
        return 0; // Invest in stable, low-risk options
      case RiskCategory.moderate:
        return 1; // Balanced investment approach
      case RiskCategory.volatile:
        return 2; // Build emergency fund first
    }
  }
}

class RiskProfile {
  final String uid;
  final RiskCategory riskCategory;
  final double riskScore; // 0-100
  final Map<String, int> questionAnswers; // question_id -> answer (0-4 for Likert scale)
  final DateTime createdAt;
  final DateTime? updatedAt;

  RiskProfile({
    required this.uid,
    required this.riskCategory,
    required this.riskScore,
    required this.questionAnswers,
    required this.createdAt,
    this.updatedAt,
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'riskCategory': riskCategory.displayName,
      'riskScore': riskScore,
      'questionAnswers': questionAnswers,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  // Create from Firestore document
  factory RiskProfile.fromMap(Map<String, dynamic> map) {
    return RiskProfile(
      uid: map['uid'] ?? '',
      riskCategory: _parseRiskCategory(map['riskCategory'] ?? 'Moderate'),
      riskScore: (map['riskScore'] ?? 50.0).toDouble(),
      questionAnswers: Map<String, int>.from(map['questionAnswers'] ?? {}),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Create copy with modifications
  RiskProfile copyWith({
    String? uid,
    RiskCategory? riskCategory,
    double? riskScore,
    Map<String, int>? questionAnswers,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RiskProfile(
      uid: uid ?? this.uid,
      riskCategory: riskCategory ?? this.riskCategory,
      riskScore: riskScore ?? this.riskScore,
      questionAnswers: questionAnswers ?? this.questionAnswers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static RiskCategory _parseRiskCategory(String value) {
    switch (value.toLowerCase()) {
      case 'conservative':
        return RiskCategory.conservative;
      case 'volatile':
        return RiskCategory.volatile;
      case 'moderate':
      default:
        return RiskCategory.moderate;
    }
  }
}

// Risk Assessment Question
class RiskQuestion {
  final String id;
  final String question;
  final List<String> options; // 5 options for Likert scale
  final String context; // Additional context/example for college students

  RiskQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.context,
  });
}

// Predefined college-student-tailored questions
final List<RiskQuestion> riskAssessmentQuestions = [
  RiskQuestion(
    id: 'q1_income',
    question: 'How stable is your current income?',
    options: [
      'No income',
      'Inconsistent (side gigs, part-time)',
      'Somewhat stable (part-time job)',
      'Very stable (part-time/work-study)',
      'Very stable (full-time or scholarship)',
    ],
    context: 'Consider income from jobs, internships, or family support',
  ),
  RiskQuestion(
    id: 'q2_expenses',
    question: 'How well do you track and control your expenses?',
    options: [
      'Never track, spend without planning',
      'Rarely track, occasional overspending',
      'Sometimes track, mostly controlled',
      'Usually track, good control',
      'Always track, strict budget',
    ],
    context: 'Include food, entertainment, subscriptions, and textbooks',
  ),
  RiskQuestion(
    id: 'q3_debt',
    question: 'What is your current debt situation?',
    options: [
      'High debt (loans, credit cards > 30% of income)',
      'Moderate debt (10-30% of income)',
      'Some debt (< 10% of income)',
      'Minimal debt (only student loans if any)',
      'No debt',
    ],
    context: 'Consider student loans, credit cards, and personal loans',
  ),
  RiskQuestion(
    id: 'q4_spending_volatility',
    question: 'How much does your monthly spending vary?',
    options: [
      'Highly unpredictable (varies 50%+ month to month)',
      'Somewhat unpredictable (varies 30-50%)',
      'Moderate variation (varies 15-30%)',
      'Relatively stable (varies < 15%)',
      'Very consistent (minimal monthly variation)',
    ],
    context: 'Think about unexpected expenses like medical, car repairs, etc.',
  ),
  RiskQuestion(
    id: 'q5_savings',
    question: 'How much of your income do you typically save?',
    options: [
      'Nothing, I spend everything',
      'Very little (< 5%)',
      'Some (5-15%)',
      'Regular savings (15-30%)',
      'Aggressive savings (> 30%)',
    ],
    context: 'Include emergency fund, savings account, or investment accounts',
  ),
];
