import 'package:flutter/material.dart';
import 'package:medret/views/elements/app_theme.dart';
import 'package:medret/views/manage_registration/login_patient.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({ Key? key }) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>(); 

  final emailEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
        // Email Address Field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator:(value) {
        if (value!.isEmpty) {
          return('Please Enter Your Email!');
        }
        // Reg Expression for Email Validator
        if (!RegExp("^[a-zA-Z0-9+_.-]+.[a-z]").hasMatch(value)) {
          return('Please Enter a Valid Email');
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Email Address',
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )
      ),        
    );
    // Send Verification Button
    final verficationButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.purple,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          FirebaseAuth.instance.sendPasswordResetEmail(email: emailEditingController.text)
          .then((value) => {
            Fluttertoast.showToast(msg: 'Please check your email'),
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginPatient())
            )
          }
          );
        },
        child: const Text('RESET PASSWORD', style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
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
        body: 
        Container(
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
                        child: Image.asset('assets/forgotpassword.png', fit: BoxFit.contain,)
                      ),
                      const SizedBox(height: 10),
    
                      SizedBox(
                        height: 30,
                        child: Title(color: const Color.fromRGBO(19, 15, 64,1.0), child: const Text('Forget Password', style: TextStyle(fontFamily: 'Dancing Script', fontSize: 20),)),
                      ),
                      const SizedBox(height: 10),
    
                      const SizedBox(
                        height: 40,
                        child: Text('Enter your email address below to reset password'),                    
                      ),
    
                      emailField,
                      const SizedBox(height: 25),
    
                      verficationButton,
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