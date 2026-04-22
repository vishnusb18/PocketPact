import 'package:flutter/material.dart';
import 'colors.dart';

class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
}

class AppRadii {
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 24;
  static const double pill = 999;
}

class AppShadows {
  static List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.primaryPurpleDark.withOpacity(0.08),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> soft = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];
}

class AppInsets {
  static const EdgeInsets screen = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
    vertical: AppSpacing.md,
  );

  static const EdgeInsets card = EdgeInsets.all(AppSpacing.md);
  static const EdgeInsets cardLarge = EdgeInsets.all(AppSpacing.lg);
}
