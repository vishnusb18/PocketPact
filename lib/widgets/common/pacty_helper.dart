// Pacty Helper Widget
// Duolingo-style mascot helper that appears throughout the app
// Shows contextual messages and different emotions with animated transitions

import 'package:flutter/material.dart';
import 'package:pocket_pact/theme/colors.dart';
import 'package:pocket_pact/utils/pacty_messages.dart';
import 'package:pocket_pact/utils/pacty_assets.dart';
import 'package:pocket_pact/widgets/common/pacty_animations.dart';

class PactyHelper extends StatefulWidget {
  final PactyMessage message;
  final double mascotSize;
  final bool showBubble;
  final EdgeInsets? padding;
  final bool animate;

  const PactyHelper({
    super.key,
    required this.message,
    this.mascotSize = 120,
    this.showBubble = true,
    this.padding,
    this.animate = true,
  });

  @override
  State<PactyHelper> createState() => _PactyHelperState();
}

class _PactyHelperState extends State<PactyHelper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) {
      return _buildContent();
    }

    return ScaleTransition(
      scale: _bounceAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final imagePath = PactyAssets.getImageForEmotion(widget.message.emotion);
    final isCelebrating = widget.message.emotion == PactyEmotion.celebrating ||
        widget.message.emotion == PactyEmotion.goalAchieved;
    
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mascot Image with emotion-specific asset and animations
          Stack(
            alignment: Alignment.center,
            children: [
              // Particles for celebration
              if (isCelebrating && widget.animate)
                const PactyParticles(
                  particleCount: 15,
                  particleColor: Color(0xFFFFD60A),
                ),
              
              // Pulse effect for emphasis
              PactyPulse(
                enabled: isCelebrating && widget.animate,
                glowColor: AppColors.accentGold,
                child: Hero(
                  tag: 'pacty_mascot_${widget.message.emotion}',
                  child: PactyBounceAnimation(
                    autoPlay: widget.animate,
                    intensity: isCelebrating ? 1.5 : 1.0,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Image.asset(
                        imagePath,
                        width: widget.mascotSize,
                        height: widget.mascotSize,
                        key: ValueKey(imagePath),
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            PactyAssets.getFallback(),
                            width: widget.mascotSize,
                            height: widget.mascotSize,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          if (widget.showBubble) ...[
            const SizedBox(height: 12),
            // Speech bubble
            _buildSpeechBubble(),
          ],
        ],
      ),
    );
  }

  Widget _buildSpeechBubble() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bubble pointer (triangle)
          Positioned(
            top: -8,
            left: 0,
            right: 0,
            child: Center(
              child: CustomPaint(
                size: const Size(20, 10),
                painter: _BubblePointerPainter(),
              ),
            ),
          ),
          // Bubble content
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: AppColors.primaryPurpleLight.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Message text
                Text(
                  widget.message.message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Action button if provided
                if (widget.message.actionText != null &&
                    widget.message.onAction != null) ...[
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: widget.message.onAction,
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(widget.message.actionText!),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the speech bubble pointer
class _BubblePointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Compact Pacty Helper - for smaller inline help messages
class PactyHelperCompact extends StatelessWidget {
  final String message;
  final VoidCallback? onTap;
  final PactyEmotion? emotion;

  const PactyHelperCompact({
    super.key,
    required this.message,
    this.onTap,
    this.emotion,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = emotion != null 
        ? PactyAssets.getImageForEmotion(emotion!)
        : PactyAssets.getFallback();
        
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primaryPurpleLight.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryPurpleLight.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Small Pacty icon with emotion
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Image.asset(
                imagePath,
                width: 40,
                height: 40,
                key: ValueKey(imagePath),
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    PactyAssets.getFallback(),
                    width: 40,
                    height: 40,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            // Message
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.primaryPurple,
              ),
          ],
        ),
      ),
    );
  }
}

// Floating Pacty Helper - appears floating at bottom of screen
class PactyHelperFloating extends StatelessWidget {
  final PactyMessage message;
  final VoidCallback? onDismiss;

  const PactyHelperFloating({
    super.key,
    required this.message,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = PactyAssets.getImageForEmotion(message.emotion);
    
    return Positioned(
      bottom: 80,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 60,
                height: 60,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    PactyAssets.getFallback(),
                    width: 60,
                    height: 60,
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message.message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onDismiss,
                  color: AppColors.textSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
