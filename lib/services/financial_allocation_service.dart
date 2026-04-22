import '../models/financial_allocation.dart';

class FinancialAllocationService {
  // Ideal allocation percentages based on risk profile
  static const Map<String, Map<String, double>> _idealAllocations = {
    'conservative': {
      'earning': 60.0,
      'spending': 25.0,
      'saving': 10.0,
      'investing': 5.0,
    },
    'moderate': {
      'earning': 50.0,
      'spending': 30.0,
      'saving': 10.0,
      'investing': 10.0,
    },
    'aggressive': {
      'earning': 40.0,
      'spending': 30.0,
      'saving': 10.0,
      'investing': 20.0,
    },
  };

  static AllocationScore calculateAllocationScore({
    required double totalIncome,
    required Map<String, double> actualSpending,
    required String riskProfile,
  }) {
    final idealAllocations = _idealAllocations[riskProfile] ?? _idealAllocations['moderate']!;
    
    // Calculate actual percentages
    final totalSpending = actualSpending.values.fold(0.0, (sum, amount) => sum + amount);
    final actualAllocations = <String, double>{};
    
    // Calculate actual percentages for each category
    actualAllocations['earning'] = (totalIncome / (totalIncome + totalSpending)) * 100;
    actualAllocations['spending'] = (totalSpending / (totalIncome + totalSpending)) * 100;
    actualAllocations['saving'] = 0.0; // This would come from savings data
    actualAllocations['investing'] = 0.0; // This would come from investment data
    
    // Create allocation categories
    final categories = <AllocationCategory>[];
    for (final category in ['earning', 'spending', 'saving', 'investing']) {
      final ideal = idealAllocations[category]!;
      final actual = actualAllocations[category]!;
      final status = actual > ideal ? 'overspending' : 'underspending';
      
      categories.add(AllocationCategory(
        name: category,
        ideal: ideal,
        actual: actual,
        status: status,
      ));
    }
    
    // Calculate score based on how close actual is to ideal
    double totalDeviation = 0.0;
    for (final category in categories) {
      totalDeviation += (category.gap).abs();
    }
    final score = (100 - (totalDeviation * 2)).clamp(0, 100).toInt();
    
    // Generate insights and recommendations
    final insights = _generateInsights(categories, riskProfile);
    final recommendations = _generateRecommendations(categories, riskProfile);
    
    return AllocationScore(
      score: score,
      riskProfile: riskProfile,
      categories: categories,
      totalIncome: totalIncome,
      categoryAmounts: actualSpending,
      insights: insights,
      recommendations: recommendations,
    );
  }

  static List<String> _generateInsights(List<AllocationCategory> categories, String riskProfile) {
    final insights = <String>[];
    
    for (final category in categories) {
      if (category.gap.abs() > 10) {
        if (category.name == 'spending' && category.status == 'overspending') {
          insights.add('You\'re spending ${category.gap.toStringAsFixed(1)}% more than ideal for your risk profile.');
        } else if (category.name == 'saving' && category.status == 'underspending') {
          insights.add('You could save ${category.gap.abs().toStringAsFixed(1)}% more to reach your ideal allocation.');
        } else if (category.name == 'investing' && category.status == 'underspending') {
          insights.add('Consider investing ${category.gap.abs().toStringAsFixed(1)}% more to optimize your portfolio.');
        }
      }
    }
    
    if (insights.isEmpty) {
      insights.add('Your financial allocation is well-balanced for your $riskProfile risk profile.');
    }
    
    return insights;
  }

  static List<String> _generateRecommendations(List<AllocationCategory> categories, String riskProfile) {
    final recommendations = <String>[];
    
    for (final category in categories) {
      if (category.gap.abs() > 5) {
        if (category.name == 'spending' && category.status == 'overspending') {
          recommendations.add('Try to reduce discretionary spending by tracking expenses more closely.');
        } else if (category.name == 'saving' && category.status == 'underspending') {
          recommendations.add('Set up automatic transfers to savings accounts to build your emergency fund.');
        } else if (category.name == 'investing' && category.status == 'underspending') {
          recommendations.add('Consider diversifying your investments across different asset classes.');
        }
      }
    }
    
    if (recommendations.isEmpty) {
      recommendations.add('Keep up the good work maintaining your financial balance!');
    }
    
    return recommendations;
  }

  // Mock data for demonstration
  static AllocationScore getMockAllocationScore() {
    final mockSpending = {
      'food': 800.0,
      'transport': 300.0,
      'shopping': 500.0,
      'entertainment': 200.0,
      'bills': 1000.0,
    };

    return calculateAllocationScore(
      totalIncome: 5000.0,
      actualSpending: mockSpending,
      riskProfile: 'moderate',
    );
  }
}
