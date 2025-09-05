import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/doctor.dart';
import '../../../domain/usecases/get_doctor.dart';
import '../../../../../features/data/datasources/doctor_service.dart';
import '../../../../../features/data/repositories/doctor_repository_impl.dart';
import 'doctor_card.dart';
import '../../provider/auth_provider.dart';

class AllDoctorsScreen extends StatelessWidget {
  final GetDoctor getDoctorUsecase =
      GetDoctor(DoctorRepositoryImpl(DoctorService()));

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
                    onTap: () => {
                      if (GoRouter.of(context).canPop())
                        {GoRouter.of(context).pop()}
                      else
                        {GoRouter.of(context).go('/recommendation-doctors')}
                    },
                    child: Icon(Icons.arrow_back,
                        size: 24, color: Colors.grey[600]),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Semua Dokter',
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
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with filter
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Paling populer',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Icon(
                              Icons.tune,
                              size: 20,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Doctor List
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
