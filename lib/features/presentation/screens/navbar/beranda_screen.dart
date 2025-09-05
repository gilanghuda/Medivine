import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({Key? key}) : super(key: key);

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.currentUser == null
          ? authProvider.getCurrentUserProfile()
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9AA2),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 0, 8),
          child: InkWell(
            onTap: () {
              context.push('/profile');
            },
            borderRadius: BorderRadius.circular(50),
            child: const CircleAvatar(
              backgroundColor: Colors.black87,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ),
        title: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            final user = authProvider.currentUser;

            if (user == null) {
              return const Text("Loading...");
            }

            final email = user.email;
            final name = email.contains('@')
                ? email.substring(0, email.indexOf('@'))
                : email;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $name! 👋',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.go('/notifications');
            },
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Pink backdrop 20% tinggi layar dengan curve bawah
          SizedBox(
            width: double.infinity,
            height: screenHeight * 0.2,
            child: CustomPaint(
              painter: PinkCurvePainter(),
            ),
          ),

          // Konten utama
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 36, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(140, 20, 20, 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF8F9E), Color(0xFFFFB7B2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Deteksi Dini AI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Periksa kesehatanmu melalui analisis rongga mulut dengan teknologi artificial Intelligence',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 45), // Space for button
                        ],
                      ),
                    ),
                    // Positioned image on the left
                    Positioned(
                      left: -10,
                      top: -20,
                      child: Image.asset(
                        'assets/images/beranda1.png',
                        width: 160,
                        height: 160,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Positioned button at bottom
                    Positioned(
                      bottom: -20,
                      right: 20,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/scan');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFFF8F9E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.camera_alt_outlined, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Mulai Pemeriksaan',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Services section
                const Text(
                  'Layanan Utama',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 16),

                // AI Service Card
                _buildServiceCard(
                  title: 'Artificial Intelligence',
                  subtitle:
                      'Konsultasi cerdas dengan AI untuk diagnosa awal yang akurat',
                  color: const Color(0xFFFF8F9E),
                  image: 'assets/images/beranda2.png',
                  onTap: () => context.go('/scan'),
                ),

                const SizedBox(height: 12),

                // Doctor Consultation Card
                _buildServiceCard(
                  title: 'Konsultasi Dokter',
                  subtitle:
                      'Konsultasi langsung dengan dokter spesialis berpengalaman',
                  color: const Color(0xFFFF8F9E),
                  image:
                      'assets/images/beranda3.png', // Replace icon with image
                  imageOnRight: false,
                  onTap: () => context.go('/recommendation-doctors'),
                ),

                const SizedBox(height: 24),

                // Latest Articles Section
                const Text(
                  'Artikel Terbaru',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                // Article cards in vertical layout
                Column(
                  children: [
                    // First article with pink background
                    GestureDetector(
                      onTap: () => context.push('/detail-artikel'),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9AA2),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(12)),
                              child: Image.asset(
                                'assets/images/beranda4.png',
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Apa itu menular seksual?',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Mari ketahui penyakit yang dapat menular melalui hubungan seksual',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () => context.push('/detail-artikel'),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.asset(
                                'assets/images/beranda6.png',
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Ini Dia 7 Manfaat Minum Air Putih Bagi Tubuh',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Berapa gelas minum air putih hari ini? Minum air putih yang cukup, sangat bermanfaat buat tubuh kita.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => context.push('/detail-artikel'),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.asset(
                                'assets/images/beranda5.png',
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Pemeriksaan Gusi Cuma Rp10.000!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '"Jangan tunggu sampai parah! Deteksi sejak dini untuk mencegah radang gusi berkembang menjadi penyakit yang lebih serius."',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 80), // Space for bottom navigation
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required Color color,
    required String image,
    bool imageOnRight = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            if (!imageOnRight) ...[
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Image.asset(
                  image,
                  width: 24,
                  height: 24,
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (imageOnRight) ...[
              const SizedBox(width: 16),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Image.asset(
                  image,
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Custom painter untuk curve pink di backdrop
class PinkCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF9AA2)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 120,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
