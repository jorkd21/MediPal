import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:medipal/forms/family.dart';
import 'package:medipal/forms/files.dart';
import 'package:medipal/forms/general_info.dart';
import 'package:medipal/forms/health_conditions.dart';
import 'package:medipal/forms/medications.dart';
import 'package:medipal/objects/patient.dart';

class PatientForm extends StatefulWidget {
  final Patient patient;
  const PatientForm({
    super.key,
    required this.patient,
  });

  @override
  PatientFormState createState() => PatientFormState();
}

class PatientFormState extends State<PatientForm> {
  // variables
  int _pageIndex = 0;
  final PageController _pageController = PageController();
  late List<Widget> _pages;
  final List<GlobalKey<FormState>> _formKeys = [
    for (int i = 0; i < 5; i++) GlobalKey<FormState>()
  ];

  @override
  void initState() {
    super.initState();
    _pages = [
      GeneralInfoForm(
        patient: widget.patient,
        formKey: _formKeys[0],
      ),
      HealthConditionsForm(
        patient: widget.patient,
        formKey: _formKeys[1],
      ),
      MedicationsForm(
        patient: widget.patient,
        formKey: _formKeys[2],
      ),
      FamilyForm(
        patient: widget.patient,
        formKey: _formKeys[3],
      ),
      FileForm(
        patient: widget.patient,
        formKey: _formKeys[4],
        edit: true,
      ),
    ];
  }

  // FUNCTIONS
  void _nextPage() {
    if (_pageIndex < _pages.length - 1) {
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
    if (_pageIndex > 0) {
      if (_currentPageIsValid()) {
        setState(() {
          _pageIndex--;
          _pageController.animateToPage(
            _pageIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      } else {
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
    return _formKeys[_pageIndex].currentState!.validate();
  }

  Future<void> _submitForm() async {
    if (_currentPageIsValid()) {
      if (widget.patient.id?.isNotEmpty == true) {
        // update existing patient
        if (widget.patient.id != null) {
          DatabaseReference ref =
              FirebaseDatabase.instance.ref('patient/${widget.patient.id}');
          ref.update(widget.patient.toJson()).then((_) {
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
        // create new patient data
        else {
          DatabaseReference ref = FirebaseDatabase.instance.ref('patient');
          DatabaseReference newPatientRef = ref.push();
          setState(() {
            widget.patient.id = newPatientRef.key!;
          });
          newPatientRef.set(widget.patient.toJson()).then((_) {
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
      }
      // files
      if (widget.patient.files.isEmpty) return;
      final storageRef = FirebaseStorage.instance.ref();
      String? uploadStatus;
      for (int i = 0; i < widget.patient.files.length; i++) {
        FileData fileData = widget.patient.files[i];
        String fileName = fileData.name ?? 'file_$i'; //
        if (fileData.file == null) continue; // Skip if file is null
        final metadata = SettableMetadata(contentType: "image/jpeg");
        String path = 'patients/';
        // existing patient path update
        if (widget.patient.id != null && widget.patient.id!.isNotEmpty) {
          path += '${widget.patient.id}/';
        }
        final uploadTask =
            storageRef.child(path + fileName).putFile(fileData.file!, metadata);
        uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
          setState(() {
            uploadStatus = taskSnapshot.state == TaskState.running
                ? "Uploading...(${(taskSnapshot.bytesTransferred / taskSnapshot.totalBytes).toStringAsFixed(1)}%)"
                : "Upload complete";
          });
          if (taskSnapshot.state == TaskState.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('File: ${fileData.name} added successfuly.'),
              ),
            );
          } else if (taskSnapshot.state == TaskState.running) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$uploadStatus'),
              ),
            );
          } else if (taskSnapshot.state == TaskState.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Upload of ${fileData.name} failed!'),
              ),
            );
          }
        });
      }
    }
  }

  // build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.patient.id == null ? false : true,
        title: Text(
          'Patient Form',
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
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Back',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: 'Submit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward),
            label: 'Next',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          if (index == 0) {
            _previousPage();
          } else if (index == 1) {
            _submitForm();
          } else if (index == 2) {
            _nextPage();
          }
        },
      ),
    );
  }
}
