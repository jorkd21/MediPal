import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:medipal/objects/appointment.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/objects/practitioner.dart';
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
  bool _isWeekend = false;
  bool _timeselected = false;
  bool _isButtonDisabled = true;
  int? _currentIndex;
  String? _topic;
  String? _patient;

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
    if (_currentIndex != null && !_isWeekend) {
      // Calculate the start and end times based on the selected index
      DateTime startTime =
          DateTime(today.year, today.month, today.day, _currentIndex! + 9, 0);
      DateTime endTime =
          DateTime(today.year, today.month, today.day, _currentIndex! + 10, 0);
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
        content: Text(
            'Appointment added for $patientId at ${_currentIndex! + 9}:00'),
      ));
      // Clear the selected index
      setState(() {
        _currentIndex = null;
        _timeselected = false;
      });
      widget.refreshCallback(); // Call the refresh callback
      Navigator.pop(context); // pop back / not working
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

  @override
  Widget build(BuildContext context) {
    Widget appointmentWidget =
        _appointmentSelect(); // Create a widget variable for _appointmentSelect()

    return Scaffold(
      appBar: AppBar(
        title: Text("Date Selected: ${today.toString().split(" ")[0]}"),
        flexibleSpace: Container(
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
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                appointmentWidget, // Use the variable instead of method call because of 'Methods can't be invoked in constant expressions'
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Center(
                    child: Text(
                      'Select a Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isWeekend
              ? SliverToBoxAdapter(
                  //Message when no appointment times
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 40,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      //message style
                      'No Times Available For This Day',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                )
              : SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            _currentIndex = index;
                            _timeselected = true;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _currentIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color:
                                _currentIndex == index //color of buton pressed
                                    ? const Color.fromARGB(197, 29, 53, 161)
                                    : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            //times begin at 9 and increments by one for each button being created
                            '${index + 9}:00',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  _currentIndex == index ? Colors.white : null,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: 10, //number of buttons of times created
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5, //amount of buttons per row
                      childAspectRatio: 1.5), //size ratio of the buttons
                ),
          _isWeekend
              ? const SliverToBoxAdapter(
                  child: SizedBox
                      .shrink(), //creates the smallest box possible in place of null
                )
              : SliverToBoxAdapter(
                  //the submit button
                  child: Column(
                    children: [
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
                              _patient = '${newValue!.firstName} ${newValue.middleName} ${newValue.lastName}';
                            });
                          },
                          selectedItem: null,
                          itemAsString: (Patient patient) =>
                              '${patient.firstName} ${patient.middleName} ${patient.lastName}',
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Topic'),
                        onChanged: (value) {
                          setState(() {
                            _topic = value;
                          });
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 100),
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
                                    Color.fromARGB(
                                        197, 29, 53, 161), //button color
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
                                onPressed: //disables button if time is not picked or the day is not available
                                    _isButtonDisabled && _timeselected
                                        ? () => {_submitAppointment(_patient!)}
                                        : null,
                                style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(
                                        197, 29, 53, 161), //button color
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
                  ),
                ),
        ],
      ),
    );
  }

  Widget _appointmentSelect() {
    return SafeArea(
      child: TableCalendar(
        locale: "en_US", //laguage for the calendar
        rowHeight: 48,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        selectedDayPredicate: (daySelected) => isSameDay(daySelected, today),
        focusedDay: today,
        firstDay: DateTime.utc(2023, 1, 1),
        lastDay: DateTime.utc(2040, 1, 1),
        onDaySelected: (daySelected, focusedDay) {
          setState(() {
            today = daySelected;

            //checks if selected date is a weekend
            //can change to other days that the clinic is closed
            if (today.weekday == 6 || today.weekday == 7) {
              _isWeekend = true;
              _timeselected = false;
              _currentIndex = null;
              _isButtonDisabled = false;
            } else {
              _isWeekend = false;
              _isButtonDisabled = true;
            }
          });
        },
      ),
    );
  }
}
