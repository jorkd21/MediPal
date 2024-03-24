import 'package:flutter/material.dart';
import 'package:medipal/constant/images.dart';

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
  final TextEditingController _insuranceNumberController =
      TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  String _errorMessage = '';
  String myImage = 'assets/images/your_image_name_here.png'; // Replace with your image path

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _insuranceNumberController,
                  decoration: InputDecoration(
                    labelText: '#Insurance Number',
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _countryController,
                  decoration: InputDecoration(
                    labelText: 'Country',
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true, // Hide the entered text
                ),
                SizedBox(height: 20.0),
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
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Add your sign-up logic here
                  },
                  child: Text('Sign Up'),
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
    );
  }
}
