import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String receiverId;
  final String senderType;
  final String text;
  final Timestamp? timestamp;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.senderType,
    required this.text,
    this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'senderType': senderType,
      'text': text,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
    };
  }

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      senderType: data['senderType'] ?? '',
      text: data['text'] ?? '',
      timestamp: data['timestamp'],
    );
  }
}
