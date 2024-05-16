import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:medipal/objects/appointment.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/objects/practitioner.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentDate extends StatefulWidget {
  final Function refreshCallback; // Receive callback function
  const AppointmentDate({super.key, required this.refreshCallback});

  @override
  State<AppointmentDate> createState() => _AppointmentDateState();
}

class _AppointmentDateState extends State<AppointmentDate> {
  late Practitioner _practitioner;
  late List<Patient> _patients = [];
  final User? user = FirebaseAuth.instance.currentUser;

  DateTime today = DateTime.now();
  int? _currentIndex;
  String? _topic;
  String? _patient;
  var hour = 0;
  var minute = 0;

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

  void _submitAppointment(String patientId) {
    // Calculate the start and end times based on the selected index
    DateTime startTime =
        DateTime(today.year, today.month, today.day, hour, minute);
    DateTime endTime =
        DateTime(today.year, today.month, today.day, hour + 1, minute);
    setState(() {
      _practitioner.appointments.add(
        Appointment(
          topic: _topic, // You can set the topic as needed
          patient: patientId,
          time: DateTimeRange(start: startTime, end: endTime),
        ),
      );
    });
    _submitForm();

    // Show a confirmation message or navigate to another screen if needed
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Appointment added for $patientId at $hour:$minute'),
    ));
    // Clear the selected index
    setState(() {
      _currentIndex = null;
    });
    widget.refreshCallback(); // Call the refresh callback
    Navigator.pop(context); // pop back / not working
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            "Date Selected: ${today.toString().split(" ")[0]}",
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
        body: SingleChildScrollView(
            child: Column(
          children: [
            TableCalendar(
              locale: "en_US", //language for the calendar
              rowHeight: 48,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              selectedDayPredicate: (daySelected) =>
                  isSameDay(daySelected, today),
              focusedDay: today,
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2040, 1, 1),
              onDaySelected: (daySelected, focusedDay) {
                setState(() {
                  today = daySelected;
                });
              },
            ),
            Text(
                "Time Selected: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, "0")}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
              decoration: BoxDecoration(
                  color: Color(0xFFDADFEC),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NumberPicker(
                    minValue: 0,
                    maxValue: 23,
                    value: hour,
                    zeroPad: true,
                    infiniteLoop: true,
                    itemWidth: 60,
                    itemHeight: 40,
                    onChanged: (value) {
                      setState(() {
                        hour = value;
                      });
                    },
                    textStyle:
                        const TextStyle(color: Colors.black, fontSize: 10),
                    selectedTextStyle:
                        const TextStyle(color: Colors.black, fontSize: 20),
                    decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.black),
                          bottom: BorderSide(color: Colors.black)),
                    ),
                  ),
                  NumberPicker(
                    minValue: 0,
                    maxValue: 59,
                    value: minute,
                    zeroPad: true,
                    infiniteLoop: true,
                    itemWidth: 60,
                    itemHeight: 40,
                    onChanged: (value) {
                      setState(() {
                        minute = value;
                      });
                    },
                    textStyle:
                        const TextStyle(color: Colors.black, fontSize: 10),
                    selectedTextStyle:
                        const TextStyle(color: Colors.black, fontSize: 20),
                    decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(
                            color: Colors.black,
                          ),
                          bottom: BorderSide(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
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
                    _patient =
                        '${newValue!.firstName} ${newValue.middleName} ${newValue.lastName}';
                  });
                },
                selectedItem: null,
                itemAsString: (Patient patient) =>
                    '${patient.firstName} ${patient.middleName} ${patient.lastName}',
              ),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Reason'),
              onChanged: (value) {
                setState(() {
                  _topic = value;
                });
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => {
                        Navigator.of(context).pop(),
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color(0xFF1F56DE) //button color
                            ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          {_submitAppointment(_patient!), setState(() {})},
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color(0xFF1F56DE) //button color
                            ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )));
  }
}
