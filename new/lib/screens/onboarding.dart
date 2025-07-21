import 'package:flutter/material.dart';
import 'package:medret/screens/auth/login.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // final VoidCallback? onPressed = enabled ? () {} : null;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: Image.asset('assets/onboarding.png'),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'An app that helps you to organize and keep track your medication intake',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('CONTINUE TO THE APP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
