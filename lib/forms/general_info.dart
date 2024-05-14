import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medipal/forms/input_template.dart';
import 'package:medipal/objects/patient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medipal/pages/language_constants.dart';

class GeneralInfoForm extends StatefulWidget {
  final Patient patient;
  final GlobalKey<FormState> formKey;
  const GeneralInfoForm({
    super.key,
    required this.patient,
    required this.formKey,
  });

  @override
  GeneralInfoFormState createState() {
    return GeneralInfoFormState();
  }
}

class GeneralInfoFormState extends State<GeneralInfoForm> {
  // list choices
  List<int> years =
      List.generate(100, (int index) => DateTime.now().year - 100 + index);
  List<int> months = List.generate(12, (int index) => index + 1);
  List<int> days = List.generate(31, (int index) => index + 1);
  List<String> bloodGroups = ['A', 'B', 'AB', 'O'];
  List<String> rhFactors = ['+', '-'];
  List<String> phoneTypes = ['home', 'work', 'mobile'];

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        widget.patient.imageFile = File(image.path);
      });
    }
  }

  // build
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  if (widget.patient.imageFile != null)
                    Image.file(widget.patient.imageFile!,
                        height: 200, width: 200),
                  Row(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: pickImage,
                        child: Text(translation(context).selectImage),
                      ),
                    ],
                  ),
                ],
              ),
              buildTextFormField(
                labelText: translation(context).firstName,
                value: widget.patient.firstName,
                onChanged: (value) {
                  setState(() {
                    widget.patient.firstName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return translation(context).required;
                  }
                  return null;
                },
              ),
              buildTextFormField(
                labelText: translation(context).middleName,
                value: widget.patient.middleName,
                onChanged: (value) {
                  setState(() {
                    widget.patient.middleName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return translation(context).required;
                  }
                  return null;
                },
              ),
              buildTextFormField(
                labelText: translation(context).lastName,
                value: widget.patient.lastName,
                onChanged: (value) {
                  setState(() {
                    widget.patient.lastName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return translation(context).required;
                  }
                  return null;
                },
              ),
              buildTextFormField(
                labelText: translation(context).location,
                value: widget.patient.location,
                onChanged: (value) {
                  setState(() {
                    widget.patient.location = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return translation(context).required;
                  }
                  return null;
                },
              ),
              buildTextFormField(
                labelText: translation(context).sex,
                value: widget.patient.sex,
                onChanged: (value) {
                  setState(() {
                    widget.patient.sex = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return translation(context).required;
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
                          widget.patient.dob = DateTime(
                              value ?? 0,
                              widget.patient.dob?.month ?? 1,
                              widget.patient.dob?.day ?? 1);
                        });
                      },
                      items: years,
                      validator: (value) {
                        if (value == null) {
                          return 'Required';
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
                          return 'Required';
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
                          return 'Required';
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
                  const SizedBox(width: 10),
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
                          return 'Required';
                        }
                        return null;
                      },
                      items: bloodGroups,
                    ),
                  ),
                  const Text('RH Factor'),
                  const SizedBox(width: 10),
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
                          return 'Required';
                        }
                        return null;
                      },
                      items: rhFactors,
                    ),
                  ),
                ],
              ),
              buildTextFormField(
                labelText: 'Marital Status',
                value: widget.patient.maritalStatus,
                onChanged: (value) {
                  setState(() {
                    widget.patient.maritalStatus = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
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
                    return 'Required';
                  }
                  return null;
                },
              ),
              const Text('Phone'),
              Column(
                children: [
                  ...List.generate(widget.patient.phone.length, (index) {
                    PhoneData contact = widget.patient.phone[index];
                    return Row(
                      children: [
                        SizedBox(
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
                            labelText: 'Phone Number ${index + 1}',
                            value: contact.phoneNumber?.toString(),
                            onChanged: (value) {
                              contact.phoneNumber = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            onSuffixIconTap: index == 0
                                ? null
                                : () =>
                                    _removeField(widget.patient.phone, index),
                          ),
                        ),
                      ],
                    );
                  }),
                  //Add more button
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        _addField(widget.patient.phone, PhoneData());
                      },
                      child: const Text("Add More"),
                    ),
                  ),
                ],
              ),
              Text(translation(context).emergencyContactInformation),
              Column(
                children: [
                  ...List.generate(widget.patient.emergency.length, (index) {
                    EmergancyData contact = widget.patient.emergency[index];
                    return Row(
                      children: [
                        Expanded(
                          child: buildTextFormField(
                            labelText: 'Name ${index + 1}',
                            value: contact.name?.toString(),
                            onChanged: (value) {
                              contact.name = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
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
                            labelText: 'Phone Number ${index + 1}',
                            value: contact.phoneNumber?.toString(),
                            onChanged: (value) {
                              contact.phoneNumber = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            onSuffixIconTap: index == 0
                                ? null
                                : () => _removeField(
                                    widget.patient.emergency, index),
                          ),
                        ),
                      ],
                    );
                  }),
                  //Add more button
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        _addField(widget.patient.emergency, EmergancyData());
                      },
                      child: const Text("Add More"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  _addField(List<dynamic>? list, dynamic value) {
    list!.add(value);
    setState(() {});
  }

  _removeField(List<dynamic>? list, int index) {
    if (list != null && index < list.length) {
      list.removeAt(index);
      setState(() {});
    }
  }
}
