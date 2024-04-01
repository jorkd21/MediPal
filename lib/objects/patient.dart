import 'dart:convert';

class Patient {
  // VARTIABLES
  // personal info
  String? firstName;
  String? middleName;
  String? lastName;
  DateTime? dob;
  String? bloodGroup;
  String? rhFactor;
  // contact
  String? email;
  List<PhoneData>? phone = [];
  List<Map<String, PhoneData>>? emergency;
  // illnesses/allergies
  List<String>? currIllness = [];
  List<String>? prevIllness = [];
  List<String>? allergies = [];
  // medications
  //List<String>? currMedications;
  //List<String>? prevMedications;

  // CONSTRUCTORS
  Patient();
  // convert patient data to a map
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'dob': dob?.toIso8601String(),
      'bloodGroup': bloodGroup,
      'rhFactor': rhFactor,
      'email': email,
      'phone': phone?.map((e) => e.toJson()).toList(),
      'illnessCurr': currIllness ?? [],
      'illnessPrev': prevIllness ?? [],
      'allergies': allergies ?? [],
    };
  }

  factory Patient.fromJson(String jsonString) {
    // Parse the JSON string into a map
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    Patient p = Patient();
    p.firstName = jsonMap['firstName'];
    p.middleName = jsonMap['middleName'];
    p.lastName = jsonMap['lastName'];
    p.dob = jsonMap['dob'] != null ? DateTime.parse(jsonMap['dob']) : null;
    p.bloodGroup = jsonMap['bloodGroup'];
    p.rhFactor = jsonMap['rhFactor'];
    p.email = jsonMap['email'];
    return p;
  }
   /* Patient.fromJson(String jsonString) {
    // Remove curly braces
    jsonString = jsonString.substring(1, jsonString.length - 1);

    // Split the string by comma and trim each part
    List<String> parts = jsonString.split(',').map((e) => e.trim()).toList();

    // Create a map from the parts
    Map<String, dynamic> map = {};
    for (String part in parts) {
      List<String> keyValue = part.split(':');
      String key = keyValue[0].trim();
      String value = keyValue.sublist(1).join(':').trim();

      // Handle string values without quotes
      if (value.startsWith("'") && value.endsWith("'")) {
        value = value.substring(1, value.length - 1);
      }

      // Handle array values
      if (value.startsWith('[') && value.endsWith(']')) {
        List<dynamic> listValue = json.decode(value);
        map[key] = listValue;
      } else {
        map[key] = value;
      }
    }
    print(map);
    // Assign values to patient object
    firstName = map['firstName'];
    middleName = map['middleName'];
    lastName = map['lastName'];
    dob = map['dob'] != null ? DateTime.tryParse(map['dob']) : null;
    bloodGroup = map['bloodGroup'];
    rhFactor = map['rhFactor'];
    email = map['email'];
    phone = (map['phone'] as List<dynamic>?)
        ?.map((e) => PhoneData.fromJson(e))
        .toList();
    currIllness = List<String>.from(map['illnessCurr'] ?? []);
    prevIllness = List<String>.from(map['illnessPrev'] ?? []);
    allergies = List<String>.from(map['allergies'] ?? []);
  } */

  String toString() {
    String str = '';
    str += "firstName: $firstName\n";
    str += "middleName: $middleName\n";
    str += "lastName: $lastName\n";
    str += "dob: $dob\n";
    str += "bloodGroup: $bloodGroup\n";
    str += "rhFactor: $rhFactor\n";
    str += "email: $email\n";
    str += "phone: $phone";
    return str;
  }
}

class PhoneData {
  // variables
  String? type;
  String? phoneNumber;
  PhoneData({this.phoneNumber, this.type});
  // convert phone data to a map
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'phoneNumber': phoneNumber,
    };
  }
  factory PhoneData.fromJson(Map<String, dynamic> json) {
    return PhoneData(
      phoneNumber: json['phoneNumber'],
      type: json['type'],
    );
  }
}
