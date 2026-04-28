// Risk Profile Questionnaire Screen
// 5-question assessment for college students
// Displays questions with Likert scale responses and calculates risk profile

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/risk_profile.dart';
import '../services/risk_profile_service.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class RiskProfileQuestionnaireScreen extends StatefulWidget {
  final Function(RiskProfile)? onComplete;

  const RiskProfileQuestionnaireScreen({
    super.key,
    this.onComplete,
  });

  @override
  State<RiskProfileQuestionnaireScreen> createState() =>
      _RiskProfileQuestionnaireScreenState();
}

class _RiskProfileQuestionnaireScreenState
    extends State<RiskProfileQuestionnaireScreen>
    with SingleTickerProviderStateMixin {
  final _riskProfileService = RiskProfileService();
  late AnimationController _animationController;
  int _currentQuestionIndex = 0;
  final Map<String, int> _answers = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectAnswer(int answerValue) {
    final question = riskAssessmentQuestions[_currentQuestionIndex];
    setState(() {
      _answers[question.id] = answerValue;
    });

    // Auto-advance after selection
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_currentQuestionIndex < riskAssessmentQuestions.length - 1) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < riskAssessmentQuestions.length - 1) {
      _animationController.forward(from: 0.0);
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _animationController.forward(from: 0.0);
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  Future<void> _submitAssessment() async {
    if (_answers.length != riskAssessmentQuestions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final profile = await _riskProfileService.createRiskProfile(
        user.uid,
        _answers,
      );

      if (mounted) {
        widget.onComplete?.call(profile);
        Navigator.pop(context, profile);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = riskAssessmentQuestions[_currentQuestionIndex];
    final isAnswered = _answers.containsKey(question.id);
    final progress = (_currentQuestionIndex + 1) / riskAssessmentQuestions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Risk Assessment'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: AppColors.lightGrey,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          // Question number
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Question ${_currentQuestionIndex + 1} of ${riskAssessmentQuestions.length}',
              style: TextStyles.caption.copyWith(color: AppColors.greyText),
            ),
          ),
          // Main content
          Expanded(
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0)
                  .animate(_animationController),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question
                    Text(
                      question.question,
                      style: TextStyles.heading3,
                    ),
                    const SizedBox(height: 8),
                    // Context
                    Text(
                      question.context,
                      style: TextStyles.bodySmall
                          .copyWith(color: AppColors.greyText),
                    ),
                    const SizedBox(height: 24),
                    // Answer options
                    ..._buildAnswerOptions(question),
                  ],
                ),
              ),
            ),
          ),
          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightGrey,
                    foregroundColor: AppColors.primary,
                  ),
                ),
                if (_currentQuestionIndex < riskAssessmentQuestions.length - 1)
                  ElevatedButton.icon(
                    onPressed: isAnswered ? _nextQuestion : null,
                    label: const Text('Next'),
                    icon: const Icon(Icons.arrow_forward),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitAssessment,
                    label: _isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Complete'),
                    icon: _isSubmitting
                        ? const SizedBox.shrink()
                        : const Icon(Icons.check),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAnswerOptions(RiskQuestion question) {
    final selectedAnswer = _answers[question.id];

    return List.generate(
      question.options.length,
      (index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _selectAnswer(index),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectedAnswer == index
                      ? AppColors.primary
                      : AppColors.lightGrey,
                  width: selectedAnswer == index ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
                color: selectedAnswer == index
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Radio button
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(right: 16, top: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedAnswer == index
                            ? AppColors.primary
                            : AppColors.lightGrey,
                        width: 2,
                      ),
                    ),
                    child: selectedAnswer == index
                        ? Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : null,
                  ),
                  // Option text
                  Expanded(
                    child: Text(
                      question.options[index],
                      style: TextStyles.body.copyWith(
                        color: selectedAnswer == index
                            ? AppColors.primary
                            : AppColors.darkText,
                        fontWeight: selectedAnswer == index
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
