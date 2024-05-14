import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medipal/constant/images.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:medipal/objects/appointment.dart';
import 'package:medipal/objects/patient.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Appointment> _appointments = [];
  List<Patient> _patients = [];
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchPatientData();
  }

  Future<void> _fetchPatientData() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await ref.child('patient').get();
      if (snapshot.value != null) {
        Map<dynamic, dynamic>? jsonMap =
            snapshot.value as Map<dynamic, dynamic>;
        List<Patient> pl = [];
        jsonMap.forEach((key, value) {
          Patient p = Patient.fromMap(value.cast<String, dynamic>());
          pl.add(p);
        });
        print(pl); // Print the list of patients
        setState(() {
          _patients = pl;
        });
      }
    } catch (e) {
      print("Error fetching patient data: $e");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "M E D I P A L",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 69, 109, 189),
                Color.fromARGB(255, 174, 186, 255),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Colors.white,
            /*gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFb6c9ee), // Light blue at the top
                  Color(0xFFb6c9ee), // Light blue at the bottom
                ],
              ),*/
          ),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /* IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.black, size: 40),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),*/
                      Container(
                        height: 100,
                        width: 100,
                        child: Image.asset(
                          myImage,
                        ),
                      ),
                    ],
                  ),*/
                Row(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, left: 148.0),
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Image.asset(
                            //FirebaseAuth.instance.currentUser!.photoURL !=null
                            //? FirebaseAuth.instance.currentUser!.photoURL! :
                            profilePic,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 55),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20), // Adjust the top padding as needed
                      child: Text(
                        'Welcome Dr. ${FirebaseAuth.instance.currentUser?.displayName}',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                /*Center(
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 35),
                      height: 150,
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),*/
                SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 25),
                    Image.asset('assets/checkmarkCal.png'),
                    SizedBox(width: 7), // Adjust the width as needed
                    Padding(
                      padding: EdgeInsets.only(
                          top: 1), // Adjust the top padding as needed
                      child: Text(
                        'Upcoming Appointments',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Center(
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 35),
                    height: 400,
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      itemCount: _appointments.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text('${_appointments[index].patient}'),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 25),
                /*Center(
                    child: Container(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/appointment');
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xFF003CD6),
                          ),
                        ),
                        child: Text(
                          'Appointments',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      
                      ),
                    ),
                  ),*/
                /*Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 25),
                      Image.asset('assets/patDashboard.png'),
                      SizedBox(width: 7), // Adjust the width as needed
                      Padding(
                        padding: EdgeInsets.only(
                            top: 3), // Adjust the top padding as needed
                        child: Text(
                          'My Patients',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(0, 3),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),*/
                SizedBox(height: 4),
                /*Center(
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 35),
                      height: 150,
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        itemCount: _patients.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            // Wrap ListTile with Card
                            color: Color(0xFFdadfec),
                            child: ListTile(
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 25),
                                  Image.asset('assets/patientCross.png'),
                                  SizedBox(width: 7),
                                  Text(
                                    '${_patients[index].firstName} ${_patients[index].middleName} ${_patients[index].lastName}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
