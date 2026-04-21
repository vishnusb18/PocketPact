// Pacty Assets
// Maps emotions to their corresponding image files
// Handles image loading for Pacty mascot

import 'package:pocket_pact/utils/pacty_messages.dart';

class PactyAssets {
  // Base path for Pacty images
  static const String _basePath = 'assets/';
  
  // Fallback to original mascot image if emotion-specific image doesn't exist
  static const String _fallback = 'assets/pacty_mascot.png';

  // Map emotions to their image file names (matching your actual files)
  static String getImageForEmotion(PactyEmotion emotion) {
    switch (emotion) {
      case PactyEmotion.happy:
        return '${_basePath}pacty_happy.png';
      case PactyEmotion.thinking:
        return '${_basePath}pacty_thinking.png';
      case PactyEmotion.celebrating:
      case PactyEmotion.goalAchieved:
        return '${_basePath}Pacty_win.png';
      case PactyEmotion.determined:
      case PactyEmotion.tracking:
        return '${_basePath}Pacty_trend.png';
      case PactyEmotion.splitting:
      case PactyEmotion.locking:
      case PactyEmotion.saving:
        return '${_basePath}pacty_happy.png'; // Default to happy for now
    }
  }

  // Get fallback image
  static String getFallback() => _fallback;

  // Get sad Pacty (for error states)
  static String getSad() => '${_basePath}Pacty_sad.png';

  // Check if emotion-specific images are available
  static bool hasEmotionImages() => true;

  // List of all available Pacty images for preloading
  static List<String> getAllImages() {
    return [
      '${_basePath}pacty_mascot.png',
      '${_basePath}pacty_happy.png',
      '${_basePath}pacty_thinking.png',
      '${_basePath}Pacty_sad.png',
      '${_basePath}Pacty_trend.png',
      '${_basePath}Pacty_win.png',
    ];
  }
}
