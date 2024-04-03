import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/forms/patient_data.dart';

class PatientList extends StatefulWidget {
  const PatientList({Key? key}) : super(key: key);

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  late List<String> _patientKeys = [];
  late List<Patient> _patients = [];
  late int _currentPageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _fetchPatientData();
  }

  void _fetchPatientData() async {
    // initialize database
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    // get snapshot
    DataSnapshot snapshot = await ref.child('patient').get();
    if (snapshot.value != null) {
      print(snapshot.value);
      String jsonString = snapshot.value.toString();
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
      print(jsonMap.values);
      //Map<dynamic, dynamic>? patientsMap = snapshot.value as Map?;
      List<Patient> pl = [];
      jsonMap.forEach((key, value) {
        print(key);
        Patient p = Patient.fromMap(value);
        //print(p);
        pl.add(p);
        setState(() {
          _currentPageIndex++;
          _patientKeys.add(key);
        });
        //_patients.add(p);
        //_patients.add(Patient.fromMap(value));
      });
      //print(pl);
      setState(() {
        _patients = pl;
      }); // Trigger rebuild to load patient data
      print(_patients);
      print(_currentPageIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient List'),
      ),
      body: _patients.isNotEmpty
          ? Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFF6D98EB), // Light blue at the bottom
                    Color(0xFFBAA2DA), // Purple at the top
                  ],
                ),
              ),
              child: ListView.builder(
                itemCount: _patients.length,
                itemBuilder: (context, index) {
                  // Construct the full name with first, middle, and last name
                  String fullName = '${_patients[index].firstName ?? ""} '
                      '${_patients[index].middleName ?? ""} '
                      '${_patients[index].lastName ?? ""}';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Patient ID: ${_patientKeys[index]}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    "Name: $fullName",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 16),
                                  Text(
                                    "DOB: ${_patients[index].dob?.year}/${_patients[index].dob?.month}/${_patients[index].dob?.day}",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GetPatientData(
                                  patientId: _patientKeys[index],
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
