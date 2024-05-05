import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/chat/chat_service.dart';
import 'package:medipal/objects/message.dart';

class ChatPage extends StatefulWidget {
  final String receiverUid;
  const ChatPage({super.key, required this.receiverUid});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessages(
          widget.receiverUid, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUid)),
      body: Column(
        children: [
          // messages
          Expanded(child: _buildMessageList(),),
          // user input
          _buildMessageInput(),
        ],
      ),
    );
  }
  // build message list
  // build message list
Widget _buildMessageList() {
  return StreamBuilder<List<Message>>(
    stream: _chatService.getMessages(widget.receiverUid, _firebaseAuth.currentUser!.uid),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      List<Message> messages = snapshot.data ?? [];

      return ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return _buildMessageItem(messages[index]);
        },
      );
    },
  );
}

  //build message item
  Widget _buildMessageItem(Message message){
    var alignment = (message.senderUid == _firebaseAuth.currentUser!.uid) ? 
    Alignment.centerRight 
    : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (message.senderUid == _firebaseAuth.currentUser!.uid) 
              ? CrossAxisAlignment.end 
              : CrossAxisAlignment.start,
          children: [
            Text(message.senderUid),
            Text(message.content),
          ],
        ),
      ),
    );
  }
  //build input
  Widget _buildMessageInput(){
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            obscureText: false,
          )
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(
            Icons.send, 
            size: 40,
          )
        )
      ]
    );
  }
}
