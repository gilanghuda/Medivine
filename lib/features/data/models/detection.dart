class Detection {
  final String condition;
  final String percentage;

  Detection({
    required this.condition,
    required this.percentage,
  });

  factory Detection.fromJson(Map<String, dynamic> json) {
    return Detection(
      condition: json['condition'] ?? '',
      percentage: json['percentage'] ?? '0',
    );
  }
}
