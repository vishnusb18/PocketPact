import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/test_screen.dart';
import 'package:pocket_pact/screens/dashboard_screen.dart';
import 'package:pocket_pact/screens/create_pact_screen.dart';
import 'package:pocket_pact/screens/pact_detail_screen.dart';
import 'package:pocket_pact/screens/profile_screen.dart';
import 'package:pocket_pact/screens/settings_screen.dart';
import 'package:pocket_pact/screens/add_friends_screen.dart';
import 'package:pocket_pact/screens/link_bank_account_screen.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      initialRoute: '/dashboard',
      routes: {
        '/': (context) => const SplashScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/test': (context) => const TestScreen(),
        '/pact-detail': (context) => const PactDetailScreen(),
        '/create-pact': (context) => const CreatePactScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/add-friends': (context) => const AddFriendScreen(),
        '/auth': (context) => const AuthScreen(),
        '/link-bank-account': (context) => const LinkBankAccountScreen(),
      },
    );
  }
}
