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
