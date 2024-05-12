import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:medipal/chat/chat_list.dart';
import 'package:medipal/forms/family.dart';
import 'package:medipal/forms/files.dart';
import 'package:medipal/forms/general_info.dart';
import 'package:medipal/forms/health_conditions.dart';
import 'package:medipal/forms/medications.dart';
import 'package:medipal/pages/appointment_page.dart';
import 'package:medipal/pages/dashboard.dart';
import 'package:medipal/pages/patient_list.dart';
import 'package:medipal/pages/settings.dart';
import 'package:medipal/pages/patient_data.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/objects/navbar.dart';

class PatientForm extends StatefulWidget {
  final Patient patient;
  const PatientForm({super.key, required this.patient});

  @override
  PatientFormState createState() {
    return PatientFormState();
  }
}

class PatientFormState extends State<PatientForm> {
  // VARIABLES
  // page
  int _pageIndex = 0;
  final PageController _pageController = PageController();
  late List<Widget> _pages;
  // patient
  String _patientKey = '';
  late Patient _patient;
  // form golobal keys
  final GlobalKey<FormState> _generalInfoFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _healthConditionsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _medicationsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _familyFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _fileFormKey = GlobalKey<FormState>();
  // upload progress
  double uploadProgress = 0;
  String? uploadStatus;
  // nav bar
  int _selectedIndex = 2;
  final List<Widget> _pagesNav = [
    Dashboard(),
    PatientList(),
    PatientForm(patient: Patient()),
    AppointmentPage(),
    ChatList(),
    SettingsPage(),
  ];

  // initialize state
  @override
  void initState() {
    super.initState();
    _patient = widget.patient;
    _pages = [
      GeneralInfoForm(
        patient: _patient,
        formKey: _generalInfoFormKey,
      ),
      HealthConditionsForm(
        patient: _patient,
        formKey: _healthConditionsFormKey,
      ),
      MedicationsForm(
        patient: _patient,
        formKey: _medicationsFormKey,
      ),
      FamilyForm(
        patient: _patient,
        formKey: _familyFormKey,
      ),
      FileForm(
        patient: _patient,
        formKey: _fileFormKey,
        edit: true,
      ),
    ];
  }

  // FUNCTIONS
  // nav bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => _pagesNav[index]),
    );
  }

  // next
  void _nextPage() {
    if (_pageIndex < _pages.length - 1) {
      // validation check
      if (_currentPageIsValid()) {
        setState(() {
          _pageIndex++;
          _pageController.animateToPage(
            _pageIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      } else {
        // display error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fix errors before proceeding'),
          ),
        );
      }
    }
  }

  // prev
  void _previousPage() {
    if (_pageIndex < _pages.length - 1) {
      // validation check
      if (_currentPageIsValid()) {
        setState(() {
          if (_pageIndex > 0) {
            _pageIndex--;
            _pageController.animateToPage(
              _pageIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      } else {
        // display error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fix errors before proceeding'),
          ),
        );
      }
    }
  }

  // page validation check
  bool _currentPageIsValid() {
    switch (_pageIndex) {
      case 0: // GeneralInfoForm
        return _generalInfoFormKey.currentState!.validate();
      case 1: // HealthConditionsForm
        return _healthConditionsFormKey.currentState!.validate();
      // ...
      default:
        return true;
    }
  }

  // submission
  Future<void> uploadFiles() async {
    if (_patient.files.isEmpty) return;

    final storageRef = FirebaseStorage.instance.ref();

    for (int i = 0; i < _patient.files.length; i++) {
      FileData fileData = _patient.files[i];
      String fileName =
          fileData.name ?? 'file_$i'; // Use a default file name if not provided
      if (fileData.file == null) continue; // Skip if file is null
      final metadata = SettableMetadata(contentType: "image/jpeg");

      String path = 'patients/';
      if (_patient.id != null && _patient.id!.isNotEmpty) {
        // Existing patient, use ID in path
        path += '${_patient.id}/';
      }

      final uploadTask =
          storageRef.child(path + fileName).putFile(fileData.file!, metadata);

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        setState(() {
          uploadProgress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          uploadStatus = taskSnapshot.state == TaskState.running
              ? "Uploading..."
              : "Upload complete";
        });

        if (taskSnapshot.state == TaskState.success) {
          // Handle successful upload
          print("Upload of $fileName successful!");
        } else if (taskSnapshot.state == TaskState.error) {
          // Handle unsuccessful upload
          print("Upload of $fileName failed!");
        }
      });
    }
  }

  Future<void> uploadID() async {
    if (_patient.imageFile == null) return;

    final metadata = SettableMetadata(contentType: "image/jpeg");
    final storageRef = FirebaseStorage.instance.ref();
    final uploadTask = storageRef
        .child("patients/$_patientKey/idImage.jpg")
        .putFile(_patient.imageFile!, metadata);

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      setState(() {
        uploadProgress =
            100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
        uploadStatus = taskSnapshot.state == TaskState.running
            ? "Uploading..."
            : "Upload complete";
      });

      if (taskSnapshot.state == TaskState.success) {
        // Handle successful upload (e.g., navigate to next form)
        print("Upload successful!");
        // You can potentially navigate to the next form here
      } else if (taskSnapshot.state == TaskState.error) {
        // Handle unsuccessful upload
        print("Upload failed!");
        // Display error message to the user
      }
    });
  }

  Future<void> _submitForm() async {
    // Validate forms as before
    if (_generalInfoFormKey.currentState!.validate()) {
      // Check if patient ID is present
      if (widget.patient.id != null && widget.patient.id!.isNotEmpty) {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref('patient/${widget.patient.id}');
        ref.update(_patient.toJson()).then((_) {
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
      } else {
        // create new patient data
        DatabaseReference ref = FirebaseDatabase.instance.ref('patient');
        DatabaseReference newPatientRef = ref.push();
        setState(() {
          _patientKey = newPatientRef.key!;
          _pages.add(GetPatientData(patientId: _patientKey));
        });
        newPatientRef.set(_patient.toJson()).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Patient data added'),
            ),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error adding patient: $error'),
            ),
          );
        });
      }
      await uploadID();
      await uploadFiles();
    }
  }

  // build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Form'),
        flexibleSpace: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xFFBAD2FF),
                Color(0xFFBAD2FF),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _pageIndex = index;
                });
              },
              children: _pages,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xFFBAD2FF),
                  Color(0xFFBAD2FF),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F56DE),
                  ),
                  onPressed: _previousPage,
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F56DE),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F56DE),
                  ),
                  onPressed: _nextPage,
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}