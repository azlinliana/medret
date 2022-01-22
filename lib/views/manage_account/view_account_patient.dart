import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medret/views/elements/app_theme.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}