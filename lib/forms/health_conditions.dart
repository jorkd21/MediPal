// Create a Form widget.
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/forms/input_template.dart';
import 'package:medipal/objects/patient.dart';

class HealthConditionsForm extends StatefulWidget {
  final Patient patient;
  final GlobalKey<FormState> formKey;
  const HealthConditionsForm({super.key, required this.patient, required this.formKey});

  @override
  HealthConditionsFormState createState() {
    return HealthConditionsFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class HealthConditionsFormState extends State<HealthConditionsForm> {
  // database connection
  DatabaseReference ref =
      FirebaseDatabase.instance.ref('test/patient/conditions');
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the widget.formKey created above.
    return ListView(
      children: [
        Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Current Illness'),
              Column(
                children: [
                  ...List.generate(widget.patient.currIllness!.length, (index) {
                    String? illness = widget.patient.currIllness![index];
                    return buildTextFormField(
                      labelText: 'illness',
                      value: illness,
                      onChanged: (value) {
                        widget.patient.currIllness![index] = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSuffixIconTap: index == 0
                          ? null
                          : () => removeField(widget.patient.currIllness, index),
                    );
                  }),
                  ///Add more button
                  Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {
                            addField(widget.patient.currIllness, '');
                          },
                          child: const Text("Add More"))),
                ],
              ),
              const Text('Previous Illness'),
              Column(
                children: [
                  ...List.generate(widget.patient.prevIllness!.length, (index) {
                    String? illness = widget.patient.prevIllness![index];
                    return buildTextFormField(
                      labelText: 'illness',
                      value: illness,
                      onChanged: (value) {
                        widget.patient.prevIllness![index] = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSuffixIconTap: index == 0
                          ? null
                          : () => removeField(widget.patient.prevIllness, index),
                    );
                  }),
                  ///Add more button
                  Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {
                            addField(widget.patient.prevIllness, '');
                          },
                          child: const Text("Add More"))),
                ],
              ),
              const Text('Specific allergies'),
              Column(
                children: [
                  ...List.generate(widget.patient.allergies!.length, (index) {
                    String? illness = widget.patient.allergies![index];
                    return buildTextFormField(
                      labelText: 'allergy',
                      value: illness,
                      onChanged: (value) {
                        widget.patient.allergies![index] = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSuffixIconTap: index == 0
                          ? null
                          : () => removeField(widget.patient.allergies, index),
                    );
                  }),
                  ///Add more button
                  Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {
                            addField(widget.patient.allergies, '');
                          },
                          child: const Text("Add More"))),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  addField(List<dynamic>? list, dynamic value) {
    list!.add(value);
    setState(() {});
  }

  removeField(List<dynamic>? list, int index) {
    if (list != null && index < list.length) {
      list.removeAt(index);
      setState(() {});
    }
  }
}
