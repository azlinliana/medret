import 'package:flutter/material.dart';
import 'package:medret/views/elements/app_theme.dart';
import 'package:medret/views/manage_registration/login_patient.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MedretApp());
}

class MedretApp extends StatelessWidget {
  const MedretApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      title: 'Medication Reminder and Tracker Application',
      home: const LandingPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/LandingPage': (context) => const LandingPage(),
      },
      onGenerateRoute: _getRoute,
    );
  }
  Route<dynamic>? _getRoute(RouteSettings settings) {
    if(settings.name != '/LandingPage') {
      return null;
    }
    return MaterialPageRoute<void>(
      builder: (BuildContext context) => const LandingPage(),
      settings: settings,
      fullscreenDialog: true,
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({ Key? key }) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: landingPageBackgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: Image.asset('assets/landingpage.png'),
            ),
            Title(color: const Color.fromRGBO(19, 15, 64, 1.0), child: const Text('MEDRET', style: TextStyle(fontSize: 36),),),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: const Text('An app that helps you to organize and keep track your medication intake', style: TextStyle(fontSize: 18, color: Colors.black),textAlign: TextAlign.justify,),
            ),
            SizedBox(
              width: 280,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(30),
                color: mainAppColor,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => const LoginPatient())
                    );
                  },
                  child: const Text('CONTINUE TO THE APP', style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
