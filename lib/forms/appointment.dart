import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:medipal/objects/appointment.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/objects/practitioner.dart'; // For date picker

class AppointmentForm extends StatefulWidget {
  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  late Practitioner _practitioner;
  late List<Patient> _patients = [];
  final User? user = FirebaseAuth.instance.currentUser;
  // Variables to hold user input
  String? _topic;
  String? _patient;
  DateTime? _startTime;
  DateTime? _endTime;
  @override
  void initState() {
    super.initState();
    _fetchPatientData();
    _getPractitioner();
  }

  void _sortLists() {
    _patients.sort((a, b) {
      return a.firstName!.compareTo(b.firstName!);
    });
    setState(() {});
  }

  void _fetchPatientData() async {
    // Initialize database
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    // Get snapshot
    DataSnapshot snapshot = await ref.child('patient').get();
    if (snapshot.value != null) {
      Map<dynamic, dynamic>? jsonMap = snapshot.value as Map<dynamic, dynamic>;
      List<Patient> pl = [];
      jsonMap.forEach((key, value) {
        Patient p = Patient.fromMap(value.cast<String, dynamic>());
        p.id = key;
        pl.add(p);
      });
      setState(() {
        _patients = pl;
      });
      _sortLists();
    }
  }

// Function to show date picker for start time
  void _showStartTimePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _startTime ?? DateTime.now(),
      firstDate: DateTime(2023, 1, 1),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _startTime = pickedDate;
      });
    }
  }

  void _getPractitioner() async {
    // initialize database
    DatabaseReference ref = FirebaseDatabase.instance.ref('users');
    // get snapshot
    DataSnapshot snapshot = await ref.child(user!.uid).get();
    // set state
    if (snapshot.exists) {
      Map<dynamic, dynamic>? value = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _practitioner = Practitioner.fromMap(value.cast<String, dynamic>());
      });
    }
  }

  Future<void> _submitForm() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user!.uid}');
    ref.update(_practitioner.toJson()).then((_) {
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

  // Function to show date picker for end time
  void _showEndTimePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _endTime ?? DateTime.now(),
      firstDate: DateTime(2023, 1, 1),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _endTime = pickedDate;
      });
    }
  }

  Widget _buildDatePicker(String labelText, DateTime? initialDate,
      Function(DateTime) onDateTimeSelected) {
    return Row(
      children: [
        TextButton(
          onPressed: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: initialDate ?? DateTime.now(),
              firstDate: DateTime(2023, 1, 1),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              onDateTimeSelected(pickedDate);
            }
            if (pickedDate != null) {
              final combinedDateTime = DateTime(
                initialDate!.year,
                initialDate.month,
                initialDate.day,
                pickedDate.hour,
                pickedDate.minute,
              );
              onDateTimeSelected(combinedDateTime);
            }
          },
          child: const Icon(Icons.calendar_today),
        ),
        SizedBox(width: 10.0), // Add spacing between the input and button
        TextButton(
          onPressed: () async {
            final pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (pickedTime != null) {
              final combinedDateTime = DateTime(
                initialDate!.year,
                initialDate.month,
                initialDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
              onDateTimeSelected(combinedDateTime);
            }
          },
          child: const Icon(Icons.access_time),
        ),
      ],
    );
  }

  /* Widget _buildDatePicker(String labelText, DateTime? initialDate,
      Function(DateTime) onDateSelected) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: initialDate ?? DateTime.now(),
                firstDate: DateTime(2023, 1, 1),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                onDateSelected(pickedDate);
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: labelText,
                hintText: initialDate != null
                    ? DateFormat('yyyy-MM-dd HH:mm').format(initialDate)
                    : 'Select $labelText',
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Icon(Icons.calendar_today),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.0), // Add spacing between the input and button
        TextButton(
          onPressed: () {
            if (labelText == 'Start Time') {
              _showStartTimePicker();
            } else {
              _showEndTimePicker();
            }
          },
          child: Text(
            labelText == 'Start Time' ? 'Start' : 'End',
            style: TextStyle(color: Colors.blue), // Optional: Style the button text
          ),
        ),
      ],
    );
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Appointment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDatePicker('Start Time', _startTime,
                (date) => setState(() => _startTime = date)),
            SizedBox(height: 20.0),
            _buildDatePicker('End Time', _endTime,
                (date) => setState(() => _endTime = date)),
            TextField(
              decoration: InputDecoration(labelText: 'Topic'),
              onChanged: (value) {
                setState(() {
                  _topic = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            /* TextField(
              decoration: InputDecoration(labelText: 'Patient'),
              onChanged: (value) {
                setState(() {
                  _patient = value;
                });
              },
            ), */
            Padding(
              padding: const EdgeInsets.all(15),
              child: DropdownSearch<Patient>(
                //dropdown search
                popupProps: const PopupProps.bottomSheet(
                  showSearchBox: true,
                ),
                items: _patients, // Set items to fetched patient data
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Select a Patient",
                  ),
                ),
                onChanged: (Patient? newValue) {
                  setState(() {
                    _patient = newValue!.id;
                  });
                },
                selectedItem: null,
                itemAsString: (Patient patient) =>
                    '${patient.firstName} ${patient.middleName} ${patient.lastName}',
              ),
            ),
            SizedBox(height: 20.0),
            /* Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _showStartTimePicker,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Start Time',
                        hintText: _startTime != null
                            ? DateFormat('yyyy-MM-dd HH:mm').format(_startTime!)
                            : 'Select start time',
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: InkWell(
                    onTap: _showEndTimePicker,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'End Time',
                        hintText: _endTime != null
                            ? DateFormat('yyyy-MM-dd HH:mm').format(_endTime!)
                            : 'Select end time',
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0), */
            ElevatedButton(
              onPressed: () {
                // Create and save the appointment
                if (_topic != null &&
                    _patient != null &&
                    _startTime != null &&
                    _endTime != null) {
                  setState(() {
                    _practitioner.appointments.add(
                      Appointment(
                        topic: _topic,
                        patient: _patient,
                        time: DateTimeRange(start: _startTime!, end: _endTime!),
                      ),
                    );
                  });
                  _submitForm();
                  Navigator.pop(
                    context,
                  );
                } else {
                  // Show error message if any field is missing
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill out all fields.'),
                    ),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
