import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/pages/patient_form.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/pages/patient_data.dart';

class PatientList extends StatefulWidget {
  const PatientList({super.key});

  @override
  PatientListState createState() {
    return PatientListState();
  }
}

class PatientListState extends State<PatientList> {
  late final List<String> _patientKeys = [];
  late List<Patient> _patients = [];
  late List<Patient> _originalPatients = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isDeleteMode = false;
  bool _isEditMode = false;

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
          _patientKeys.add(key);
        });
      });
      setState(() {
        _patients = pl;
        _originalPatients = pl;
      });
      // Sort the patient list before assigning to _originalPatients
      _originalPatients.sort((a, b) {
        // Implement your sorting logic here (e.g., by name)
        String nameA = a.firstName ?? "";
        String nameB = b.firstName ?? "";
        return nameA.compareTo(nameB);
      });
      setState(() {});
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
          automaticallyImplyLeading: true,
          title: Text(
            'All Patient List',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(0, 3),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
          flexibleSpace: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color.fromARGB(255, 73, 118, 207),
                  Color.fromARGB(255, 191, 200, 255),
                ],
              ),
            ),
          ),
          actions: [
            // Delete toggle button
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
                  _isEditMode = !_isEditMode;
                });
              },
              icon: Icon(_isEditMode ? Icons.cancel : Icons.edit),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      // Update the UI based on the new search term
                      _patients = _filterPatients(value);
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 0),
                    hintText: 'Search by name...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(143, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          )),
      body: _patients.isNotEmpty
          ? Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              color: Colors.white,
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    kBottomNavigationBarHeight,
                child: ListView.builder(
                  itemCount: _patients.length,
                  itemBuilder: (context, index) {
                    // Construct the full name with first, middle, and last name
                    String fullName = '${_patients[index].firstName ?? ""} '
                        '${_patients[index].middleName ?? ""} '
                        '${_patients[index].lastName ?? ""}';
                    return GestureDetector(
                      onTap: () {
                        // Handle tap on the patient entry
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GetPatientData(
                              patientId: _patients[index].id!,
                            ),
                          ),
                        );
                      },
                      child: Padding(
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
                                ],
                              ),
                            ),
                            if (_isEditMode)
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
                                icon: const Icon(Icons.edit),
                              ),
                            // delete patient
                            if (_isDeleteMode)
                              IconButton(
                                onPressed: () async {
                                  await _deletePatient(_patientKeys[index]);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
