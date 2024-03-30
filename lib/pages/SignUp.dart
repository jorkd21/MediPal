import 'package:flutter/material.dart';
import 'package:medipal/constant/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:medipal/main.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  String _errorMessage = '';

  void _signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // Update user profile with first name, last name, and license number
        // ignore: deprecated_member_use
        await user.updateProfile(
          displayName: '${_firstNameController.text} ${_lastNameController.text}',
          photoURL: _licenseController.text,
        );

        // Update user's phone number
        //await user.updatePhoneNumber(_phoneNumberController.text);

        // Update user's country
        // ignore: deprecated_member_use
        await user.updateProfile(
          photoURL: _countryController.text,
        );
      }

      // Navigate to HomeScreen or any other page after successful sign up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );

    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Sign Up Page")),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xFF6D98EB), // Light blue at the bottom
                Color(0xFFBAA2DA), // Purple at the top
              ],
            ),
          ),
          
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        child: Image.asset(
                          myImage,
                        ),
                      ),
                    ],
                    ),
                    SizedBox(height: 17.0),
                    SizedBox(height: 17.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 100, 25.0),
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    FractionallySizedBox(
                      widthFactor: 0.75, // Set width factor to half
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    FractionallySizedBox(
                      widthFactor: 0.75, // Set width factor to half
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    FractionallySizedBox(
                      widthFactor: 0.75, // Set width factor to half
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    FractionallySizedBox(
                      widthFactor: 0.75, // Set width factor to half
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                          obscureText: true, // Hide the entered text
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    FractionallySizedBox(
                      widthFactor: 0.75, // Set width factor to half
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    FractionallySizedBox(
                      widthFactor: 0.75, // Set width factor to half
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          controller: _licenseController,
                          decoration: InputDecoration(
                            labelText: 'License Number',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    FractionallySizedBox(
                      widthFactor: 0.75, // Set width factor to half
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          controller: _countryController,
                          decoration: InputDecoration(
                            labelText: 'Country',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: _signUp,
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(Size(278.0, 44.0)),
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF003CD6)),
                        ),
                        child: Text(
                          'Create Account',
                          style: TextStyle(color: Color(0xFFEFEFEF), fontSize: 20, fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
                    if (_errorMessage.isNotEmpty)
                      Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}