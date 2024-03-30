// Create a Form widget.
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/forms/input_template.dart';
import 'package:medipal/objects/patient.dart';

class HealthConditionsForm extends StatefulWidget {
  const HealthConditionsForm({super.key});

  @override
  HealthConditionsFormState createState() {
    return HealthConditionsFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class HealthConditionsFormState extends State<HealthConditionsForm> {
  final _formKey = GlobalKey<FormState>();
  Patient _patient = Patient();
  // database connection
  DatabaseReference ref =
      FirebaseDatabase.instance.ref('test/patient/conditions');
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return ListView(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Illness'),
              Column(
                children: [
                  ...List.generate(_patient.currIllness!.length, (index) {
                    String? illness = _patient.currIllness![index];
                    return buildTextFormField(
                      labelText: 'illness',
                      value: illness,
                      onChanged: (value) {
                        _patient.currIllness![index] = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSuffixIconTap: index == 0
                          ? null
                          : () => removeField(_patient.currIllness, index),
                    );
                  }),
                  ///Add more button
                  Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {
                            addField(_patient.currIllness, '');
                          },
                          child: const Text("Add More"))),
                ],
              ),
              Text('Previous Illness'),
              Column(
                children: [
                  ...List.generate(_patient.prevIllness!.length, (index) {
                    String? illness = _patient.prevIllness![index];
                    return buildTextFormField(
                      labelText: 'illness',
                      value: illness,
                      onChanged: (value) {
                        _patient.prevIllness![index] = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSuffixIconTap: index == 0
                          ? null
                          : () => removeField(_patient.prevIllness, index),
                    );
                  }),
                  ///Add more button
                  Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {
                            addField(_patient.prevIllness, '');
                          },
                          child: const Text("Add More"))),
                ],
              ),
              Text('Specific allergies'),
              Column(
                children: [
                  ...List.generate(_patient.allergies!.length, (index) {
                    String? illness = _patient.allergies![index];
                    return buildTextFormField(
                      labelText: 'allergy',
                      value: illness,
                      onChanged: (value) {
                        _patient.allergies![index] = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSuffixIconTap: index == 0
                          ? null
                          : () => removeField(_patient.allergies, index),
                    );
                  }),
                  ///Add more button
                  Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {
                            addField(_patient.allergies, '');
                          },
                          child: const Text("Add More"))),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // process lists
                      List<String> illnessesCurrData = [];
                      for (int i = 0; i < _patient.currIllness!.length; i++) {
                        String illness = _patient.currIllness![i];
                        if (illness.isNotEmpty) {
                          illnessesCurrData.add(illness);
                        }
                      }
                      // process lists
                      List<String> illnessesPrevData = [];
                      for (int i = 0; i < _patient.prevIllness!.length; i++) {
                        String illness = _patient.prevIllness![i];
                        if (illness.isNotEmpty) {
                          illnessesPrevData.add(illness);
                        }
                      }
                      // process lists
                      List<String> allergiesData = [];
                      for (int i = 0; i < _patient.allergies!.length; i++) {
                        String allergy = _patient.allergies![i];
                        if (allergy.isNotEmpty) {
                          allergiesData.add(allergy);
                        }
                      }
                      final patientData = {
                        'illnessCurr': illnessesCurrData,
                        'illnessPrev': illnessesPrevData,
                        'allergies': allergiesData,
                      };
                      DatabaseReference newPatientRef = ref.push();
                      newPatientRef.set(patientData);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  addField(List<dynamic>? list, dynamic value) {
    if (list == null) {
      list = [];
    }
    list!.add(value);
    setState(() {});
  }

  removeField(List<dynamic>? list, int index) {
    if (list != null && index < list!.length) {
      list!.removeAt(index);
      setState(() {});
    }
  }

  addTextField(List<TextEditingController> list, TextEditingController value) {
    list.add(value);
    setState(() {});
  }

  removeTextField(List<TextEditingController> list, int index) {
    list.removeAt(index);
    setState(() {});
  }
}
