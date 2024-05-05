import 'package:flutter/material.dart';

class Appointment {
  // Variables
  String? topic;
  String? patient;
  DateTimeRange? time;

  Appointment({this.topic, this.patient, this.time});

  // Convert Appointment object to JSON
  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'patient': patient,
      'time': time != null
          ? {
              'start': time!.start.toIso8601String(),
              'end': time!.end.toIso8601String(),
            }
          : null,
    };
  }

  // Factory method to create Appointment object from JSON
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      topic: json['topic'],
      patient: json['patient'],
      time: json['time'] != null
          ? DateTimeRange(
              start: DateTime.parse(json['time']['start']),
              end: DateTime.parse(json['time']['end']),
            )
          : null,
    );
  }
}
