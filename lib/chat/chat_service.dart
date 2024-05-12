import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/objects/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.ref().child('messages');

  // SEND MERSSAGE
  Future<void> sendMessages(String recieverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final DateTime timestamp = DateTime.now();
    Message newMessage = Message(
      content: message,
      timeSent: timestamp,
      senderUid: currentUserId,
      receiverUid: recieverId,
    );
    List<String> ids = [currentUserId, recieverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    _messagesRef.child(chatRoomId).push().set(newMessage.toJson());
  }

  // GET MESSAGES.
  Stream<List<Message>> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    final messagesRef =
        FirebaseDatabase.instance.ref().child('messages').child(chatRoomId);
    return messagesRef.onValue.map((event) {
      List<Message> messages = [];
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            final message = Message.fromMap(value.cast<String, dynamic>());
            messages.add(message);
          }
          messages.sort((a, b) => a.timeSent.compareTo(b.timeSent));
        });
      }
      return messages;
    });
  }
}
