import 'dart:io';
import '../../data/datasources/analysis_service.dart';
import '../../data/models/medical_analysis_result.dart';
import 'package:flutter/material.dart';
import '../../domain/usecases/save_analysis.dart';
import '../../domain/entities/analysis.dart';

class AnalisisProvider with ChangeNotifier {
  final GeminiAnalysisService _service;
  MedicalAnalysisResult? _result;
  bool _isLoading = false;
  String? _error;
  SaveAnalysis? saveAnalysisUsecase;

  AnalisisProvider({required String apiKey})
      : _service = GeminiAnalysisService(apiKey: apiKey);

  MedicalAnalysisResult? get result => _result;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setSaveAnalysisUsecase(SaveAnalysis usecase) {
    saveAnalysisUsecase = usecase;
  }

  Future<void> analyze(File image) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _result = await _service.analyzeOralImage(image);
      if (_result == null) {
        _error = "Gagal mendapatkan hasil analisis.";
      }
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> saveAnalysis(File image) async {
    if (_result == null || saveAnalysisUsecase == null) return false;
    try {
      await saveAnalysisUsecase!(image, _result!);
      return true;
    } catch (e, stack) {
      print("ERROR SAAT SAVE ANALYSIS: $e");
      print("STACKTRACE: $stack");
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clear() {
    _result = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
