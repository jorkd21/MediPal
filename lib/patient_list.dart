import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/form_patient.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/forms/patient_data.dart';

class PatientList extends StatefulWidget {
  const PatientList({super.key});

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  late final List<String> _patientKeys = [];
  late List<Patient> _patients = [];
  late List<Patient> _originalPatients = [];
  late int _currentPageIndex = 0;
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();

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
      Map<dynamic, dynamic>? jsonMap = snapshot.value as Map<dynamic, dynamic>;
      List<Patient> pl = [];
      jsonMap.forEach((key, value) {
        //print(key);
        Patient p = Patient.fromMap(value.cast<String, dynamic>());
        p.id = key;
        //print(p);
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

  List<Patient> _filterPatients(String searchTerm) {
    // If search term is empty, return the original list
    if (searchTerm.isEmpty) {
      return _originalPatients;
    }
    return _originalPatients.where((patient) {
      String fullName =
          '${patient.firstName ?? ""} ${patient.middleName ?? ""} ${patient.lastName ?? ""}';
      return fullName.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
  }

  Future<void> _deletePatient(String key) async {
    // Initialize database
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    // Delete the patient from the database
    await ref.child('patient/$key').remove();

    // Update the local state
    setState(() {
      // Remove the patient from the list of patients using the key
      int index = _patientKeys.indexOf(key);
      if (index != -1) {
        _patientKeys.removeAt(index);
        _patients.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //remove back arrow from appbar
        title: const Text('Patient List'),
        flexibleSpace: Container(
          //appbar container
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 192, 212, 248), // light blue at bottom
                Color.fromARGB(255, 214, 228, 255), // White at top
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: 200, // Adjust the width as needed
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    // Update the UI based on the new search term
                    _patients = _filterPatients(value);
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search by name...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _patients.isNotEmpty
          ? Container(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color.fromARGB(
                        255, 151, 183, 247), // Light blue at the bottom
                    Color.fromARGB(255, 192, 212, 248), // White at top
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
                              const SizedBox(height: 4),
                              Text(
                                "Name: $fullName",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "DOB: ${_patients[index].dob?.year}/${_patients[index].dob?.month}/${_patients[index].dob?.day}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Patient ID: ${_patientKeys[index]}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
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
                          icon: const Icon(Icons.arrow_forward),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientForm(
                                  patient: _patients[index],
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.add),
                        ),
                        // delete patient
                        IconButton(
                          onPressed: () async {
                            await _deletePatient(_patientKeys[index]);
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
