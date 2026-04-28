# Risk Profiling System - Complete Implementation Guide

## Overview

A comprehensive financial risk assessment system tailored for college students. The system helps users understand their financial behavior through a 5-question quiz and categorizes their finances as Conservative, Moderate, or Volatile. Based on their profile, users receive personalized financial recommendations.

## Components

### 1. **RiskProfile Model** (`lib/models/risk_profile.dart`)

Defines the data structure for risk profiles:

- **RiskCategory Enum**: 
  - `Conservative` (🛡️) - Careful spenders with stable income/expenses
  - `Moderate` (⚖️) - Balanced spending with some variability
  - `Volatile` (⚡) - Unpredictable spending patterns

- **RiskProfile Class**:
  - `uid`: User ID
  - `riskCategory`: Risk classification
  - `riskScore`: 0-100 score
  - `questionAnswers`: Map of answers to all questions
  - `createdAt`/`updatedAt`: Timestamps

- **RiskQuestion Class**: Defines individual assessment questions with options and context

- **Assessment Questions** (5 questions):
  1. Income Stability
  2. Expense Control
  3. Debt Level
  4. Spending Volatility
  5. Savings Rate

### 2. **RiskProfileService** (`lib/services/risk_profile_service.dart`)

Handles all business logic:

**Core Methods:**
- `calculateRiskProfile()` - Calculates risk category and score from answers
- `createRiskProfile()` - Creates new risk profile with Firestore persistence
- `updateRiskProfile()` - Updates existing profile
- `getRiskProfile()` - Fetches profile from Firestore
- `getRecommendations()` - Generates personalized recommendations
- `watchRiskProfile()` - Real-time profile updates via Firestore listener

**Risk Calculation:**
- Converts Likert-scale answers (0-4) to 0-100 score
- Categorizes: Conservative (<33), Moderate (33-66), Volatile (>66)

### 3. **UI Screens**

#### **RiskProfileQuestionnaireScreen** (`lib/screens/risk_profile_questionnaire_screen.dart`)
- 5-question interactive questionnaire
- Likert-scale responses with visual feedback
- Auto-advance after selection
- Progress bar showing completion
- Question context specific to college students
- Validation before submission

#### **RiskProfileResultsScreen** (`lib/screens/risk_profile_results_screen.dart`)
- Displays results after questionnaire completion
- Shows risk profile card with category and score
- Financial quick stats grid
- Expandable recommendations section
- Option to retake assessment

### 4. **Widgets** (`lib/widgets/`)

#### **risk_profile_badge.dart**
- `RiskProfileBadge` - Compact badge showing category emoji and name
- `RiskProfileCard` - Detailed card with score circle and description
- `RiskScoreIndicator` - Progress bar showing risk score

#### **financial_recommendations_widget.dart**
- `FinancialRecommendationsWidget` - Full recommendations list
- `_RecommendationTile` - Expandable recommendation with details
- `FinancialQuickStatsWidget` - 6-stat grid showing financial profile
- Personalized tips based on user's specific answers

### 5. **Profile Screen Integration** (`lib/screens/profile_screen.dart`)

**Two Scenarios:**

1. **User has taken assessment** - Shows:
   - Risk profile badge
   - Risk score
   - Score visualization
   - Link to detailed results

2. **User hasn't taken assessment** - Shows:
   - Attractive prompt with emoji
   - Description of benefits
   - "Start Assessment" button

## Calculation Logic

### Risk Score Calculation
```dart
score = (sum of all answers / (number_of_questions * 4)) * 100
```
- Each answer: 0-4 on Likert scale
- 5 questions total
- Results in 0-100 score

### Category Assignment
- **Conservative**: 0-33 (low risk, stable finances)
- **Moderate**: 33-66 (balanced risk, some variation)
- **Volatile**: 66-100 (high risk, unpredictable finances)

## Recommendations Logic

### Automatic Prioritization
The system prioritizes recommendations based on specific answers:

1. **Low income stability** → Suggests finding stable income sources
2. **High debt levels** → Prioritizes debt payoff
3. **Low savings rate** → Suggests starting with small savings
4. **Poor expense tracking** → Recommends budgeting apps

