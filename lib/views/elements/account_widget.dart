import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:medret/views/manage_account/home_patient.dart';
import 'package:medret/views/manage_account/view_account_patient.dart';
import 'package:medret/views/manage_tracker/view_tracker.dart';
import 'package:medret/views/elements/app_theme.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget({ Key? key }) : super(key: key);

  @override
  _AccountWidgetState createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  final _bottomNavigationKey = GlobalKey<CurvedNavigationBarState>();

  // Displaying All the Pages when Tapping on Bottom Navigation Bar Icon
  final pages = [
    const AccountPatient(),
    const HomePatient(),
    const Tracker(),
  ];

  // Returning Index = 1 of Bottom Navigation Bar (Returning Home as the First Screen User will See after a Successful Login)
  int selectedIndex = 1; 

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.person, size: 30),
      const Icon(Icons.home, size: 30),
      const Icon(Icons.history, size: 30),
    ];

    return MaterialApp(
      home: Scaffold(
        extendBody: true,
        body: pages[selectedIndex],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: const IconThemeData(color: Colors.black),
          ), 
          child: CurvedNavigationBar(
            key: _bottomNavigationKey,
            backgroundColor: Colors.transparent,
            color: bottomNavigationBarColor,
            buttonBackgroundColor: bottomNavigationBarColor,
            height: 60,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 300),
            index: selectedIndex,
            items: items,
            onTap: (selectedIndex) => setState(() {
              this.selectedIndex = selectedIndex;
            }),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}