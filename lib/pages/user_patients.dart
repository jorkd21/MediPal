import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/objects/practitioner.dart';
import 'package:medipal/pages/patient_data.dart';

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
  late List<Patient> _allPatients = [];
  late final List<Patient> _myPatients = [];
  bool _isDeleteMode = false;
  bool _isAddMode = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchPractitioner();
    _fetchPatients();
  }

  void _fetchPractitioner() async {
    Practitioner? practitioner =
        await Practitioner.getPractitioner(widget.user!.uid);
    if (practitioner != null) {
      setState(() {
        _practitioner = practitioner;
      });
    }
  }

  void _fetchPatients() async {
    List<Patient> patients = await Patient.getAllPatients();
    setState(() {
      _allPatients = patients;
    });
    _separateMyPatients();
    _sortLists();
  }

  void _separateMyPatients() {
    List<Patient> patientsCopy = List.of(_allPatients);
    for (String s in _practitioner.patients) {
      for (Patient p in patientsCopy) {
        if (p.id == s) {
          setState(() {
            _myPatients.add(p);
            _allPatients.remove(p);
          });
        }
      }
    }
  }

  void _sortLists() {
    _allPatients.sort((a, b) {
      return a.firstName!.toLowerCase().compareTo(b.firstName!.toLowerCase());
    });
    _myPatients.sort((a, b) {
      return a.firstName!.toLowerCase().compareTo(b.firstName!.toLowerCase());
    });
    setState(() {});
  }

  void _addToPatients(Patient patient) {
    setState(() {
      _practitioner.patients.add(patient.id!);
      _myPatients.add(patient);
      _allPatients.remove(patient);
    });
    _sortLists();
  }

  void _removeFromPatients(Patient patient) {
    setState(() {
      _practitioner.patients.remove(patient.id);
      _myPatients.remove(patient);
      _allPatients.add(patient);
    });
    _sortLists();
  }

  Future<void> _updatePatients() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('users/${widget.user!.uid}');
    ref.update(_practitioner.toJson()).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Patient list updated'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating patient list: $error'),
        ),
      );
    });
  }

  Widget _buildPatientInfo(Patient patient, bool isPatient) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GetPatientData(patientId: patient.id!),
          ),
        );
      },
      child: ListTile(
        title: Text(
            '${patient.firstName} ${patient.middleName} ${patient.lastName}'),
        subtitle: Text('DOB: ${patient.dob.toString()}'),
        trailing: ElevatedButton(
          onPressed: (_isDeleteMode || _isAddMode)
              ? () {
                  if (isPatient) {
                    _removeFromPatients(patient);
                  } else {
                    _addToPatients(patient);
                  }
                }
              : null,
          child: Icon(isPatient ? Icons.delete : Icons.add),
        ),
      ),
    );
  }

  List<Patient> _filterPatients(List<Patient> patients) {
    if (_searchQuery.isEmpty) {
      return patients;
    } else {
      return patients
          .where((patient) =>
              patient.firstName!.toLowerCase().contains(_searchQuery) ||
              patient.middleName!.toLowerCase().contains(_searchQuery) ||
              patient.lastName!.toLowerCase().contains(_searchQuery))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_isAddMode ? 'All Patients' : 'Patient List'),
        actions: [
          // delete toggle button
          if (!_isAddMode)
            IconButton(
              onPressed: () {
                setState(() {
                  _isDeleteMode = !_isDeleteMode;
                });
              },
              icon: Icon(_isDeleteMode ? Icons.cancel : Icons.delete),
            ),
          // add toggle button
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
          preferredSize: const Size(50, 50),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _updatePatients,
                child: const Text('Update'),
              ),
            ],
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
                      // display the patient list
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filterPatients(_myPatients).length,
                        itemBuilder: (context, index) {
                          Patient familyPatient =
                              _filterPatients(_myPatients)[index];
                          return _buildPatientInfo(familyPatient, true);
                        },
                      ),
                    ],
                  ),
                if (_isAddMode)
                  Column(
                    children: [
                      // display all patients
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filterPatients(_allPatients).length,
                        itemBuilder: (context, index) {
                          Patient patient =
                              _filterPatients(_allPatients)[index];
                          return _buildPatientInfo(patient, false);
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
