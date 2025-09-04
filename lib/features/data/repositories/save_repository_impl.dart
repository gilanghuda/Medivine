import 'dart:io';
import 'package:medivine/features/data/datasources/analysis_service.dart';
import 'package:medivine/features/data/models/medical_analysis_result.dart';
import 'package:medivine/features/domain/entities/analysis.dart';
import 'package:medivine/features/domain/repositories/save_repository.dart';
import 'package:medivine/features/presentation/provider/auth_provider.dart';
import 'package:get_it/get_it.dart';

class SaveRepositoryImpl implements SaveRepository {
  final GeminiAnalysisService service;
  SaveRepositoryImpl(this.service);

  @override
  Future<void> uploadAndSaveAnalysis(
      File imageFile, AnalysisEntity analysis) async {
    print('DEBUG : Mulai upload gambar ke Cloudinary...');
    final imageUrl = await service.uploadImageToCloudinary(imageFile.path);
    print('DEBUG : Hasil upload imageUrl: $imageUrl');
    if (imageUrl == null) throw Exception('Upload gambar gagal');

    // Ambil user id dari AuthProvider (pastikan sudah register di provider)
    final authProvider = GetIt.I<AuthProvider>();
    final userId = authProvider.currentUser?.id;

    final data = {
      'image_url': imageUrl,
      'user_id': userId,
      'primary_diagnosis': {
        'name': analysis.primaryDiagnosis.name,
        'accuracy': analysis.primaryDiagnosis.accuracy,
        'description': analysis.primaryDiagnosis.description,
      },
      'all_detections': analysis.allDetections
          .map((d) => {
                'condition': d.condition,
                'percentage': d.percentage,
              })
          .toList(),
      'symptoms': analysis.symptoms,
      'recommendations': analysis.recommendations,
      'created_at': DateTime.now().toIso8601String(),
    };
    print('DEBUG : Data yang akan disimpan ke Firestore: $data');
    await service.saveAnalysisToFirestore(data);
    print('DEBUG : Selesai simpan ke Firestore');
  }
}
