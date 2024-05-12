import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:medipal/forms/family.dart';
import 'package:medipal/forms/files.dart';
import 'package:medipal/forms/general_info.dart';
import 'package:medipal/forms/health_conditions.dart';
import 'package:medipal/forms/medications.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/objects/navbar.dart';

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
  // VARIABLES
  // page
  int _pageIndex = 0;
  final PageController _pageController = PageController();
  late List<Widget> _pages;
  // form golobal keys
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  // upload progress
  double uploadProgress = 0;
  String? uploadStatus;

  // initialize state
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
    if (_pageIndex > 0) {
      // validation check
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
    return _formKeys[_pageIndex].currentState!.validate();
  }

  // submission
  Future<void> uploadFiles() async {
    if (widget.patient.files.isEmpty) return;

    final storageRef = FirebaseStorage.instance.ref();

    for (int i = 0; i < widget.patient.files.length; i++) {
      FileData fileData = widget.patient.files[i];
      String fileName =
          fileData.name ?? 'file_$i'; // Use a default file name if not provided
      if (fileData.file == null) continue; // Skip if file is null
      final metadata = SettableMetadata(contentType: "image/jpeg");

      String path = 'patients/';
      if (widget.patient.id != null && widget.patient.id!.isNotEmpty) {
        // Existing patient, use ID in path
        path += '${widget.patient.id}/';
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
    if (widget.patient.imageFile == null) return;

    final metadata = SettableMetadata(contentType: "image/jpeg");
    final storageRef = FirebaseStorage.instance.ref();
    final uploadTask = storageRef
        .child("patients/${widget.patient.id}}/idImage.jpg")
        .putFile(widget.patient.imageFile!, metadata);

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      setState(() {
        uploadProgress =
            100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
        uploadStatus = taskSnapshot.state == TaskState.running
            ? "Uploading..."
            : "Upload complete";
      });

      if (taskSnapshot.state == TaskState.success) {
        print("Upload successful!");
      } else if (taskSnapshot.state == TaskState.error) {
        print("Upload failed!");
      }
    });
  }

  Future<void> _submitForm() async {
    // Validate forms as before
    if (_currentPageIsValid()) {
      if (widget.patient.id?.isNotEmpty == true) {
        // Check if patient ID is present
        if (widget.patient.id != null && widget.patient.id!.isNotEmpty) {
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
        } else {
          // create new patient data
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
        ],
      ),
      ),
    );
  }
}
