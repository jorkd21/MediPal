class Message {
  // vairaibles
  String content;
  DateTime timeSent;
  String senderUid;
  String receiverUid;

  // constructor
  Message({
    required this.content,
    required this.timeSent,
    required this.senderUid,
    required this.receiverUid,
  });

  // create message from json map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      content: map['content'] ?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] ?? 0),
      senderUid: map['senderUid'] ?? '',
      receiverUid: map['receiverUid'] ?? '',
    );
  }

  // convert to json
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'senderUid': senderUid,
      'receiverUid': receiverUid,
    };
  }
}
