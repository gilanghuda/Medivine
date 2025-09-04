import 'dart:io';
import '../entities/analysis.dart';
import '../repositories/save_repository.dart';

class SaveAnalysis {
  final SaveRepository repository;
  SaveAnalysis(this.repository);

  Future<void> call(File imageFile, AnalysisEntity analysis) {
    return repository.uploadAndSaveAnalysis(imageFile, analysis);
  }
}
