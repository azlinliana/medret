import 'package:flutter/material.dart';
import 'package:medret/views/elements/app_theme.dart';
import 'package:medret/views/elements/account_widget.dart';
import 'package:medret/views/manage_registration/login_patient.dart';
import 'package:medret/models/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPatient extends StatefulWidget {
  const RegisterPatient({ Key? key }) : super(key: key);

  @override
  _RegisterPatientState createState() => _RegisterPatientState();
}

class _RegisterPatientState extends State<RegisterPatient> {
  final _formKey = GlobalKey<FormState>();
  
  final firstNameEditingController = TextEditingController();
  final lastNameEditingController = TextEditingController();
  final usernameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController  = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // First Name Field
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      validator: (value) {
        RegExp regex = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return('Please Enter Your First Name!');
        }
        if (!regex.hasMatch(value)) {
          return('Please Enter a Valid Name (Minimum 2 characters)');
        }
        return null;
        },
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'First Name',
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),        
    );

    // Last Name Field
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameEditingController,
      validator: (value) {
        if (value!.isEmpty) {
          return('Please Enter Your Second Name!');
        }
        return null;
      },
      onSaved: (value) {
        lastNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Last Name',
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),        
    );

    // Username Field
    final usernameField = TextFormField(
      autofocus: false,
      controller: usernameEditingController,
      validator: (value) {
        RegExp regex = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return('Please Enter Your Username!');
        }
        if (!regex.hasMatch(value)) {
          return('Please Enter a Valid Username (Minimum 2 characters)');
        }
        return null;
      },
      onSaved: (value) {
        usernameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_box),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Username',
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),        
    );

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
        prefixIcon: const Icon(Icons.email),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Email Address',
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),        
    );

    // Password Field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
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
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Password',
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),        
    );

    // Confirm Password Field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (confirmPasswordEditingController.text != passwordEditingController.text) {
          return('Password does not match');
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Confirm Password',
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),        
    );

    // Register Button
    final registerButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.indigo,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailEditingController.text, passwordEditingController.text);
        },
        child: const Text('REGISTER', style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)
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
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                      child: Title(color: const Color.fromRGBO(19, 15, 64,1.0), child: const Text('Lets join our community!', style: TextStyle(fontFamily: 'Dancing Script', fontSize: 25),)),
                    ),
                    SizedBox(
                      height: 200,
                      child: Image.asset('assets/registerpatient.png', fit: BoxFit.contain,)
                    ),
                    const SizedBox(height: 45),

                    firstNameField,
                    const SizedBox(height: 25),

                    lastNameField,
                    const SizedBox(height: 25),

                    usernameField,
                    const SizedBox(height: 25),

                    emailField,
                    const SizedBox(height: 25),

                    passwordField,
                    const SizedBox(height: 25),

                    confirmPasswordField,
                    const SizedBox(height: 25),

                    registerButton,
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Already have an account? Back to '),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, 
                              MaterialPageRoute(builder: (context) => const LoginPatient())
                            );
                          },
                          child: const Text(
                            'Login Page!', style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  // Register function
  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
      .then((value) => {
        addUser()
      }).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  addUser() async {
    // Call Firestore
    // Call UserModel
    // Send the Value to the Firestore

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // Write All the Values
    userModel.uid = user!.uid;
    userModel.email = user.email;
    userModel.firstName = firstNameEditingController.text;
    userModel.lastName = lastNameEditingController.text;
    userModel.username = usernameEditingController.text;
    userModel.firstName = firstNameEditingController.text;

    await firebaseFirestore
      .collection("users")
      .doc(user.uid)
      .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully!");

    Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => const AccountWidget()), (route) => false);
  }
}
