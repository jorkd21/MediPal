import 'package:flutter/material.dart';
import 'package:medipal/forms/input_template.dart';
import 'package:medipal/objects/patient.dart';

class HealthConditionsForm extends StatefulWidget {
  final Patient patient;
  final GlobalKey<FormState> formKey;

  const HealthConditionsForm({
    super.key,
    required this.patient,
    required this.formKey,
  });

  @override
  HealthConditionsFormState createState() {
    return HealthConditionsFormState();
  }
}

class HealthConditionsFormState extends State<HealthConditionsForm> {
  @override
  Widget build(BuildContext context) {
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
                  ...List.generate(widget.patient.currIllness.length, (index) {
                    String? illness = widget.patient.currIllness[index];
                    return buildTextFormField(
                      labelText: 'illness ${index + 1}',
                      value: illness,
                      onChanged: (value) {
                        widget.patient.currIllness[index] = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      onSuffixIconTap: () =>
                          _removeField(widget.patient.currIllness, index),
                    );
                  }),
                  //Add more button
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        _addField(widget.patient.currIllness, '');
                      },
                      child: const Text("Add More"),
                    ),
                  ),
                ],
              ),
              const Text('Previous Illness'),
              Column(
                children: [
                  ...List.generate(widget.patient.prevIllness.length, (index) {
                    String? illness = widget.patient.prevIllness[index];
                    return buildTextFormField(
                      labelText: 'illness ${index + 1}',
                      value: illness,
                      onChanged: (value) {
                        widget.patient.prevIllness[index] = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      onSuffixIconTap: () =>
                          _removeField(widget.patient.prevIllness, index),
                    );
                  }),
                  //Add more button
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        _addField(widget.patient.prevIllness, '');
                      },
                      child: const Text("Add More"),
                    ),
                  ),
                ],
              ),
              const Text('Specific allergies'),
              Column(
                children: [
                  ...List.generate(widget.patient.allergies.length, (index) {
                    String? illness = widget.patient.allergies[index];
                    return buildTextFormField(
                      labelText: 'allergy ${index + 1}',
                      value: illness,
                      onChanged: (value) {
                        widget.patient.allergies[index] = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      onSuffixIconTap: () =>
                          _removeField(widget.patient.allergies, index),
                    );
                  }),
                  //Add more button
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        _addField(widget.patient.allergies, '');
                      },
                      child: const Text("Add More"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
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
