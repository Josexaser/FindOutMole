/// @class Prediction
/// @brief Modelo que representa una predicción realizada por el sistema.
/// 
/// Contiene información sobre el resultado de la predicción, el tipo, las probabilidades
/// asociadas, la URL de la imagen, la fecha y hora del diagnóstico y el identificador del diagnóstico.
class Prediction {
  /// @brief Resultado de la predicción (por ejemplo, "benigno" o "maligno").
  final String prediction;
  /// @brief Tipo de predicción o categoría.
  final String type;
  /// @brief Probabilidades asociadas a cada clase.
  final Map<String, double> probabilities;
  /// @brief URL de la imagen asociada a la predicción (opcional).
  final String? imageUrl;
  /// @brief Fecha y hora en que se realizó la predicción (opcional).
  final DateTime? timestamp;
  /// @brief Identificador único del diagnóstico (opcional).
  final String? diagnosticId; // Nuevo campo

  /// @brief Constructor de la clase Prediction.
  /// @param prediction Resultado de la predicción.
  /// @param type Tipo de predicción.
  /// @param probabilities Probabilidades asociadas.
  /// @param imageUrl URL de la imagen (opcional).
  /// @param timestamp Fecha y hora de la predicción (opcional).
  /// @param diagnosticId Identificador del diagnóstico (opcional).
  Prediction({
    required this.prediction,
    required this.type,
    required this.probabilities,
    this.imageUrl,
    this.timestamp,
    this.diagnosticId,
  });

  /// @brief Crea una instancia de Prediction a partir de un mapa JSON.
  /// @param json Mapa con los datos en formato JSON.
  /// @return Instancia de Prediction.
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