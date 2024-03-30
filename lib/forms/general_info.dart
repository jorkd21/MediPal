import 'package:flutter/material.dart';
import 'package:medipal/forms/input_template.dart';
import 'package:medipal/objects/patient.dart';

// Create a Form widget.
class GeneralInfoForm extends StatefulWidget {
  final Patient patient;
  final GlobalKey<FormState> formKey;
  const GeneralInfoForm({super.key, required this.patient, required this.formKey });

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
  //final _formKey = GlobalKey<FormState>();

  // Patient instance to hold form data
  //Patient _patient = Patient();

  // Define lists for dropdown options
  List<int> years =
      List.generate(100, (int index) => DateTime.now().year - 100 + index);
  List<int> months = List.generate(12, (int index) => index + 1);
  List<int> days = List.generate(31, (int index) => index + 1);
  List<String> bloodGroups = ['A', 'B', 'AB', 'O'];
  List<String> rhFactors = ['+', '-'];
  List<String> phoneTypes = ['home', 'work', 'mobile'];

  // database connection
  //DatabaseReference ref = FirebaseDatabase.instance.ref('test/patient/geninfo');

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
              buildTextFormField(
                labelText: 'First Name',
                value: widget.patient.firstName,
                onChanged: (value) {
                  setState(() {
                    widget.patient.firstName = value;
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
                value: widget.patient.middleName,
                onChanged: (value) {
                  setState(() {
                    widget.patient.middleName = value;
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
                value: widget.patient.lastName,
                onChanged: (value) {
                  setState(() {
                    widget.patient.lastName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const Text('Date of Birth'),
              Row(
                children: [
                  // Dropdown for Year
                  SizedBox(
                    width: 100,
                    child: buildDropdownFormField<int>(
                      value: widget.patient.dob?.year,
                      onChanged: (int? value) {
                        setState(() {
                          widget.patient.dob = DateTime(value ?? 0,
                              widget.patient.dob?.month ?? 1, widget.patient.dob?.day ?? 1);
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
                  SizedBox(
                    width: 50,
                    child: buildDropdownFormField<int>(
                      value: widget.patient.dob?.month,
                      onChanged: (int? value) {
                        setState(() {
                          widget.patient.dob = DateTime(
                              widget.patient.dob?.year ?? DateTime.now().year,
                              value ?? 1,
                              widget.patient.dob?.day ?? 1);
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
                  SizedBox(
                    width: 50,
                    child: buildDropdownFormField<int>(
                      value: widget.patient.dob?.day,
                      onChanged: (int? value) {
                        setState(() {
                          widget.patient.dob = DateTime(
                              widget.patient.dob?.year ?? DateTime.now().year,
                              widget.patient.dob?.month ?? 1,
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
                  const Text('Blood Group'),
                  SizedBox(
                    width: 50,
                    child: buildDropdownFormField<String>(
                      value: widget.patient.bloodGroup,
                      onChanged: (String? value) {
                        setState(() {
                          widget.patient.bloodGroup = value;
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
                  const Text('RH Factor'),
                  SizedBox(
                    width: 50,
                    child: buildDropdownFormField<String>(
                      value: widget.patient.rhFactor,
                      onChanged: (String? value) {
                        setState(() {
                          widget.patient.rhFactor = value;
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
                value: widget.patient.email,
                onChanged: (value) {
                  setState(() {
                    widget.patient.email = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const Text('Phone'),
              Column(
                children: [
                  ...List.generate(widget.patient.phone?.length ?? 0, (index) {
                    PhoneData contact = widget.patient.phone![index];
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
                        const SizedBox(width: 10),
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
                            addField(widget.patient.phone, PhoneData());
                          },
                          child: const Text("Add More"))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  addField(List<dynamic>? list, dynamic value) {
    list!.add(value);
    setState(() {});
  }

  removeField(int index) {
    if (widget.patient.phone != null && index < widget.patient.phone!.length) {
      widget.patient.phone!.removeAt(index);
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
