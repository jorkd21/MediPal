import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/objects/patient.dart';

class FamilyForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Patient patient;

  const FamilyForm({
    super.key,
    required this.formKey,
    required this.patient,
  });

  @override
  FamilyFormState createState() {
    return FamilyFormState();
  }
}

class FamilyFormState extends State<FamilyForm> {
  late List<Patient> _patients = [];
  late List<Patient> _family = [];
  bool _isDeleteMode = false;
  bool _isAddMode = false;

  @override
  void initState() {
    super.initState();
    _fetchPatientData();
    _fetchFamilyData();
    _sortLists();
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
    for (String s in widget.patient.family) {
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
    }
  }

  // Function to add a patient to the family list
  void _addToFamily(Patient patient) {
    setState(() {
      widget.patient.family!.add(patient.id!); // Add patient ID to family list
      _family.add(patient);
      _patients.remove(patient);
    });
    _sortLists();
  }

  // Function to remove a patient from the family list and add them back to the patients list
  void _removeFromFamily(Patient patient) {
    setState(() {
      widget.patient.family!.remove(patient.id);
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
        title: Text(_isAddMode ? 'All Patients' : 'Family Information'),
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
