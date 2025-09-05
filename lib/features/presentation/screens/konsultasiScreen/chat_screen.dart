import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medivine/features/presentation/provider/chat_provider.dart';
import 'package:medivine/features/data/models/message_model.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class ChatScreen extends StatefulWidget {
  final String doctorId;
  final bool isAnonymous;
  const ChatScreen({
    Key? key,
    required this.doctorId,
    this.isAnonymous = false,
  }) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? currentUserId;
  late String roomId;
  String? doctorName;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    currentUserId = authProvider.currentUser?.id;
    if (currentUserId != null) {
      roomId = _buildRoomId(currentUserId!, widget.doctorId);
      print(
          '[DEBUG] ChatScreen roomId: $roomId, currentUserId: $currentUserId, doctorId: ${widget.doctorId}');
      _fetchDoctorName(widget.doctorId);
      // Ensure room metadata (participants & is_anonymous) exists/merged
      FirebaseFirestore.instance.collection('chats').doc(roomId).set({
        'participants': [currentUserId, widget.doctorId],
        'is_anonymous': widget.isAnonymous,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      setState(() {});
    }
  }

  Future<void> _fetchDoctorName(String doctorId) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(doctorId)
        .get();
    if (doc.exists) {
      setState(() {
        doctorName = doc.data()?['name'] ?? 'Dokter';
      });
    }
  }

  // Ubah: roomId selalu [userId]_[doctorId] tanpa sort
  String _buildRoomId(String userId, String doctorId) {
    return '${userId}_$doctorId';
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || currentUserId == null) return;

    print(
        '[DEBUG] Sending message: $text from $currentUserId to ${widget.doctorId} in room $roomId');
    final provider = Provider.of<ChatProvider>(context, listen: false);
    final message = MessageModel(
      senderId: currentUserId!,
      receiverId: widget.doctorId,
      senderType: 'user',
      text: text,
      timestamp: null,
    );
    await provider.send(roomId, message);

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text(
              doctorName ?? 'Dokter',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              context.go('/hasildiagnosis');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Akhiri pesan',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: Provider.of<ChatProvider>(context).messages(roomId),
              builder: (context, snapshot) {
                print(
                    '[DEBUG] StreamBuilder snapshot.hasData: ${snapshot.hasData}, roomId: $roomId');
                if (snapshot.hasData) {
                  print(
                      '[DEBUG] StreamBuilder messages length: ${snapshot.data?.length}');
                  if (snapshot.data != null) {
                    for (var msg in snapshot.data!) {
                      print(
                          '[DEBUG] Message: senderId=${msg.senderId}, receiverId=${msg.receiverId}, text=${msg.text}');
                    }
                  }
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index];
                    final isMe = data.senderId == currentUserId;
                    print(
                        '[DEBUG] ListView.builder index: $index, isMe: $isMe, senderId: ${data.senderId}, text: ${data.text}');
                    return _buildChatMessage(
                      isDoctor: !isMe,
                      message: data.text,
                      time: '',
                    );
                  },
                );
              },
            ),
          ),
          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Color(0xFF999999)),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE53E3E),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage({
    required bool isDoctor,
    required String message,
    required String time,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          isDoctor ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (isDoctor) ...[
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDoctor ? Colors.white : const Color(0xFFE53E3E),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: isDoctor ? Colors.black : Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ),
        if (!isDoctor) ...[
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[300],
            child: Icon(
              Icons.person,
              color: Colors.grey[600],
              size: 18,
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
