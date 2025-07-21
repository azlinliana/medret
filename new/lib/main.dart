import 'package:flutter/material.dart';
import 'package:medret/screens/onboarding.dart';

void main() {
  runApp(const MedretApp());
}

class MedretApp extends StatelessWidget {
  const MedretApp({super.key});

  // This widget is the root of MEDRET application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medication Reminder and Tracker Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF003366),
          brightness: Brightness.light
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF003366),
          brightness: Brightness.dark
        ),
      ),
      themeMode: ThemeMode.system,
      home: const OnboardingPage(enabled: true,),
    );
  }
}
