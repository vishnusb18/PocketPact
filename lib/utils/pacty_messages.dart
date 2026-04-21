// Pacty Messages
// Duolingo-style contextual messages for the Pacty mascot
// Different messages and emotions for different app contexts

import 'package:flutter/material.dart';

enum PactyEmotion {
  happy,
  thinking,
  celebrating,
  determined,
  tracking,
  splitting,
  locking,
  saving,
  goalAchieved,
}

class PactyMessage {
  final String message;
  final PactyEmotion emotion;
  final String? actionText;
  final VoidCallback? onAction;

  const PactyMessage({
    required this.message,
    required this.emotion,
    this.actionText,
    this.onAction,
  });
}

class PactyMessages {
  // Splash Screen Messages
  static const List<PactyMessage> splash = [
    PactyMessage(
      message: "Hi! I'm Pacty 👋\nI lock in your money pacts and help you hit your goals!",
      emotion: PactyEmotion.happy,
    ),
  ];

  // Welcome Messages
  static const List<PactyMessage> welcome = [
    PactyMessage(
      message: "Welcome to PocketPact! I'm here to help you save together.",
      emotion: PactyEmotion.happy,
    ),
    PactyMessage(
      message: "Your pocket. Your pact. Let's make saving fun!",
      emotion: PactyEmotion.celebrating,
    ),
  ];

  // Dashboard Messages
  static const List<PactyMessage> dashboard = [
    PactyMessage(
      message: "Looking great! Your pacts are on track! 🎯",
      emotion: PactyEmotion.happy,
    ),
    PactyMessage(
      message: "Ready to create a new pact? Let's do this together!",
      emotion: PactyEmotion.determined,
    ),
    PactyMessage(
      message: "Your friends are counting on you. Keep it up!",
      emotion: PactyEmotion.celebrating,
    ),
  ];

  // Creating Pact Messages
  static const List<PactyMessage> createPact = [
    PactyMessage(
      message: "Let's lock in a new pact! What are we saving for?",
      emotion: PactyEmotion.locking,
    ),
    PactyMessage(
      message: "Great choice! Set your goal and I'll help you get there.",
      emotion: PactyEmotion.determined,
    ),
  ];

  // Bank Linking Messages
  static const List<PactyMessage> bankLinking = [
    PactyMessage(
      message: "Link your bank to track your money automatically!",
      emotion: PactyEmotion.tracking,
    ),
    PactyMessage(
      message: "Don't worry, your data is super secure with me! 🔒",
      emotion: PactyEmotion.locking,
    ),
  ];

  // Saving Progress Messages
  static const List<PactyMessage> saving = [
    PactyMessage(
      message: "Every contribution counts! Keep going! 💪",
      emotion: PactyEmotion.saving,
    ),
    PactyMessage(
      message: "You're doing amazing! Your goal is getting closer!",
      emotion: PactyEmotion.determined,
    ),
  ];

  // Goal Achievement Messages
  static const List<PactyMessage> goalAchieved = [
    PactyMessage(
      message: "🎉 YOU DID IT! Goal achieved! I'm so proud of you!",
      emotion: PactyEmotion.goalAchieved,
    ),
    PactyMessage(
      message: "Amazing work! Ready to set a new goal?",
      emotion: PactyEmotion.celebrating,
    ),
  ];

  // Splitting Bills Messages
  static const List<PactyMessage> splitting = [
    PactyMessage(
      message: "Time to split the bill! Everyone pays their fair share.",
      emotion: PactyEmotion.splitting,
    ),
    PactyMessage(
      message: "Splitting made easy! No awkward money talks needed.",
      emotion: PactyEmotion.happy,
    ),
  ];

  // Reminder Messages
  static const List<PactyMessage> reminder = [
    PactyMessage(
      message: "Hey! Don't forget your contribution is due soon!",
      emotion: PactyEmotion.thinking,
    ),
    PactyMessage(
      message: "Your friends are waiting! Let's keep the pact going.",
      emotion: PactyEmotion.determined,
    ),
  ];

  // Profile Messages
  static const List<PactyMessage> profile = [
    PactyMessage(
      message: "Look at all those achievements! You're a savings superstar! ⭐",
      emotion: PactyEmotion.celebrating,
    ),
    PactyMessage(
      message: "Your saving streak is impressive! Keep it up!",
      emotion: PactyEmotion.happy,
    ),
  ];

  // Settings Messages
  static const List<PactyMessage> settings = [
    PactyMessage(
      message: "Customize your experience! I'm here to help you succeed.",
      emotion: PactyEmotion.thinking,
    ),
  ];

  // Error/Encouragement Messages
  static const List<PactyMessage> encouragement = [
    PactyMessage(
      message: "Oops! That didn't work. But don't worry, let's try again!",
      emotion: PactyEmotion.thinking,
    ),
    PactyMessage(
      message: "Every expert was once a beginner. You've got this!",
      emotion: PactyEmotion.determined,
    ),
  ];

  // Token Messages
  static const List<PactyMessage> tokens = [
    PactyMessage(
      message: "Complete your goals, earn tokens, and unlock more together! 🪙",
      emotion: PactyEmotion.celebrating,
    ),
    PactyMessage(
      message: "Pact Tokens! The more you save, the more you earn!",
      emotion: PactyEmotion.happy,
    ),
  ];

  // Random motivational messages
  static const List<PactyMessage> motivational = [
    PactyMessage(
      message: "Small steps lead to big achievements! 🚀",
      emotion: PactyEmotion.determined,
    ),
    PactyMessage(
      message: "Together, we're unstoppable!",
      emotion: PactyEmotion.celebrating,
    ),
    PactyMessage(
      message: "Your future self will thank you!",
      emotion: PactyEmotion.happy,
    ),
  ];
}
