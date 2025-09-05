import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnBoardingData> _pages = [
    _OnBoardingData(
      image: 'assets/images/splash1.png',
      title: 'Analisis Cepat & Mudah',
      desc:
          'Unggah foto mulut Anda, lalu biarkan AI menganalisis untuk mendeteksi potensi penyakit dan memberikan saran penanganan awal',
      button: 'Next',
    ),
    _OnBoardingData(
      image: 'assets/images/splash2.png',
      title: 'Konsultasi Secara Anonim',
      desc:
          'Tidak perlu khawatir! Hubungi dokter spesialis secara langsung, tanpa harus khawatir identitas Anda terbuka',
      button: 'Next',
    ),
    _OnBoardingData(
      image: 'assets/images/splash3.png',
      title: 'Solusi Lengkap Kesehatan',
      desc:
          'Konsultasi dengan dokter, lalu dapatkan obat yang direkomendasikan secara aman dan terpercaya.',
      button: 'Daftar',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final rootContext = context;
    return Scaffold(
      backgroundColor: _currentPage == 1 ? Colors.pink[100] : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, i) {
                  final data = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(data.image),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          data.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data.desc,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        // Tombol dot dan next/daftar selinear
                        Row(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(_pages.length, (idx) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  width: _currentPage == idx ? 18 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _currentPage == idx
                                        ? Colors.pink
                                        : Colors.pink[100],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_currentPage < _pages.length - 1) {
                                    _controller.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                    );
                                  } else {
                                    print("MASUK KAN?");
                                    context.go('/signup');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 0),
                                ),
                                child: Text(
                                  data.button,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnBoardingData {
  final String image;
  final String title;
  final String desc;
  final String button;
  const _OnBoardingData({
    required this.image,
    required this.title,
    required this.desc,
    required this.button,
  });
}
