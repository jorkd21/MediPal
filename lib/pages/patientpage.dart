import 'dart:ui';
import 'package:medipal/objects/patient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medipal/constant/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medipal/main.dart';
import 'package:medipal/pages/signup.dart';
import 'package:medipal/pages/forgotpasswd.dart';

class PatientPage extends StatelessWidget {

  //final Patient patient;
  //PatientPage({required this.patient});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color.fromARGB(255, 151, 183, 247), // Light blue at the bottom
                      Color.fromARGB(255, 192, 212, 248), // White at top
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.black, size: 40),
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
                      SizedBox(height: 34),
                      Row(
                        children: [ 
                          Image.asset(
                            myCal,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.25),
                            child: Text(
                              'Patient Record',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(0, 3),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    profilePic,
                  ),
                ],
              ),
              SizedBox(height: 8.47,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Name of Patient', //${patient.firstName ?? ''} ${patient.middleName ?? ''} ${patient.lastName ?? ''}
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 21.64,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF7B7B7B),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 23.24,),  
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFDADFEC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 21.82, left: 27),
                              child: Text(
                                'General info',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ),
                        ],
                      ),
                      for (int i = 0; i < 5; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, left: 30),
                            child: Text(
                              i == 0 ? 'Date of birth' : i == 1 ? 'Location' : i == 2 ? 'Id' : i == 3 ? 'Blood type' : 'Marital status',
                              style: TextStyle(
                                color: Color(0xFF7B7B7B),
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, right: 111),
                            child: Text(
                              i == 0 ? '08/12/1986' : i == 1 ? 'United States' : i == 2 ? '0000-0026' : i == 3 ? 'O+' : 'Married',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                        SizedBox(height: 23.01),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 21.82, left: 27),
                              child: Text(
                                'Recent Diagnosis',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (int i = 0; i < 2; i++)
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, left: 30),
                            child: Text(
                              i == 0 ? 'Date of diagnosis' : 'Date of diagnosis',
                              style: TextStyle(
                                color: Color(0xFF7B7B7B),
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, right: 111),
                            child: Text(
                              i == 0 ? 'lorem ipsum' : 'lorem ipsum',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.91),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 25.91, left: 27),
                            child: Text(
                              'Disorders',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (int i = 0; i < 2; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, left: 30),
                            child: Text(
                              i == 0 ? 'Illness' : 'Alergy',
                              style: TextStyle(
                                color: Color(0xFF7B7B7B),
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, right: 111),
                            child: Text(
                              i == 0 ? 'Polio' : 'Lactose intolerance',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.91),   
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 21.82, left: 27),
                            child: Text(
                              'Immunizations',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (int i = 0; i < 4; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, left: 30),
                            child: Text(
                              i == 0 ? 'Tuberculosis' : i == 1 ? 'Influenza' : i == 2 ? 'Malaria' : 'Dengue',
                              style: TextStyle(
                                color: Color(0xFF7B7B7B),
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, right: 111),
                            child: Text(
                              i == 0 ? 'Updated' : i == 1 ? 'Updated' : i == 2 ? 'Updated' : 'Booster needed',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.91), 
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 21.82, left: 27),
                            child: Text(
                              'Lab Work',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (int i = 0; i < 2; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, left: 30),
                            child: Text(
                              i == 0 ? 'Blood tests' : 'X-Rays',
                              style: TextStyle(
                                color: Color(0xFF7B7B7B),
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, right: 111),
                            child: Text(
                              i == 0 ? 'RH testing' : 'Spinal scan',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.91), 
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
  
}
