# Pacty Mascot Integration Guide 🤖

Welcome to the Pacty Mascot System! This guide shows you how to use Pacty (your friendly savings mascot) throughout the PocketPact app, Duolingo-style.

## 📁 Files Created

1. **`lib/utils/pacty_messages.dart`** - All contextual messages and emotions
2. **`lib/widgets/common/pacty_helper.dart`** - Reusable mascot widgets
3. **Updated `lib/screens/splash_screen.dart`** - Pacty appears on app launch
4. **Updated `lib/screens/dashboard_screen.dart`** - Example integration
5. **Updated `lib/screens/link_bank_account_screen.dart`** - Example integration

## 🎨 Pacty Components

### 1. PactyHelper (Full Widget)
Use this for prominent mascot appearances with speech bubbles.

```dart
import 'package:pocket_pact/widgets/common/pacty_helper.dart';
import 'package:pocket_pact/utils/pacty_messages.dart';

PactyHelper(
  message: PactyMessages.welcome[0],
  mascotSize: 120,
  showBubble: true,
  animate: true,
)
```

**Props:**
- `message`: PactyMessage object with text and emotion
- `mascotSize`: Size of Pacty image (default 120)
- `showBubble`: Show speech bubble (default true)
- `animate`: Bounce animation on appear (default true)
- `padding`: Custom padding

### 2. PactyHelperCompact
Use this for compact, inline helper messages (perfect for card layouts).

```dart
PactyHelperCompact(
  message: "Great job! You're on track! 🎯",
  onTap: () {
    // Optional action when tapped
  },
)
```

**Props:**
- `message`: String message to display
- `onTap`: Optional callback when tapped

### 3. PactyHelperFloating
Use this for temporary floating messages that appear over content.

```dart
Stack(
  children: [
    // Your main content
    YourContent(),
    
    // Floating Pacty
    PactyHelperFloating(
      message: PactyMessages.saving[0],
      onDismiss: () {
        // Handle dismiss
      },
    ),
  ],
)
```

## 💬 Message Categories

Pacty has contextual messages for different situations:

### Available Message Categories:
- `PactyMessages.splash` - App launch
- `PactyMessages.welcome` - First-time users
- `PactyMessages.dashboard` - Home screen
- `PactyMessages.createPact` - Creating new pacts
- `PactyMessages.bankLinking` - Bank connection
- `PactyMessages.saving` - Progress updates
- `PactyMessages.goalAchieved` - Celebrations
- `PactyMessages.splitting` - Bill splitting
- `PactyMessages.reminder` - Reminders
- `PactyMessages.profile` - User profile
- `PactyMessages.settings` - Settings screen
- `PactyMessages.encouragement` - Error recovery
- `PactyMessages.tokens` - Pact tokens
- `PactyMessages.motivational` - General motivation

### Using Messages:

```dart
// Single message
PactyHelper(
  message: PactyMessages.goalAchieved[0],
)

// Random message from category
import 'dart:math';

final randomMsg = PactyMessages.dashboard[
  Random().nextInt(PactyMessages.dashboard.length)
];

PactyHelperCompact(message: randomMsg.message)
```

## 🎭 Pacty Emotions

Different emotions for different contexts (for future expansion):

```dart
enum PactyEmotion {
  happy,          // General positive
  thinking,       // Considering/processing
  celebrating,    // Major achievement
  determined,     // Focused/motivated
  tracking,       // Monitoring progress
  splitting,      // Bill splitting
  locking,        // Securing pacts
  saving,         // Saving money
  goalAchieved,   // Goal completed
}
```

## 📖 Usage Examples

### Example 1: Dashboard Welcome
```dart
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PactyHelperCompact(
          message: "Looking great! Your pacts are on track! 🎯",
        ),
        // ... rest of dashboard
      ],
    );
  }
}
```

### Example 2: Goal Achievement Modal
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    content: PactyHelper(
      message: PactyMessages.goalAchieved[0],
      mascotSize: 150,
    ),
  ),
);
```

### Example 3: Custom Message
```dart
const customMessage = PactyMessage(
  message: "You've saved \$500 this month! Amazing! 🎉",
  emotion: PactyEmotion.celebrating,
);

PactyHelper(message: customMessage)
```

### Example 4: Interactive Message with Action
```dart
const messageWithAction = PactyMessage(
  message: "Ready to create your first pact?",
  emotion: PactyEmotion.determined,
  actionText: "Let's Go!",
  onAction: () {
    Navigator.pushNamed(context, '/create-pact');
  },
);

PactyHelper(message: messageWithAction)
```

## 🎬 Implementation Examples in App

### ✅ Splash Screen
Pacty appears with bounce animation introducing the app.

### ✅ Dashboard
Compact helper shows random motivational messages.

### ✅ Bank Linking
Reassures users about security when linking bank accounts.

## 💡 Best Practices

1. **Use Compact for Cards/Lists**: PactyHelperCompact works great in tight spaces
2. **Use Full Widget for Emphasis**: Use PactyHelper for important messages
3. **Match Context to Message**: Use appropriate message categories
4. **Don't Overuse**: Pacty should enhance, not overwhelm
5. **Consider Animation**: Set `animate: false` for static contexts

## 🚀 Adding Pacty to New Screens

1. Import the required files:
```dart
import 'package:pocket_pact/widgets/common/pacty_helper.dart';
import 'package:pocket_pact/utils/pacty_messages.dart';
```

2. Choose the right variant (Full, Compact, or Floating)

3. Pick appropriate message category

4. Add to your widget tree

Example:
```dart
Column(
  children: [
    PactyHelperCompact(
      message: PactyMessages.createPact[0].message,
    ),
    // Your screen content
  ],
)
```

## 🎨 Customization

### Custom Colors (if needed)
Pacty uses app colors from `lib/theme/colors.dart`:
- Primary Purple: Speech bubble borders
- Background White: Speech bubble background

### Custom Sizes
```dart
PactyHelper(
  message: myMessage,
  mascotSize: 80,  // Smaller
)

PactyHelper(
  message: myMessage,
  mascotSize: 200,  // Larger
)
```

## 📝 Adding New Messages

To add new messages, edit `lib/utils/pacty_messages.dart`:

```dart
class PactyMessages {
  // Add new category
  static const List<PactyMessage> yourNewCategory = [
    PactyMessage(
      message: "Your helpful message here!",
      emotion: PactyEmotion.happy,
    ),
    // Add more variations
  ];
}
```

## 🎯 Where to Use Pacty

**Great Places:**
- ✅ Onboarding flows
- ✅ Achievement celebrations
- ✅ Empty states
- ✅ Error recovery
- ✅ Tips and tutorials
- ✅ Milestones
- ✅ Security reassurance

**Avoid:**
- ❌ Every single screen (too much)
- ❌ Error messages (use for encouragement after)
- ❌ Forms (distracting)
- ❌ Critical actions (stays neutral)

## 🔮 Future Enhancements

Ideas for expanding Pacty:

1. **Animated Emotions**: Different mascot images for different emotions
2. **Sound Effects**: Optional sounds when Pacty appears
3. **Gesture Interactions**: Tap Pacty for random tips
4. **Achievement Tracking**: Pacty celebrates milestones
5. **Personalization**: Remember user preferences for message frequency
6. **Story Mode**: Pacty guides users through complex flows

## 📞 Questions?

Check the implementation in:
- [splash_screen.dart](lib/screens/splash_screen.dart)
- [dashboard_screen.dart](lib/screens/dashboard_screen.dart)
- [link_bank_account_screen.dart](lib/screens/link_bank_account_screen.dart)

Happy coding with Pacty! 🎉
