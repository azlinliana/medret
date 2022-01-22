import 'package:flutter/material.dart';
import 'package:medret/views/elements/app_theme.dart';
import 'package:medret/views/elements/account_widget.dart';
import 'package:medret/views/manage_registration/register_patient.dart';
import 'package:medret/views/manage_registration/forget_password.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPatient extends StatefulWidget {
  const LoginPatient({ Key? key }) : super(key: key);

  @override
  _LoginPatientState createState() => _LoginPatientState();
}

class _LoginPatientState extends State<LoginPatient> {
  final _formKey = GlobalKey<FormState>();

 // Editing Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // Email Address Field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
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
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Email Address',
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )
      ),    
    );

    // Password Field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return('Please Enter Your Password!');
        }
        if (!regex.hasMatch(value)) {
          return('Please Enter a Valid Password (Minimum 6 characters)');
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Password',
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )
      ),          
    );

    // Login Button
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: mainAppColor,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
        child: const Text('LOGIN', style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: landingPageBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back_ios_new, color: mainAppColor),
        ),
      ),
      body: 
      Container(
        color: landingPageBackgroundColor,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding:const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      child: Title(color: const Color.fromRGBO(19, 15, 64,1.0), child: const Text('Welcome, Patient!', style: TextStyle(fontFamily: 'Dancing Script', fontSize: 25),)),
                    ),

                    SizedBox(
                      height: 200,
                      child: Image.asset('assets/authpatient.png', fit: BoxFit.contain,)
                    ),
                    const SizedBox(height: 45),

                    emailField,
                    const SizedBox(height: 25),

                    passwordField,
                    const SizedBox(height: 25),

                    loginButton,
                    const SizedBox(height: 10),

                    Row(
                      textDirection: TextDirection.rtl,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, 
                              MaterialPageRoute(builder: (context) => const ForgetPassword())
                            );
                          },
                          child: const Text('Forgot password?', style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline),),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Does not have an account? '),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, 
                              MaterialPageRoute(builder: (context) => const RegisterPatient())
                            );
                          },
                          child: const Text('Register Now!', style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold,),),
                        ),
                      ],
                    ),
                  ],
                )
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Login Function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth.signInWithEmailAndPassword(email: email, password: password).then((uid) => {
        Fluttertoast.showToast(msg: "Successfully Login"),
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AccountWidget()))
      })
      .catchError((e){
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}