
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medret/models/user_model.dart';
import 'package:medret/views/elements/app_theme.dart';
import 'package:medret/views/manage_account/view_account_patient.dart';
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
  final _auth = FirebaseAuth.instance;

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
        hintText: '${loggedInUser.firstName}',
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
        hintText: '${loggedInUser.lastName}',
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
        child: const Text('UPDATE', style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)

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
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();
    userModel.firstName = firstNameEditingController.text;
    userModel.lastName = lastNameEditingController.text;

    await firebaseFirestore
      .collection("users")
      .doc(user!.uid)
      .update(userModel.toMap());
    Fluttertoast.showToast(msg: "Name edited successfully!");

    Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => const ViewAccountPatient()), (route) => false);


  }
}