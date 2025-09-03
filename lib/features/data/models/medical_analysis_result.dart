import 'primary_diagnosis.dart';
import 'detection.dart';

class MedicalAnalysisResult {
  final PrimaryDiagnosis primaryDiagnosis;
  final List<Detection> allDetections;
  final List<String> symptoms;
  final List<String> recommendations;

  MedicalAnalysisResult({
    required this.primaryDiagnosis,
    required this.allDetections,
    required this.symptoms,
    required this.recommendations,
  });

  factory MedicalAnalysisResult.fromJson(Map<String, dynamic> json) {
    return MedicalAnalysisResult(
      primaryDiagnosis:
          PrimaryDiagnosis.fromJson(json['primary_diagnosis'] ?? {}),
      allDetections: (json['all_detections'] as List<dynamic>?)
              ?.map((item) => Detection.fromJson(item))
              .toList() ??
          [],
      symptoms: (json['symptoms'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
    );
  }
}
