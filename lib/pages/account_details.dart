import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medipal/objects/practitioner.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:medipal/pages/forgotpasswd.dart';

class AccountInfoPage extends StatefulWidget {
  final String? userUid;
  AccountInfoPage({
    super.key,
    required this.userUid,
  });

  @override
  _AccountInfoPageState createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  late Practitioner _practitioner;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late String? _photoController;
  final ImagePicker _picker = ImagePicker();
  var user = FirebaseAuth.instance.currentUser;
  bool _isEditing = false;

  void _fetchPractitioner() async {
    Practitioner? practitioner = await Practitioner.getPractitioner(widget.userUid!);
  practitioner!.id = widget.userUid;
    practitioner.appointments.sort((a, b) {
      return a.patient!.toLowerCase().compareTo(b.patient!.toLowerCase());
    });
    setState(() {
      _practitioner = practitioner;
    });
  }


  @override
  void initState(){
    super.initState();
    _fetchPractitioner();
    _nameController = TextEditingController(text: Practitioner.currentPractitioner?.name);
    _emailController = TextEditingController(text: FirebaseAuth.instance.currentUser?.email);
    _passwordController = TextEditingController(text: '');
    _photoController = FirebaseAuth.instance.currentUser?.photoURL;  
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Information',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(0, 3),
                blurRadius: 5,
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xFF4976CF),
                Color(0xFFBFC8FF),
              ],
            ),
          ),
        ),
        actions: _buildAppBarActions(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: '${_practitioner.name}',
                ),
                controller: _nameController,
                enabled: _isEditing,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Email:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              TextField(
                decoration: InputDecoration(
                  hintText: '${_practitioner.email}',
                ),
                controller: _emailController,
                enabled: _isEditing,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Password:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              TextField(
                decoration: InputDecoration(
                  hintText: "Confirm your password",
                ),
                controller: _passwordController,
                enabled: _isEditing,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => ForgotPassPage()),
                      );
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(Size(278.0, 44)),
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF003CD6)),
                    ),
                    child: Text(
                      'Reset Password',
                      style: TextStyle(color: Color(0xFFEFEFEF), fontSize: 20, fontStyle: FontStyle.normal),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Text(
                  'Profile Photo',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 105.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoURL!),
                      radius: 50,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80.0),
                    child: IconButton(
                      icon: Icon(Icons.edit, size: 30,),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
                        iconColor: MaterialStateColor.resolveWith((states) => const Color.fromARGB(255, 41, 49, 70)),
                      ),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAppBarActions(){
    if (_isEditing){
      return [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: (){
            _saveChanges();
          }
        ),
      ];
    }else{
      return [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          }
        ),
      ];
    }
  }

  Future<String?> _uploadImage(String filePath) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('user_photos/${_practitioner.id}/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(File(filePath));
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print('Error uploading image: $error');
      return null;
    }
  }


  void _saveChanges() async {
    if (_practitioner != null) {
      // ignore: deprecated_member_use
      var user = FirebaseAuth.instance.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(email: FirebaseAuth.instance.currentUser?.email ?? '', password: _passwordController.text);
      user?.reauthenticateWithCredential(credential).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reauthenticated')));
        _updatePractitionerInfo();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to reauthenticate: $error')));
      });
    }
  }

  void _updatePractitionerInfo() {
    //Update the practitioner's info in the database
    _practitioner.name = _nameController.text;
    FirebaseAuth.instance.currentUser?.updateEmail(_emailController.text);
    _practitioner.email = _emailController.text;
    final String? newPhotoUrl = _photoController;
    if (newPhotoUrl!.isNotEmpty) {
      FirebaseAuth.instance.currentUser?.updatePhotoURL(newPhotoUrl);
    } 
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/${_practitioner.id}');
    ref.set(_practitioner.toJson()).then((_) {
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Changes saved')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save changes to database: $error')));
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final String filePath = image.path;
      setState(() {
        _photoController = filePath;
      });
    }
  }


  @override
  void dispose(){
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}