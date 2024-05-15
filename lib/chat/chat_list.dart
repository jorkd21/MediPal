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
  List<Practitioner> _practitioners = [];

  @override
  void initState() {
    super.initState();
    _fetchPractitioners();
  }

  void _fetchPractitioners() async {
    List<Practitioner>? practitioners = await Practitioner.getAllPractitioners();
    setState(() {
      _practitioners = practitioners!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practitioners'),
      ),
      body: _practitioners.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _practitioners.length,
              itemBuilder: (context, index) {
                final practitioner = _practitioners[index];
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
