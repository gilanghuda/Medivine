import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/analisis_provider.dart';

class SimpanScreen extends StatefulWidget {
  const SimpanScreen({Key? key}) : super(key: key);

  @override
  State<SimpanScreen> createState() => _SimpanScreenState();
}

class _SimpanScreenState extends State<SimpanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalisisProvider>().fetchUserAnalyses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Hasil Analisis',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AnalisisProvider>(
          builder: (context, provider, _) {
            if (provider.isFetchingAnalyses) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.fetchError != null) {
              return Center(child: Text(provider.fetchError!));
            }

            if (!provider.hasSavedAnalyses) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.medical_services_outlined,
                        size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada hasil analisis',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lakukan scan untuk mendapatkan hasil analisis',
                      style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: provider.savedAnalyses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final analysis = provider.savedAnalyses[index];
                print("DEBUG: $analysis");
                final primary = analysis['primary_diagnosis'] ?? {};
                final recommendations =
                    (analysis['recommendations'] as List<dynamic>?)
                            ?.map((e) => e.toString())
                            .toList() ??
                        [];

                return _buildAnalysisCard(
                  iconUrl: analysis['image_url'] ??
                      'https://cdn-icons-png.flaticon.com/512/2785/2785819.png',
                  iconColor: const Color(0xFFE74C3C),
                  title: primary['name'] ?? 'Unknown',
                  subtitle: 'Hasil scan: ${primary['name'] ?? 'Unknown'}',
                  timeAgo: _getTimeAgo(analysis['created_at']),
                  accuracy: primary['accuracy'] ?? '0%',
                  recommendations: recommendations,
                  onDelete: analysis['id'] != null
                      ? () => provider.deleteAnalysis(analysis['id'] as String)
                      : null,
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _getTimeAgo(dynamic timestamp) {
    if (timestamp == null) return '';
    DateTime date;
    if (timestamp is DateTime) {
      date = timestamp;
    } else {
      try {
        date = timestamp.toDate();
      } catch (_) {
        return '';
      }
    }
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) return '${difference.inDays} hari yang lalu';
    if (difference.inHours > 0) return '${difference.inHours} jam yang lalu';
    return '${difference.inMinutes} menit yang lalu';
  }

  Widget _buildAnalysisCard({
    required String iconUrl,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String timeAgo,
    required String accuracy,
    required List<String> recommendations,
    VoidCallback? onDelete,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon, title, and delete button
            Row(
              children: [
                CircleAvatar(
                  radius: 25, // setengah dari 50
                  backgroundColor: iconColor.withOpacity(0.1),
                  backgroundImage: NetworkImage(iconUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeAgo,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFFF6B9D),
                        size: 24,
                      ),
                      onPressed: onDelete,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEB3B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Akurasi $accuracy',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Recommendations section
            const Text(
              'Rekomendasi awal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            // Recommendation items
            ...recommendations
                .map((recommendation) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(top: 6, right: 12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF6B9D),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              recommendation,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
