import 'dart:io';
import 'package:firebase_database/firebase_database.dart';

class Patient {
  // VARTIABLES
  // personal info
  String? id;
  // name
  String? firstName;
  String? middleName;
  String? lastName;
  // date of birth
  DateTime? dob;
  // blood
  String? bloodGroup;
  String? rhFactor;
  String? sex;
  String? location;
  String? maritalStatus;
  // contact
  String? email;
  List<PhoneData> phone = [PhoneData()];
  List<EmergancyData> emergency = [EmergancyData()];
  // illnesses/allergies
  List<String> currIllness = [];
  List<String> prevIllness = [];
  List<String> allergies = [];
  // medications
  List<String> currMedications = [];
  List<String> prevMedications = [];
  // family
  List<String> family = [];
  // files
  File? imageFile;
  List<FileData> files = [];

  // CONSTRUCTOR
  Patient();

  // convert to json
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'location': location,
      'sex': sex,
      'dob': dob?.toIso8601String(),
      'bloodGroup': bloodGroup,
      'rhFactor': rhFactor,
      'maritalStatus': maritalStatus,
      'email': email,
      'phone': phone.map((e) => e.toJson()).toList(),
      'emergency': emergency.map((e) => e.toJson()).toList(),
      'illnessCurr': currIllness,
      'illnessPrev': prevIllness,
      'allergies': allergies,
      'medicationsCurr': currMedications,
      'medicationsPrev': prevMedications,
      'family': family,
    };
  }

  // get patient from map
  factory Patient.fromMap(Map<String, dynamic> jsonMap) {
    Patient p = Patient();
    p.firstName = jsonMap['firstName'];
    p.middleName = jsonMap['middleName'];
    p.lastName = jsonMap['lastName'];
    p.sex = jsonMap['sex'];
    p.location = jsonMap['location'];
    p.dob = jsonMap['dob'] != null ? DateTime.parse(jsonMap['dob']) : null;
    p.bloodGroup = jsonMap['bloodGroup'];
    p.rhFactor = jsonMap['rhFactor'];
    p.maritalStatus = jsonMap['maritalStatus'];
    p.email = jsonMap['email'];
    if (jsonMap['phone'] != null && jsonMap['phone'] is List<dynamic>) {
      p.phone = (jsonMap["phone"] as List<dynamic>)
          .map((phoneMap) => PhoneData(
                phoneNumber: phoneMap["phoneNumber"] as String,
                type: phoneMap["type"] as String,
              ))
          .toList();
    }
    if (jsonMap['emergency'] != null && jsonMap['emergency'] is List<dynamic>) {
      p.emergency = (jsonMap["emergency"] as List<dynamic>)
          .map((emergencyMap) => EmergancyData(
                name: emergencyMap["name"] as String,
                phoneNumber: emergencyMap["phoneNumber"] as String,
                type: emergencyMap["type"] as String,
              ))
          .toList();
    }
    List<dynamic>? allergiesList = jsonMap['allergies'];
    if (allergiesList is List<dynamic>) {
      p.allergies = List<String>.from(allergiesList);
    }
    List<dynamic>? currList = jsonMap['illnessCurr'];
    if (currList is List<dynamic>) {
      p.currIllness = List<String>.from(currList);
    }
    List<dynamic>? prevList = jsonMap['illnessPrev'];
    if (prevList is List<dynamic>) {
      p.prevIllness = List<String>.from(prevList);
    }
    List<dynamic>? currMed = jsonMap['medicationsCurr'];
    if (currMed is List<dynamic>) {
      p.currMedications = List<String>.from(currMed);
    }
    List<dynamic>? prevMed = jsonMap['medicationsPrev'];
    if (prevMed is List<dynamic>) {
      p.prevMedications = List<String>.from(prevMed);
    }
    List<dynamic>? family = jsonMap['family'];
    if (family is List<dynamic>) {
      p.family = List<String>.from(family);
    }
    return p;
  }

  // get patient from database
  static Future<Patient?> getPatient(String uid) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('patient');
    DataSnapshot snapshot = await ref.child(uid).get();
    if (!snapshot.exists) return null;
    Map<dynamic, dynamic>? value = snapshot.value as Map<dynamic, dynamic>;
    return Patient.fromMap(value.cast<String, dynamic>());
  }

  // get list of all patients from database
  static Future<List<Patient>> getAllPatients() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('patient');
    DataSnapshot snapshot = await ref.get();
    if (!snapshot.exists) return [];
    Map<dynamic, dynamic>? jsonMap = snapshot.value as Map<dynamic, dynamic>;
    List<Patient> patients = [];
    jsonMap.forEach((key, value) {
      Patient p = Patient.fromMap(value.cast<String, dynamic>());
      p.id = key;
      patients.add(p);
    });
    return patients;
  }

  @override
  String toString() {
    String str = '';
    str += "firstName: $firstName\n";
    str += "middleName: $middleName\n";
    str += "lastName: $lastName\n";
    str += "sex: $sex\n";
    str += "location:";
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

  // constructor
  PhoneData({
    this.phoneNumber,
    this.type,
  });

  // convert to json
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'phoneNumber': phoneNumber,
    };
  }

  @override
  String toString() {
    String str = '';
    str += "type: $type ";
    str += "phoneNumber: $phoneNumber\n";
    return str;
  }
}

class EmergancyData extends PhoneData {
  // variables
  String? name;

  //constructor
  EmergancyData({
    this.name,
    super.type,
    super.phoneNumber,
  });

  // convert to json
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {'name': name};
    map.addAll(super.toJson());
    return map;
  }

  @override
  String toString() {
    String str = '';
    str += "type: $name ";
    str += super.toString();
    return str;
  }
}

class FileData {
  // variables
  File? file;
  String? name;
  String? url;

  //constructor
  FileData({
    this.file,
    this.name,
    this.url,
  });
}
