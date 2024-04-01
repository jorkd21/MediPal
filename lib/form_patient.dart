import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/forms/general_info.dart';
import 'package:medipal/forms/health_conditions.dart';
import 'package:medipal/objects/patient.dart';

class PatientForm extends StatefulWidget {
  const PatientForm({super.key});

  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  int _pageIndex = 0;
  final PageController _pageController = PageController();
  late List<Widget> _pages;
  late String _patientKey;
  late Patient _patient;
  // database connection
  DatabaseReference ref = FirebaseDatabase.instance.ref('patient');
  // Create separate global keys for each form
  final GlobalKey<FormState> _generalInfoFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _healthConditionsFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _patientKey = UniqueKey().toString(); // Generate unique patient key
    _patient = Patient(); // Create patient object
    _pages = [
      GeneralInfoForm(patient: _patient, formKey: _generalInfoFormKey),
      HealthConditionsForm(
          patient: _patient, formKey: _healthConditionsFormKey),
      NextForm(),
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

  void _submitForm() {
    // Validate returns true if the form is valid, or false otherwise.
    if (_generalInfoFormKey.currentState!.validate() /* &&  _healthConditionsFormKey.currentState!.validate() */ ) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      //DatabaseReference newPatientRef = ref.child(_patientKey);
      DatabaseReference newPatientRef = ref.push();
      newPatientRef.set(_patient.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Form'),
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
    );
  }
}

class NextForm extends StatelessWidget {
  const NextForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Next Form'),
    );
  }
}
