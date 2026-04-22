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
  sad,
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
  static const List<PactyMessage> splash = [
    PactyMessage(
      message: "Hi, I'm Pacty. I help you save with your people.",
      emotion: PactyEmotion.happy,
    ),
  ];

  static const List<PactyMessage> welcome = [
    PactyMessage(
      message: "Welcome to PocketPact. I'm here to help you save together.",
      emotion: PactyEmotion.happy,
    ),
    PactyMessage(
      message: "Your pocket. Your pact. Let's make saving feel doable.",
      emotion: PactyEmotion.celebrating,
    ),
  ];

  static const List<PactyMessage> dashboard = [
    PactyMessage(
      message: "Looking great. Your pacts are on track.",
      emotion: PactyEmotion.happy,
    ),
    PactyMessage(
      message: "You're 46% to your goal. Keep going.",
      emotion: PactyEmotion.determined,
    ),
    PactyMessage(
      message: "Nice work. You saved more this week.",
      emotion: PactyEmotion.celebrating,
    ),
  ];

  static const List<PactyMessage> createPact = [
    PactyMessage(
      message: "Let's lock in a new pact. What are we saving for?",
      emotion: PactyEmotion.locking,
    ),
    PactyMessage(
      message: "Great choice. Set your goal and I'll help you get there.",
      emotion: PactyEmotion.determined,
    ),
  ];

  static const List<PactyMessage> bankLinking = [
    PactyMessage(
      message: "Link your bank to track your money automatically.",
      emotion: PactyEmotion.tracking,
    ),
    PactyMessage(
      message: "Your bank connection stays protected while I track progress.",
      emotion: PactyEmotion.locking,
    ),
  ];

  static const List<PactyMessage> saving = [
    PactyMessage(
      message: "Every contribution counts. Keep going.",
      emotion: PactyEmotion.saving,
    ),
    PactyMessage(
      message: "You're doing well. Your goal is getting closer.",
      emotion: PactyEmotion.determined,
    ),
  ];

  static const List<PactyMessage> goalAchieved = [
    PactyMessage(
      message: "You did it. Goal achieved.",
      emotion: PactyEmotion.goalAchieved,
    ),
    PactyMessage(
      message: "Amazing work. Ready to set a new goal?",
      emotion: PactyEmotion.celebrating,
    ),
  ];

  static const List<PactyMessage> splitting = [
    PactyMessage(
      message: "Time to split the bill. Everyone pays their fair share.",
      emotion: PactyEmotion.splitting,
    ),
    PactyMessage(
      message: "Splitting made easy. No awkward money talks needed.",
      emotion: PactyEmotion.happy,
    ),
  ];

  static const List<PactyMessage> reminder = [
    PactyMessage(
      message: "Your contribution is due soon.",
      emotion: PactyEmotion.thinking,
    ),
    PactyMessage(
      message: "Your friends are waiting. Let's keep the pact going.",
      emotion: PactyEmotion.determined,
    ),
  ];

  static const List<PactyMessage> profile = [
    PactyMessage(
      message: "Look at those achievements. Your streak is building.",
      emotion: PactyEmotion.celebrating,
    ),
    PactyMessage(
      message: "Your saving streak is impressive. Keep it up.",
      emotion: PactyEmotion.happy,
    ),
  ];

  static const List<PactyMessage> settings = [
    PactyMessage(
      message: "Customize your experience. I'm here to help you succeed.",
      emotion: PactyEmotion.thinking,
    ),
  ];

  static const List<PactyMessage> encouragement = [
    PactyMessage(
      message: "That did not work, but we can try again.",
      emotion: PactyEmotion.thinking,
    ),
    PactyMessage(
      message: "Every expert was once a beginner. You've got this.",
      emotion: PactyEmotion.determined,
    ),
  ];

  static const List<PactyMessage> tokens = [
    PactyMessage(
      message: "Complete goals, earn tokens, and unlock more together.",
      emotion: PactyEmotion.celebrating,
    ),
    PactyMessage(
      message: "Pact Tokens reward the progress you make together.",
      emotion: PactyEmotion.happy,
    ),
  ];

  static const List<PactyMessage> motivational = [
    PactyMessage(
      message: "Small steps lead to big achievements.",
      emotion: PactyEmotion.determined,
    ),
    PactyMessage(
      message: "Together, you can keep the pact moving.",
      emotion: PactyEmotion.celebrating,
    ),
    PactyMessage(
      message: "Your future self will thank you.",
      emotion: PactyEmotion.happy,
    ),
  ];
}
