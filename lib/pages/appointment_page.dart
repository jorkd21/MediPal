import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/objects/appointment.dart';
import 'package:medipal/objects/practitioner.dart';
import 'package:medipal/pages/appointment_date.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medipal/pages/language_constants.dart';

class AppointmentPage extends StatefulWidget {
  final String? userUid;
  const AppointmentPage({
    super.key,
    required this.userUid,
  });

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
        SnackBar(
          content: Text(translation(context).appointmentListUpdated),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              translation(context).errorUpdatingAppointmentList + ': $error'),
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
          return const CircularProgressIndicator(); // Show loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text(translation(context).errorLabel + ': ${snapshot.error}');
        } else {
          Practitioner practitioner = snapshot.data!;
          if (practitioner.appointments.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  translation(context).appointments,
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
                  SizedBox(
                    width: 350,
                    height: 57,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppointmentDate(
                                  refreshCallback: _refreshData)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF1F56DE), // Text color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15), // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Button border radius
                        ),
                      ),
                      child: Text(
                        translation(context).createAppointment,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
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
                translation(context).appointments,
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 350,
                    height: 57,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppointmentDate(
                                  refreshCallback: _refreshData)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF1F56DE),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        translation(context).createAppointment,
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translation(context).upcomingAppointments,
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
                                color: Colors.grey.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        // Display upcoming appointments
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: practitioner.appointments.length,
                          itemBuilder: (context, index) {
                            practitioner.appointments.sort((a, b) =>
                                a.time!.start.compareTo(b.time!.start));
                            Appointment appointment =
                                practitioner.appointments[index];
                            return Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.person),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    setState(() {});
                                    practitioner.appointments.remove(
                                        practitioner.appointments[index]);
                                    await _updatePractitioner(practitioner);
                                  },
                                ),
                                title: Text(appointment.topic!),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(appointment.patient!),
                                    Text(appointment.time!.start.toString()),
                                  ],
                                ),
                                tileColor: const Color(0xFFDADFEC),
                              ),
                            );
                          },
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
