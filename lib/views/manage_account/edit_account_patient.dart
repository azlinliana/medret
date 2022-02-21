
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medret/models/user_model.dart';
import 'package:medret/views/elements/account_widget.dart';
import 'package:medret/views/elements/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditNamePatient extends StatefulWidget {
  const EditNamePatient({ Key? key }) : super(key: key);

  @override
  _EditNamePatientState createState() => _EditNamePatientState();
}

class _EditNamePatientState extends State<EditNamePatient> {
  final _formKey = GlobalKey<FormState>();

  final firstNameEditingController = TextEditingController();
  final lastNameEditingController = TextEditingController();

  // User Model Class
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
    .collection('users')
    .doc(user!.uid)
    .get()
    .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      firstNameEditingController.text = loggedInUser.firstName!;
      lastNameEditingController.text = loggedInUser.lastName!;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // First Name Field
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      style: textFormInputStyle,
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
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ), 
    );

    // Last Name Field
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameEditingController,
      style: textFormInputStyle,
      validator: (value) {
        RegExp regex = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return('Please Enter Your Last Name!');
        }
        if (!regex.hasMatch(value)) {
          return('Please Enter a Valid Name (Minimum 2 characters)');
        }
        return null;
      },
      onSaved: (value) {
        lastNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ), 
    );

    final updateNameButton = Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(30),
      color: addButtonColor,
      child: MaterialButton(
        onPressed: () {
          updateName();
        },
        child: const Text('UPDATE', style: TextStyle(color: Colors.white),textAlign: TextAlign.center),
      ),
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Name'),
          backgroundColor: mainAppColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('First Name', style: textFormTitleStyle),
                    const SizedBox(height: 10),
                    firstNameField,
                    const SizedBox(height: 15),

                    Text('Last Name', style: textFormTitleStyle),
                    const SizedBox(height: 10),
                    lastNameField,
                    const SizedBox(height: 30),

                    updateNameButton,
                  ],
                )
              ),
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  updateName () async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    loggedInUser.firstName = firstNameEditingController.text;
    loggedInUser.lastName = lastNameEditingController.text;

    await firebaseFirestore
      .collection("users")
      .doc(user!.uid)
      .update(loggedInUser.toMap());
    Fluttertoast.showToast(msg: "Name edited successfully!");

    Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => const AccountWidget()), (route) => false);


  }
}

class EditPasswordPatient extends StatefulWidget {
  const EditPasswordPatient({ Key? key }) : super(key: key);

  @override
  _EditPasswordPatientState createState() => _EditPasswordPatientState();
}

class _EditPasswordPatientState extends State<EditPasswordPatient> {
  final _formKey = GlobalKey<FormState>();

  final passwordEditingController  = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();
  
  // User Model Class
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Confirm Password',
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),        
    );
    
    final updatePasswordButton = Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(30),
      color: addButtonColor,
      child: MaterialButton(
        onPressed: () {
          updatePassword();
        },
        child: const Text('UPDATE', style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)

      ),
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Password'),
          backgroundColor: mainAppColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Password', style: textFormTitleStyle),
                    const SizedBox(height: 10),
                    passwordField,
                    const SizedBox(height: 15),

                    Text('Confirm Password', style: textFormTitleStyle),
                    const SizedBox(height: 10),
                    confirmPasswordField,
                    const SizedBox(height: 30),

                    updatePasswordButton,
                  ],
                )
              ),
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  updatePassword () async{
    if (_formKey.currentState!.validate()) {
      await user!.updatePassword(passwordEditingController.text)
        .then((value){Fluttertoast.showToast(msg: "Password edited successfully!");})
        .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
    }

    // Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => const AccountWidget()), (route) => false);
  }
}