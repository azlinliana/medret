import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
// import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medret/views/elements/account_widget.dart';
import 'package:medret/views/elements/app_theme.dart';
import 'package:medret/models/user_model.dart';
import 'package:medret/views/manage_registration/login_patient.dart';
import 'package:medret/views/manage_account/edit_account_patient.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AccountPatient extends StatefulWidget {
  const AccountPatient({ Key? key }) : super(key: key);

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
        onPressed: () {
        },
        icon: const Icon(Icons.delete_outline),
      ),
      actions: [IconButton(
        icon: const Icon(Icons.logout_outlined), 
        onPressed: () {
          logoutButton(context);
        },
      )],
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: mainAppColor),
    ),
    body: const ViewAccountPatient(),
  );
}

// Delete Account
// Future<void> deleteAccountButton(BuildContext context) async {
//   User? user = FirebaseAuth.instance.currentUser;
//   UserModel loggedInUser = UserModel();
//   await FirebaseAuth.instance.currentUser.delete();
// }
// Signout from the account function
Future<void> logoutButton(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPatient()));
}


class ViewAccountPatient extends StatefulWidget {
  const ViewAccountPatient({ Key? key }) : super(key: key);

  @override
  _ViewAccountPatientState createState() => _ViewAccountPatientState();
}

class _ViewAccountPatientState extends State<ViewAccountPatient> {
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
      usernameEditingController.text = loggedInUser.username!;
      avatarUrl = loggedInUser.avatarUrl!;
      setState(() {});
    });
  }
  
  
  final _formKey = GlobalKey<FormState>();

  final usernameEditingController = TextEditingController();

  bool darkModeStatus = false;

  File? profilePicture;

  String? avatarUrl;

  // Get the image from the gallery
  Future getImageAvatar() async {
    var imageAvatar = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      profilePicture = File(imageAvatar!.path);
      uploadImageAvatar();
    });
  }
  
  final _auth = FirebaseAuth.instance;

  uploadImageAvatar() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    loggedInUser.email = loggedInUser.email!;
    loggedInUser.firstName = loggedInUser.firstName!;
    loggedInUser.lastName = loggedInUser.lastName!;

    var storageImage = FirebaseStorage.instance.ref().child(profilePicture!.path);
    var task = storageImage.putFile(profilePicture!);
    avatarUrl = await(await task.whenComplete(() => null)).ref.getDownloadURL();
    // Call Firestore
    // Call UserModel
    // Send the Value to the Firestore

    // Write All the Values
    userModel.uid = user!.uid;
    userModel.avatarUrl = avatarUrl.toString();

    await firebaseFirestore
      .collection("users")
      .doc(user.uid)
      .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Profile Picture uploaded successfully!");

    Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => const AccountWidget()), (route) => false);
  }
  
  @override
  Widget build(BuildContext context) {
    final usernameField = TextFormField(
      autofocus: false,
      controller: usernameEditingController,
      style: textFormInputStyle,
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
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final cancelButton = Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(30),
      color: Colors.red.shade200,
      child: MaterialButton(
        onPressed: () {
          Navigator.of(context,rootNavigator: true).pop();
        },
        child: const Text('CANCEL', style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)

      ),
    );

    final updateUsernameButton = Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(30),
      color: addButtonColor,
      child: MaterialButton(
        onPressed: () {
          updateUsername();
        },
        child: const Text('UPDATE', style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)

      ),
    );

    // Display Email
    final displayEmail = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 21.0),
          child: 
          Material(
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.email_outlined, size: 40.0, color: Colors.blue[100]),
                const SizedBox(width: 8.0),
          
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Email', style: TextStyle(fontSize: 17.0)),
                    const SizedBox(height: 10.0),
          
                    Text('${loggedInUser.email}', style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );

    // Display First Name + Last Name
    final displayName = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 21.0),
          child: Material(
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.account_box_outlined, size: 42.0, color: Colors.blue[100]),
                    const SizedBox(width: 8.0),
          
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text('Name', style: TextStyle(fontSize: 16.0)),
          
                        const SizedBox(height: 10.0),
          
                        Text('${loggedInUser.firstName} ${loggedInUser.lastName}', style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),)
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => const EditNamePatient())
                    );
                  }, 
                  icon: Icon(Icons.keyboard_arrow_right_rounded, size: 40.0, color: Colors.blue[100]))
              ],
            ),
          ),
        ),
      ),
    );

    // Display Password
    final displayPassword = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AnimationLimiter(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 21.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Icon(Icons.vpn_key_outlined, size: 40.0, color: Colors.blue[100]),
                      const SizedBox(width: 8.0),
              
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Text('Change Password', style: TextStyle(fontSize: 18.0),),              
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => const EditPasswordPatient())
                      );
                    }, 
                   icon: Icon(Icons.keyboard_arrow_right_rounded, size: 40.0, color: Colors.blue[100])
                  )
                ],
              ),
            ),
          ),   
        ),
    );
    
    // Display Change Theme
    // final displayChangeTheme = Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //   child: AnimationLimiter(
    //       child: Card(
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 21.0),
    //           child: Row(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: <Widget>[
    //               Row(
    //                 children: [
    //                   Icon(Icons.dark_mode_outlined, size: 40.0, color: Colors.blue[100]),
    //                   const SizedBox(width: 8.0),
              
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: const <Widget>[
    //                       Text('Dark Mode', style: TextStyle(fontSize: 18.0),),              
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //               FlutterSwitch(
    //                 showOnOff: true,
    //                 activeColor: mainAppColor,
    //                 activeTextColor: Colors.white,
    //                 inactiveColor: Colors.blue.shade100,
    //                 inactiveTextColor: Colors.white,
    //                 value: darkModeStatus, 
    //                 onToggle: (value) {
    //                   setState(() {
    //                     darkModeStatus = value;
    //                   });
    //                 }
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),   
    //     ),
    // );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300.0,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: MyCustomClipper(),
                    child: Container(
                      height: 300.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(image: NetworkImage('https://c4.wallpaperflare.com/wallpaper/122/72/39/up-town-wallpaper-preview.jpg'),
                        fit: BoxFit.cover
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          child: 
                          Stack(
                            children: [
                              CircularProfileAvatar(
                              '',
                              borderWidth: 4.0,
                              radius: 60.0,
                              // child: Image.asset('assets/defaultpatientprofile.png'),
                              child: profilePicture != null ? Image.file(profilePicture!, fit: BoxFit.fill,) : Image.asset('assets/defaultpatientprofile.png', fit: BoxFit.fill,),
                              ),
                              Positioned(
                                right: -5,
                                bottom: 5,
                                child: IconButton(
                                    onPressed: () {
                                      getImageAvatar();
                                    }, 
                                    icon: const Icon(Icons.camera_alt_rounded, size: 30, color: Colors.black,),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {}, 
                            icon: const Icon(Icons.camera_alt_rounded, size: 30, color: Colors.black,),
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              ), 
            ),
            Align(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text('${loggedInUser.username}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 100, 0),
                      child: IconButton(
                        onPressed: () {
                          showAnimatedDialog(
                            barrierDismissible: true,
                            context: context, 
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Edit Username'),
                                content: Form(
                                  key: _formKey, 
                                  child: usernameField,
                                ),
                                actions: [
                                  cancelButton,
                                  updateUsernameButton,
                                ],
                              );
                            }
                          );
                        }, 
                        icon: const Icon(Icons.edit, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(loggedInUser.role, style: TextStyle(color: Colors.grey[700])),                  
            const SizedBox(height: 20,),
            // Card
            displayEmail,
            displayName,
            displayPassword,
            // displayChangeTheme,

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Future<void> logoutButton(BuildContext context) async {
  //   await FirebaseAuth.instance.signOut();
  //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPatient()));
  // }

  updateUsername() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    loggedInUser.username = usernameEditingController.text;

    await firebaseFirestore
      .collection("users")
      .doc(user!.uid)
      .update(loggedInUser.toMap());
    Fluttertoast.showToast(msg: "Username edited successfully");

    Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => const AccountWidget()), (route) => false);
  }

  cancelButton() {}
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
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}