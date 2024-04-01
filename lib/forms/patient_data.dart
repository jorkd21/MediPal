import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/objects/patient.dart';

// Create a Form widget.
class GetPatientData extends StatefulWidget {
  final String patientId;
  const GetPatientData({super.key, required this.patientId});

  @override
  GetPatientDataState createState() {
    return GetPatientDataState(patientId: patientId);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class GetPatientDataState extends State<GetPatientData> {
  final String patientId;
  late Patient _patient;
  GetPatientDataState({required this.patientId});
  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    // initialize database
    DatabaseReference ref = FirebaseDatabase.instance.ref('patient');
    // get snapshot
    DataSnapshot snapshot = await ref.child(patientId).get();
    // set state
    if (snapshot.exists) {
      print(snapshot.value.toString());
      String data = snapshot.value.toString();
      // Remove curly braces
      data = data.substring(1, data.length - 1);

      // Split the string by comma and trim each part
      List<String> parts = data.split(',').map((e) => e.trim()).toList();

      // Create a map from the parts
      Map<String, dynamic> map = {};
      for (String part in parts) {
        List<String> keyValue = part.split(':');
        String key = keyValue[0].trim();
        String value = keyValue[1].trim();
        // Handle string values without quotes
        if (value.startsWith("'") && value.endsWith("'")) {
          value = value.substring(1, value.length - 1);
        }
        map[key] = value;
      }

      // Convert map to JSON string
      String jsonString = json.encode(map);
      print(jsonString);
      Patient p = Patient.fromJson(jsonString);
      print(p.toString());
      setState(() {
        _patient = p;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _patient != null
          ? ListView(
              children: [
                ListTile(
                  title: Text('First Name'),
                  subtitle: Text(_patient.firstName ?? ''),
                ),
                ListTile(
                  title: Text('Middle Name'),
                  subtitle: Text(_patient.middleName ?? ''),
                ),
                ListTile(
                  title: Text('Last Name'),
                  subtitle: Text(_patient.lastName ?? ''),
                ),
                ListTile(
                  title: Text('Date of Birth'),
                  subtitle: Text(_patient.dob != null
                      ? _patient.dob!.toIso8601String()
                      : ''),
                ),
                ListTile(
                  title: Text('Blood Group'),
                  subtitle: Text(_patient.bloodGroup ?? ''),
                ),
                ListTile(
                  title: Text('Email'),
                  subtitle: Text(_patient.email ?? ''),
                ),
                ListTile(
                  title: Text('Phone Number'),
                  subtitle: _patient.phone != null && _patient.phone!.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _patient.phone!.map((phoneData) {
                            return Text(
                                '${phoneData.type}: ${phoneData.phoneNumber}');
                          }).toList(),
                        )
                      : Text(''),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
