// Pacty Celebration Modal
// Full-screen celebration with confetti and animated Pacty
// Duolingo-style achievement celebration

import 'package:flutter/material.dart';
import 'package:pocket_pact/theme/colors.dart';
import 'package:pocket_pact/utils/pacty_messages.dart';
import 'package:pocket_pact/widgets/common/pacty_helper.dart';
import 'package:pocket_pact/widgets/common/pacty_animations.dart';

class PactyCelebrationModal extends StatefulWidget {
  final String title;
  final String message;
  final PactyMessage? pactyMessage;
  final VoidCallback? onDismiss;
  final String? buttonText;

  const PactyCelebrationModal({
    super.key,
    required this.title,
    required this.message,
    this.pactyMessage,
    this.onDismiss,
    this.buttonText,
  });

  @override
  State<PactyCelebrationModal> createState() => _PactyCelebrationModalState();
}

class _PactyCelebrationModalState extends State<PactyCelebrationModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultMessage = widget.pactyMessage ?? PactyMessages.goalAchieved[0];

    return Material(
      color: Colors.black54,
      child: Stack(
        children: [
          // Full-screen confetti
          const PactyConfetti(show: true),

          // Modal content
          FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Celebrating Pacty with animations
                      PactyHelper(
                        message: defaultMessage,
                        mascotSize: 150,
                        showBubble: false,
                        animate: true,
                      ),

                      const SizedBox(height: 24),

                      // Title
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      // Message
                      Text(
                        widget.message,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // Action button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.onDismiss?.call();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            widget.buttonText ?? 'Awesome!',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper function to show celebration
void showPactyCelebration(
  BuildContext context, {
  required String title,
  required String message,
  PactyMessage? pactyMessage,
  String? buttonText,
  VoidCallback? onDismiss,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PactyCelebrationModal(
      title: title,
      message: message,
      pactyMessage: pactyMessage,
      buttonText: buttonText,
      onDismiss: onDismiss,
    ),
  );
}
