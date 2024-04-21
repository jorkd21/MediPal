import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medipal/constant/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medipal/main.dart';
import 'package:medipal/model/message.dart';

class ChatService extends ChangeNotifier{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  Future<void> sendMessage(String receiverId, String message) async {

    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(

      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firebaseDatabase
        // ignore: deprecated_member_use
        .reference()
        .child('chat_rooms')
        .child(chatRoomId)
        .child('messages')
        .push()
        .set(newMessage.toMap());
  }

  Stream<List<Message>> getMessages(String userId, String otherUserId){

    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firebaseDatabase
        // ignore: deprecated_member_use
        .reference()
        .child('chat_rooms')
        .child(chatRoomId)
        .child('messages')
        .orderByChild('timestamp')
        .onValue
        .map((event) => parseMessages(event.snapshot));
  }

  List<Message> parseMessages(DataSnapshot dataSnapshot){
    List<Message> messages = [];

    if (dataSnapshot.value != null){
      Map<dynamic, dynamic> messagesMap = dataSnapshot.value as Map<dynamic, dynamic>;
      messagesMap.forEach((key, value){
        Message message = Message.fromMap(value as Map<String, dynamic>);
        messages.add(message);
      });
    }

    return messages;

  }


}