// Authentication Screen
// Handles user login and registration
// Contains forms for email/password input
// Validates credentials and manages authentication state

import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // "Welcome" Header
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 42,
                  fontFamily: 'Serif', // Ensure you have a serif font in pubspec.yaml
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              // Email Field
              _buildTextField('Email'),
              const SizedBox(height: 16),
              // Password Field
              _buildTextField('Password', isPassword: true),
              const SizedBox(height: 24),
              // Sign In Button
              _buildPrimaryButton('Sign In', () {
                // TODO: Add sign-in logic using Provider
              }),
              const SizedBox(height: 16),
              // Forgot Password Link
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Social Login Buttons
              _buildSocialButton('Continue with Google', 'assets/google_logo.png'),
              const SizedBox(height: 12),
              _buildSocialButton('Continue with Apple', Icons.apple, isIcon: true),
              const Spacer(flex: 1),
              // Terms and Privacy Policy
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'By clicking continue, you agree to our Terms of Service and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for Input Fields
  Widget _buildTextField(String hint, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ],
    );
  }

  // Helper method for the Main Sign In Button
  Widget _buildPrimaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D2D2D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }

  // Helper method for Social Buttons
  Widget _buildSocialButton(String text, dynamic leading, {bool isIcon = false}) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFF0F0F0),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isIcon 
              ? Icon(leading as IconData, color: Colors.black, size: 24)
              : Image.asset(leading as String, height: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
