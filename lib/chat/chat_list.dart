import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/chat/chat_page.dart';
import 'package:medipal/objects/practitioner.dart';
import 'package:medipal/pages/appointment_page.dart';
import 'package:medipal/pages/dashboard.dart';
import 'package:medipal/pages/patient_list.dart';
import 'package:medipal/pages/settings.dart';
import 'package:medipal/pages/patient_form.dart';
import '../objects/patient.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  ChatListState createState() {
    return ChatListState();
  }
}

class ChatListState extends State<ChatList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Practitioner> practitioners = [];

  @override
  void initState() {
    super.initState();
    _fetchPractitioners();
  }

  int _selectedIndex = 4;
  final List<Widget> _pages = [
    Dashboard(),
    PatientList(),
    PatientForm(patient: Patient()),
    AppointmentPage(),
    ChatList(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  void _fetchPractitioners() async {
    List<Practitioner> practitioners = await Practitioner.getPractitioners();
    setState(() {
      this.practitioners = practitioners;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practitioners'),
      ),
      body: practitioners.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: practitioners.length,
              itemBuilder: (context, index) {
                final practitioner = practitioners[index];

                // Exclude current user from the chat list
                if (practitioner.id == _auth.currentUser!.uid) {
                  return Container();
                }

                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    title:
                        Text(practitioner.email!), // Assuming email is present
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatPage(receiverUid: practitioner.id!),
                      ),
                    ),
                    tileColor: const Color(0xFFDADFEC),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Patients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: '+Patient',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Schedule'),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
