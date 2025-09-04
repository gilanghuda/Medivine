import 'dart:io';
import '../entities/analysis.dart';

abstract class SaveRepository {
  Future<void> uploadAndSaveAnalysis(File imageFile, AnalysisEntity analysis);
}
