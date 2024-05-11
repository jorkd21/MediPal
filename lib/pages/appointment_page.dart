import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/chat/chat_list.dart';
import 'package:medipal/constant/images.dart';
import 'package:medipal/objects/appointment.dart';
import 'package:medipal/objects/practitioner.dart';
import 'package:medipal/pages/appointment_date.dart';
import 'package:medipal/pages/dashboard.dart' as dash;
import 'package:medipal/pages/patient_list.dart';
import 'package:medipal/pages/settings.dart';
import 'package:medipal/pages/patient_form.dart';

import '../objects/patient.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  late Future<Practitioner> _practitionerFuture = fetchPractitionerData();
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  Future<Practitioner> fetchPractitionerData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('users');
    DataSnapshot snapshot = await ref.child(_user!.uid).get();
    return Practitioner.fromSnapshot(snapshot);
  }

  void _refreshData() {
    setState(() {
      _practitionerFuture = fetchPractitionerData(); // Refetch data
    });
  }

  int _selectedIndex = 3;
  final List<Widget> _pages = [
    dash.Dashboard(),
    PatientList(),
    PatientForm(patient: Patient()),
    AppointmentPage(),
    ChatList(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  Future<void> _updatePractitioner(Practitioner p) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('users/${_user!.uid}');
    ref.update(p.toJson()).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment list updated'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating appointment list: $error'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Practitioner>(
      future: _practitionerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Practitioner practitioner = snapshot.data!;
          if (practitioner.appointments.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Appointments'),
              ),
              body: Column(
                children: [
                  Container(
                    width: 350,
                    height: 57,
                    child: ElevatedButton(
                      onPressed: () {
                        // goes to appointment_date.dart
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppointmentDate(
                                  refreshCallback: _refreshData)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF1F56DE), // Text color
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20), // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Button border radius
                        ),
                      ),
                      child: const Text(
                        'Create Appointment',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text('No appointments found.'),
                  ),
                ],
              ),
            );
          }
          practitioner.appointments
              .sort((a, b) => a.time!.start.compareTo(b.time!.start));
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0xFF6D98EB), // Light blue at the bottom
                            Color.fromARGB(255, 192, 212, 248), // White at top
                          ],
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Align logo and "Appointments" text at opposite ends
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.25),
                                  child: Text(
                                    'Appointments',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.5),
                                          offset: const Offset(0, 3),
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image.asset(
                                    myImage, // Replace with your image path
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            /* Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white, // White background color
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Next Appointment',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.grey.withOpacity(
                                              0.5), // Greyish blurred line
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.red, // Red background color
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${practitioner.appointments[0].topic} on ${practitioner.appointments[0].time!.start}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ), */
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 350,
                      height: 57,
                      child: ElevatedButton(
                        onPressed: () {
                          // goes to appointment_date.dart
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppointmentDate(
                                    refreshCallback: _refreshData)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF1F56DE), // Text color
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Button border radius
                          ),
                        ),
                        child: const Text(
                          'Create Appointment',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white, // White background color
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Upcoming Appointments',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.grey
                                      .withOpacity(0.5), // Greyish blurred line
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          // Display upcoming appointments
                          Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: practitioner.appointments.length,
                              itemBuilder: (context, index) {
                                practitioner.appointments.sort((a, b) =>
                                    a.time!.start.compareTo(b.time!.start));
                                Appointment appointment =
                                    practitioner.appointments[index];
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.white, // White background color
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween, // Align content and button
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            appointment
                                                .topic!, // Display appointment title
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          Text(
                                            appointment
                                                .patient!, // Display appointment title
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            appointment.time!.start
                                                .toString(), // Display appointment date and time
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () async {
                                          practitioner.appointments.remove(
                                              practitioner.appointments[index]);
                                          await _updatePractitioner(
                                              practitioner);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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
                    label: '+Patient',
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today), label: 'Schedule'),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat_bubble),
                    label: 'Chat',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
                onTap: _onItemTapped,
              ),
            ),
          );
        }
      },
    );
  }
}
