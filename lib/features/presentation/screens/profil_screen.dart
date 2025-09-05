import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medivine/features/presentation/provider/auth_provider.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
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
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.currentUser;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: Column(
            children: [
              SizedBox(
                height: 220,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, 220),
                      painter: PinkCurvePainter(),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (GoRouter.of(context).canPop()) {
                                      context.pop();
                                    } else {
                                      context.go('/');
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(50),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Profile Saya',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user?.email?.split('@').first ??
                                            'Loading...',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFE74C3C),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        user?.gender ?? 'male',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFE74C3C),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF9AA2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 8),
                                    ),
                                    onPressed: () {},
                                    child: const Text(
                                      'Ubah',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
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
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: user == null
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              'Asuransi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildMenuItem(
                              title: 'Tautkan Asuransimu',
                              icon: Icons.medical_services_outlined,
                              color: const Color(0xFFFFF0F1),
                              iconColor: const Color(0xFFFF9AA2),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Riwayat Kesehatanmu',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildMenuItem(
                              title: 'Riwayat Pendetesian',
                              icon: Icons.history,
                              color: const Color(0xFFFFF0F1),
                              iconColor: const Color(0xFFFF9AA2),
                            ),
                            const SizedBox(height: 12),
                            _buildMenuItem(
                              title: 'Hasil Konsultasi',
                              icon: Icons.chat_outlined,
                              color: const Color(0xFFFFF0F1),
                              iconColor: const Color(0xFFFF9AA2),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFFBDBDBD),
            size: 18,
          ),
        ],
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
      size.height + 80,
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
