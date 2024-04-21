import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medipal/constant/images.dart';
import 'package:medipal/main.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFb6c9ee), // Light blue at the top
                  Color(0xFFb6c9ee), // Light blue at the bottom
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Expanded(
                // Wrap the Column in Expanded
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.black, size: 40),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          child: Image.asset(
                            myImage,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 25),
                        Image.asset('assets/alert.png'),
                        SizedBox(width: 7), // Adjust the width as needed
                        Padding(
                          padding: EdgeInsets.only(
                              top: 3), // Adjust the top padding as needed
                          child: Text(
                            'Alerts',
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
                    SizedBox(height: 4),
                    Center(
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 35),
                        height: 150,
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 25),
                        Image.asset('assets/checkmarkCal.png'),
                        SizedBox(width: 7), // Adjust the width as needed
                        Padding(
                          padding: EdgeInsets.only(
                              top: 3), // Adjust the top padding as needed
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
                    SizedBox(height: 4),
                    Center(
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 35),
                        height: 150,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 25),
                        Image.asset('assets/patDashboard.png'),
                        SizedBox(width: 7), // Adjust the width as needed
                        Padding(
                          padding: EdgeInsets.only(
                              top: 3), // Adjust the top padding as needed
                          child: Text(
                            'My Patients',
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
                    SizedBox(height: 4),
                    Center(
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 35),
                        height: 150,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
