import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Perform validation (you can add more complex validation as needed)
    if (username.isNotEmpty && password.isNotEmpty) {
      // For this example, let's just show a success message
      setState(() {
        _errorMessage = 'Login successful!';
      });
    } else {
      setState(() {
        _errorMessage = 'Please enter both username and password.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: Image.asset(
                        'MediPal_Logo-transformed_1.png',
                        width: 91,
                        height: 82,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 17.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(41.0, 0.0, 0.0, 0.0),
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(41.0, 0.0, 0.0, 0.0),
                  child: Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 75.0),
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
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: '      Email or phone',
                          labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 19.69),
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
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: '      Password',
                          labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.0),
                Padding(
                  padding: EdgeInsets.only(left: 50.0), // Adjust left padding as needed
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(Size(278.0, 44.0)),
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF003CD6)),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Color(0xFFEFEFEF), fontSize: 20, fontStyle: FontStyle.normal),
                    ),
                  ),
                ),
                SizedBox(height: 13.0),
                Padding(
                  padding: const EdgeInsets.only(left: 78.0),
                  child: Row(
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(color: Color(0xFFEFEFEF), fontSize: 15, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 4), // Padding of 4 between widgets
                      Text(
                        'Sign Up',
                        style: TextStyle(color: Color(0xFFEFEFEF), fontSize: 15, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
