import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medivine/features/presentation/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ListChatScreen extends StatelessWidget {
  const ListChatScreen({Key? key}) : super(key: key);

  Future<String?> _getDoctorName(String doctorId) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(doctorId)
        .get();
    if (doc.exists) {
      final data = doc.data();
      return data?['name'] as String?;
    }
    return null;
  }

  Future<Map<String, dynamic>?> _getUserData(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final dt = timestamp.toDate();
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour.$minute';
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final doctorId = authProvider.currentUser?.id;

    if (doctorId == null) {
      return const Scaffold(
        body: Center(child: Text('User tidak ditemukan')),
      );
    }

    return FutureBuilder<String?>(
      future: _getDoctorName(doctorId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final doctorName = snapshot.data;
        if (doctorName == null) {
          return const Scaffold(
            body: Center(child: Text('Nama dokter tidak ditemukan')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => context.go('/'),
            ),
            title: Text('Daftar Chat'),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('chats').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data!.docs;
              // Ambil hanya room yang melibatkan dokter ini berdasarkan field participants
              final doctorRooms = docs.where((doc) {
                final participants =
                    List<String>.from(doc['participants'] ?? []);
                return participants.contains(doctorId);
              }).toList();

              if (doctorRooms.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Belum ada chat masuk'),
                      const SizedBox(height: 16),
                      Text('doctorName: $doctorName'),
                      ...docs.map((d) => Text('roomId: ${d.id}')).toList(),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: doctorRooms.length,
                itemBuilder: (context, index) {
                  final roomDoc = doctorRooms[index];
                  final roomId = roomDoc.id;
                  final participants =
                      List<String>.from(roomDoc['participants'] ?? []);
                  final userId = participants.firstWhere((id) => id != doctorId,
                      orElse: () => '');
                  final lastMessage = roomDoc['lastMessage'] ?? '';
                  final updatedAt = roomDoc['updatedAt'] as Timestamp?;
                  final isAnon = roomDoc['is_anonymous'] ?? false;

                  // Jika anonim: jangan fetch user data, tampilkan "Pasien"
                  if (isAnon == true) {
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: const Text(
                        'Pasien anonymous',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                      trailing: Text(
                        _formatTime(updatedAt),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      onTap: () {
                        context.push('/doctor-chat/$userId');
                      },
                    );
                  }

                  // Bukan anonim: fetch user data seperti semula
                  return FutureBuilder<Map<String, dynamic>?>(
                    future: _getUserData(userId),
                    builder: (context, userSnapshot) {
                      final userData = userSnapshot.data;
                      final userName = userData?['name'] ?? 'Pasien';
                      final userAvatar = userData?['photoUrl'] as String?;

                      return ListTile(
                        leading: userAvatar != null && userAvatar.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(userAvatar))
                            : const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(
                          userName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                        trailing: Text(
                          _formatTime(updatedAt),
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        onTap: () {
                          context.push('/doctor-chat/$userId');
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
