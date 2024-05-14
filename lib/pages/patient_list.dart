import 'package:flutter/material.dart';
import 'package:medipal/pages/patient_form.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/pages/patient_data.dart';

class PatientList extends StatefulWidget {
  const PatientList({super.key});

  @override
  PatientListState createState() => PatientListState();
}

class PatientListState extends State<PatientList> {
  late List<Patient> _patients = [];
  bool _isDeleteMode = false;
  bool _isEditMode = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  void _fetchPatients() async {
    List<Patient>? patients = await Patient.getAllPatients();
    patients!.sort((a, b) {
      return a.firstName!.toLowerCase().compareTo(b.firstName!.toLowerCase());
    });
    setState(() {
      _patients = patients;
    });
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

  Widget _buildPatientInfo(Patient patient) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GetPatientData(
              patientId: patient.id!,
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
                    'Name: ${patient.firstName} ${patient.middleName} ${patient.lastName}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "DOB: ${patient.dob?.year}/${patient.dob?.month}/${patient.dob?.day}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
                        patient: patient,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            if (_isDeleteMode)
              IconButton(
                onPressed: () async {
                  await Patient.deletePatient(
                      patient.id!); // possible check is success
                  setState(() {
                    _patients.remove(patient);
                  });
                },
                icon: const Icon(Icons.delete),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('All Patient List'),
          flexibleSpace: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color.fromARGB(255, 192, 212, 248),
                  Color.fromARGB(255, 214, 228, 255),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isDeleteMode = !_isDeleteMode;
                });
              },
              icon: Icon(_isDeleteMode ? Icons.cancel : Icons.delete),
            ),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search by name...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
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
                child: SizedBox(
                  height: MediaQuery.of(context).size.height -
                      kToolbarHeight -
                      kBottomNavigationBarHeight,
                  child: ListView.builder(
                    itemCount: _filterPatients(_patients).length,
                    itemBuilder: (context, index) {
                      return _buildPatientInfo(_filterPatients(_patients)[index]);
                    },
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
