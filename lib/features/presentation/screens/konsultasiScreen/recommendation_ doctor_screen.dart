import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/doctor.dart';
import '../../../domain/usecases/get_doctor.dart';
import '../../../../../features/data/datasources/doctor_service.dart';
import '../../../../../features/data/repositories/doctor_repository_impl.dart';
import 'doctor_card.dart';
import '../../provider/auth_provider.dart';

class RecommendationDoctorScreen extends StatelessWidget {
  final GetDoctor getDoctorUsecase =
      GetDoctor(DoctorRepositoryImpl(DoctorService()));

  List<Doctor> filterRecommended(List<Doctor> doctors) {
    return doctors.where((d) {
      final ratingNum = double.tryParse(d.rating.replaceAll('%', '')) ?? 0;
      return ratingNum > 85;
    }).toList();
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
        child: Column(
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
                        context.go('/');
                      }
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Rekomendasi Dokter',
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
              child: FutureBuilder<List<Doctor>>(
                future: getDoctorUsecase(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Gagal memuat data dokter'));
                  }
                  final doctors = snapshot.data ?? [];
                  final recommendedDoctors = filterRecommended(doctors);

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rekomendasi Dokter Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rekomendasi Dokter',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Diagnosis lebih akurat bersama dokter',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            SizedBox(height: 16),
                            ...recommendedDoctors.map(
                              (doctor) => DoctorCard(
                                doctor: doctor,
                                onSelect: () {
                                  context.push('/select-doctor/${doctor.id}');
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        // Semua Dokter Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Semua Dokter',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.go('/all-doctors');
                                  },
                                  child: Text(
                                    'Lihat Semua',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFEC4899),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            ...doctors.map(
                              (doctor) => DoctorCard(
                                doctor: doctor,
                                onSelect: () {
                                  context.go('/select-doctor/${doctor.id}');
                                },
                              ),
                            ),
                          ],
                        ),
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
