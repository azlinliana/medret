import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 60,
            child: Title(
              color: const Color.fromRGBO(19, 15, 64, 1.0),
              child: const Text(
                'Forget Password',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          SizedBox(
            width: 300,
            child: Image.asset('assets/forget-password.png'),
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
            child: FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgetPasswordPage()),
                );
              },
              child: const Text('RESET PASSWORD'),
            ),
          ),
          
        ],
      )
    );
  }
}