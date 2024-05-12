import 'package:flutter/material.dart';

class AllPatientsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/PatientList');
      },
      child: Icon(
        Icons.list,
        color: Colors.white,
      ),
      backgroundColor: Color(0xFF003CD6), // Set background color if needed
    );
  }
}