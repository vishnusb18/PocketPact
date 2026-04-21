// Pacty Animation Demo Screen
// Showcases all Pacty animations and emotions
// Use this to test and demonstrate Duolingo-style animations

import 'package:flutter/material.dart';
import 'package:pocket_pact/theme/colors.dart';
import 'package:pocket_pact/utils/pacty_messages.dart';
import 'package:pocket_pact/widgets/common/pacty_helper.dart';
import 'package:pocket_pact/widgets/common/pacty_celebration.dart';

class PactyAnimationDemoScreen extends StatefulWidget {
  const PactyAnimationDemoScreen({super.key});

  @override
  State<PactyAnimationDemoScreen> createState() => _PactyAnimationDemoScreenState();
}

class _PactyAnimationDemoScreenState extends State<PactyAnimationDemoScreen> {
  PactyMessage _currentMessage = PactyMessages.welcome[0];

  void _showCelebration() {
    showPactyCelebration(
      context,
      title: '🎉 Goal Achieved!',
      message: 'You saved \$1,000 this month! Amazing work!',
      buttonText: 'Keep Going!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pacty Animations Demo',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Main Pacty Display
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: PactyHelper(
                  message: _currentMessage,
                  mascotSize: 180,
                  animate: true,
                ),
              ),

              const SizedBox(height: 32),

              // Emotion Selector
              const Text(
                'Try Different Emotions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 16),

              // Emotion Buttons
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _emotionButton('Happy', PactyMessages.welcome[0]),
                  _emotionButton('Thinking', PactyMessages.settings[0]),
                  _emotionButton('Celebrating', PactyMessages.goalAchieved[0]),
                  _emotionButton('Determined', PactyMessages.createPact[1]),
                  _emotionButton('Tracking', PactyMessages.dashboard[0]),
                  _emotionButton('Saving', PactyMessages.saving[0]),
                ],
              ),

              const SizedBox(height: 32),

              // Compact Examples
              const Text(
                'Compact Helper Examples',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 16),

              PactyHelperCompact(
                message: 'Great job! You\'re on track! 🎯',
                emotion: PactyEmotion.happy,
              ),

              const SizedBox(height: 12),

              PactyHelperCompact(
                message: 'Link your bank to track savings automatically!',
                emotion: PactyEmotion.thinking,
              ),

              const SizedBox(height: 12),

              PactyHelperCompact(
                message: 'Amazing! You completed your goal! 🏆',
                emotion: PactyEmotion.goalAchieved,
              ),

              const SizedBox(height: 32),

              // Celebration Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _showCelebration,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGold,
                    foregroundColor: AppColors.textPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.celebration, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Show Full Celebration',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurpleLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryPurpleLight.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✨ Animation Features',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _featureItem('🎯 Bounce animation on appear'),
                    _featureItem('✨ Particle effects for celebrations'),
                    _featureItem('💫 Pulse/glow for emphasis'),
                    _featureItem('🎊 Full-screen confetti celebrations'),
                    _featureItem('🔄 Smooth crossfade between emotions'),
                    _featureItem('🎬 Hero transitions between screens'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emotionButton(String label, PactyMessage message) {
    final isSelected = _currentMessage == message;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _currentMessage = message;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? AppColors.primaryPurple
            : Colors.white,
        foregroundColor: isSelected
            ? Colors.white
            : AppColors.textPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected
                ? AppColors.primaryPurple
                : AppColors.grey300,
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _featureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
    );
  }
}
