import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/chat/chat_page.dart';
import 'package:medipal/objects/practitioner.dart';


class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Practitioner> practitioners = [];

  @override
  void initState() {
    super.initState();
    _fetchPractitioners();
  }

  void _fetchPractitioners() async {
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  DataSnapshot snapshot = await ref.child('users').get();
  if (snapshot.exists) {
    Map<dynamic, dynamic>? jsonMap = snapshot.value as Map<dynamic, dynamic>;
    //Map<dynamic, dynamic> practitionersData = snapshot.value as Map<dynamic, dynamic>;
    List<Practitioner> pl = [];
    jsonMap.forEach((key, value) {
        Practitioner p = Practitioner.fromMap(value.cast<String, dynamic>());
        p.id = key;
        pl.add(p);
      });
    setState(() {
      practitioners = pl;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practitioners'),
      ),
      body: practitioners.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: practitioners.length,
              itemBuilder: (context, index) {
                final practitioner = practitioners[index];

                // Exclude current user from the chat list
                if (practitioner.id == _auth.currentUser!.uid) return Container();

                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.person),
                    trailing: Icon(Icons.arrow_forward_ios),
                    title: Text(practitioner.email!), // Assuming email is present
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(receiverUid: practitioner.id!),
                      ),
                    ),
                    tileColor: Color(0xFFDADFEC),
                  ),
                );
              },
            ),
    );
  }
}
