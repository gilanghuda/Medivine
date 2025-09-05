import 'package:flutter/material.dart';
import '../../domain/usecases/get_message.dart';
import '../../domain/usecases/send_message.dart';
import '../../data/models/message_model.dart';

class ChatProvider extends ChangeNotifier {
  final GetMessage getMessage;
  final SendMessage sendMessage;

  ChatProvider({
    required this.getMessage,
    required this.sendMessage,
  });

  Stream<List<MessageModel>> messages(String roomId) {
    return getMessage(roomId);
  }

  Future<void> send(String roomId, MessageModel message) async {
    await sendMessage(roomId, message);
    notifyListeners();
  }
}
