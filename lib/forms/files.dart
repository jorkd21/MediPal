import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medipal/objects/patient.dart';

class FileForm extends StatefulWidget {
  final Patient patient;
  final Function(List<File>, List<String>) onFilesSelected;
  const FileForm({
    Key? key,
    required this.patient,
    required this.onFilesSelected,
  }) : super(key: key);

  @override
  _FileFormState createState() => _FileFormState();
}

class _FileFormState extends State<FileForm> {
  List<File> selectedFiles = [];
  List<String> fileNames = [];

  Future<void> pickImage() async {
    final image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedFiles.add(File(image.path)); // Store the actual picked image path
        fileNames.add(""); // Add an empty string as a placeholder for the file name
        widget.onFilesSelected(selectedFiles, fileNames);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: pickImage,
            child: Text('Select Image'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedFiles.length,
              itemBuilder: (context, index) {
                File file = selectedFiles[index];
                String fileName = fileNames[index];
                String filePath = file.path;
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'File Name: $fileName',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'File Path: $filePath',
                      ),
                    ],
                  ),
                  subtitle: TextFormField(
                    decoration: InputDecoration(labelText: 'File Name'),
                    onChanged: (value) {
                      fileNames[index] = value; // Update file name list
                      widget.onFilesSelected(selectedFiles, fileNames);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
