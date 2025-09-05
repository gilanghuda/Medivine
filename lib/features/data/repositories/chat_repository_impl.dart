import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_service.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatService chatService;

  ChatRepositoryImpl(this.chatService);

  @override
  Stream<List<MessageModel>> getMessages(String roomId) {
    return chatService.getMessages(roomId);
  }

  @override
  Future<void> sendMessage(String roomId, MessageModel message) {
    return chatService.sendMessage(roomId, message);
  }
}
