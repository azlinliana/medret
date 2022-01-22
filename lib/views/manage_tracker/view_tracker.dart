import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medret/views/elements/app_theme.dart';

class Tracker extends StatelessWidget {
  const Tracker({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('TRACKER'),
      backgroundColor: mainAppColor,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: mainAppColor),

    ),
    body: const ViewTracker(),
  );
}

class ViewTracker extends StatefulWidget {
  const ViewTracker({ Key? key }) : super(key: key);

  @override
  _ViewTrackerState createState() => _ViewTrackerState();
}

class _ViewTrackerState extends State<ViewTracker> {
  @override
  Widget build(BuildContext context) {
    return Container(
    
    );
  }
}