class Prediction {
  final String prediction;
  final String type;
  final Map<String, double> probabilities;

  Prediction({
    required this.prediction,
    required this.type,
    required this.probabilities,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      prediction: json['prediction'],
      type: json['type'],
      probabilities: Map<String, double>.from(
        (json['probabilities'] as Map).map(
          (key, value) => MapEntry(key, value.toDouble()),
        ),
      ),
    );
  }
}