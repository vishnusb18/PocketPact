import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme/app_design.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../utils/pacty_messages.dart';
import '../widgets/common/pacty_animations.dart';
import '../widgets/common/pacty_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );
    _fade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0, 0.75, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _introController, curve: Curves.easeOutCubic),
    );

    _introController.forward();

    Timer(const Duration(milliseconds: 2800), () {
      if (!mounted) return;
      final user = FirebaseAuth.instance.currentUser;
      Navigator.of(context).pushReplacementNamed(
        user != null ? '/dashboard' : '/auth',
      );
    });
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lavenderMist,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned(
              top: 86,
              right: 38,
              child: _SparkleDot(size: 10, opacity: 0.32),
            ),
            const Positioned(
              top: 150,
              left: 34,
              child: _SparkleDot(size: 14, opacity: 0.22),
            ),
            const Positioned(
              bottom: 174,
              right: 56,
              child: _SparkleDot(size: 8, opacity: 0.28),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PactyReactionWidget(
                        emotion: PactyMessages.splash.first.emotion,
                        size: 210,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        'PocketPact',
                        style: AppTextStyles.h1.copyWith(
                          color: AppColors.primaryPurpleDark,
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Save together. Stay accountable.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      PactyMessageBubble(
                        message: PactyMessages.splash.first.message,
                        alignment: CrossAxisAlignment.center,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      const _BrandedLoadingBar(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandedLoadingBar extends StatelessWidget {
  const _BrandedLoadingBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 132,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.pill),
        child: LinearProgressIndicator(
          minHeight: 6,
          backgroundColor: Colors.white.withOpacity(0.72),
          valueColor: const AlwaysStoppedAnimation<Color>(
            AppColors.primaryPurple,
          ),
        ),
      ),
    );
  }
}

class _SparkleDot extends StatelessWidget {
  final double size;
  final double opacity;

  const _SparkleDot({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return PactyFloatAnimation(
      amplitude: 4,
      duration: const Duration(milliseconds: 2600),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.accentGold.withOpacity(opacity),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
