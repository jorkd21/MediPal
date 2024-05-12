import 'package:flutter/material.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/pages/patient_data.dart';

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
  late final List<Patient> _family = [];
  bool _isDeleteMode = false;
  bool _isAddMode = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  void _fetchPatients() async {
    List<Patient> patients = await Patient.getAllPatients();
    setState(() {
      _patients = patients;
    });
    _separateFamily();
    _sortLists();
  }

  void _separateFamily() {
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

  void _sortLists() {
    _patients.sort((a, b) {
      return a.firstName!.toLowerCase().compareTo(b.firstName!.toLowerCase());
    });
    _family.sort((a, b) {
      return a.firstName!.toLowerCase().compareTo(b.firstName!.toLowerCase());
    });
    setState(() {});
  }

  void _addToFamily(Patient patient) {
    setState(() {
      widget.patient.family.add(patient.id!);
      _family.add(patient);
      _patients.remove(patient);
    });
    _sortLists();
  }

  void _removeFromFamily(Patient patient) {
    setState(() {
      widget.patient.family.remove(patient.id);
      _family.remove(patient);
      _patients.add(patient);
    });
    _sortLists();
  }

  Widget _buildPatientInfo(Patient patient, bool isInFamily) {
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
                  if (isInFamily) {
                    _removeFromFamily(patient);
                  } else {
                    _addToFamily(patient);
                  }
                }
              : null,
          child: Icon(isInFamily ? Icons.delete : Icons.add),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
              ],
            ),
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
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filterPatients(_family).length,
                        itemBuilder: (context, index) {
                          Patient familyPatient =
                              _filterPatients(_family)[index];
                          return _buildPatientInfo(familyPatient, true);
                        },
                      ),
                    ],
                  ),
                if (_isAddMode)
                  Column(
                    children: [
                      // Display all patients
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filterPatients(_patients).length,
                        itemBuilder: (context, index) {
                          Patient patient = _filterPatients(_patients)[index];
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
