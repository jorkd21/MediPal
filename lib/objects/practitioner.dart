import 'package:firebase_database/firebase_database.dart';

class Practitioner {
  // VARIABLES
  String? email;
  List<String> patients = [];

  // CONSTRUCTOR
  Practitioner();

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'patients': patients,
    };
  }

  factory Practitioner.fromSnapshot(DataSnapshot snapshot) {
    if (snapshot.exists) {
      Map<dynamic, dynamic>? value = snapshot.value as Map<dynamic, dynamic>;
      return Practitioner.fromMap(value.cast<String, dynamic>());
    }
    throw const FormatException('snapshot does not exist');
  }

  factory Practitioner.fromMap(Map<String, dynamic> jsonMap) {
    Practitioner u = Practitioner();
    u.email = jsonMap['email'];
    List<dynamic>? patients = jsonMap['patients'];
    if (patients is List<dynamic>) {
      //p.family = family.cast<String>();
      u.patients = List<String>.from(patients);
    }
    return u;
  }
}
