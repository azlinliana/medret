import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medret/views/elements/app_theme.dart';

class HomePatient extends StatelessWidget {
  const HomePatient({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('MEDRET'),
      backgroundColor: mainAppColor,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: mainAppColor),
    ),
    body: const ViewHomePatient(),
  );
}

class ViewHomePatient extends StatefulWidget {
  const ViewHomePatient({ Key? key }) : super(key: key);

  @override
  _ViewHomePatientState createState() => _ViewHomePatientState();
}

class _ViewHomePatientState extends State<ViewHomePatient> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}