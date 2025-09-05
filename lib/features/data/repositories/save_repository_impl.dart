import 'dart:io';
import 'package:medivine/features/data/datasources/analysis_service.dart';
import 'package:medivine/features/domain/entities/analysis.dart';
import 'package:medivine/features/domain/repositories/save_repository.dart';
import 'package:medivine/features/presentation/provider/auth_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class SaveRepositoryImpl implements SaveRepository {
  final GeminiAnalysisService service;
  SaveRepositoryImpl(this.service);

  @override
  Future<void> uploadAndSaveAnalysis(
      File imageFile, AnalysisEntity analysis) async {
    final imageUrl = await service.uploadImageToCloudinary(imageFile.path);
    if (imageUrl == null) throw Exception('Upload gambar gagal');

    final authProvider = GetIt.I<AuthProvider>();
    String? userId = authProvider.currentUser?.id;
    if (userId == null) {
      final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
      userId = firebaseUser?.uid;
    }

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
    await service.saveAnalysisToFirestore(data);
  }
}
