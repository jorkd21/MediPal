import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medipal/constant/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medipal/main.dart';
import 'package:medipal/pages/language_constants.dart';
import 'package:medipal/pages/signup.dart';
import 'package:medipal/pages/forgotpasswd.dart';

class ForgotPassPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: Colors.white, size: 40),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(41.0, 0.0, 0.0, 0.0),
                    child: Text(
                      translation(context).forgotPassword,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 25.0),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 290,
                      height: 42.66,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: translation(context).enterYourEmail,
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.all(15.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(278.0, 44)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFF003CD6)),
                      ),
                      child: Text(
                        translation(context).confirm,
                        style: TextStyle(
                            color: Color(0xFFEFEFEF),
                            fontSize: 20,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                  ),
                  SizedBox(height: 75),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
