// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medret/models/user_model.dart';
import 'package:medret/views/elements/account_widget.dart';
import 'package:medret/views/elements/app_theme.dart';
import 'package:medret/views/manage_registration/login_patient.dart';

class AccountPatient extends StatefulWidget {
  const AccountPatient({Key? key}) : super(key: key);

  @override
  State<AccountPatient> createState() => _AccountPatientState();
}

class _AccountPatientState extends State<AccountPatient> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('PROFILE'),
          backgroundColor: mainAppColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_outline),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_outlined),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (!mounted) return;
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPatient()));
              },
            )
          ],
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: mainAppColor),
        ),
        body: const ViewAccountPatient(),
      );
}

class ViewAccountPatient extends StatefulWidget {
  const ViewAccountPatient({Key? key}) : super(key: key);

  @override
  ViewAccountPatientState createState() => ViewAccountPatientState();
}

class ViewAccountPatientState extends State<ViewAccountPatient> {
  final User? user = FirebaseAuth.instance.currentUser;
  late UserModel loggedInUser;
  final TextEditingController usernameEditingController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? profilePicture;
  String? avatarUrl;
  bool darkModeStatus = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    final data = doc.data();
    if (data != null) {
      loggedInUser = UserModel.fromMap(data);
      usernameEditingController.text = loggedInUser.username ?? '';
      avatarUrl = loggedInUser.avatarUrl;
      if (mounted) setState(() {});
    }
  }

  Future<void> getImageAvatar() async {
    final XFile? imageAvatar =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageAvatar != null) {
      profilePicture = File(imageAvatar.path);
      if (mounted) setState(() {});
      await uploadImageAvatar();
    }
  }

  Future<void> uploadImageAvatar() async {
    final firebaseFirestore = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || profilePicture == null) return;

    final ref = FirebaseStorage.instance
        .ref()
        .child('avatars')
        .child('${currentUser.uid}.jpg');
    final uploadTask = ref.putFile(profilePicture!);

    avatarUrl = await (await uploadTask).ref.getDownloadURL();
    loggedInUser.avatarUrl = avatarUrl;

    await firebaseFirestore
        .collection("users")
        .doc(currentUser.uid)
        .set(loggedInUser.toMap(), SetOptions(merge: true));

    Fluttertoast.showToast(msg: "Profile Picture uploaded successfully!");

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AccountWidget()),
      (route) => false,
    );
  }

  Future<void> updateUsername() async {
    final firebaseFirestore = FirebaseFirestore.instance;
    loggedInUser.username = usernameEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .update(loggedInUser.toMap());

    Fluttertoast.showToast(msg: "Username edited successfully");

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AccountWidget()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top banner with profile
            // Display name, username, email, etc.
            // Buttons to edit name/password/etc.
            // Button to open edit dialog with updateUsername()
            // Use the existing widgets you already built
          ],
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 150);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}