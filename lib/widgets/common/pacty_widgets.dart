import 'package:flutter/material.dart';
import '../../theme/app_design.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/pacty_assets.dart';
import '../../utils/pacty_messages.dart';
import 'pacty_animations.dart';

class PactyMessageBubble extends StatelessWidget {
  final String message;
  final CrossAxisAlignment alignment;

  const PactyMessageBubble({
    super.key,
    required this.message,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.primaryPurpleLight.withOpacity(0.18)),
        boxShadow: AppShadows.soft,
      ),
      child: Text(
        message,
        textAlign: alignment == CrossAxisAlignment.center
            ? TextAlign.center
            : TextAlign.start,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.grey700,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
      ),
    );
  }
}

class PactyReactionWidget extends StatelessWidget {
  final PactyEmotion emotion;
  final double progress;
  final double size;
  final bool animate;
  final String? assetPath;

  const PactyReactionWidget({
    super.key,
    this.emotion = PactyEmotion.happy,
    this.progress = 0,
    this.size = 96,
    this.animate = true,
    this.assetPath,
  });

  factory PactyReactionWidget.forProgress({
    Key? key,
    required double progress,
    double size = 96,
    bool animate = true,
  }) {
    final emotion = progress >= 0.8
        ? PactyEmotion.celebrating
        : progress >= 0.4
            ? PactyEmotion.happy
            : PactyEmotion.determined;

    return PactyReactionWidget(
      key: key,
      emotion: emotion,
      progress: progress,
      size: size,
      animate: animate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final path = assetPath ?? PactyAssets.getImageForEmotion(emotion);
    final isCelebrating =
        emotion == PactyEmotion.celebrating || emotion == PactyEmotion.goalAchieved;

    Widget image = AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      child: Image.asset(
        path,
        key: ValueKey(path),
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            PactyAssets.getFallback(),
            width: size,
            height: size,
            fit: BoxFit.contain,
          );
        },
      ),
    );

    if (animate) {
      image = PactyFloatAnimation(
        amplitude: isCelebrating ? 8 : 5,
        duration: const Duration(milliseconds: 2200),
        child: image,
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        if (isCelebrating && animate)
          PactyParticles(
            particleCount: 12,
            particleColor: AppColors.accentGold,
            particleIcon: Icons.star_rounded,
          ),
        image,
      ],
    );
  }
}

class PactyHeroCard extends StatelessWidget {
  final PactyMessage message;
  final String? title;
  final String? eyebrow;
  final Widget? trailing;
  final double mascotSize;

  const PactyHeroCard({
    super.key,
    required this.message,
    this.title,
    this.eyebrow,
    this.trailing,
    this.mascotSize = 128,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.lavenderCard,
            Colors.white,
            AppColors.accentGold.withOpacity(0.16),
          ],
          stops: const [0, 0.72, 1],
        ),
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.primaryPurpleLight.withOpacity(0.14)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (eyebrow != null) ...[
                      Text(
                        eyebrow!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primaryPurpleDark,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                    ],
                    if (title != null)
                      Text(
                        title!,
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.12,
                        ),
                      ),
                  ],
                ),
              ),
              PactyReactionWidget(
                emotion: message.emotion,
                size: mascotSize,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          PactyMessageBubble(message: message.message),
          if (trailing != null) ...[
            const SizedBox(height: AppSpacing.md),
            trailing!,
          ],
        ],
      ),
    );
  }
}
