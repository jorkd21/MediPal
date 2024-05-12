import 'package:flutter/material.dart';

class Appointment {
  // variables
  String? topic;
  String? patient;
  DateTimeRange? time;

  // constructor
  Appointment({
    this.topic,
    this.patient,
    this.time,
  });

  // convert to json
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

  // 
  factory Appointment.fromMap(Map<String, dynamic> json) {
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
