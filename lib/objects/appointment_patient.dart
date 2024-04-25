import 'package:firebase_database/firebase_database.dart';

class Patient {
  // VARTIABLES
  // personal info
  String? firstName;
  String? middleName;
  String? lastName;
  String? dob;
  String? email;
  List<PhoneData>? phone = [PhoneData()];
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
      'email': email,
      'phone': phone?.map((e) => e.toJson()).toList(),
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
    p.email = jsonMap['email'];
    // Check if phone list is not null before mapping
    if (jsonMap['phone'] != null && jsonMap['phone'] is List<dynamic>) {
      p.phone = (jsonMap["phone"] as List<dynamic>)
          .map((phoneMap) => PhoneData(
                phoneNumber: phoneMap["phoneNumber"] as String,
                type: phoneMap["type"] as String,
              ))
          .toList();
    }
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

class PhoneData {
  String? type;
  String? phoneNumber;

  PhoneData({
    this.phoneNumber,
    this.type,
  });

  // convert phone data to a map
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'phoneNumber': phoneNumber,
    };
  }

  @override
  String toString() {
    String str = '';
    str += "$phoneNumber";
    return str;
  }
}
