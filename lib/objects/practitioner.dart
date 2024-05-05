import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/objects/appointment.dart';

class Practitioner {
  // VARIABLES
  String? id;
  String? email;
  List<String> patients = [];
  List<Appointment> appointments = [];

  // CONSTRUCTOR
  Practitioner();

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'patients': patients,
      'appointments': appointments
          .map((appointment) => appointment.toJson())
          .toList(), // Serialize appointments
    };
  }

  factory Practitioner.fromSnapshot(DataSnapshot snapshot) {
    if (snapshot.exists) {
      Map<dynamic, dynamic>? value = snapshot.value as Map<dynamic, dynamic>;
      return Practitioner.fromMap(value.cast<String, dynamic>());
    }
    throw const FormatException('snapshot does not exist');
  }

  /* factory Practitioner.fromMap(Map<String, dynamic> jsonMap) {
    Practitioner u = Practitioner();
    u.email = jsonMap['email'];
    List<dynamic>? patients = jsonMap['patients'];
    if (patients is List<dynamic>) {
      u.patients = List<String>.from(patients);
    }

    List<dynamic>? appointments = jsonMap['appointments'];
    if (appointments is List<dynamic>) {
      u.appointments = appointments
          .map((appointment) => Appointment.fromJson(appointment))
          .toList();
    }
    if (jsonMap['appointments'] != null &&
        jsonMap['appointments'] is List<dynamic>) {
      u.appointments = (jsonMap["appointments"] as List<dynamic>)
          .map((appointmentMap) => Appointment(
                topic: appointmentMap["topic"] as String,
                patient: appointmentMap["patient"] as String,
                // map to time
              ))
          .toList();
    }
    return u;
  } */
 /*  factory Practitioner.fromMap(Map<String, dynamic> jsonMap) {
  Practitioner u = Practitioner();
  u.email = jsonMap['email'];
  List<dynamic>? patients = jsonMap['patients'];
  if (patients is List<dynamic>) {
    u.patients = List<String>.from(patients);
  }

  List<dynamic>? appointments = jsonMap['appointments'];
  if (appointments is List<dynamic>) {
    u.appointments = appointments
        .map((appointment) => Appointment.fromJson(appointment))
        .toList();
  }
  return u;
} */

// Deserialize appointments including time mapping
factory Practitioner.fromMap(Map<String, dynamic> jsonMap) {
  Practitioner u = Practitioner();
  u.email = jsonMap['email'];
  List<dynamic>? patients = jsonMap['patients'];
  if (patients is List<dynamic>) {
    u.patients = List<String>.from(patients);
  }

  List<dynamic>? appointments = jsonMap['appointments'];
  if (appointments is List<dynamic>) {
    u.appointments = appointments.map((appointment) {
      // Check if appointment has 'time' property
      if (appointment['time'] != null) {
        return Appointment(
          topic: appointment['topic'] as String?,
          patient: appointment['patient'] as String?,
          time: DateTimeRange(
            start: DateTime.parse(appointment['time']['start'] as String),
            end: DateTime.parse(appointment['time']['end'] as String),
          ),
        );
      } else {
        return Appointment.fromJson(appointment);
      }
    }).toList();
  }
  return u;
}

}
