import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailArtikelScreen extends StatelessWidget {
  const DetailArtikelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => {
            if (GoRouter.of(context).canPop())
              {GoRouter.of(context).pop()}
            else
              {GoRouter.of(context).go('/')}
          },
        ),
        title: const Text(
          'Artikel',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image with Water Illustration
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/detail-artikel.png',
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            // Article Title
            const Text(
              '7 Manfaat Minum Air Putih Bagi Tubuh',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 16),

            // Author and Date Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // small avatar (use asset if available)
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      const AssetImage('assets/images/avatar_natasya.png'),
                  // If avatar asset missing, it will show blank - keep consistent with project assets
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Natasya Winkle',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '@Winkle_Natasya',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: const Text(
                        'Lifestyle',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '3 days ago',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Article Content
            const Text(
              'Air putih adalah sumber kehidupan yang paling penting bagi manusia. Tubuh manusia terdiri dari sekitar 60% air, sehingga sangat penting untuk memenuhi kebutuhan air setiap harinya. Dengan mengkonsumsi air putih yang cukup, tubuh dapat berfungsi dengan optimal dan berbagai masalah kesehatan dapat dihindari.',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 16),

            // Quote Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border(
                  left: BorderSide(
                    color: Colors.blue[400]!,
                    width: 4,
                  ),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.format_quote,
                    color: Colors.blue,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '"Minum air putih merupakan kebiasaan sederhana yang dapat memberikan manfaat luar biasa bagi kesehatan"',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Benefits Section
            const Text(
              'Berikut 7 manfaat pentingnya:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 16),

            // Benefits List
            ..._buildBenefitsList(),

            const SizedBox(height: 20),

            // Like counter and Share action (matches screenshot)
            Row(
              children: [
                InkWell(
                  onTap: () {
                    // TODO: implement like action
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.red[400], size: 16),
                        const SizedBox(width: 8),
                        const Text(
                          '2.1k',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    // TODO: implement share
                  },
                  icon: const Icon(Icons.share_outlined),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterMolecule() {
    return Container(
      width: 30,
      height: 20,
      child: Stack(
        children: [
          // H2O molecule representation
          Positioned(
            left: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 11,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterDroplet({required double size}) {
    return Container(
      width: size,
      height: size * 1.2,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(size / 2),
          top: Radius.circular(size * 0.8),
        ),
      ),
    );
  }

  List<Widget> _buildBenefitsList() {
    final benefits = [
      'Menjaga Hidrasi Tubuh\nAir putih membantu menjaga keseimbangan cairan dalam tubuh dan mencegah dehidrasi.',
      'Mengoptimalkan Konsentrasi\nOtak memerlukan air untuk berfungsi optimal, sehingga dapat meningkatkan fokus dan konsentrasi.',
      'Mendukung Pencernaan\nMembantu proses pencernaan makanan dan mencegah konstipasi.',
      'Mengatur Suhu Tubuh\nAir membantu tubuh mengatur suhu melalui proses berkeringat dan pernapasan.',
      'Membersihkan Racun\nMembantu ginjal menyaring zat-zat sisa dan racun dari tubuh.',
      'Menjaga Kesehatan Kulit\nKulit akan tampak lebih segar dan lembut ketika tubuh terhidrasi dengan baik.',
      'Mendukung Penurunan Berat Badan\nDapat membantu meningkatkan metabolisme dan memberikan rasa kenyang.',
    ];

    return benefits.asMap().entries.map((entry) {
      int index = entry.key + 1;
      String benefit = entry.value;
      List<String> parts = benefit.split('\n');
      String title = parts[0];
      String description = parts.length > 1 ? parts[1] : '';

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$index',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
