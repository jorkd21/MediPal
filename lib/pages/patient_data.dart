import 'dart:js';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:medipal/constant/images.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/pages/language_constants.dart';

class DisplayPatient extends StatefulWidget {
  final String patientId;

  const DisplayPatient({
    super.key,
    required this.patientId,
  });

  @override
  DisplayPatientState createState() => DisplayPatientState();
}

class DisplayPatientState extends State<DisplayPatient> {
  // VARIABLES
  Patient? _patient;
  String? _imageID;

  // CONSTRUCTOR
  DisplayPatientState();
  // initialize
  @override
  void initState() {
    super.initState();
    _fetchPatient();
  }

  void _fetchPatient() async {
    Patient? patient = await Patient.getPatient(widget.patientId);
    final storageRef = FirebaseStorage.instance.ref();
    setState(() {
      _patient = patient!;
    });
    final downloadUrl = await storageRef
        .child("patients/${widget.patientId}/idImage")
        .getDownloadURL();
    setState(() {
      _imageID = downloadUrl;
    });
  }

  // build
  @override
  Widget build(BuildContext context) {
    return _patient != null
        ? Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: Text(
                translation(context).patientRecord,
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color.fromARGB(255, 151, 183, 247),
                          Color.fromARGB(255, 192, 212, 248),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 200,
                    child: Center(
                        child: _imageID != null
                            ? Image.network(
                                _imageID!,
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                              )
                            : const CircularProgressIndicator()),
                  ),
                  const SizedBox(
                    height: 8.47,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_patient!.firstName ?? ''} ${_patient!.middleName ?? ''} ${_patient!.lastName ?? ''}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 21.64,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_patient!.sex}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF7B7B7B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 23.24,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFDADFEC),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        // General info
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 21.82, left: 27),
                              child: Text(
                                translation(context).generalInformation,
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
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 18.92, left: 30),
                                child: Text(
                                  i == 0
                                      ? translation(context).dateOfBirth
                                      : i == 1
                                          ? translation(context).location
                                          : i == 2
                                              ? translation(context).id
                                              : i == 3
                                                  ? translation(context)
                                                      .bloodType
                                                  : translation(context)
                                                      .maritalStatus,
                                  style: const TextStyle(
                                    color: Color(0xFF7B7B7B),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 18.92, right: 30),
                                  child: Text(
                                    i == 0
                                        ? '${_patient!.dob?.day}/${_patient!.dob?.month}/${_patient!.dob?.year}'
                                        : i == 1
                                            ? '${_patient!.location}'
                                            : i == 2
                                                ? ''
                                                : i == 3
                                                    ? '${_patient!.bloodGroup}${_patient!.rhFactor}'
                                                    : translation(context)
                                                        .married,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 23.01),
                        // Contact Display Section
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 21.82, left: 27),
                              child: Text(
                                translation(context).contactInformation,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Phone
                        for (int i = 0; i < _patient!.phone.length; i++)
                          if (_patient!.phone[i].phoneNumber != null)
                            Row(
                              children: [
                                if (i == 0)
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 18.92, left: 30),
                                    child: Text(
                                      translation(context).phone,
                                      style: TextStyle(
                                        color: Color(0xFF7B7B7B),
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 18.92, right: 30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          _patient!.phone[i].type ?? 'N/A',
                                          style: const TextStyle(
                                            color: Color(0xFF7B7B7B),
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          _patient!.phone[i].phoneNumber!,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        // Emergancy Contact Information
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 21.82, left: 27),
                              child: Text(
                                translation(context)
                                    .emergencyContactInformation,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Emergency
                        for (int i = 0; i < _patient!.emergency.length; i++)
                          if (_patient!.emergency[i].phoneNumber != null)
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 18.92, left: 30),
                                  child: Text(
                                    _patient!.emergency[i].name ?? 'N/A',
                                    style: const TextStyle(
                                      color: Color(0xFF7B7B7B),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 18.92, right: 30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          _patient!.emergency[i].type ?? 'N/A',
                                          style: const TextStyle(
                                            color: Color(0xFF7B7B7B),
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          _patient!.emergency[i].phoneNumber!,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                        // Health Conditions
                        const SizedBox(height: 23.01),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 21.82, left: 27),
                              child: Text(
                                translation(context).healthConditions,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Current Illnesses
                        for (int i = 0; i < _patient!.currIllness.length; i++)
                          Row(
                            children: [
                              if (i == 0)
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 18.92, left: 30),
                                  child: Text(
                                    translation(context).currentIllness,
                                    style: TextStyle(
                                      color: Color(0xFF7B7B7B),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 18.92, right: 30),
                                  child: Text(
                                    _patient!.currIllness[i],
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 23.01),
                        // Previous Illnesses
                        for (int i = 0; i < _patient!.prevIllness.length; i++)
                          Row(
                            children: [
                              if (i == 0)
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 18.92, left: 30),
                                  child: Text(
                                    translation(context).previousIllness,
                                    style: TextStyle(
                                      color: Color(0xFF7B7B7B),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 18.92, right: 30),
                                  child: Text(
                                    _patient!.prevIllness[i],
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        // Allergies
                        for (int i = 0; i < _patient!.allergies.length; i++)
                          Row(
                            children: [
                              if (i == 0)
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 18.92, left: 30),
                                  child: Text(
                                    translation(context).allergies,
                                    style: TextStyle(
                                      color: Color(0xFF7B7B7B),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 18.92, right: 30),
                                  child: Text(
                                    _patient!.allergies[i],
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 23.01),
                        // Medications
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 21.82, left: 27),
                              child: Text(
                                translation(context).medications,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Current Medications
                        for (int i = 0;
                            i < _patient!.currMedications.length;
                            i++)
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 18.92, left: 30),
                                child: Text(
                                  translation(context).currentMedications,
                                  style: TextStyle(
                                    color: Color(0xFF7B7B7B),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 18.92, right: 30),
                                  child: Text(
                                    _patient!.currMedications[i],
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        // Previous Medications
                        for (int i = 0;
                            i < _patient!.prevMedications.length;
                            i++)
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 18.92, left: 30),
                                child: Text(
                                  translation(context).previousMedications,
                                  style: TextStyle(
                                    color: Color(0xFF7B7B7B),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 18.92, right: 30),
                                  child: Text(
                                    _patient!.prevMedications[i],
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
