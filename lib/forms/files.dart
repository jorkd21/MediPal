import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medipal/forms/input_template.dart';
import 'package:medipal/objects/patient.dart';

class FileForm extends StatefulWidget {
  final Patient patient;
  final GlobalKey<FormState> formKey;

  const FileForm({
    super.key,
    required this.patient,
    required this.formKey,
  });

  @override
  FileFormState createState() {
    return FileFormState();
  }
}

class FileFormState extends State<FileForm> {
  Future<void> pickFile(FileData f) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        f.file = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Files'),
              Column(
                children: [
                  ...List.generate(widget.patient.files?.length ?? 0, (index) {
                    FileData file = widget.patient.files![index];
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: buildTextFormField(
                                labelText: 'file name ${index + 1}',
                                value: file.name,
                                onChanged: (value) {
                                  file.name = value!;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                onSuffixIconTap: index == 0
                                    ? null
                                    : () => _removeField(
                                        widget.patient.files, index),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => pickFile(file),
                              child: Text('Select Image'),
                            ),
                          ],
                        ),
                        if (file.file != null)
                          Text('File Path: ${file.file!.path}')
                      ],
                    );
                  }),
                  //Add more button
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        _addField(widget.patient.files, FileData());
                      },
                      child: Text("Add More"),
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
