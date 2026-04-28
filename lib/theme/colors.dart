import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Purple
  static const Color primaryPurple = Color(0xFF7B2CBF);
  static const Color primaryPurpleLight = Color(0xFF9D4EDD);
  static const Color primaryPurpleDark = Color(0xFF5A189A);
  
  // Accent Colors - Gold
  static const Color accentGold = Color(0xFFFFD60A);
  static const Color accentGoldLight = Color(0xFFFFC300);
  static const Color accentGoldDark = Color(0xFFFFB703);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF3F4F6);
  static const Color lavenderMist = Color(0xFFF4ECFB);
  static const Color lavenderCard = Color(0xFFE9D8F7);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  
  // Neutral Colors
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey700 = Color(0xFF374151);
  
  // Gradient Colors
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [primaryPurple, primaryPurpleLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient goldGradient = LinearGradient(
    colors: [accentGold, accentGoldDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Aliases for backward compatibility
  static const Color primary = primaryPurple;
  static const Color lightGrey = grey200;
  static const Color greyText = textSecondary;
  static const Color darkText = textPrimary;
}
