import 'primary_diagnosis_model.dart';
import 'detection_model.dart';
import '../../domain/entities/analysis.dart';

class MedicalAnalysisResult extends AnalysisEntity {
  MedicalAnalysisResult({
    String? imageUrl,
    required PrimaryDiagnosis primaryDiagnosis,
    required List<Detection> allDetections,
    required List<String> symptoms,
    required List<String> recommendations,
  }) : super(
          imageUrl: imageUrl,
          primaryDiagnosis: PrimaryDiagnosisEntity(
            name: primaryDiagnosis.name,
            accuracy: primaryDiagnosis.accuracy,
            description: primaryDiagnosis.description,
          ),
          allDetections: allDetections
              .map((d) => DetectionEntity(
                    condition: d.condition,
                    percentage: d.percentage,
                  ))
              .toList(),
          symptoms: symptoms,
          recommendations: recommendations,
        );

  factory MedicalAnalysisResult.fromJson(Map<String, dynamic> json) {
    return MedicalAnalysisResult(
      // imageUrl opsional, bisa null
      imageUrl: json['image_url'],
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
