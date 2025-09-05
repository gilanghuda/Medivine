import '../../data/models/message_model.dart';

abstract class ChatRepository {
  Stream<List<MessageModel>> getMessages(String roomId);
  Future<void> sendMessage(String roomId, MessageModel message);
}
