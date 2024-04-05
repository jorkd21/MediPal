import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/objects/patient.dart';

class GetPatientData extends StatefulWidget {
  final String patientId;

  const GetPatientData({
    super.key,
    required this.patientId,
  });

  @override
  GetPatientDataState createState() {
    return GetPatientDataState();
  }
}

class GetPatientDataState extends State<GetPatientData> {
  // VARIABLES
  Patient _patient = Patient();

  // CONSTRUCTOR
  GetPatientDataState();
  // initialize
  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    // initialize database
    DatabaseReference ref = FirebaseDatabase.instance.ref('patient');
    // get snapshot
    DataSnapshot snapshot = await ref.child(widget.patientId).get();
    // set state
    if (snapshot.exists) {
      String data = snapshot.value.toString();
      setState(() {
        _patient = Patient.fromJson(data);
      });
    }
  }

  // build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patientId),
      ),
      body: ListView(
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
            subtitle: Text(
              _patient.dob != null ? _patient.dob!.toIso8601String() : '',
            ),
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
            title: Text('Marital Status'),
            subtitle: Text(_patient.maritalStatus ?? ''),
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
            subtitle:
                _patient.allergies != null && _patient.allergies!.isNotEmpty
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
            subtitle:
                _patient.currIllness != null && _patient.currIllness!.isNotEmpty
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
            subtitle:
                _patient.prevIllness != null && _patient.prevIllness!.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _patient.prevIllness!.map((allergy) {
                          return Text(allergy);
                        }).toList(),
                      )
                    : Text(''),
          ),
        ],
      ),
      //: const Center(child: CircularProgressIndicator()),
    );
  }
}
