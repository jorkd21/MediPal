import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/forms/input_template.dart';
import 'package:medipal/objects/patient.dart';

// Create a Form widget.
class GeneralInfoForm extends StatefulWidget {
  const GeneralInfoForm({super.key});

  @override
  GeneralInfoFormState createState() {
    return GeneralInfoFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class GeneralInfoFormState extends State<GeneralInfoForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  // Patient instance to hold form data
  Patient _patient = Patient();

  // Define lists for dropdown options
  List<int> years =
      List.generate(100, (int index) => DateTime.now().year - 100 + index);
  List<int> months = List.generate(12, (int index) => index + 1);
  List<int> days = List.generate(31, (int index) => index + 1);
  List<String> bloodGroups = ['A', 'B', 'AB', 'O'];
  List<String> rhFactors = ['+', '-'];
  List<String> phoneTypes = ['home', 'work', 'mobile'];

  // database connection
  DatabaseReference ref = FirebaseDatabase.instance.ref('test/patient/geninfo');

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
              buildTextFormField(
                labelText: 'First Name',
                value: _patient.firstName,
                onChanged: (value) {
                  setState(() {
                    _patient.firstName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              buildTextFormField(
                labelText: 'Middle Name',
                value: _patient.middleName,
                onChanged: (value) {
                  setState(() {
                    _patient.middleName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              buildTextFormField(
                labelText: 'Last Name',
                value: _patient.lastName,
                onChanged: (value) {
                  setState(() {
                    _patient.lastName = value;
                  });
                },
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
                  Container(
                    width: 100,
                    child: buildDropdownFormField<int>(
                      value: _patient.dob?.year,
                      onChanged: (int? value) {
                        setState(() {
                          _patient.dob = DateTime(value ?? 0,
                              _patient.dob?.month ?? 1, _patient.dob?.day ?? 1);
                        });
                      },
                      items: years,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a year';
                        }
                        return null;
                      },
                    ),
                  ),
                  // Dropdown for Month
                  Container(
                    width: 50,
                    child: buildDropdownFormField<int>(
                      value: _patient.dob?.month,
                      onChanged: (int? value) {
                        setState(() {
                          _patient.dob = DateTime(
                              _patient.dob?.year ?? DateTime.now().year,
                              value ?? 1,
                              _patient.dob?.day ?? 1);
                        });
                      },
                      items: months,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a month';
                        }
                        return null;
                      },
                    ),
                  ),
                  // Dropdown for Day
                  Container(
                    width: 50,
                    child: buildDropdownFormField<int>(
                      value: _patient.dob?.day,
                      onChanged: (int? value) {
                        setState(() {
                          _patient.dob = DateTime(
                              _patient.dob?.year ?? DateTime.now().year,
                              _patient.dob?.month ?? 1,
                              value ?? 1);
                        });
                      },
                      items: days,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a day';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Blood Group'),
                  Container(
                    width: 50,
                    child: buildDropdownFormField<String>(
                      value: _patient.bloodGroup,
                      onChanged: (String? value) {
                        setState(() {
                          _patient.bloodGroup = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a blood group';
                        }
                        return null;
                      },
                      items: bloodGroups,
                    ),
                  ),
                  Text('RH Factor'),
                  Container(
                    width: 50,
                    child: buildDropdownFormField<String>(
                      value: _patient.rhFactor,
                      onChanged: (String? value) {
                        setState(() {
                          _patient.rhFactor = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an RH factor';
                        }
                        return null;
                      },
                      items: rhFactors,
                    ),
                  ),
                ],
              ),
              buildTextFormField(
                labelText: 'E-mail',
                value: _patient.email,
                onChanged: (value) {
                  setState(() {
                    _patient.email = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Text('Phone'),
              Column(
                children: [
                  ...List.generate(_patient.phone?.length ?? 0, (index) {
                    PhoneData contact = _patient.phone![index];
                    return Row(
                      children: [
                        Container(
                          width: 100,
                          child: buildDropdownFormField<String>(
                            value: contact.type,
                            onChanged: (String? value) {
                              setState(() {
                                contact.type = value;
                              });
                            },
                            items: phoneTypes,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a phone type';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: buildTextFormField(
                            labelText: 'Phone Number',
                            value: contact.phoneNumber?.toString(),
                            onChanged: (value) {
                              contact.phoneNumber = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            onSuffixIconTap:
                                index == 0 ? null : () => removeField(index),
                          ),
                        ),
                      ],
                    );
                  }),

                  ///Add more button
                  Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {
                            addField(_patient.phone, PhoneData());
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
                      DatabaseReference newPatientRef = ref.push();
                      newPatientRef.set(_patient.toJson());

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

  addField(List<dynamic>? list, dynamic value) {
    if (list == null) {
      list = [];
    }
    list!.add(value);
    setState(() {});
  }

  removeField(int index) {
    if (_patient.phone != null && index < _patient.phone!.length) {
      _patient.phone!.removeAt(index);
      setState(() {});
    }
  }
}

String? validateDropDown(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select an option';
  }
  return null;
}
