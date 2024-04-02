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
      String jsonString = _convertToJsonStringQuotes(data);
      print(jsonString);
      Patient p = Patient.fromJson(jsonString);
      print(p.toString());
      setState(() {
        _patient = p;
      });
    }
  }

  String _convertToJsonStringQuotes(String raw) {
    String jsonString = raw;

    /// add quotes to json string
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
    //
    jsonString = jsonString.replaceAll('"[', '["');
    jsonString = jsonString.replaceAll(']"', '"]');

    return jsonString;
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
                  title: Text('RH Factor'),
                  subtitle: Text(_patient.rhFactor ?? ''),
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
                ListTile(
                  title: Text('Allergies'),
                  subtitle: _patient.allergies != null && _patient.allergies!.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _patient.allergies!.map((allergy) {
                            return Text(allergy);
                          }).toList(),
                        )
                      : Text(''),
                ),
                ListTile(
                  title: Text('Current Illnesses'),
                  subtitle: _patient.currIllness != null && _patient.currIllness!.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _patient.currIllness!.map((allergy) {
                            return Text(allergy);
                          }).toList(),
                        )
                      : Text(''),
                ),
                ListTile(
                  title: Text('Previous Illnesses'),
                  subtitle: _patient.prevIllness != null && _patient.prevIllness!.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _patient.prevIllness!.map((allergy) {
                            return Text(allergy);
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
