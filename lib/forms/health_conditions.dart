// Create a Form widget.
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
  List<TextEditingController> illnessCurrList = [TextEditingController()];
  List<TextEditingController> illnessPrevList = [TextEditingController()];
  List<TextEditingController> allergiesList = [TextEditingController()];
  // database connection
  DatabaseReference ref = FirebaseDatabase.instance.ref('test/patient/conditions');
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
                  ...List.generate(illnessCurrList.length, (index) {
                    final controller = illnessCurrList[index];
                    return TextFormField(
                      controller: controller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: "illness ${index + 1}",
                          suffixIcon: index == 0
                              ? null
                              : GestureDetector(
                                  onTap: () {
                                    removeTextField(illnessCurrList,index);
                                  },
                                  child: const Icon(Icons.delete))),
                    );
                  }),

                  ///Add more button
                  Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {
                            addTextField(illnessCurrList,TextEditingController());
                          },
                          child: const Text("Add More"))),
                ],
              ),
              Text('Previous Illness'),
              Column(
                children: [
                  ...List.generate(illnessPrevList.length, (index) {
                    final controller = illnessPrevList[index];
                    return TextFormField(
                      controller: controller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: "illness ${index + 1}",
                          suffixIcon: index == 0
                              ? null
                              : GestureDetector(
                                  onTap: () {
                                    removeTextField(illnessPrevList,index);
                                  },
                                  child: const Icon(Icons.delete))),
                    );
                  }),

                  ///Add more button
                  Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {
                            addTextField(illnessPrevList,TextEditingController());
                          },
                          child: const Text("Add More"))),
                ],
              ),
              Text('Specific allergies'),
              Column(
                children: [
                  ...List.generate(allergiesList.length, (index) {
                    final controller = allergiesList[index];
                    return TextFormField(
                      controller: controller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: "allergy ${index + 1}",
                          suffixIcon: index == 0
                              ? null
                              : GestureDetector(
                                  onTap: () {
                                    removeTextField(allergiesList,index);
                                  },
                                  child: const Icon(Icons.delete))),
                    );
                  }),

                  ///Add more button
                  Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {
                            addTextField(allergiesList,TextEditingController());
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
                      for (int i = 0; i < illnessCurrList.length; i++) {
                        String illness = illnessCurrList[i].text;
                        if (illness.isNotEmpty) {
                          illnessesCurrData.add(illness);
                        }
                      }
                      // process lists
                      List<String> illnessesPrevData = [];
                      for (int i = 0; i < illnessPrevList.length; i++) {
                        String illness = illnessPrevList[i].text;
                        if (illness.isNotEmpty) {
                          illnessesPrevData.add(illness);
                        }
                      }
                      // process lists
                      List<String> allergiesData = [];
                      for (int i = 0; i < allergiesList.length; i++) {
                        String allergy = allergiesList[i].text;
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
  addTextField(List<TextEditingController> list, TextEditingController value) {
    list.add(value);
    setState(() {});
  }

  removeTextField(List<TextEditingController> list, int index) {
    list.removeAt(index);
    setState(() {});
  }
}
