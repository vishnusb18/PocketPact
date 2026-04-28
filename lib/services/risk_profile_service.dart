// Risk Profile Service
// Handles risk profile calculations, data persistence, and recommendations

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/risk_profile.dart';

class RiskProfileService {
  static const String _collectionName = 'riskProfiles';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Calculate risk category and score based on answers
  (RiskCategory, double) calculateRiskProfile(Map<String, int> answers) {
    if (answers.isEmpty) {
      return (RiskCategory.moderate, 50.0);
    }

    double riskScore = 0;
    int totalQuestions = answers.length;

    // Calculate raw score from answers (each answer 0-4)
    answers.forEach((key, value) {
      riskScore += value;
    });

    // Normalize to 0-100
    riskScore = (riskScore / (totalQuestions * 4)) * 100;

    // Determine category based on score
    RiskCategory category;
    if (riskScore < 33) {
      category = RiskCategory.conservative;
    } else if (riskScore < 66) {
      category = RiskCategory.moderate;
    } else {
      category = RiskCategory.volatile;
    }

    return (category, riskScore);
  }

  // Save risk profile to Firestore
  Future<void> saveRiskProfile(String uid, RiskProfile profile) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(uid)
          .set(profile.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save risk profile: $e');
    }
  }

  // Get user's risk profile from Firestore
  Future<RiskProfile?> getRiskProfile(String uid) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(uid).get();
      if (doc.exists) {
        return RiskProfile.fromMap({...doc.data() ?? {}, 'uid': uid});
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch risk profile: $e');
    }
  }

  // Create a new risk profile from answers
  Future<RiskProfile> createRiskProfile(
    String uid,
    Map<String, int> answers,
  ) async {
    final (category, score) = calculateRiskProfile(answers);
    final profile = RiskProfile(
      uid: uid,
      riskCategory: category,
      riskScore: score,
      questionAnswers: answers,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await saveRiskProfile(uid, profile);
    return profile;
  }

  // Update risk profile with new answers
  Future<RiskProfile> updateRiskProfile(
    String uid,
    Map<String, int> answers,
  ) async {
    final (category, score) = calculateRiskProfile(answers);
    final profile = RiskProfile(
      uid: uid,
      riskCategory: category,
      riskScore: score,
      questionAnswers: answers,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await saveRiskProfile(uid, profile);
    return profile;
  }

  // Get financial recommendations based on risk profile
  List<String> getRecommendations(RiskProfile profile) {
    final recommendations = <String>[];

    switch (profile.riskCategory) {
      case RiskCategory.conservative:
        recommendations.addAll([
          '💰 Build an emergency fund with 3-6 months of expenses',
          '📈 Start a high-yield savings account for your savings',
          '🛡️ Consider low-risk investments (bonds, index funds)',
          '📊 Keep detailed expense tracking to maintain control',
          '🎯 Set specific short-term financial goals',
        ]);
        break;

      case RiskCategory.moderate:
        recommendations.addAll([
          '⚖️ Maintain a balanced portfolio (60% safe, 40% growth)',
          '💡 Review and reduce any high-interest debt',
          '📱 Use budgeting apps to improve expense tracking',
          '🚀 Consider diversified investments (stocks, funds)',
          '🎓 Set both short and long-term financial goals',
        ]);
        break;

      case RiskCategory.volatile:
        recommendations.addAll([
          '🆘 Build an emergency fund FIRST (crucial for you)',
          '💳 Create a strict budget to stabilize spending',
          '🎯 Track expenses daily to identify patterns',
          '🔄 Avoid high-risk investments until stable',
          '📞 Consider speaking with a financial advisor',
        ]);
        break;
    }

    // Add personalized recommendations based on specific scores
    final answers = profile.questionAnswers;

    // Check income stability (q1)
    if (answers['q1_income'] != null && answers['q1_income']! < 2) {
      recommendations.insert(
        0,
        '⚠️ Focus on finding stable income sources (work-study, part-time job)',
      );
    }

    // Check debt levels (q3)
    if (answers['q3_debt'] != null && answers['q3_debt']! > 2) {
      recommendations.insert(
        0,
        '💳 Prioritize paying down high-interest debt first',
      );
    }

    // Check savings (q5)
    if (answers['q5_savings'] != null && answers['q5_savings']! < 2) {
      recommendations.insert(
        0,
        '💾 Start with small regular savings, even \$5-10 per week counts',
      );
    }

    return recommendations;
  }

  // Stream to listen to risk profile changes
  Stream<RiskProfile?> watchRiskProfile(String uid) {
    return _firestore
        .collection(_collectionName)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return RiskProfile.fromMap({...doc.data() ?? {}, 'uid': uid});
      }
      return null;
    });
  }

  // Delete risk profile
  Future<void> deleteRiskProfile(String uid) async {
    try {
      await _firestore.collection(_collectionName).doc(uid).delete();
    } catch (e) {
      throw Exception('Failed to delete risk profile: $e');
    }
  }
}
