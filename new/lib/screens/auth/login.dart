import 'package:flutter/material.dart';
import 'package:medret/screens/auth/forget_password.dart';
import 'package:medret/screens/auth/register.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 60,
            child: Title(
              color: const Color.fromRGBO(19, 15, 64, 1.0),
              child: const Text(
                'Welcome, Patient!',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          SizedBox(
            width: 300,
            child: Image.asset('assets/login.png'),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
            ),
          ),
          Row(
            textDirection: TextDirection.rtl,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgetPasswordPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('Forget password?'),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('LOGIN'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Does not have an account? '),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage())
                  );
                },
                child: const Text('Register Now!'),
              ),
            ],
          ),
        ],
      )
    );
  }
}