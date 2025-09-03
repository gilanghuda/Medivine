class PrimaryDiagnosis {
  final String name;
  final String accuracy;
  final String description;

  PrimaryDiagnosis({
    required this.name,
    required this.accuracy,
    required this.description,
  });

  factory PrimaryDiagnosis.fromJson(Map<String, dynamic> json) {
    return PrimaryDiagnosis(
      name: json['name'] ?? '',
      accuracy: json['accuracy'] ?? '0',
      description: json['description'] ?? '',
    );
  }
}
