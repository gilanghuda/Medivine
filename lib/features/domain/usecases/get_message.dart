import '../repositories/chat_repository.dart';
import '../../data/models/message_model.dart';

class GetMessage {
  final ChatRepository repository;

  GetMessage(this.repository);

  Stream<List<MessageModel>> call(String roomId) {
    return repository.getMessages(roomId);
  }
}
