import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/chat/chat_bubble.dart';
import 'package:medipal/chat/chat_service.dart';
import 'package:medipal/objects/message.dart';

class ChatPage extends StatefulWidget {
  final String receiverUid;
  final String receiverName;

  const ChatPage({
    super.key,
    required this.receiverUid,
    required this.receiverName,
  });
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessages(
          widget.receiverUid, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          widget.receiverName,
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
      body: Column(
        children: [
          // messages
          Expanded(
            child: _buildMessageList(),
          ),
          // user input
          _buildMessageInput(),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder<List<Message>>(
      stream: _chatService.getMessages(
          widget.receiverUid, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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

  // build message item
  Widget _buildMessageItem(Message message) {
    var alignment = (message.senderUid == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (message.senderUid == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            ChatBubble(
                message: message.content,
                isCurrentUser:
                    (message.senderUid == _firebaseAuth.currentUser!.uid)),
          ],
        ),
      ),
    );
  }

  // build input
  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            obscureText: false,
          ),
        ),
        IconButton(
          onPressed: _sendMessage,
          icon: const Icon(
            Icons.send,
            size: 40,
          ),
        )
      ],
    );
  }
}
