import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medipal/constant/images.dart';
import 'package:medipal/main.dart';


class ChatScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context){

    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String receiverUserEmail = args['receiverUserEmail'];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('$receiverUserEmail'),
        ),
        body: Center(
          child: Text('Chatting with: $receiverUserEmail'),
        ),
      ),
    );
  }

}