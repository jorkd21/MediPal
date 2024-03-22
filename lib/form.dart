import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PatientForm extends StatelessWidget {
  const PatientForm({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'General Patient Information';

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: const GenPatInfoForm(),
    );
  }
}

// Create a Form widget.
class GenPatInfoForm extends StatefulWidget {
  const GenPatInfoForm({super.key});

  @override
  GenPatInfoFormState createState() {
    return GenPatInfoFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class GenPatInfoFormState extends State<GenPatInfoForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  // Text
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  List<TextEditingController> illnessList = [TextEditingController()];
  // dropdown menues
  int? selectedYear;
  int? selectedMonth;
  int? selectedDay;
  String selectedBG = '';
  String selectedRH = '';

  // Define lists for dropdown options
  List<int> years =
      List.generate(100, (int index) => DateTime.now().year - 100 + index);
  List<int> months = List.generate(12, (int index) => index + 1);
  List<int> days = List.generate(31, (int index) => index + 1);
  List<String> bloodGroups = ['A', 'B', 'AB', 'O'];
  List<String> rhFactors = ['+', '-'];

  // database connection
  DatabaseReference ref = FirebaseDatabase.instance.ref('test/patient');

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
              Text('First Name'),
              TextFormField(
                controller: firstNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Text('Middle Name'),
              TextFormField(
                controller: middleNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Text('Last Name'),
              TextFormField(
                controller: lastNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Text('Date of Birth'),
              Row(
                children: [
                  // Dropdown for Year
                  DropdownMenu<int>(
                    initialSelection: years.last,
                    onSelected: (int? value) {
                      setState(() {
                        selectedYear = value!;
                      });
                    },
                    dropdownMenuEntries:
                        years.map<DropdownMenuEntry<int>>((int value) {
                      return DropdownMenuEntry<int>(
                        value: value,
                        label: value.toString(),
                      );
                    }).toList(),
                  ),
                  // Dropdown for Month
                  DropdownMenu<int>(
                    initialSelection: months.last,
                    onSelected: (int? value) {
                      setState(() {
                        selectedMonth = value!;
                      });
                    },
                    dropdownMenuEntries:
                        months.map<DropdownMenuEntry<int>>((int value) {
                      return DropdownMenuEntry<int>(
                        value: value,
                        label: value.toString(),
                      );
                    }).toList(),
                  ),
                  // Dropdown for Day
                  DropdownMenu<int>(
                    initialSelection: days.last,
                    onSelected: (int? value) {
                      setState(() {
                        selectedDay = value!;
                      });
                    },
                    dropdownMenuEntries:
                        days.map<DropdownMenuEntry<int>>((int value) {
                      return DropdownMenuEntry<int>(
                        value: value,
                        label: value.toString(),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Text('Blood Group'),
              DropdownMenu<String>(
                initialSelection: bloodGroups.last,
                onSelected: (String? value) {
                  setState(() {
                    selectedBG = value!;
                  });
                },
                dropdownMenuEntries:
                    bloodGroups.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(
                    value: value,
                    label: value,
                  );
                }).toList(),
              ),
              Text('RH Factor'),
              DropdownMenu<String>(
                initialSelection: rhFactors.last,
                onSelected: (String? value) {
                  setState(() {
                    selectedRH = value!;
                  });
                },
                dropdownMenuEntries:
                    rhFactors.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(
                    value: value,
                    label: value,
                  );
                }).toList(),
              ),
              Text('Phone'),
              Row(
                children: [
                  Text('+'),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      controller: phoneNumberControllers[0],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: phoneNumberControllers[1],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Text('E-mail'),
              TextFormField(
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Text('Illness'),
              Column(
                children: [
                  ...List.generate(illnessList.length, (index) {
                    final controller = illnessList[index];
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
                                    removeTextField(index);
                                  },
                                  child: const Icon(Icons.delete))),
                    );
                  }),

                  ///Add more button
                  Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {
                            addTextField(TextEditingController());
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
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      final String firstName = firstNameController.text;
                      final String middleName = middleNameController.text;
                      final String lastName = lastNameController.text;
                      final int? year = selectedYear;
                      final int? month = selectedMonth;
                      final int? day = selectedDay;
                      final String rhFactor = selectedRH;
                      final String bloodGroup = selectedBG;
                      
                      ref.push().set({
                        'firstName': firstName,
                        'middleName': middleName,
                        'lastName': lastName,
                        'year': year,
                        'month': month,
                        'day': day,
                        'bloodGroup': bloodGroup,
                        'rhFactor': rhFactor,
                      });
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
        ),
      ],
    );
  }

  addTextField(TextEditingController value) {
    illnessList.add(value);
    setState(() {});
  }

  removeTextField(int index) {
    illnessList.removeAt(index);
    setState(() {});
  }
}
