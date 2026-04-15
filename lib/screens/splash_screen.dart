// Splash Screen
// Initial loading screen displayed when the app launches
// Shows branding with PocketPact name and handshake emoji
// Checks authentication status and navigates accordingly

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup fade-in animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _controller.forward();
    
    // Check authentication and navigate after 3 seconds
    Timer(const Duration(seconds: 3), () async {
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6D4F7), // Light violet background
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                        color: const Color(0xFF5A189A),
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
                        color: const Color(0xFFC77DFF),
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Tagline
                Text(
                  'Save Together, Achieve Together',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFF7B2CBF).withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
