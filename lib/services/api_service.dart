import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../models/prediction.dart';

class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: kIsWeb ? 'http://127.0.0.1:8000' : 'http://10.0.2.2:8000',
  );

  Future<Prediction> predict(dynamic imageData, String token) async {
    try {
      if (imageData == null) {
        throw Exception('No se proporcionó ninguna imagen');
      }

      print('Enviando solicitud a: $baseUrl/predict');
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/predict'));
      request.headers['Authorization'] = 'Bearer $token';

      XFile imageFile = imageData as XFile;

      if (kIsWeb) {
        final bytes = await imageFile.readAsBytes();
        if (bytes == null || bytes.isEmpty) {
          throw Exception('No se pudieron leer los bytes de la imagen');
        }
        String filename = imageFile.name.isNotEmpty ? imageFile.name : 'uploaded_image.jpg';
        String extension = path.extension(filename).toLowerCase();
        String mimeType = _getMimeType(extension);

        request.files.add(http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: filename,
          contentType: http_parser.MediaType('image', mimeType),
        ));
      } else {
        if (!File(imageFile.path).existsSync()) {
          throw Exception('El archivo de imagen no existe: ${imageFile.path}');
        }
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ));
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
      print('Enviando solicitud a: $baseUrl/diagnostics');
      final response = await http.get(
        Uri.parse('$baseUrl/diagnostics'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Respuesta del servidor: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final diagnostics = (data['diagnostics'] as List)
            .map((item) => Prediction.fromJson(item))
            .toList();
        return diagnostics;
      } else {
        throw Exception('Error: ${jsonDecode(response.body)['detail']}');
      }
    } catch (e) {
      print('Error en ApiService.getDiagnostics: $e');
      throw Exception('Error al obtener diagnósticos: $e');
    }
  }

  Future<void> deleteDiagnostic(String diagnosticId, String token) async {
    try {
      print('Enviando solicitud DELETE a: $baseUrl/diagnostics/$diagnosticId');
      final response = await http.delete(
        Uri.parse('$baseUrl/diagnostics/$diagnosticId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Respuesta del servidor: ${response.statusCode} - ${response.body}');
      if (response.statusCode != 200) {
        throw Exception('Error: ${jsonDecode(response.body)['detail']}');
      }
    } catch (e) {
      print('Error en ApiService.deleteDiagnostic: $e');
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