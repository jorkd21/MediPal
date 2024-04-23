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
  late List<String> _patientKeys = [];
  late List<Patient> _patients = [];
  late List<Patient> _originalPatients = [];
  late int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchPatientData();
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
        setState(() {
          _currentPageIndex++;
          _patientKeys.add(key);
        });
      });
      setState(() {
        _patients = pl;
        _originalPatients = pl;
      }); // Trigger rebuild to load patient data
    }
  }

  // Function to add a patient to the family list
  void _addToFamily(Patient patient) {
    setState(() {
      widget.patient.family?.add(patient);
      _patients.remove(patient);
    });
  }

  // Function to remove a patient from the family list and add them back to the patients list
  void _removeFromFamily(Patient patient) {
    setState(() {
      widget.patient.family?.remove(patient);
      _patients.add(patient);
    });
  }

  // Function to create a widget for displaying a patient's information
  Widget buildPatientInfo(Patient patient, bool isInFamily) {
    return ListTile(
      title: Text('${patient.firstName} ${patient.middleName} ${patient.lastName}'),
      subtitle: Text('DOB: ${patient.dob.toString()}'),
      trailing: ElevatedButton(
        onPressed: () {
          if (isInFamily) {
            _removeFromFamily(patient);
          } else {
            _addToFamily(patient);
          }
        },
        child: Text(isInFamily ? 'Remove from Family' : 'Add to Family'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Family Information'),
              Column(
                children: [
                  // Display the family list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.patient.family!.length,
                    itemBuilder: (context, index) {
                      Patient familyPatient = widget.patient.family![index];
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
    );
  }
}