### Category-Specific Tips
- **Conservative**: Emergency fund, high-yield savings, low-risk investments
- **Moderate**: Balanced portfolio, debt management, diversification
- **Volatile**: Emergency fund priority, strict budgeting, expense tracking

## Data Flow

```
User Profile Screen
         ↓
[No Profile?] → Show Prompt
[Has Profile?] → Show Badge
         ↓
User Taps "Start" → Questionnaire Screen
         ↓
User Answers 5 Questions
         ↓
RiskProfileService.createRiskProfile()
         ↓
Calculate Score & Category
         ↓
Save to Firestore
         ↓
Results Screen (Recommendations)
         ↓
Return to Profile Screen (updated with badge)
```

## Firestore Structure

```
riskProfiles/
  ├── {uid}/
  │   ├── uid: string
  │   ├── riskCategory: string (Conservative|Moderate|Volatile)
  │   ├── riskScore: number (0-100)
  │   ├── questionAnswers: map
  │   │   ├── q1_income: number
  │   │   ├── q2_expenses: number
  │   │   ├── q3_debt: number
  │   │   ├── q4_spending_volatility: number
  │   │   └── q5_savings: number
  │   ├── createdAt: timestamp
  │   └── updatedAt: timestamp
```

## College Student Focus

Questions and recommendations are tailored for college students:

- **Income**: Covers part-time jobs, work-study, internships, family support
- **Expenses**: Includes tuition, food, entertainment, subscriptions, textbooks
- **Debt**: Student loans, credit cards, personal loans
- **Savings**: Even small amounts like $5-10/week
- **Resources**: Campus financial counseling, low-cost apps, free services

## Usage Examples

### Starting Assessment
```dart
final result = await Navigator.push<RiskProfile>(
  context,
  MaterialPageRoute(
    builder: (context) => const RiskProfileQuestionnaireScreen(),
  ),
);
```

### Getting Recommendations
```dart
final service = RiskProfileService();
final profile = await service.getRiskProfile(uid);
if (profile != null) {
  final recommendations = service.getRecommendations(profile);
}
```

### Displaying Badge
```dart
RiskProfileBadge(profile: riskProfile)
```

### Real-time Updates
```dart
final service = RiskProfileService();
service.watchRiskProfile(uid).listen((profile) {
  if (profile != null) {
    // Update UI with new profile
  }
});
```

## Future Enhancements

1. **Periodic Reassessment**: Remind users to retake every 6 months
2. **Goal Tracking**: Track progress toward recommendations
3. **Financial Education**: Add educational content based on profile
4. **Peer Comparison**: Anonymous comparison with anonymized peer data
5. **Integration**: Link recommendations to specific Pacts
6. **Mobile Notifications**: Alert users about relevant recommendations
7. **Export Reports**: Generate PDF reports of assessments
8. **Multi-language Support**: Translate for international students

## Testing

### Test Cases to Implement

1. **Questionnaire Flow**
   - All 5 questions answered
   - Navigation back/forward
   - Form validation

2. **Score Calculation**
   - Conservative profile (low answers)
   - Moderate profile (mid answers)
   - Volatile profile (high answers)

3. **Recommendations**
   - Correct recommendations for each category
   - Priority prioritization

4. **Data Persistence**
   - Save to Firestore
   - Retrieve from Firestore
   - Update existing profile

5. **UI Integration**
   - Badge displays correctly
   - Prompt shows for new users
   - Results screen displays all data

## Styling

The system uses the existing PocketPact theme:
- Primary color for interactive elements
- Colors for risk levels:
  - Conservative: Green (#2ECC71)
  - Moderate: Orange (#F39C12)
  - Volatile: Red (#E74C3C)
- Consistent spacing, shadows, and border radius per app design

## Dependencies

- `firebase_auth` - User authentication
- `cloud_firestore` - Data persistence
- `flutter` - UI framework

## Files Created/Modified

### New Files
- `lib/models/risk_profile.dart`
- `lib/services/risk_profile_service.dart`
- `lib/screens/risk_profile_questionnaire_screen.dart`
- `lib/screens/risk_profile_results_screen.dart`
- `lib/widgets/risk_profile_badge.dart`
- `lib/widgets/financial_recommendations_widget.dart`

### Modified Files
- `lib/screens/profile_screen.dart` - Added risk profile integration
