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
  List<EmergancyData>? emergency;
  // illnesses/allergies
  List<String>? currIllness = [];
  List<String>? prevIllness = [];
  List<String>? allergies = [];
  // medications
  List<String>? currMedications;
  List<String>? prevMedications;

  // CONSTRUCTORS
  Patient();
  // convert patient data to a map
  // used for input to database
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
  factory Patient.fromMap( Map<String,dynamic> jsonMap ) {
    Patient p = Patient();
    p.firstName = jsonMap['firstName'];
    p.middleName = jsonMap['middleName'];
    p.lastName = jsonMap['lastName'];
    p.dob = jsonMap['dob'] != null ? DateTime.parse(jsonMap['dob']) : null;
    p.bloodGroup = jsonMap['bloodGroup'];
    p.rhFactor = jsonMap['rhFactor'];
    p.email = jsonMap['email'];
    p.phone = (jsonMap["phone"] as List<dynamic>)
        .map((phoneMap) => PhoneData(
            phoneNumber: phoneMap["phoneNumber"] as String,
            type: phoneMap["type"] as String))
        .toList();
    List<dynamic>? allergiesList = jsonMap['allergies'];
    if (allergiesList is List<dynamic>) {
      p.allergies = allergiesList.cast<String>(); // Cast to List<String>
    }
    List<dynamic>? currList = jsonMap['illnessCurr'];
    if (currList is List<dynamic>) {
      p.currIllness = currList.cast<String>(); // Cast to List<String>
    }
    List<dynamic>? prevList = jsonMap['illnessPrev'];
    if (prevList is List<dynamic>) {
      p.prevIllness = prevList.cast<String>(); // Cast to List<String>
    }
    return p;
  }
  // convert snapshot.value string value to Patient object
  factory Patient.fromJson(String jsonString) {
    // convert from json without quotes to one with
    jsonString = jsonString.replaceAll('{', '{"');
    jsonString = jsonString.replaceAll(': ', '": "');
    jsonString = jsonString.replaceAll(', ', '", "');
    jsonString = jsonString.replaceAll('}', '"}');
    /// remove quotes on object json string
    jsonString = jsonString.replaceAll('"{"', '{"');
    jsonString = jsonString.replaceAll('"}"', '"}');
    /// remove quotes on array json string
    jsonString = jsonString.replaceAll('"[{', '[{');
    jsonString = jsonString.replaceAll('}]"', '}]');
    // fix quotes on first and last item in lists
    jsonString = jsonString.replaceAll('"[', '["');
    jsonString = jsonString.replaceAll(']"', '"]');
    // Parse the JSON string into a map
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    //print(jsonMap);
    Patient p = Patient();
    p.firstName = jsonMap['firstName'];
    p.middleName = jsonMap['middleName'];
    p.lastName = jsonMap['lastName'];
    p.dob = jsonMap['dob'] != null ? DateTime.parse(jsonMap['dob']) : null;
    p.bloodGroup = jsonMap['bloodGroup'];
    p.rhFactor = jsonMap['rhFactor'];
    p.email = jsonMap['email'];
    p.phone = (jsonMap["phone"] as List<dynamic>)
        .map((phoneMap) => PhoneData(
            phoneNumber: phoneMap["phoneNumber"] as String,
            type: phoneMap["type"] as String))
        .toList();
    List<dynamic>? allergiesList = jsonMap['allergies'];
    if (allergiesList is List<dynamic>) {
      p.allergies = allergiesList.cast<String>(); // Cast to List<String>
    }
    List<dynamic>? currList = jsonMap['illnessCurr'];
    if (currList is List<dynamic>) {
      p.currIllness = currList.cast<String>(); // Cast to List<String>
    }
    List<dynamic>? prevList = jsonMap['illnessPrev'];
    if (prevList is List<dynamic>) {
      p.prevIllness = prevList.cast<String>(); // Cast to List<String>
    }
    return p;
  }

  String toString() {
    String str = '';
    str += "firstName: $firstName\n";
    str += "middleName: $middleName\n";
    str += "lastName: $lastName\n";
    str += "dob: $dob\n";
    str += "bloodGroup: $bloodGroup\n";
    str += "rhFactor: $rhFactor\n";
    str += "email: $email\n";
    str += "phone: ${phone.toString()}\n";
    str += "allergies: $allergies\n";
    str += "currIllness: $currIllness\n";
    str += "prevIllness: $prevIllness\n";
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

  String toString() {
    String str = '';
    str += "type: $type ";
    str += "phoneNumber: $phoneNumber\n";
    return str;
  }
}

class EmergancyData extends PhoneData {
  //
  String? name;
  EmergancyData(String this.name, String type, String phoneNumber) : super(type: type, phoneNumber: phoneNumber);
}