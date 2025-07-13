import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:medret/models/medication_model.dart';
import 'package:medret/views/elements/app_theme.dart';
import 'package:medret/views/manage_prescription/add_medication_patient.dart';
import 'package:medret/views/manage_prescription/edit_medication.dart';
import 'package:medret/views/manage_reminder/notification_service.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePatient extends StatelessWidget {
  const HomePatient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('MEDRET'),
          backgroundColor: mainAppColor,
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: mainAppColor),
        ),
        body: const ViewHomePatient(),
      );
}

class ViewHomePatient extends StatefulWidget {
  const ViewHomePatient({Key? key}) : super(key: key);

  @override
  ViewHomePatientState createState() => ViewHomePatientState();
}

class ViewHomePatientState extends State<ViewHomePatient> {
  DateTime _selectedDate = DateTime.now();
  User? user = FirebaseAuth.instance.currentUser;
  late final NotificationService notificationHelper;

  final TextEditingController medicationNameEditingController =
      TextEditingController();
  final TextEditingController medicationPurposeEditingController =
      TextEditingController();
  final TextEditingController medicationSizeEditingController =
      TextEditingController();
  final TextEditingController medicationNoteEditingController =
      TextEditingController();

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
      ],
    );
  }

  Widget _header() {
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
                Text(DateFormat.yMMMd().format(DateTime.now()),
                    style: subHeadingStyle),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AddMedicationPatient()));
                  },
                  child: const Text(
                    'ADD MEDICATION',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateTimeline() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: mainAppColor,
        selectedTextColor: Colors.white,
        monthTextStyle: GoogleFonts.oswald(color: Colors.grey),
        dateTextStyle: GoogleFonts.oswald(color: Colors.grey),
        dayTextStyle: GoogleFonts.oswald(color: Colors.grey),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  Widget _viewMedicationList() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('medications')
          .where('uid', isEqualTo: user!.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MedicationModel> medicationList = snapshot.data!.docs
              .map((doc) =>
                  MedicationModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          for (var medication in medicationList) {
            DateTime date =
                DateFormat.jm().parse(medication.medicationTime.toString());
            var myTime = DateFormat("HH:mm").format(date);

            notificationHelper.scheduledNotification(
              int.parse(myTime.split(":")[0]),
              int.parse(myTime.split(":")[1]),
              medication,
            );
          }

          return Flexible(
            child: AnimationLimiter(
              child: ListView.builder(
                itemCount: medicationList.length,
                itemBuilder: (BuildContext context, int index) {
                  final med = medicationList[index];

                  if (med.medicationRepeat == 'Daily' ||
                      med.medicationDate ==
                          DateFormat.yMd().format(_selectedDate)) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 800),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditMedicationPatient(
                                    medicationModel: med,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 5, right: 20, left: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: getColor(med.medicationColor ?? 0),
                              ),
                              height: 80,
                              margin: const EdgeInsets.only(
                                  right: 20, left: 20, bottom: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(med.medicationName ?? '',
                                            style: headingStyleTwo),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(med.medicationSize ?? ''),
                                            Text(med.medicationUnit ?? ''),
                                            const SizedBox(height: 5),
                                          ],
                                        ),
                                        Text('${med.medicationIntake ?? ''} meals',
                                            style: subHeadingStyleThree),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_alarm,
                                          size: 20, color: Colors.white),
                                      Text(med.medicationTime ?? '',
                                          style: showTimeStyle),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        height: 60,
                                        width: 1.5,
                                        color: Colors.grey[200],
                                      ),
                                      RotatedBox(
                                        quarterTurns: 3,
                                        child: getMedicationStatus(
                                            med.medicationIsCompleted),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(); // Not shown
                  }
                },
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text("It's Error!");
        } else {
          return const CircularProgressIndicator(color: mainAppColor);
        }
      },
    );
  }

  Color getColor(int colorNumber) {
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

  Widget getMedicationStatus(int statusNumber) {
    switch (statusNumber) {
      case 0:
        return const Text('Uncomplete',
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white));
      case 1:
        return const Text('Complete',
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white));
      default:
        return const Text('Uncomplete',
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white));
    }
  }
}
