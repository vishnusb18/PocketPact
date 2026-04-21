// Splash Screen
// Initial loading screen displayed when the app launches
// Features Pacty mascot with PocketPact branding
// Checks authentication status and navigates accordingly

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pocket_pact/theme/colors.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pactyController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pactyBounceAnimation;
  late Animation<Offset> _pactySlideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup fade-in animation for text
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    
    // Setup Pacty mascot animation
    _pactyController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _pactyBounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pactyController,
        curve: Curves.elasticOut,
      ),
    );
    
    _pactySlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _pactyController,
        curve: Curves.easeOut,
      ),
    );
    
    // Start animations
    _pactyController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController.forward();
    });
    
    // Check authentication and navigate after 3.5 seconds
    Timer(const Duration(milliseconds: 3500), () async {
      if (mounted) {
        // Check if user is logged in
        final user = FirebaseAuth.instance.currentUser;
        
        if (user != null) {
          // User is signed in, go to dashboard
          Navigator.of(context).pushReplacementNamed('/dashboard');
        } else {
          // User is not signed in, go to auth screen
          Navigator.of(context).pushReplacementNamed('/auth');
        }
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pactyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6D4F7), // Light violet background
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Pacty Mascot with bounce animation
              SlideTransition(
                position: _pactySlideAnimation,
                child: ScaleTransition(
                  scale: _pactyBounceAnimation,
                  child: Image.asset(
                    'assets/pacty_happy.png',
                    width: 180,
                    height: 180,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to original mascot
                      return Image.asset(
                        'assets/pacty_mascot.png',
                        width: 180,
                        height: 180,
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // PocketPact branding with fade-in
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    // PocketPact with handshake between the words
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // "Pocket" in dark purple
                        Text(
                          'Pocket',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryPurpleDark,
                            letterSpacing: -1,
                          ),
                        ),
                        // Handshake emoji
                        Text(
                          '🤝',
                          style: TextStyle(
                            fontSize: 48,
                          ),
                        ),
                        // "Pact" in light purple
                        Text(
                          'Pact',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryPurpleLight,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Pacty's intro message
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        "Hi! I'm Pacty 👋\nYour pocket. Your pact.\nWe help you save, together.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Loading indicator
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Footer tagline
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Text(
                    'Save Together, Achieve Together',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryPurple.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
