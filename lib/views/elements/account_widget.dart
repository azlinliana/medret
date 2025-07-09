import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:medret/views/manage_account/home_patient.dart';
import 'package:medret/views/manage_account/view_account_patient.dart';
import 'package:medret/views/manage_tracker/view_tracker.dart';
import 'package:medret/views/elements/app_theme.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget({Key? key}) : super(key: key);

  @override
  AccountWidgetState createState() => AccountWidgetState(); // ✅ Now using public State class
}

class AccountWidgetState extends State<AccountWidget> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey<CurvedNavigationBarState>();

  // Pages to switch between
  final List<Widget> pages = [
    const AccountPatient(),
    const HomePatient(),
    const Tracker(),
  ];

  // Start with index 1 (Home)
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [
      const Icon(Icons.person, size: 30),
      const Icon(Icons.home, size: 30),
      const Icon(Icons.history, size: 30),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
            onTap: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
