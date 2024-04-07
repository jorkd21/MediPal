import 'package:flutter/material.dart';
import 'package:medipal/forms/input_template.dart';
import 'package:medipal/objects/patient.dart';

class MedicationsForm extends StatefulWidget {
  final Patient patient;
  final GlobalKey<FormState> formKey;

  const MedicationsForm({
    super.key,
    required this.patient,
    required this.formKey,
  });

  @override
  MedicationsFormState createState() {
    return MedicationsFormState();
  }
}

class MedicationsFormState extends State<MedicationsForm> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Current Medications'),
              Column(
                children: [
                  ...List.generate(widget.patient.currMedications!.length, (index) {
                    String? medication = widget.patient.currMedications![index];
                    return buildTextFormField(
                      labelText: 'medication ${index+1}',
                      value: medication,
                      onChanged: (value) {
                        widget.patient.currMedications![index] = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSuffixIconTap: () =>
                          _removeField(widget.patient.currMedications, index),
                    );
                  }),
                  ///Add more button
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        _addField(widget.patient.currMedications, '');
                      },
                      child: const Text("Add More"),
                    ),
                  ),
                ],
              ),
              const Text('Previous Medications'),
              Column(
                children: [
                  ...List.generate(widget.patient.prevMedications!.length, (index) {
                    String? medication = widget.patient.prevMedications![index];
                    return buildTextFormField(
                      labelText: 'medication ${index+1}',
                      value: medication,
                      onChanged: (value) {
                        widget.patient.prevMedications![index] = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSuffixIconTap: () =>
                          _removeField(widget.patient.prevMedications, index),
                    );
                  }),
                  //Add more button
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        _addField(widget.patient.prevMedications, '');
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
