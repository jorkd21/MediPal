import 'package:flutter/material.dart';
import 'package:medipal/objects/practitioner.dart';

class PractitionerPage extends StatefulWidget {
  final Practitioner practitioner;

  const PractitionerPage({
    super.key,
    required this.practitioner,
  });

  @override
  PractitionerPageState createState() => PractitionerPageState();
}

class PractitionerPageState extends State<PractitionerPage> {
  // CONSTRUCTOR
  PractitionerPageState();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(),
    );
  }
}

