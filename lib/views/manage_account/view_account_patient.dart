import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:medret/views/elements/app_theme.dart';
import 'package:medret/models/user_model.dart';
import 'package:medret/views/manage_registration/login_patient.dart';
import 'package:medret/views/manage_account/edit_account_patient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountPatient extends StatelessWidget {
  const AccountPatient({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('PROFILE'),
      backgroundColor: mainAppColor,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: mainAppColor),

    ),
    body: const ViewAccountPatient(),
  );
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
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
    final displayChangeTheme = Padding(
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
                      Icon(Icons.dark_mode_outlined, size: 40.0, color: Colors.blue[100]),
                      const SizedBox(width: 8.0),
              
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Text('Theme Mode', style: TextStyle(fontSize: 18.0),),              
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => const ChangeTheme())
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

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stack Container
            SizedBox(
              height: 300.0,
              child: Stack(
                children: <Widget>[
                  // Container(),
                  ClipPath(
                    clipper: MyCustomeClipper(),
                    child: Container(
                      height: 300.0,
                      // color: Colors.indigo,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage('https://c4.wallpaperflare.com/wallpaper/122/72/39/up-town-wallpaper-preview.jpg'),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                  ),
                  // Circular Profile Avatar
                  Align(
                    alignment: const Alignment(0, 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircularProfileAvatar(
                          '',
                          borderWidth: 4.0,
                          radius: 60.0,
                          child: Image.asset('assets/defaultpatientprofile.png'),
                        ),
      
                        const SizedBox(height: 3.0),

                        Align(                        
                          child: Text('${loggedInUser.username}', style: const TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),),
                        ),
                        // Display First Name + Second Name
                        // Display User Role
                        Text(loggedInUser.role, style: TextStyle(color: Colors.grey[700])),  
                      ],
                    ),
                  ),
                  // Top Bar
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ActionChip(
                            side: const BorderSide(color: Colors.white, width: 2),
                            shadowColor: Colors.black,
                            backgroundColor: Colors.white,
                            label: const Text('LOGOUT', style: TextStyle(fontWeight: FontWeight.bold)), 
                            onPressed: () {
                              logoutButton(context);
                            }
                          ),
                        ),
                      ],
                    )
                  ),
                  // Top Bar
                ],
              ),
            ), 

            // Card Item
            displayEmail,

            displayName,

            displayPassword,

            displayChangeTheme,

            const SizedBox(height: 100,),
          ],
        ),
      ), //Stack Container
    );
  }

  Future<void> logoutButton(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPatient()));
  }
}

class MyCustomeClipper extends CustomClipper<Path> {
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