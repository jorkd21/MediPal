import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/chat/chat_page.dart';
import 'package:medipal/objects/practitioner.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  ChatListState createState() {
    return ChatListState();
  }
}

class ChatListState extends State<ChatList> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<Practitioner> practitioners = [];

  @override
  void initState() {
    super.initState();
    _fetchPractitioners();
  }

  void _fetchPractitioners() async {
    List<Practitioner> practitioners = await Practitioner.getAllPractitioners();
    setState(() {
      this.practitioners = practitioners;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Practitioners',
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
                Color.fromARGB(255, 73, 118, 207),
                Color.fromARGB(255, 191, 200, 255),
              ],
            ),
          ),
        ),
      ),
      body: practitioners.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: practitioners.length,
              itemBuilder: (context, index) {
                final practitioner = practitioners[index];
                if (practitioner.id == _firebaseAuth.currentUser!.uid) {
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
                    title: Text(practitioner.name!),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          receiverUid: practitioner.id!,
                          receiverName: practitioner.name!,
                        ),
                      ),
                    ),
                    tileColor: const Color(0xFFDADFEC),
                  ),
                );
              },
            ),
    );
  }
}
