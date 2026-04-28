import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/test_screen.dart';
import 'screens/pacty_demo_screen.dart';
import 'package:pocket_pact/screens/dashboard_screen.dart';
import 'package:pocket_pact/screens/create_pact_screen.dart';
import 'package:pocket_pact/screens/pact_detail_screen.dart';
import 'package:pocket_pact/screens/profile_screen.dart';
import 'package:pocket_pact/screens/settings_screen.dart';
import 'package:pocket_pact/screens/financial_allocation_screen.dart';
import 'package:pocket_pact/screens/terms_policies_screen.dart';
import 'package:pocket_pact/screens/add_friends_screen.dart';
import 'package:pocket_pact/screens/link_bank_account_screen.dart';
import 'package:pocket_pact/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketPact',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/dashboard',
      routes: {
        '/': (context) => const SplashScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/test': (context) => const TestScreen(),
        '/pacty-demo': (context) => const PactyAnimationDemoScreen(),
        '/pact-detail': (context) => const PactDetailScreen(),
        '/create-pact': (context) => const CreatePactScreen(),
        '/financial-allocation': (context) => const FinancialAllocationScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/terms-policies': (context) => const TermsPoliciesScreen(),
        '/add-friends': (context) => const AddFriendScreen(),
        '/auth': (context) => const AuthScreen(),
        '/link-bank-account': (context) => const LinkBankAccountScreen(),
      },
    );
  }
}
