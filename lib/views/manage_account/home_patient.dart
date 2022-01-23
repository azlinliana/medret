import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:medret/models/medication_model.dart';
import 'package:medret/views/elements/app_theme.dart';
import 'package:medret/views/manage_prescription/add_medication_patient.dart';
import 'package:medret/views/manage_reminder/notification_service.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  DateTime _selectedDate = DateTime.now();
  
  User? user = FirebaseAuth.instance.currentUser;

  late final NotificationService notificationHelper;

  @override
  void initState() {
    super.initState();
    notificationHelper = NotificationService();
    notificationHelper.initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _header(),
        _dateTimeline(),
        _viewMedicationList(),
        // const ViewMedicationList(),     
      ],
    );
  }

  _header() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMd().format(DateTime.now()), style: subHeadingStyle),
                Text('Today', style: headingStyle),
              ],
            ),
          ),
          Row(
            children: [
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(30),
                color: addButtonColor,
                child: MaterialButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMedicationPatient()));
                },
                  child: const Text('ADD MEDICATION',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _dateTimeline() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: mainAppColor,
        selectedTextColor: Colors.white,
        monthTextStyle: GoogleFonts.oswald(
          color: Colors.grey,
        ),
        dateTextStyle: GoogleFonts.oswald(
          color: Colors.grey,
        ),
        dayTextStyle: GoogleFonts.oswald(
          color: Colors.grey,
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }
  
  _viewMedicationList() {
    var futureBuilder = FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('medications').where('uid', isEqualTo: user!.uid).get(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          List<MedicationModel> medicationList = snapshot.data!.docs.map((e) => MedicationModel.fromMap(e)).toList();
          
          // Notification Service to give reminder
          for (var medication in medicationList) {
            DateTime date = DateFormat.jm().parse(medication.medicationTime.toString());
            var myTime = DateFormat("HH:mm").format(date);
            print("Something");

            notificationHelper.scheduledNotification(
              int.parse(myTime.toString().split(":")[0]),
              int.parse(myTime.toString().split(":")[1]),
              medication
            );
          }

          return Flexible(
            child: AnimationLimiter(
              child: ListView.builder(
                itemCount: medicationList.length,
                itemBuilder: (BuildContext context, int index) {
                  if(medicationList[index].medicationRepeat == 'Daily') {
                    return AnimationConfiguration.staggeredList(
                      position: index, 
                      duration: const Duration(milliseconds: 800),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {

                            },
                            onLongPress: () {
                            },
                            child: Container(
                              padding: const EdgeInsets.only(top: 5, right: 20, left: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: getColor(medicationList[index].medicationColor??0),
                              ),
                              height: 80,
                              margin: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(medicationList[index].medicationName!, style: headingStyleTwo),
                                        const SizedBox(height: 5),
                                        
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(medicationList[index].medicationSize!),
                                            Text(medicationList[index].medicationUnit!),
                                            const SizedBox(height: 5),
                                          ],
                                        ),
                                        Text('${medicationList[index].medicationIntake!} meals', style: subHeadingStyleThree),
                                      ],
                                    )
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_alarm, size: 20, color: Colors.white),
                                      Text(medicationList[index].medicationTime!, style: showTimeStyle),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10, right: 5),
                                        height: 60,
                                        width: 1.5,
                                        color: Colors.grey[200],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        child: RotatedBox(
                                          quarterTurns: 3,
                                          child: getMedicationStatus(medicationList[index].medicationIsCompleted),),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ),
                          )
                        ),
                      )
                    );
                  }
                  if(medicationList[index].medicationDate == DateFormat.yMd().format(_selectedDate)) {
                    return AnimationConfiguration.staggeredList(
                      position: index, 
                      duration: const Duration(milliseconds: 800),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {},
                            onLongPress: (){},
                            child: Container(
                              padding: const EdgeInsets.only(top: 5, right: 20, left: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: getColor(medicationList[index].medicationColor??0),
                              ),
                              height: 80,
                              margin: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(medicationList[index].medicationName!, style: headingStyleTwo),
                                        const SizedBox(height: 5),
                                        
                                        Row(
                                          children: [
                                            Text(medicationList[index].medicationSize!),
                                            Text(medicationList[index].medicationUnit!),
                                            const SizedBox(height: 5),
                                          ],
                                        ),
                                        Text('${medicationList[index].medicationIntake!} meals', style: subHeadingStyleThree),
                                      ],
                                    )
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_alarm, size: 20, color: Colors.white),
                                      Text(medicationList[index].medicationTime!, style: showTimeStyle),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10, right: 5),
                                        height: 60,
                                        width: 1.5,
                                        color: Colors.grey[200],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        child: RotatedBox(
                                          quarterTurns: 3,
                                          child: getMedicationStatus(medicationList[index].medicationIsCompleted),),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ),
                          )
                        ),
                      )
                    );
                  }
                  else {
                    return Container();
                  }
                }
              ),
            ),
          );
        }
        else if (snapshot.hasError) {
          return const Text("It's Error!");
        }
        else {
          return const CircularProgressIndicator(color: mainAppColor);
        }
      },
    );
    return futureBuilder;
  }
  
  getColor(int colorNumber) {
    switch (colorNumber) {
      case 0:
        return fillOne;
      case 1:
        return fillTwo;
      case 2:
        return fillThree;
      default:
        return fillOne;
    }
  }
    
  getMedicationStatus(int statusNumber) {
    switch (statusNumber) {
      case 0:
        return const Text('Unomplete', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white));
      case 1:
        return const Text('Complete', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white));
      default:
        return const Text('Uncomplete', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white));
    }
  }
}