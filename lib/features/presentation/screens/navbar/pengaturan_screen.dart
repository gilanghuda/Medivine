import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class PengaturanScreen extends StatelessWidget {
  const PengaturanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF3F3F3);
    const card = Colors.white;
    const pink = Color(0xFFF86F7C);
    const textPrimary = Color(0xFF141414);
    const textSecondary = Color(0xFF6B6B6B);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bg,
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Pengaturan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 4),
              // Kartu daftar menu
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _ItemTile(
                      iconPath: 'assets/images/pengaturan1.png',
                      title: 'Pusat Bantuan',
                      onTap: () {},
                    ),
                    const _DividerThin(),
                    _ItemTile(
                      iconPath: 'assets/images/pengaturan2.png',
                      title: 'Metode Pembayaran',
                      onTap: () {},
                    ),
                    const _DividerThin(),
                    _ItemTile(
                      iconPath: 'assets/images/pengaturan3.png',
                      title: 'Pengaturan Akun',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Tombol "Keluar Akun"
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _showLogoutSheet(context, pink),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: SizedBox(
                      height: 56,
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF8954),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/pengaturan4.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Keluar Akun',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded,
                              color: textSecondary),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutSheet(BuildContext context, Color pink) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: 265,
          child: Column(
            children: [
              // Header merah muda + lengkungan putih
              SizedBox(
                height: 150,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // background pink
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: pink,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    // lengkungan putih yang "menggerus" area pink di bawah, melengkung ke atas
                    Positioned(
                      bottom: -55,
                      child: Container(
                        width: 400,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6000),
                            topRight: Radius.circular(6000),
                            bottomLeft: Radius.circular(4200),
                            bottomRight: Radius.circular(4200),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 28,
                      child: Image.asset(
                        'assets/images/exit1.png',
                        width: 90,
                        height: 90,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Anda yakin ingin keluar?',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2B2B2B),
                ),
              ),
              const SizedBox(height: 16),
              // Tombol
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _PillButton(
                    label: 'Tidak',
                    filled: false,
                    color: Colors.white,
                    textColor: Color(0xFFDB4F5C),
                    borderColor: Color(0xFFDB4F5C),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 10),
                  _PillButton(
                    label: 'Iya',
                    filled: true,
                    color: Color(0xFFDB4F5C),
                    textColor: Colors.white,
                    borderColor: Color(0xFFDB4F5C),
                    onPressed: () async {
                      await Provider.of<AuthProvider>(context, listen: false)
                          .logout(context);
                      context.go('/signup');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

// Ubah _ItemTile agar pakai asset gambar
class _ItemTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const _ItemTile({
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const textPrimary = Color(0xFF141414);
    const textSecondary = Color(0xFF6B6B6B);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // ikon kiri pakai asset
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2F0),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                iconPath,
                width: 28,
                height: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: textSecondary),
          ],
        ),
      ),
    );
  }
}

class _DividerThin extends StatelessWidget {
  const _DividerThin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFFF3F3F3),
      ),
    );
  }
}

// Ubah _PillButton agar bisa custom warna
class _PillButton extends StatelessWidget {
  final String label;
  final bool filled;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onPressed;

  const _PillButton({
    required this.label,
    this.filled = false,
    required this.color,
    required this.textColor,
    required this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(40));

    if (filled) {
      return FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          minimumSize: const Size(72, 36),
          shape: shape,
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(label,
            style: TextStyle(
                fontSize: 13, color: textColor, fontWeight: FontWeight.w600)),
      );
    }

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor),
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        minimumSize: const Size(72, 36),
        shape: shape,
      ),
      onPressed: onPressed,
      child: Text(label,
          style: TextStyle(
              fontSize: 13, color: textColor, fontWeight: FontWeight.w600)),
    );
  }
}
