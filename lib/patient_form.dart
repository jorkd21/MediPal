import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:medipal/chat/chat_list.dart';
import 'package:medipal/forms/family.dart';
import 'package:medipal/forms/files.dart';
import 'package:medipal/forms/files_list.dart';
import 'package:medipal/forms/general_info.dart';
import 'package:medipal/forms/health_conditions.dart';
import 'package:medipal/forms/medications.dart';
import 'package:medipal/pages/appointment_page.dart';
import 'package:medipal/pages/dashboard.dart';
import 'package:medipal/pages/patient_list.dart';
import 'package:medipal/patient_data.dart';
import 'package:medipal/objects/patient.dart';

class PatientForm extends StatefulWidget {
  final Patient patient;
  const PatientForm({super.key, required this.patient});

  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  int _pageIndex = 0;
  final PageController _pageController = PageController();
  late List<Widget> _pages;
  String _patientKey = '';
  late Patient _patient;
  // Create separate global keys for each form
  final GlobalKey<FormState> _generalInfoFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _healthConditionsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _medicationsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _familyFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _fileFormKey = GlobalKey<FormState>();
  //
  double uploadProgress = 0;
  String? uploadStatus;

  int _selectedIndex = 2;
  final List<Widget> _pagesNav = [
    Dashboard(),
    PatientList(),
    PatientForm(patient: Patient()),
    AppointmentPage(),
    ChatList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => _pagesNav[index]),);
  }


  // initialize state
  @override
  void initState() {
    super.initState();
    _patient = widget.patient; // Create patient object
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
      if (_patient.id == null)
        FileForm(
          patient: _patient,
          formKey: _fileFormKey,
        ),
      if (_patient.id != null)
        FilesListPage(
          patientId: _patient.id!,
        ),
    ];
  }

  void _nextPage() {
    setState(() {
      if (_pageIndex < _pages.length - 1) {
        _pageIndex++;
        _pageController.animateToPage(
          _pageIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _previousPage() {
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
  }

  Future<void> uploadFiles() async {
    if (_patient.files == null || _patient.files!.isEmpty) return;

    final storageRef = FirebaseStorage.instance.ref();

    for (int i = 0; i < _patient.files!.length; i++) {
      FileData fileData = _patient.files![i];
      String fileName =
          fileData.name ?? 'file_$i'; // Use a default file name if not provided
      if (fileData.file == null) continue; // Skip if file is null
      final metadata = SettableMetadata(contentType: "image/jpeg");

      final uploadTask = storageRef
          .child("patients/$_patientKey/$fileName")
          .putFile(fileData.file!, metadata); // Use ! to assert non-nullability

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
    if (_generalInfoFormKey.currentState!
            .validate() /*&&
        _healthConditionsFormKey.currentState!.validate() &&
        _medicationsFormKey.currentState!.validate() */
        ) {
      // Check if patient ID is present (widget.patient.id)
      if (widget.patient.id != null && widget.patient.id!.isNotEmpty) {
        // Update existing patient data
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
        // Create new patient data (existing functionality)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Form'),
        flexibleSpace: Container(
          //appbar container
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xFFBAA2DA), // Light blue at the bottom
                Color.fromARGB(255, 228, 192, 248), // White at top
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFF6D98EB), // Light blue at the bottom
              Color(0xFFBAA2DA), // Purple at the top
            ],
          ),
        ),
        child: Column(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _previousPage,
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Patients',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              label: 'Add Patient',
            ),   
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), 
              label: 'Appntments'),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
        ),
    );
  }
}
