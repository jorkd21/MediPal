import 'package:flutter/material.dart';
import 'package:medipal/pages/language_constants.dart';
import 'package:medipal/templates/input_template.dart';
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
  MedicationsFormState createState() => MedicationsFormState();
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
              Text(translation(context).currentMedications),
              Column(
                children: [
                  ...List.generate(widget.patient.currMedications.length,
                      (index) {
                    String? medication = widget.patient.currMedications[index];
                    return buildTextFormField(
                      labelText: translation(context).currentMedications +
                          ' ${index + 1}',
                      value: medication,
                      onChanged: (value) {
                        widget.patient.currMedications[index] = value!;
                      },
                      onSuffixIconTap: () => setState(
                          () => widget.patient.currMedications.removeAt(index)),
                    );
                  }),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          widget.patient.currMedications.add('');
                        });
                      },
                      child: Text(translation(context).addMore),
                    ),
                  ),
                ],
              ),
              Text(translation(context).previousMedications),
              Column(
                children: [
                  ...List.generate(
                    widget.patient.prevMedications.length,
                    (index) {
                      String? medication =
                          widget.patient.prevMedications[index];
                      return buildTextFormField(
                        labelText: 'medication ${index + 1}',
                        value: medication,
                        onChanged: (value) {
                          widget.patient.prevMedications[index] = value!;
                        },
                        onSuffixIconTap: () => setState(() =>
                            widget.patient.prevMedications.removeAt(index)),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          widget.patient.prevMedications.add('');
                        });
                      },
                      child: Text(translation(context).addMore),
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
}
