class Prediction {
  final String prediction;
  final String type;
  final Map<String, double> probabilities;
  final String? imageUrl;
  final DateTime? timestamp;
  final String? diagnosticId; // Nuevo campo

  Prediction({
    required this.prediction,
    required this.type,
    required this.probabilities,
    this.imageUrl,
    this.timestamp,
    this.diagnosticId,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      prediction: json['prediction'] ?? '',
      type: json['type'] ?? '',
      probabilities: Map<String, double>.from(
          (json['probabilities'] as Map).map((key, value) => MapEntry(key, value.toDouble()))),
      imageUrl: json['image_url'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
      diagnosticId: json['diagnostic_id'], // Nuevo campo
    );
  }
}