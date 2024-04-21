import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:medipal/objects/appointment_patient.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentDate extends StatefulWidget {
  const AppointmentDate({super.key});

  @override
  State<AppointmentDate> createState() => _AppointmentDateState();
}

class _AppointmentDateState extends State<AppointmentDate> {
  DateTime today = DateTime.now();
  bool _isWeekend = false;
  bool _timeselected = false;
  bool _isButtonDisabled = true;
  int? _currentIndex;

  late List<Patient> _patients = [];

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
        //print(p);
        pl.add(p);
      });
      setState(() {
        _patients = pl;
      }); // Trigger rebuild to load patient data
    }
  }

  Future<void> addAppointment(String name) async {
    try {
      await FirebaseFirestore.instance.collection('appointments').add({
        'name': name,
        // Add additional fields as needed
      });
      print('Appointment added successfully');
    } catch (error) {
      print('Error: $error');
    }
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
                            // Handle when a new value is selected
                          },
                          selectedItem: null,
                        ),
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
                                        ? () => {}
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
