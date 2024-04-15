import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medipal/constant/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medipal/main.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}


class _ChatListState extends State<ChatListPage> {

  late User? currentUser;
  void initState(){
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: 
      Scaffold(
        appBar: AppBar(
        ),
        body: StreamBuilder(
          // ignore: deprecated_member_use
          stream: FirebaseDatabase.instance.reference().child('users').onValue, 
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError){
              return const Text('Error');
            }

            if (snapshot.connectionState == ConnectionState.waiting){
              return const Text('Loading');
            }

            DataSnapshot dataSnapshot = snapshot.data!.snapshot;
            List<String> users = [];

            if (dataSnapshot.value != null){
              Map<dynamic, dynamic> usersMap = snapshot.data!.snapshot.value;
              usersMap.forEach((key, value){
                if (value != null && value['email'] != null){
                  if (value['email'] != FirebaseAuth.instance.currentUser?.email){
                    users.add(value['email']);
                  }
                }
              });
            }
            return _buildUserList(users);
          }
        ),
      )
    );
  }

  Widget _buildUserList(List<String> users){
      return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => _buildUserListItem(users[index], context),
      );
    }
  }

  Widget _buildUserListItem(String usserEmail, BuildContext context){
    return ListTile(
      title: Text(usserEmail),
      onTap: () {
        Navigator.pushNamed(
          context, 
          '/chat',
          arguments: {'receiverUserEmail': usserEmail},
        );
      }
    );
  }

class ChatScreen extends StatelessWidget {
  final String receiverUserEmail;
  ChatScreen({required this.receiverUserEmail});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('$receiverUserEmail'),
      ),
      body: Center(
        child: Text('Chatting with: $receiverUserEmail'),
      ),
    );
  }
}