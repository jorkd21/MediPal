import 'package:firebase_database/firebase_database.dart';

class Patient {
  // VARTIABLES
  // personal info
  String? firstName;
  String? middleName;
  String? lastName;
  String? dob;
  var dateTime;

  // CONSTRUCTOR
  Patient();
  // convert patient data to json map
  // used for input to database
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'dob': dob,
    };
  }

  factory Patient.fromSnapshot(DataSnapshot snapshot) {
    if (snapshot.exists) {
      Map<dynamic, dynamic>? value = snapshot.value as Map<dynamic, dynamic>;
      return Patient.fromMap(value.cast<String, dynamic>());
    }
    throw const FormatException('snapshot does not exist');
  }

  factory Patient.fromMap(Map<String, dynamic> jsonMap) {
    Patient p = Patient();
    p.firstName = jsonMap['firstName'];
    p.middleName = jsonMap['middleName'];
    p.lastName = jsonMap['lastName'];
    p.dob = jsonMap['dob'] != null
        ? "${DateTime.parse(jsonMap['dob']).year}-${DateTime.parse(jsonMap['dob']).month}-${DateTime.parse(jsonMap['dob']).day}"
        : null;
    return p;
  }

  @override
  String toString() {
    String str = '';
    str += "$firstName $middleName $lastName\n";
    str += "dob: $dob";
    return str;
  }
}
