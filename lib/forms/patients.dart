import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/objects/practitioner.dart';

class UserPatients extends StatefulWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final User? user;

  UserPatients({
    super.key,
    required this.user,
  });

  @override
  UserPatientsState createState() {
    return UserPatientsState();
  }
}

class UserPatientsState extends State<UserPatients> {
  late Practitioner _practitioner;
  late List<Patient> _patients = [];
  late List<Patient> _family = [];

  @override
  void initState() {
    super.initState();
    _getPractitioner();
    _fetchPatientData();
    //_fetchFamilyData();
  }

  void _fetchFamilyData() {
    List<Patient> patientsCopy = List.of(_patients);
    for (String s in _practitioner.patients!) {
      for (Patient p in patientsCopy) {
        if (p.id == s) {
          setState(() {
            _family.add(p);
            _patients.remove(p);
          });
        }
      }
    }
  }

  void _getPractitioner() async {
    // initialize database
    DatabaseReference ref = FirebaseDatabase.instance.ref('users');
    // get snapshot
    DataSnapshot snapshot = await ref.child(widget.user!.uid).get();
    // set state
    if (snapshot.exists) {
      Map<dynamic, dynamic>? value = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _practitioner = Practitioner.fromMap(value.cast<String, dynamic>());
      });
    }
  }

  void _fetchPatientData() async {
    // Initialize database
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    // Get snapshot
    DataSnapshot snapshot = await ref.child('patient').get();
    if (snapshot.value != null) {
      Map<dynamic, dynamic>? jsonMap = snapshot.value as Map<dynamic, dynamic>;
      List<Patient> pl = [];
      jsonMap.forEach((key, value) {
        Patient p = Patient.fromMap(value.cast<String, dynamic>());
        p.id = key;
        pl.add(p);
      });
      setState(() {
        _patients = pl;
      }); // Trigger rebuild to load patient data
      //_fetchFamilyData();
    }
  }

  // Function to add a patient to the family list
  void _addToFamily(Patient patient) {
    setState(() {
      _practitioner.patients!
          .add(patient.id!); // Add patient ID to family list
      _family.add(patient);
      _patients.remove(patient);
    });
  }

  // Function to remove a patient from the family list and add them back to the patients list
  void _removeFromFamily(Patient patient) {
    setState(() {
      _practitioner.patients!.remove(patient.id);
      _family.remove(patient);
      _patients.add(patient);
    });
  }

  // Function to create a widget for displaying a patient's information
  Widget buildPatientInfo(Patient patient, bool isInFamily) {
    return ListTile(
      title: Text(
          '${patient.firstName} ${patient.middleName} ${patient.lastName}'),
      subtitle: Text('DOB: ${patient.dob.toString()}'),
      trailing: ElevatedButton(
        onPressed: () {
          if (isInFamily) {
            _removeFromFamily(patient);
          } else {
            _addToFamily(patient);
          }
        },
        child: Text(isInFamily ? 'Remove Patient' : 'Add Patients'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        children: [
          Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('User Patients'),
                Text('${widget.user!.uid}'),
                Column(
                  children: [
                    // Display the family list
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _family.length,
                      itemBuilder: (context, index) {
                        Patient familyPatient = _family[index];
                        return buildPatientInfo(familyPatient, true);
                      },
                    ),
                  ],
                ),
                const Text('All Patients'),
                Column(
                  children: [
                    // Display all patients with "Add to Family" button
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _patients.length,
                      itemBuilder: (context, index) {
                        Patient patient = _patients[index];
                        return buildPatientInfo(patient, false);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
