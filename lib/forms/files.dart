import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medipal/templates/input_template.dart';
import 'package:medipal/objects/patient.dart';

class FileForm extends StatefulWidget {
  final Patient patient;
  final GlobalKey<FormState> formKey;
  final bool edit;

  const FileForm({
    super.key,
    required this.patient,
    required this.formKey,
    required this.edit,
  });

  @override
  FileFormState createState() => FileFormState();
}

class FileFormState extends State<FileForm> {
  List<FileData> files = [];

  @override
  void initState() {
    super.initState();
    _fetchAllFiles();
  }

  Future<void> _selectFile(FileData f) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        f.file = File(image.path);
      });
    }
  }

  void _fetchAllFiles() async {
    files = await widget.patient.getAllFiles();
    setState(() {});
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
                ...List.generate(
                  widget.patient.files.length,
                  (index) {
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
                                onSuffixIconTap: () => setState(
                                    () => widget.patient.files.removeAt(index)),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _selectFile(file),
                              child: const Text('Select Image'),
                            ),
                          ],
                        ),
                        if (file.file != null)
                          Text('File Path: ${file.file!.path}')
                      ],
                    );
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        widget.patient.files.add(FileData());
                      });
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
}

class ImageDisplayPage extends StatelessWidget {
  final String imageUrl;

  const ImageDisplayPage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Display'),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Stack(
          children: [
            InteractiveViewer(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Center(
              child: FutureBuilder(
                future: precacheImage(NetworkImage(imageUrl), context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
