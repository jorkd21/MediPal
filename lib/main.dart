import 'package:flutter/material.dart';
// firebase
import 'package:firebase_core/firebase_core.dart'; // firebase core
import 'firebase_options.dart'; // firebase api keys
import 'package:firebase_database/firebase_database.dart'; // realtime database
import 'package:cloud_firestore/cloud_firestore.dart'; // cloud firestore
import 'package:firebase_auth/firebase_auth.dart'; // authentication
import 'package:firebase_analytics/firebase_analytics.dart'; // analytics
// pages
import 'package:medipal/count.dart';
import 'package:medipal/page1.dart';
import 'package:medipal/page2.dart';
import 'package:medipal/page3.dart';

void main() async {
  runApp(const MyApp());
  // initialize firebase (testing)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // read/print database value
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('test/num').get();
  print(snapshot.value as int);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Development Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/Count': (context) => Count(),
        '/Page1': (context) => Page1(),
        '/Page2': (context) => Page2(),
        '/Page3': (context) => Page3(),
        //'/Page4': (context) => BlankPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ButtonWidget('Count', '/Count'),
            ButtonWidget('Page 1', '/Page1'),
            ButtonWidget('Page 2', '/Page2'),
            ButtonWidget('Page 3', '/Page3'),
            //ButtonWidget('Page 4', '/Page4'),
          ],
        ),
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final String buttonText;
  final String routeName;

  ButtonWidget(this.buttonText, this.routeName);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Text(buttonText),
    );
  }
}
