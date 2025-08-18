import 'package:flutter/material.dart';
import 'screens/Welcome_Screen.dart';

import 'navigation/bottom_nav_bar.dart';

import 'profile/about_us.dart';
import 'profile/chat_support.dart';
import 'profile/privacy.dart';
import 'profile/terms.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MarketPlace',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Helvetica',
        useMaterial3: true, // Enable Material 3 for modern design
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),

        '/home': (context) => const BottomNavBar(),
        '/about_us': (context) => const AboutUsScreen(),
        '/chat_support': (context) => const ChatSupportScreen(),
        '/privacy': (context) => const PrivacyPolicyScreen(),
        '/terms': (context) => const TermsOfUseScreen(),
      },
    );
  }
}
