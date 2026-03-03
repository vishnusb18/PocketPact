# Pocket Pact - Project Structure

## Overview
This document outlines the complete folder and file structure for the Pocket Pact Flutter mobile application. The structure follows Flutter best practices and is designed for a 3-4 person student development team.

## Project File Tree

```
pocket_pact/
├── lib/
│   ├── main.dart
│   │
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── auth_screen.dart
│   │   ├── dashboard_screen.dart
│   │   ├── create_pact_screen.dart
│   │   ├── pact_detail_screen.dart
│   │   ├── add_contribution_screen.dart
│   │   ├── profile_screen.dart
│   │   └── settings_screen.dart
│   │
│   ├── widgets/
│   │   ├── common/
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_text_field.dart
│   │   │   ├── loading_spinner.dart
│   │   │   └── error_message.dart
│   │   │
│   │   ├── pact/
│   │   │   ├── pact_card.dart
│   │   │   ├── progress_bar.dart
│   │   │   └── member_avatar.dart
│   │   │
│   │   └── dashboard/
│   │       ├── pact_list.dart
│   │       └── quick_stats.dart
│   │
│   ├── models/
│   │   ├── user.dart
│   │   ├── pact.dart
│   │   ├── contribution.dart
│   │   └── member.dart
│   │
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── pact_service.dart
│   │   ├── user_service.dart
│   │   ├── storage_service.dart
│   │   └── notification_service.dart
│   │
│   ├── utils/
│   │   ├── constants.dart
│   │   ├── validators.dart
│   │   ├── formatters.dart
│   │   └── navigation.dart
│   │
│   └── theme/
│       ├── app_theme.dart
│       ├── colors.dart
│       └── text_styles.dart
│
└── README.md
```

## Folder Explanations

### `/lib`
The main source directory containing all Dart code for the application.

### `/lib/screens/`
**Purpose:** Contains all full-page screens in the application.

**What goes here:**
- Complete screen/page widgets that represent a full view
- Each file represents one distinct screen in the app's navigation
- Screens compose smaller widgets and interact with services
- Handles state management for that specific screen

**Files:**
- `splash_screen.dart` - Initial loading screen with branding
- `auth_screen.dart` - Login and registration interface
- `dashboard_screen.dart` - Main home screen showing all pacts
- `create_pact_screen.dart` - Form for creating new savings pacts
- `pact_detail_screen.dart` - Detailed view of a specific pact
- `add_contribution_screen.dart` - Form to add money to a pact
- `profile_screen.dart` - User profile and statistics
- `settings_screen.dart` - App settings and preferences

### `/lib/widgets/`
**Purpose:** Reusable UI components that can be used across multiple screens.

**What goes here:**
- Small, focused UI components
- Stateless or stateful widgets that handle specific UI elements
- Organized into subfolders by feature area or usage pattern
- Should be generic enough to be reused

**Subfolders:**

#### `/lib/widgets/common/`
Generic, app-wide reusable components:
- `custom_button.dart` - Styled button widget with variants
- `custom_text_field.dart` - Styled input fields with validation
- `loading_spinner.dart` - Loading indicators
- `error_message.dart` - Error display widgets

#### `/lib/widgets/pact/`
Pact-specific reusable components:
- `pact_card.dart` - Preview card for a single pact
- `progress_bar.dart` - Visual savings progress indicator
- `member_avatar.dart` - Displays pact member information

#### `/lib/widgets/dashboard/`
Dashboard-specific components:
- `pact_list.dart` - Scrollable list of pact cards
- `quick_stats.dart` - Summary statistics widget

### `/lib/models/`
**Purpose:** Data structure definitions and business entities.

**What goes here:**
- Plain Dart classes representing core data entities
- JSON serialization/deserialization methods (toJson, fromJson)
- Data validation logic
- Computed properties based on the data

**Files:**
- `user.dart` - User profile data model
- `pact.dart` - Savings pact/goal model
- `contribution.dart` - Individual contribution record
- `member.dart` - Pact member information

### `/lib/services/`
**Purpose:** Business logic and data access layer.

**What goes here:**
- API calls and network communication (when backend is added)
- Local data storage operations
- Authentication logic
- Complex business logic that doesn't belong in widgets
- Singleton services or service classes

**Files:**
- `auth_service.dart` - User authentication and session management
- `pact_service.dart` - Pact CRUD operations and business logic
- `user_service.dart` - User data management
- `storage_service.dart` - Local data persistence (SharedPreferences/Hive)
- `notification_service.dart` - Push notification handling (future)

### `/lib/utils/`
**Purpose:** Helper functions and utilities used throughout the app.

**What goes here:**
- Pure functions that perform specific tasks
- Constants and configuration values
- Validation functions
- Formatting helpers
- Extensions on existing classes

**Files:**
- `constants.dart` - App-wide constants (colors, strings, configs)
- `validators.dart` - Input validation functions
- `formatters.dart` - Data formatting (currency, dates, percentages)
- `navigation.dart` - Navigation helper functions

### `/lib/theme/`
**Purpose:** Centralized styling and theming configuration.

**What goes here:**
- Theme data and configuration
- Color palette definitions
- Typography styles
- Custom theme extensions

**Files:**
- `app_theme.dart` - Overall theme configuration
- `colors.dart` - Color palette and definitions
- `text_styles.dart` - Typography styles and font configuration

### `main.dart`
**Purpose:** Application entry point.

**What it does:**
- Initializes the Flutter application
- Sets up the root widget (MaterialApp)
- Configures app-wide settings
- Defines navigation routes
- Applies theme configuration

## Development Workflow

### For a team of 3-4 developers:

1. **Define models first** - Agree on data structures as a team
2. **Build services** - Implement data management logic
3. **Create reusable widgets** - Build UI components that screens will use
4. **Develop screens independently** - Each team member can work on different screens
5. **Test incrementally** - Test components as they're built

### Division of Work Example:
- **Developer 1:** Authentication screens, auth service, user service
- **Developer 2:** Dashboard screen, pact widgets, dashboard widgets
- **Developer 3:** Create/detail pact screens, pact service
- **Developer 4:** Profile/settings screens, storage service, utilities

This structure minimizes merge conflicts by separating concerns into distinct files and folders.

## Notes

- **No backend yet:** Services currently use local storage only
- **No Plaid integration:** Payment integration will be added later
- **Scalable:** Structure supports adding new features easily
- **Testing:** Add corresponding test files as you build features
- **State Management:** Can add a state management solution (Provider, Riverpod, Bloc) when needed

## Next Steps

1. Set up Flutter project with `flutter create pocket_pact`
2. Create this folder structure
3. Add necessary dependencies in pubspec.yaml
4. Begin implementation starting with models
5. Set up version control and establish branching strategy
