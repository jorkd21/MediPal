import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medipal/forms/file_display.dart';
import 'package:medipal/forms/input_template.dart';
import 'package:medipal/objects/patient.dart';

class FileForm extends StatefulWidget {
  final Patient patient;
  final GlobalKey<FormState> formKey;
  final bool edit;

  const FileForm({
    Key? key,
    required this.patient,
    required this.formKey,
    required this.edit,
  }) : super(key: key);

  @override
  FileFormState createState() => FileFormState();
}

class FileFormState extends State<FileForm> {
  List<FileData> files = [];

  @override
  void initState() {
    super.initState();
    fetchFilesForPatient();
  }

  Future<void> pickFile(FileData f) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        f.file = File(image.path);
      });
    }
  }

  Future<void> fetchFilesForPatient() async {
    Reference patientRef =
        FirebaseStorage.instance.ref().child('patients/${widget.patient.id}');
    try {
      ListResult result = await patientRef.listAll();
      for (Reference ref in result.items) {
        String fileName = ref.name;
        String downloadUrl = await ref.getDownloadURL();
        FileData fileData = FileData(
          name: fileName,
          url: downloadUrl,
        );
        setState(() {
          files.add(fileData);
        });
      }
    } catch (e) {
      print('Error fetching files: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                FileData file = files[index];
                return ListTile(
                  title: Text(file.name ?? 'File ${index + 1}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ImageDisplayPage(imageUrl: file.url ?? ''),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add Files'),
                ...List.generate(widget.patient.files.length, (index) {
                  FileData file = widget.patient.files[index];
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: buildTextFormField(
                              labelText: 'File name ${index + 1}',
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
                              onSuffixIconTap: () =>
                                  _removeField(widget.patient.files, index),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => pickFile(file),
                            child: const Text('Select Image'),
                          ),
                        ],
                      ),
                      if (file.file != null)
                        Text('File Path: ${file.file!.path}')
                    ],
                  );
                }),
                // Add more button
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      _addField(widget.patient.files, FileData());
                    },
                    child: const Text("Add More"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addField(List<FileData>? list, FileData value) {
    if (list != null) {
      setState(() {
        list.add(value);
      });
    }
  }

  void _removeField(List<FileData>? list, int index) {
    if (list != null && index < list.length) {
      setState(() {
        list.removeAt(index);
      });
    }
  }
}
