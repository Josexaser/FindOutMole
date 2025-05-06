class Prediction {
  final String prediction;
  final String type;
  final Map<String, double> probabilities;
  final String? imageUrl;
  final DateTime? timestamp;

  Prediction({
    required this.prediction,
    required this.type,
    required this.probabilities,
    this.imageUrl,
    this.timestamp,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      prediction: json['prediction'],
      type: json['type'],
      probabilities: Map<String, double>.from(
          json['probabilities'].map((key, value) => MapEntry(key, value.toDouble()))),
      imageUrl: json['image_url'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
    );
  }
}