import '../repositories/chat_repository.dart';
import '../../data/models/message_model.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<void> call(String roomId, MessageModel message) {
    return repository.sendMessage(roomId, message);
  }
}
