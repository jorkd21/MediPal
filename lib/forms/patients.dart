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
  bool _isDeleteMode = false;
  bool _isAddMode = false;

  @override
  void initState() {
    super.initState();
    _getPractitioner();
    _fetchPatientData();
    //_fetchFamilyData(); //?
    //_sortLists();
  }

  Future<void> _submitForm() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('users/${widget.user!.uid}');
    ref.update(_practitioner.toJson()).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Patient data updated'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating patient: $error'),
        ),
      );
    });
  }

  void _sortLists() {
    _patients.sort((a, b) {
      return a.firstName!.compareTo(b.firstName!);
    });
    _family.sort((a, b) {
      return a.firstName!.compareTo(b.firstName!);
    });
    setState(() {});
  }

  void _fetchFamilyData() {
    List<Patient> patientsCopy = List.of(_patients);
    for (String s in _practitioner.patients) {
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
      });
      _fetchFamilyData();
      _sortLists();
    }
  }

  // Function to add a patient to the family list
  void _addToFamily(Patient patient) {
    setState(() {
      _practitioner.patients!.add(patient.id!); // Add patient ID to family list
      _family.add(patient);
      _patients.remove(patient);
    });
    _sortLists();
  }

  // Function to remove a patient from the family list and add them back to the patients list
  void _removeFromFamily(Patient patient) {
    setState(() {
      _practitioner.patients!.remove(patient.id);
      _family.remove(patient);
      _patients.add(patient);
    });
    _sortLists();
  }

  // Function to create a widget for displaying a patient's information
  Widget buildPatientInfo(Patient patient, bool isInFamily) {
    return ListTile(
      title: Text(
          '${patient.firstName} ${patient.middleName} ${patient.lastName}'),
      subtitle: Text('DOB: ${patient.dob.toString()}'),
      trailing: ElevatedButton(
        onPressed: (_isDeleteMode || _isAddMode)
            ? () {
                if (isInFamily) {
                  _removeFromFamily(patient);
                } else {
                  _addToFamily(patient);
                }
              }
            : null,
        child: Icon(isInFamily ? Icons.delete : Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_isAddMode ? 'All Patients' : 'Patient List'),
        actions: [
          // Delete toggle button
          if (!_isAddMode)
            IconButton(
              onPressed: () {
                setState(() {
                  _isDeleteMode = !_isDeleteMode;
                });
              },
              icon: Icon(_isDeleteMode ? Icons.cancel : Icons.delete),
            ),
          // Add patient button
          IconButton(
            onPressed: () {
              setState(() {
                _isAddMode = !_isAddMode;
              });
            },
            icon: Icon(_isAddMode ? Icons.cancel : Icons.add),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(50,50),
          child: ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Submit'),
          ),
        ),
      ),
      body: ListView(
        children: [
          Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_isAddMode)
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
                if (_isAddMode)
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
