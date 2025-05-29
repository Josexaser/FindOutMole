import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import '../models/prediction.dart';

class ApiService {
  // Modo LOCAL: para desarrollo en emulador Android o navegador Web
  static const String baseUrl =
      kIsWeb
          ? 'http://localhost:8000' // Flutter Web
          : 'http://10.0.2.2:8000'; // Emulador Android

  // Modo PRODUCCIÓN: para cuando uses Vercel + Render
  // static const String baseUrl = 'https://findoutmole-backend.onrender.com';

  Future<Prediction> predict(dynamic imageData, String token) async {
    try {
      if (imageData == null) {
        throw Exception('No se proporcionó ninguna imagen');
      }

      print('Enviando solicitud a: $baseUrl/predict');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/predict'),
      );
      request.headers['Authorization'] = 'Bearer $token';

      if (kIsWeb && imageData is Uint8List) {
        const filename = 'uploaded_image.jpg';
        const mimeType = 'jpeg';

        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            imageData,
            filename: filename,
            contentType: MediaType('image', mimeType),
          ),
        );
      } else if (!kIsWeb && imageData is File) {
        if (!imageData.existsSync()) {
          throw Exception('El archivo no existe');
        }

        final extension = path.extension(imageData.path).toLowerCase();
        final mime = _getMimeType(extension);

        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            imageData.path,
            contentType: MediaType('image', mime),
          ),
        );
      } else {
        throw Exception('Formato de imagen no válido');
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Respuesta del servidor: ${response.statusCode} - $responseBody');

      if (response.statusCode == 200) {
        return Prediction.fromJson(jsonDecode(responseBody));
      } else {
        throw Exception(jsonDecode(responseBody)['detail']);
      }
    } catch (e) {
      print('Error en ApiService.predict: $e');
      throw Exception('Error al realizar la predicción: $e');
    }
  }

  Future<List<Prediction>> getDiagnostics(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/diagnostics'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['diagnostics'] as List)
            .map((item) => Prediction.fromJson(item))
            .toList();
      } else {
        throw Exception(jsonDecode(response.body)['detail']);
      }
    } catch (e) {
      print('Error en getDiagnostics: $e');
      throw Exception('Error al obtener diagnósticos: $e');
    }
  }

  Future<void> deleteDiagnostic(String id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/diagnostics/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        throw Exception(jsonDecode(response.body)['detail']);
      }
    } catch (e) {
      print('Error en deleteDiagnostic: $e');
      throw Exception('Error al eliminar diagnóstico: $e');
    }
  }

  String _getMimeType(String extension) {
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'jpeg';
      case '.png':
        return 'png';
      case '.gif':
        return 'gif';
      case '.bmp':
        return 'bmp';
      default:
        return 'jpeg';
    }
  }
}
