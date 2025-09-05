import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/datasources/analysis_service.dart';
import '../../data/models/medical_analysis_result.dart';
import 'package:flutter/material.dart';
import '../../domain/usecases/save_analysis.dart';

class AnalisisProvider with ChangeNotifier {
  final GeminiAnalysisService _service;
  MedicalAnalysisResult? _result;
  bool _isLoading = false;
  String? _error;
  SaveAnalysis? saveAnalysisUsecase;

  List<Map<String, dynamic>> _savedAnalyses = [];
  bool _isFetchingAnalyses = false;
  String? _fetchError;

  AnalisisProvider({required String apiKey})
      : _service = GeminiAnalysisService(apiKey: apiKey);

  MedicalAnalysisResult? get result => _result;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Map<String, dynamic>> get savedAnalyses => _savedAnalyses;
  bool get isFetchingAnalyses => _isFetchingAnalyses;
  String? get fetchError => _fetchError;
  bool get hasSavedAnalyses => _savedAnalyses.isNotEmpty;

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
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchUserAnalyses() async {
    _isFetchingAnalyses = true;
    _fetchError = null;
    notifyListeners();

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _savedAnalyses = [];
        _fetchError = 'User not logged in';
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('analysis')
          .where('user_id', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .get();

      _savedAnalyses = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } on FirebaseException catch (e) {
      final msg = e.message ?? e.toString();
      final indexUrl = _extractIndexUrl(msg);
      if (indexUrl != null) {
        _fetchError =
            'Query requires a Firestore index. Create it here:\n$indexUrl';
      } else {
        _fetchError = msg;
      }
      _savedAnalyses = [];
    } catch (e) {
      _fetchError = e.toString();
      _savedAnalyses = [];
    } finally {
      _isFetchingAnalyses = false;
      notifyListeners();
    }
  }

  String? _extractIndexUrl(String? message) {
    if (message == null) return null;
    final regex = RegExp(r'https?:\/\/[^\s)]+');
    final match = regex.firstMatch(message);
    return match?.group(0);
  }

  Future<void> deleteAnalysis(String analysisId) async {
    try {
      await FirebaseFirestore.instance
          .collection('analysis')
          .doc(analysisId)
          .delete();
      _savedAnalyses.removeWhere((a) => a['id'] == analysisId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clear() {
    _result = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
