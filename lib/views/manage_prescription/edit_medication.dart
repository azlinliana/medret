import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medret/models/medication_model.dart';
import 'package:medret/views/elements/account_widget.dart';
import 'package:medret/views/elements/app_theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditMedicationPatient extends StatefulWidget {
  const EditMedicationPatient({ Key? key, required this.medicationModel }) : super(key: key);
  final MedicationModel medicationModel;

  @override
  _EditMedicationPatientState createState() => _EditMedicationPatientState();
}

class _EditMedicationPatientState extends State<EditMedicationPatient> {
  final _formKey = GlobalKey<FormState>();

  final medicationNameEditingController = TextEditingController();
  final medicationPurposeEditingController = TextEditingController();
  final medicationSizeEditingController = TextEditingController();
  final medicationNoteEditingController = TextEditingController();

  @override
  void dispose() {
    medicationNameEditingController.dispose();
    medicationPurposeEditingController.dispose();
    medicationSizeEditingController.dispose();
    medicationNoteEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // ignore: unnecessary_null_comparison
    if(widget.medicationModel == null) {
      medicationNameEditingController.text= "";
      _selectedMedicationType = "";
      medicationPurposeEditingController.text= "";
      medicationSizeEditingController.text= "";
      _selectedMedicationUnit = "";
      _selectedDate = DateTime.now();
      _selectedMedicationIntake = "";
      _selectedMedicationRemind = 5;
      _selectedMedicationRepeat = "";
      medicationNoteEditingController.text= "";
      _selectedColor = 0;
    }
    else {
      medicationNameEditingController.text = widget.medicationModel.medicationName!;
      _selectedMedicationType = widget.medicationModel.medicationType!;
      medicationPurposeEditingController.text = widget.medicationModel.medicationPurpose!;
      medicationSizeEditingController.text = widget.medicationModel.medicationSize!;
      _selectedMedicationUnit = widget.medicationModel.medicationUnit!;
      // _selectedDate = DateFormat.yMd().format(widget.medicationModel.medicationDate!) as DateTime;
      _time = widget.medicationModel.medicationTime!;
      _selectedMedicationIntake = widget.medicationModel.medicationIntake!;
      _selectedMedicationRemind = widget.medicationModel.medicationRemind!;
      _selectedMedicationRepeat = widget.medicationModel.medicationRepeat!;
      medicationNoteEditingController.text = widget.medicationModel.medicationNote!;
      _selectedColor = widget.medicationModel.medicationColor!;
    }
    super.initState();
  }

  String _selectedMedicationType = "Pills";
  List<String> medicationTypeList = [
    "Pills",
    "Liquid",
    "Tablet",
    "Capsules",
    "Drops",
  ];

  String _selectedMedicationUnit = "mg";
  List<String> medicationUnitList = [
    "mg",
    "ml",
    "Tablet(s)",
    "Drop(s)",
  ];

  DateTime _selectedDate = DateTime.now();
  String _time = DateFormat("hh:mm a").format(DateTime.now()).toString();
  
  String _selectedMedicationIntake = "Before";
  List<String> medicationIntakeList =[
    "Before",
    "After",
  ];

  int _selectedMedicationRemind = 5;
  List<int> medicationRemindList =[
    5,
    10,
    15,
    20,
  ];

  String _selectedMedicationRepeat = "None";
  List<String> medicationRepeatList =[
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];

  int _selectedColor = 0;
  
  final _medication = FirebaseAuth.instance;

  String? documentId;

  @override
  Widget build(BuildContext context) {
    // Medication Name Field
    final medicationNameField = TextFormField(
      autofocus: false,
      controller: medicationNameEditingController,
      style: textFormInputStyle,
      validator: (value) {
        RegExp regex = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return('Please Enter Medication Name!');
        }
        if (!regex.hasMatch(value)) {
          return('Please Enter a Valid Medication Name (Minimum 2 characters)');
        }
        return null;
      },
      onSaved: (value) {
        medicationNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Enter Medication Name',
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ), 
    );

