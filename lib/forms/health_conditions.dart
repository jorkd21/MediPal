import 'package:flutter/material.dart';
import 'package:medipal/templates/input_template.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/pages/language_constants.dart';

class HealthConditionsForm extends StatefulWidget {
  final Patient patient;
  final GlobalKey<FormState> formKey;

  const HealthConditionsForm({
    super.key,
    required this.patient,
    required this.formKey,
  });

  @override
  HealthConditionsFormState createState() => HealthConditionsFormState();
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
              Text(translation(context).currentIllness),
              Column(
                children: [
                  ...List.generate(
                    widget.patient.currIllness.length,
                    (index) {
                      String? illness = widget.patient.currIllness[index];
                      return buildTextFormField(
                        labelText:
                            '${translation(context).illness} ${index + 1}',
                        value: illness,
                        onChanged: (value) {
                          widget.patient.currIllness[index] = value!;
                        },
                        onSuffixIconTap: () => setState(
                            () => widget.patient.currIllness.removeAt(index)),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          widget.patient.currIllness.add('');
                        });
                      },
                      child: Text(translation(context).addMore),
                    ),
                  ),
                ],
              ),
              Text(translation(context).previousIllness),
              Column(
                children: [
                  ...List.generate(
                    widget.patient.prevIllness.length,
                    (index) {
                      String? illness = widget.patient.prevIllness[index];
                      return buildTextFormField(
                        labelText:
                            '${translation(context).illness} ${index + 1}',
                        value: illness,
                        onChanged: (value) {
                          widget.patient.prevIllness[index] = value!;
                        },
                        onSuffixIconTap: () => setState(
                            () => widget.patient.prevIllness.removeAt(index)),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          widget.patient.prevIllness.add('');
                        });
                      },
                      child: Text(translation(context).addMore),
                    ),
                  ),
                ],
              ),
              Text(translation(context).specificAllergies),
              Column(
                children: [
                  ...List.generate(
                    widget.patient.allergies.length,
                    (index) {
                      String? illness = widget.patient.allergies[index];
                      return buildTextFormField(
                        labelText:
                            translation(context).allergy + ' ${index + 1}',
                        value: illness,
                        onChanged: (value) {
                          widget.patient.allergies[index] = value!;
                        },
                        onSuffixIconTap: () => setState(
                            () => widget.patient.allergies.removeAt(index)),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          widget.patient.allergies.add('');
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
