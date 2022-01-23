// Model that will help to send and pass data to the manage prescription 

class MedicationModel {
  String? uid;
  String? medicationName;
  String? medicationType;
  String? medicationPurpose;
  String? medicationSize;
  String? medicationUnit;
  String? medicationDate;
  String? medicationTime;
  String? medicationIntake;
  int? medicationRemind;
  String? medicationRepeat;
  String? medicationNote;
  int? medicationColor;
  int medicationIsCompleted = 0;

  MedicationModel({
    this.uid, 
    this.medicationName,
    this.medicationType,
    this.medicationPurpose,
    this.medicationSize,
    this.medicationUnit,
    this.medicationDate,
    this.medicationTime,
    this.medicationIntake,
    this.medicationRemind,
    this.medicationRepeat,
    this.medicationNote,
    this.medicationColor,
    medicationIsCompleted,
  });

  // Send Data to the Server
  Map <String, dynamic> toMap() {
    return {
      'uid': uid,
      'medicationName': medicationName,
      'medicationType': medicationType,
      'medicationPurpose': medicationPurpose,
      'medicationSize': medicationSize,
      'medicationUnit': medicationUnit,
      'medicationDate': medicationDate,
      'medicationTime': medicationTime,
      'medicationIntake': medicationIntake,
      'medicationRemind': medicationRemind,
      'medicationRepeat': medicationRepeat,
      'medicationNote': medicationNote,
      'medicationColor': medicationColor,
      'medicationIsCompleted': medicationIsCompleted,
    };
  }
  
  //Retrieve the Data from the Server
  factory MedicationModel.fromMap(map) {
    return MedicationModel(
      uid: map['uid'],
      medicationName: map['medicationName'],
      medicationType: map['medicationType'],
      medicationPurpose: map['medicationPurpose'],
      medicationSize: map['medicationSize'],
      medicationUnit: map['medicationUnit'],
      medicationDate: map['medicationDate'],
      medicationTime: map['medicationTime'],
      medicationIntake: map['medicationIntake'],
      medicationRemind: map['medicationRemind'],
      medicationRepeat: map['medicationRepeat'],
      medicationNote: map['medicationNote'],
      medicationColor: map['medicationColor'],
      medicationIsCompleted: map['medicationIsCompleted'],
    );
  }
}