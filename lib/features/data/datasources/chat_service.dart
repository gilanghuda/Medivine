import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore firestore;

  ChatService({required this.firestore});

  Stream<List<MessageModel>> getMessages(String roomId) {
    return firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromFirestore(doc))
            .toList());
  }

  Future<void> sendMessage(String roomId, MessageModel message) async {
    final roomRef = firestore.collection('chats').doc(roomId);
    final roomDoc = await roomRef.get();
    if (!roomDoc.exists || roomDoc.data()!.isEmpty) {
      await roomRef.set({
        'participants': [message.senderId, message.receiverId],
        'lastMessage': message.text,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      await roomRef.update({
        'lastMessage': message.text,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await roomRef.collection('messages').add(message.toMap());
  }
}
