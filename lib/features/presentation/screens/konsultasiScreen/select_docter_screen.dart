import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/doctor.dart';
import '../../../domain/usecases/get_doctor.dart';
import '../../../../../features/data/datasources/doctor_service.dart';
import '../../../../../features/data/repositories/doctor_repository_impl.dart';
import '../../provider/auth_provider.dart';
import '../../provider/analisis_provider.dart'; // added import

class SelectDoctorScreen extends StatefulWidget {
  final String doctorId;
  const SelectDoctorScreen({Key? key, required this.doctorId})
      : super(key: key);

  @override
  _SelectDoctorScreenState createState() => _SelectDoctorScreenState();
}

class _SelectDoctorScreenState extends State<SelectDoctorScreen> {
  final TextEditingController _keluhanController = TextEditingController();
  bool _isAnonymous = false;

  late Future<Doctor?> doctorFuture;

  @override
  void initState() {
    super.initState();
    doctorFuture = _fetchDoctor(widget.doctorId);
    // fetch saved analyses for current user
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalisisProvider>().fetchUserAnalyses();
    });
  }

  Future<Doctor?> _fetchDoctor(String doctorId) async {
    final getDoctorUsecase = GetDoctor(DoctorRepositoryImpl(DoctorService()));
    final List<Doctor> doctors = await getDoctorUsecase();
    try {
      // Cari berdasarkan id, bukan name
      return doctors.firstWhere((d) => d.id == doctorId);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser?.role == 'doctor') {
      Future.microtask(() => context.go('/list-chat'));
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      body: SafeArea(
        child: FutureBuilder<Doctor?>(
          future: doctorFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            final doctor = snapshot.data;
            return Column(
              children: [
                // Header
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (GoRouter.of(context).canPop()) {
                            context.pop();
                          } else {
                            context.go('/recommendation-doctors');
                          }
                        },
                        child: Icon(Icons.arrow_back,
                            size: 24, color: Colors.grey[600]),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Chat Dengan Dokter',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                // Search Bar
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari Dokter',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pilihan Dokter Section
                        Text(
                          'Pilihan Dokter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        doctor == null
                            ? Text('Dokter tidak ditemukan')
                            : _buildDoctorCard(doctor),
                        SizedBox(height: 24),

                        // Riwayat Scan Penyakit Section
                        Text(
                          'Riwayat Scan Penyakit',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Pilih riwayat yang ingin dikonsultasikan',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 16),

                        // Dynamic Scan History from AnalisisProvider
                        Consumer<AnalisisProvider>(
                          builder: (context, provider, _) {
                            if (provider.isFetchingAnalyses) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (provider.fetchError != null) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  provider.fetchError!,
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            }

                            if (!provider.hasSavedAnalyses) {
                              return Container(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Column(
                                  children: [
                                    Icon(Icons.medical_services_outlined,
                                        size: 56, color: Colors.grey[300]),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Belum ada hasil analisis',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: provider.savedAnalyses.length,
                              separatorBuilder: (_, __) => SizedBox(height: 12),
                              itemBuilder: (context, i) {
                                final analysis = provider.savedAnalyses[i];
                                final primary =
                                    analysis['primary_diagnosis'] ?? {};
                                final imageUrl = analysis['image_url'] ??
                                    'https://cdn-icons-png.flaticon.com/512/2785/2785819.png';
                                final createdAt = analysis['created_at'];
                                final symptomsList =
                                    (analysis['symptoms'] as List<dynamic>?)
                                            ?.map((e) => e.toString())
                                            .toList() ??
                                        [];
                                final symptoms = symptomsList.isNotEmpty
                                    ? symptomsList.take(2).join(', ')
                                    : '';
                                final accStr =
                                    primary['accuracy']?.toString() ?? '0%';
                                final accNum = int.tryParse(accStr.replaceAll(
                                        RegExp(r'[^0-9]'), '')) ??
                                    0;
                                final accColor = accNum >= 80
                                    ? Color(0xFF10B981)
                                    : Color(0xFFEAB308);

                                return Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        Border.all(color: Colors.grey[200]!),
                                  ),
                                  child: Row(
                                    children: [
                                      // Image
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: NetworkImage(imageUrl),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      // Content
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              primary['name'] ?? 'Hasil Scan',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              symptoms.isNotEmpty
                                                  ? symptoms
                                                  : 'Hasil: ${primary['name'] ?? '-'}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              _getTimeAgo(createdAt),
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey[500]),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Accuracy badge
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: accColor.withOpacity(0.12),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Akurasi ${accStr}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: accColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      // Radio / select indicator
                                      Icon(Icons.radio_button_unchecked,
                                          color: Colors.grey[400]),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        SizedBox(height: 24),

                        // Keluhan Tambahan Section
                        Text(
                          'Keluhan Tambahan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Text Input for Additional Complaints
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: TextField(
                            controller: _keluhanController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: 'Ceritakan keluhan dan juga atas...',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Anonymous Consultation Checkbox
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.security,
                                size: 20,
                                color: Colors.black87,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Konsultasi secara anonimus',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      'Sembunyikan data anda saat berkonsultasi',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _isAnonymous,
                                onChanged: (value) {
                                  setState(() {
                                    _isAnonymous = value;
                                  });
                                },
                                activeColor: Color(0xFF10B981),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Bottom Button
                Container(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Ubah ke doctor.id, bukan doctor.name
                        if (doctor != null) {
                          context.push(
                            '/payment-confirmation/${doctor.id}',
                            extra: {
                              'isAnonymous': _isAnonymous,
                              'keluhan': _keluhanController.text,
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEC4899),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Konfirmasi Pembayaran',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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

  Widget _buildDoctorCard(Doctor doctor) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.grey[400],
              ),
            ),
          ),
          SizedBox(width: 12),
          // Doctor Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  doctor.specialty,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Text(
                      doctor.experience,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.thumb_up, size: 12, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Text(
                      doctor.rating,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  doctor.price,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _keluhanController.dispose();
    super.dispose();
  }
}
