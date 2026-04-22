class AllocationCategory {
  final String name;
  final double ideal; // percentage
  final double actual; // percentage
  final double gap; // actual - ideal
  final String status; // 'overspending' or 'underspending'

  AllocationCategory({
    required this.name,
    required this.ideal,
    required this.actual,
    required this.status,
  }) : gap = actual - ideal;

  factory AllocationCategory.fromJson(Map<String, dynamic> json) {
    return AllocationCategory(
      name: json['name'],
      ideal: json['ideal'].toDouble(),
      actual: json['actual'].toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ideal': ideal,
      'actual': actual,
      'gap': gap,
      'status': status,
    };
  }
}

enum RiskProfile {
  conservative,
  moderate,
  aggressive,
}

class AllocationScore {
  final int score; // 0-100
  final String riskProfile;
  final List<AllocationCategory> categories;
  final double totalIncome;
  final Map<String, double> categoryAmounts; // actual amounts in currency
  final List<String> insights; // actionable insights
  final List<String> recommendations;

  AllocationScore({
    required this.score,
    required this.riskProfile,
    required this.categories,
    required this.totalIncome,
    required this.categoryAmounts,
    required this.insights,
    required this.recommendations,
  });

  factory AllocationScore.fromJson(Map<String, dynamic> json) {
    return AllocationScore(
      score: json['score'],
      riskProfile: json['riskProfile'],
      categories: (json['categories'] as List)
          .map((c) => AllocationCategory.fromJson(c))
          .toList(),
      totalIncome: json['totalIncome'].toDouble(),
      categoryAmounts: Map<String, double>.from(json['categoryAmounts']),
      insights: List<String>.from(json['insights']),
      recommendations: List<String>.from(json['recommendations']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'riskProfile': riskProfile,
      'categories': categories.map((c) => c.toJson()).toList(),
      'totalIncome': totalIncome,
      'categoryAmounts': categoryAmounts,
      'insights': insights,
      'recommendations': recommendations,
    };
  }
}