    // Medication Type Field
    final medicationTypeField = DropdownButtonFormField(
      items: medicationTypeList.map<DropdownMenuItem<String>>((String? value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value!, style: textFormInputStyle),
        );
      }).toList(), 
      onChanged: (String? newvalue) {
        setState(() {
          _selectedMedicationType = newvalue!;
        });
      }, 
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: _selectedMedicationType,
        hintStyle: textFormInputStyle,
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Medication Purpose Field
    final medicationPurposeField = TextFormField(
      autofocus: false,
      controller: medicationPurposeEditingController,
      style: textFormInputStyle,
      validator: (value) {
        RegExp regex = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return('Please Enter Medication Purpose!');
        }
        if (!regex.hasMatch(value)) {
          return('Please Enter a Valid Medication Purpose (Minimum 2 characters)');
        }
        return null;
        },
      onSaved: (value) {
        medicationPurposeEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Enter Medication Purpose',
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ), 
    );

    //Medication Size & Unit
    final medicationSizeUnit = Row(
      children: [
        Expanded(
          child: TextFormField(
            autofocus: false,
            controller: medicationSizeEditingController,
            style: textFormInputStyle,
            validator: (value) {
              if(value!.isEmpty) {
                return('Please Enter Medication Size!');
              }
              return null;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: 'Medication Size',
              border:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),),
        Expanded(
          child: DropdownButtonFormField(
            items: medicationUnitList.map<DropdownMenuItem<String>>((String? value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value!, style: textFormInputStyle),
              );
            }).toList(),
            onChanged: (String? newvalue) {
              setState(() {
                _selectedMedicationUnit = newvalue!;
              });
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
              hintText: _selectedMedicationUnit,
              hintStyle: textFormInputStyle,
              border:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );

    // Medication Date Field
    final medicationDateField = TextFormField(
      style: textFormInputStyle,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            _getDate();
          }, 
          icon: const Icon(Icons.calendar_today_outlined, size: 20),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: DateFormat().add_yMd().format(_selectedDate),
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ), 
    );

    // Medication Time Field
    final medicationTimeField = TextFormField(
      style: textFormInputStyle,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            _getTime(isStartTime:true);
          }, 
          icon: const Icon(Icons.access_alarm_outlined, size: 20),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: _time,
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ), 
    );

    // Medication Intake Field=
    final medicationIntakeField = Row(
      children: [
        Expanded(
          child: DropdownButtonFormField(
            items: medicationIntakeList.map<DropdownMenuItem<String>>((String? value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value!, style: textFormInputStyle),
              );
            }).toList(), 
            onChanged: (String? newvalue) {
              setState(() {
                _selectedMedicationIntake = newvalue!;
              });
            }, 
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: _selectedMedicationIntake,
              hintStyle: textFormInputStyle,
              border:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 5, 0),
          child: Expanded(
            child: Text('Meals', style: textFormTitleStyle,)
          ),
        ),
      ],
    );

    // Medication Remind Field
    final medicationRemindField = Row(
      children: [
        Expanded(
          child: DropdownButtonFormField(
            items: medicationRemindList.map<DropdownMenuItem<String>>((int value) {
              return DropdownMenuItem<String>(
                value: value.toString(),
                child: Text(value.toString(), style: textFormInputStyle),
              );
            }).toList(), 
            onChanged: (String? newvalue) {
              setState(() {
                _selectedMedicationRemind = int.parse(newvalue!);
              });
            }, 
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "$_selectedMedicationRemind",
              hintStyle: textFormInputStyle,
              border:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 5, 0),
          child: Expanded(
            child: Text('Minutes early', style: textFormTitleStyle,)
          ),
        ),
      ],
    );

    // Medication Repeat Field
    final medicationRepeatField = DropdownButtonFormField(
      items: medicationRepeatList.map<DropdownMenuItem<String>>((String? value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value!, style: textFormInputStyle),
        );
      }).toList(), 
      onChanged: (String? newvalue) {
        setState(() {
          _selectedMedicationRepeat = newvalue!;
        });
      }, 
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: _selectedMedicationRepeat,
        hintStyle: textFormInputStyle,
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Medication Note Field
    final medicationNoteField = TextFormField(
      autofocus: false,
      controller: medicationNoteEditingController,
      style: textFormInputStyle,
      validator: (value) {
        RegExp regex = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return('Please Enter Medication Note!');
        }
        if (!regex.hasMatch(value)) {
          return('Please Enter a Valid Medication Note (Minimum 2 characters)');
        }
        return null;
        },
      onSaved: (value) {
        medicationNoteEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Enter Medication Note',
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ), 
    );

    // Color
    final medicationBackgroundColor = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _getPallete(),
        Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(30),
          color: addButtonColor,
          child: MaterialButton(
            onPressed: () {
              updateMedication();
            },
            child: const Text('UPDATE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          ),
        ),
      ],
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Medication'),
          backgroundColor: mainAppColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: 
        SingleChildScrollView(
          child: 
          Container(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Medication Name', style: textFormTitleStyle),
                      const SizedBox(height: 10),
                      medicationNameField,
                      const SizedBox(height: 15),

                      Text('Medication Type', style: textFormTitleStyle),
                      const SizedBox(height: 10),
                      medicationTypeField,
                      const SizedBox(height: 15),


                      Text('Medication Purpose', style: textFormTitleStyle),
                      const SizedBox(height: 10),
                      medicationPurposeField,
                      const SizedBox(height: 15),

                      Text('Medication Size', style: textFormTitleStyle),
                      const SizedBox(height: 10),
                      medicationSizeUnit,
                      const SizedBox(height: 15),

                      Text('Date', style: textFormTitleStyle),
                      const SizedBox(height: 10),
                      medicationDateField,
                      const SizedBox(height: 15),

                      Text('Time', style: textFormTitleStyle),
                      const SizedBox(height: 10),
                      medicationTimeField,
                      const SizedBox(height: 15),

                      Text('Medication Intake', style: textFormTitleStyle),
                      const SizedBox(height: 10),
                      medicationIntakeField,
                      const SizedBox(height: 15),

                      Text('Medication Remind', style: textFormTitleStyle),
                      const SizedBox(height: 10),
                      medicationRemindField,
                      const SizedBox(height: 15),

                      Text('Medication Repeat', style: textFormTitleStyle),
                      const SizedBox(height: 10),
                      medicationRepeatField,
                      const SizedBox(height: 15),

                      Text('Medication Note', style: textFormTitleStyle),
                      const SizedBox(height: 10),
                      medicationNoteField,
                      const SizedBox(height: 15),

                      Text('Color', style: textFormTitleStyle),
                      const SizedBox(height: 10),
                      medicationBackgroundColor,
                      const SizedBox(height: 100),
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  _getDate() async {
      DateTime? _pickerDate = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2021), 
      lastDate: DateTime(2120),
    );

    if(_pickerDate!=null) {
      setState(() {
        _selectedDate = _pickerDate;
        // ignore: avoid_print
        print(_selectedDate);

      });
    }
    else{
      // ignore: avoid_print
      print("It's null or something is wrong!");
    }
  }

  _getTime({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);

    if(pickedTime==null) {
      // ignore: avoid_print
      print("Time canceled!");
    }
    else if(isStartTime==true) {
      setState(() {
        _time = _formatedTime;

      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context, 
      initialTime: TimeOfDay(
        hour: int.parse(_time.split(":")[0]), 
        minute: int.parse(_time.split(":")[1].split(" ")[0]),
      ),
    );
  }

  _getPallete () {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        // Put element in horizonatal line
        Wrap(
          children: List<Widget>.generate(
            3, 
            (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                    // ignore: avoid_print
                    print("$index");
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 6.0, bottom: 5.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index==0?fillOne:index==1?fillTwo:fillThree,
                    child: _selectedColor==index?const Icon(Icons.done, color: Colors.white, size: 20,): 
                    Container(),
                  ),
                ),
              );
            }
          ),
        ),
      ],
    );
  }
  // Add New Medication FUnction
  updateMedication() async {
    // Call Firestore
    // Call MedicationModel
    // Send the Value to the Firestore

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    // User? user = _medication.currentUser;

    MedicationModel medicationModel = MedicationModel();

    // // Write All the Values
    // medicationModel.documentId = documentId;
    // medicationModel.uid = user!.uid;
    medicationModel.medicationName = medicationNameEditingController.text;
    // medicationModel.medicationType = _selectedMedicationType;
    // medicationModel.medicationPurpose = medicationPurposeEditingController.text;
    // medicationModel.medicationSize = medicationSizeEditingController.text;
    // medicationModel.medicationUnit = _selectedMedicationUnit;
    // medicationModel.medicationDate = DateFormat.yMd().format(_selectedDate);
    // medicationModel.medicationTime = _time;
    // medicationModel.medicationIntake = _selectedMedicationIntake;
    // medicationModel.medicationRemind = _selectedMedicationRemind;
    // medicationModel.medicationRepeat = _selectedMedicationRepeat;
    // medicationModel.medicationNote = medicationNoteEditingController.text;
    // medicationModel.medicationColor = _selectedColor;
    // final firebaseFirestore = FirebaseFirestore.instance;

    // MedicationModel medicationModel = MedicationModel(
    //   medicationName: medicationNameEditingController.text,
    // );

    // await firebaseFirestore
    //   .collection("medications")
    //   .doc(documentId)
    //   .update(medicationModel.toMap());


    await firebaseFirestore
    .collection("medications")
    .doc(documentId)
    .update(medicationModel.toMap());

    Fluttertoast.showToast(msg: "Medication updated successfully!");

    Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => const AccountWidget()), (route) => false);

  }
}