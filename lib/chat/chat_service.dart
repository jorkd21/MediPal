import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/objects/message.dart';

class ChatService extends ChangeNotifier {
  // get instance of auth and firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.reference().child('messages');

  // SEND MERSSAGE
  Future<void> sendMessages(String recieverId, String message) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final DateTime timestamp = DateTime.now();
    // create a new message
    Message newMessage = Message(
      content: message,
      timeSent: timestamp,
      senderUid: currentUserId,
      receiverUid: recieverId,
    );
    // construct chat room id from current user id and reciever id (sorted to ensure )
    List<String> ids = [currentUserId, recieverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    // add new message to database
    _messagesRef.child(chatRoomId).push().set(newMessage.toMap());
  }

  // GET MESSAGES
  Stream<List<Message>> getMessages(String userId, String otherUserId) {
    // Construct chat room id from user ids (sorted)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    // Reference the chat room in the Firebase Realtime Database
    final messagesRef = FirebaseDatabase.instance
        .reference()
        .child('messages')
        .child(chatRoomId);

    // Listen for changes and convert to a list of Message objects
    return messagesRef.onValue.map((event) {
      List<Message> messages = [];
      if (event.snapshot.value != null) {
        // Cast the snapshot value to a Map
        final data = event.snapshot.value as Map<dynamic, dynamic>;

        // Loop through each message data within the map
        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            // Convert each message data to a Message object
            final message = Message.fromMap(value.cast<String, dynamic>());
            messages.add(message);
          }
          // Sort the messages based on timeSent
          messages.sort((a, b) => a.timeSent.compareTo(b.timeSent));
        });
      }
      return messages;
    });
  }
}
