import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medret/models/user_model.dart';
import 'package:medret/views/elements/account_widget.dart';
import 'package:medret/views/elements/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditNamePatient extends StatefulWidget {
  const EditNamePatient({Key? key}) : super(key: key);

  @override
  State<EditNamePatient> createState() => _EditNamePatientState();
}

class _EditNamePatientState extends State<EditNamePatient> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameEditingController = TextEditingController();
  final TextEditingController lastNameEditingController = TextEditingController();

  final User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    final data = doc.data();
    if (data != null) {
      loggedInUser = UserModel.fromMap(data);
      if (mounted) {
        setState(() {
          firstNameEditingController.text = loggedInUser.firstName ?? '';
          lastNameEditingController.text = loggedInUser.lastName ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Name'),
        backgroundColor: mainAppColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('First Name', style: textFormTitleStyle),
              const SizedBox(height: 10),
              _buildFirstNameField(),
              const SizedBox(height: 15),
              Text('Last Name', style: textFormTitleStyle),
              const SizedBox(height: 10),
              _buildLastNameField(),
              const SizedBox(height: 30),
              _buildUpdateNameButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstNameField() => TextFormField(
        controller: firstNameEditingController,
        style: textFormInputStyle,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please Enter Your First Name!';
          if (value.length < 2) return 'First name must be at least 2 characters';
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

  Widget _buildLastNameField() => TextFormField(
        controller: lastNameEditingController,
        style: textFormInputStyle,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please Enter Your Last Name!';
          if (value.length < 2) return 'Last name must be at least 2 characters';
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

  Widget _buildUpdateNameButton() => Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(30),
        color: addButtonColor,
        child: MaterialButton(
          onPressed: updateName,
          child: const Text('UPDATE', style: TextStyle(color: Colors.white)),
        ),
      );

  Future<void> updateName() async {
    if (!_formKey.currentState!.validate()) return;

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    loggedInUser.firstName = firstNameEditingController.text;
    loggedInUser.lastName = lastNameEditingController.text;

    await firestore.collection("users").doc(user!.uid).update(loggedInUser.toMap());
    Fluttertoast.showToast(msg: "Name updated successfully!");

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AccountWidget()),
        (route) => false,
      );
    }
  }
}

class EditPasswordPatient extends StatefulWidget {
  const EditPasswordPatient({Key? key}) : super(key: key);

  @override
  State<EditPasswordPatient> createState() => _EditPasswordPatientState();
}

class _EditPasswordPatientState extends State<EditPasswordPatient> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordEditingController = TextEditingController();
  final TextEditingController confirmPasswordEditingController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Password'),
        backgroundColor: mainAppColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Password', style: textFormTitleStyle),
              const SizedBox(height: 10),
              _buildPasswordField(),
              const SizedBox(height: 15),
              Text('Confirm Password', style: textFormTitleStyle),
              const SizedBox(height: 10),
              _buildConfirmPasswordField(),
              const SizedBox(height: 30),
              _buildUpdatePasswordButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() => TextFormField(
        controller: passwordEditingController,
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter your password!';
          if (value.length < 6) return 'Password must be at least 6 characters';
          return null;
        },
        decoration: InputDecoration(
          hintText: 'Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

  Widget _buildConfirmPasswordField() => TextFormField(
        controller: confirmPasswordEditingController,
        obscureText: true,
        validator: (value) {
          if (value != passwordEditingController.text) return 'Passwords do not match';
          return null;
        },
        decoration: InputDecoration(
          hintText: 'Confirm Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

  Widget _buildUpdatePasswordButton() => Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(30),
        color: addButtonColor,
        child: MaterialButton(
          onPressed: updatePassword,
          child: const Text('UPDATE', style: TextStyle(color: Colors.white)),
        ),
      );

  Future<void> updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await user!.updatePassword(passwordEditingController.text);
      Fluttertoast.showToast(msg: "Password updated successfully!");
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? "An error occurred");
    }
  }
}
