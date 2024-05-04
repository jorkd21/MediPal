import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUid;

  ChatScreen({required this.receiverUid});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.reference().child('messages');
  List<Message> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index].content),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Enter message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String messageContent) {
    if (messageContent.isNotEmpty) {
      Message message = Message(
        content: messageContent,
        timeSent: DateTime.now(),
        senderUid: FirebaseAuth.instance.currentUser!.uid,
        receiverUid: widget.receiverUid,
      );

      _messagesRef
          .child(widget.receiverUid)
          .push()
          .set(message.toMap()); // Save the message object to the database
      _messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _messagesRef.child(widget.receiverUid).onChildAdded.listen((event) {
      // Check if the snapshot value is a map
      if (event.snapshot.value is Map<dynamic, dynamic>) {
        // Cast snapshot value to Map<String, dynamic>
        Map<String, dynamic> data =
            event.snapshot.value as Map<String, dynamic>;
        // Check if the map contains the necessary fields for a message
        if (data.containsKey('content') &&
            data.containsKey('timeSent') &&
            data.containsKey('senderUid') &&
            data.containsKey('receiverUid')) {
          setState(() {
            _messages.add(Message.fromMap(data));
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class Message {
  String content;
  DateTime timeSent;
  String senderUid;
  String receiverUid;

  Message({
    required this.content,
    required this.timeSent,
    required this.senderUid,
    required this.receiverUid,
  });

  // Factory method to create a Message object from a Map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      content: map['content'] ?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] ?? 0),
      senderUid: map['senderUid'] ?? '',
      receiverUid: map['receiverUid'] ?? '',
    );
  }

  // Convert Message object to a Map
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'senderUid': senderUid,
      'receiverUid': receiverUid,
    };
  }
}
