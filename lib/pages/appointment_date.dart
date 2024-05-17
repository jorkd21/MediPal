import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:medipal/objects/appointment.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/objects/practitioner.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentSelect extends StatefulWidget {
  final Function refreshCallback;
  const AppointmentSelect({
    super.key,
    required this.refreshCallback,
  });

  @override
  State<AppointmentSelect> createState() => AppointmentSelectState();
}

class AppointmentSelectState extends State<AppointmentSelect> {
  late Practitioner? _practitioner;
  late List<Patient>? _patients = [];
  final User? _user = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  DateTime _today = DateTime.now();
  String? _topic;
  String? _patient;
  int _hour = 0;
  int _minute = 0;

  @override
  void initState() {
    super.initState();
    _fetchPatientsData();
    _fetchPractitioner();
  }

  void _fetchPatientsData() async {
    List<Patient>? pl = await Patient.getAllPatients();
    pl!.sort((a, b) {
      return a.firstName!.compareTo(b.firstName!);
    });
    setState(() {
      _patients = pl;
    });
  }

  void _fetchPractitioner() async {
    Practitioner? p = await Practitioner.getPractitioner(_user!.uid);
    setState(() {
      _practitioner = p;
    });
  }

  void _submitAppointment(String patientId) {
    if (_patient == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a patient'),
      ));
    }
    if (_formkey.currentState!.validate()) {
      DateTime startTime =
          DateTime(_today.year, _today.month, _today.day, _hour, _minute);
      DateTime endTime =
          DateTime(_today.year, _today.month, _today.day, _hour + 1, _minute);
      setState(() {
        _practitioner!.appointments.add(
          Appointment(
            topic: _topic,
            patient: patientId,
            time: DateTimeRange(start: startTime, end: endTime),
          ),
        );
      });
      // submit form
      DatabaseReference ref =
          FirebaseDatabase.instance.ref('users/${_user!.uid}');
      ref.update(_practitioner!.toJson()).then((_) {
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Appointment added for $patientId at $_hour:$_minute'),
      ));
      setState(() {
        _patient = null;
        _topic = null;
      });
      widget.refreshCallback();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            "Date Selected: ${_today.toString().split(" ")[0]}",
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
              locale: "en_US",
              rowHeight: 48,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              selectedDayPredicate: (daySelected) =>
                  isSameDay(daySelected, _today),
              focusedDay: _today,
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2040, 1, 1),
              onDaySelected: (daySelected, focusedDay) {
                setState(() {
                  _today = daySelected;
                });
              },
            ),
            Text(
                "Time Selected: ${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, "0")}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
              decoration: BoxDecoration(
                  color: const Color(0xFFDADFEC),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NumberPicker(
                    minValue: 0,
                    maxValue: 23,
                    value: _hour,
                    zeroPad: true,
                    infiniteLoop: true,
                    itemWidth: 60,
                    itemHeight: 40,
                    onChanged: (value) {
                      setState(() {
                        _hour = value;
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
                    value: _minute,
                    zeroPad: true,
                    infiniteLoop: true,
                    itemWidth: 60,
                    itemHeight: 40,
                    onChanged: (value) {
                      setState(() {
                        _minute = value;
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
                items: _patients!,
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
            Form(
              key: _formkey,
              child: TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Reason for Appointment'),
                onChanged: (value) {
                  setState(() {
                    _topic = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
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
