import 'package:flutter/material.dart';
import 'package:medret/views/elements/app_theme.dart';
import 'package:medret/views/manage_registration/login_patient.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  ForgetPasswordState createState() => ForgetPasswordState();
}

class ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Widget emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please Enter Your Email!';
        }
        if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+").hasMatch(value)) {
          return 'Please Enter a Valid Email';
        }
        return null;
      },
      onSaved: (value) {
        if (value != null) {
          emailEditingController.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Email Address',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final Widget verificationButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.purple,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          if (!_formKey.currentState!.validate()) return;

          try {
            await FirebaseAuth.instance.sendPasswordResetEmail(
              email: emailEditingController.text.trim(),
            );

            // ✅ Guard only context-dependent operations
            if (!context.mounted) return;

            Fluttertoast.showToast(msg: 'Please check your email');

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPatient()),
            );
          } on FirebaseAuthException catch (e) {
            if (!context.mounted) return;
            Fluttertoast.showToast(msg: e.message ?? 'Error occurred');
          }
        },
        child: const Text(
          'RESET PASSWORD',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: landingPageBackgroundColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.purple),
          ),
        ),
        body: Container(
          color: landingPageBackgroundColor,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 200,
                        child: Image.asset(
                          'assets/forgotpassword.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(
                        height: 30,
                        child: Text(
                          'Forget Password',
                          style: TextStyle(
                            fontFamily: 'Dancing Script',
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(
                        height: 40,
                        child: Text(
                          'Enter your email address below to reset password',
                        ),
                      ),
                      emailField,
                      const SizedBox(height: 25),
                      verificationButton,
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
