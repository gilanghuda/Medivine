class AnalysisEntity {
  final String? imageUrl;
  final PrimaryDiagnosisEntity primaryDiagnosis;
  final List<DetectionEntity> allDetections;
  final List<String> symptoms;
  final List<String> recommendations;

  AnalysisEntity({
    this.imageUrl,
    required this.primaryDiagnosis,
    required this.allDetections,
    required this.symptoms,
    required this.recommendations,
  });
}

class PrimaryDiagnosisEntity {
  final String name;
  final String accuracy;
  final String description;

  PrimaryDiagnosisEntity({
    required this.name,
    required this.accuracy,
    required this.description,
  });
}

class DetectionEntity {
  final String condition;
  final String percentage;

  DetectionEntity({
    required this.condition,
    required this.percentage,
  });
}
