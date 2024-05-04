import 'package:flutter/material.dart';
import 'package:medipal/constant/images.dart';
import 'package:medipal/pages/appointment_date.dart';

class Appointment {
  final String id;
  final String title;
  final DateTime dateTime;

  Appointment({
    required this.id,
    required this.title,
    required this.dateTime,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      title: map['title'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}

class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
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
                      Container(
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
                              'Next Appointments',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
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
                              child: const Text(
                                'April 10, 2024 - 10:00 AM',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue, // Blue background color
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Tue, Feb 5',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // goes to appointment_date.dart
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AppointmentDate()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 20), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Button border radius
                  ),
                ),
                child: const Text(
                  'Create Appointment',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
