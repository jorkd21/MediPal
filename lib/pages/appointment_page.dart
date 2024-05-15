import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medipal/constant/images.dart';
import 'package:medipal/objects/appointment.dart';
import 'package:medipal/objects/practitioner.dart';
import 'package:medipal/pages/appointment_date.dart';

class AppointmentPage extends StatefulWidget {
  final String? userUid;
  const AppointmentPage({super.key, required this.userUid,});

  @override
  AppointmentPageState createState() => AppointmentPageState();
}

class AppointmentPageState extends State<AppointmentPage> {
  late Future<Practitioner> _practitionerFuture = fetchPractitionerData();

  @override
  void initState() {
    super.initState();
  }

  Future<Practitioner> fetchPractitionerData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('users');
    DataSnapshot snapshot = await ref.child(widget.userUid!).get();
    if (snapshot.exists) {
      Map<dynamic, dynamic>? value = snapshot.value as Map<dynamic, dynamic>;
      return Practitioner.fromMap(value.cast<String, dynamic>());
    }
    return Practitioner();
  }

  void _refreshData() {
    setState(() {
      _practitionerFuture = fetchPractitionerData(); // Refetch data
    });
  }

  Future<void> _updatePractitioner(Practitioner p) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('users/${widget.userUid}');
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
                automaticallyImplyLeading: false,
                title: Text(
                  'Appointments',
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
                children: [
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
                            horizontal: 20, vertical: 15), // Button padding
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
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Appointments',
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
                  /*Container(
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Align(
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
                  ),*/
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
                                  color: Colors.white, // White background color
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
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        setState(() {});
                                        practitioner.appointments.remove(
                                            practitioner.appointments[index]);
                                        await _updatePractitioner(practitioner);
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
          );
        }
      },
    );
  }
}
